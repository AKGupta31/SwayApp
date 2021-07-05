//
//  LightCompressor.swift
//  Sway
//
//  Created by Admin on 01/07/21.
//


import AVFoundation
import UIKit

public enum VideoQuality {
    case very_high
    case high
    case medium
    case low
    case very_low
}

// Compression Result
public enum CompressionResult {
    case onStart
    case onSuccess(URL)
    case onFailure(CompressionError)
    case onCancelled
}

// Compression Interruption Wrapper
public class Compression {
    public init() {}

    public var cancel = false
}

// Compression Error Messages
public struct CompressionError: LocalizedError {
    public let title: String
    public let code:Int

    init(title: String = "Compression Error",code:Int) {
        self.title = title
        self.code = code
    }
}

@available(iOS 11.0, *)
public class LightCompressor {

    public init() {}

    private let MIN_BITRATE = Float(1000000)
    private let MIN_HEIGHT = 640.0
    private let MIN_WIDTH = 360.0

    /**
     * This function compresses a given [source] video file and writes the compressed video file at
     * [destination]
     *
     * @param [source] the path of the provided video file to be compressed
     * @param [destination] the path where the output compressed video file should be saved
     * @param [quality] to allow choosing a video quality that can be [.very_low], [.low],
     * [.medium],  [.high], and [very_high]. This defaults to [.medium]
     * @param [isMinBitRateEnabled] to determine if the checking for a minimum bitrate threshold
     * before compression is enabled or not. This default to `true`
     * @param [keepOriginalResolution] to keep the original video height and width when compressing.
     * This defaults to `false`
     * @param [progressHandler] a compression progress  listener that listens to compression progress status
     * @param [completion] to return completion status that can be [onStart], [onSuccess], [onFailure],
     * and if the compression was [onCancelled]
     */

    public func compressVideo(source: URL,
                              destination: URL,
                              quality: VideoQuality,
                              isMinBitRateEnabled: Bool = true,
                              keepOriginalResolution: Bool = true,
                              progressQueue: DispatchQueue,
                              progressHandler: ((Progress) -> ())?,
                              completion: @escaping (CompressionResult) -> ()) -> Compression {

        var frameCount = 0
        let compressionOperation = Compression()

        // Compression started
        completion(.onStart)

        let videoAsset = AVURLAsset(url: source)
        guard let videoTrack = videoAsset.tracks(withMediaType: AVMediaType.video).first else {
            let error = CompressionError(title: "Cannot find video track", code: 150)
            completion(.onFailure(error))
            return Compression()
        }

        let bitrate = videoTrack.estimatedDataRate
        // Check for a min video bitrate before compression
        if isMinBitRateEnabled && bitrate <= MIN_BITRATE {
            let error = CompressionError(title: "The provided bitrate is smaller than what is needed for compression try to set isMinBitRateEnabled to false",code:151)
            completion(.onFailure(error))
            return Compression()
        }

        // Generate a bitrate based on desired quality
        let newBitrate = getBitrate(bitrate: bitrate, quality: quality)

        // Handle new width and height values
        let videoSize = videoTrack.naturalSize
        let size = generateWidthAndHeight(width: videoSize.width, height: videoSize.height, keepOriginalResolution: keepOriginalResolution)
        let newWidth = size.width
        let newHeight = size.height

        // Total Frames
        let durationInSeconds = videoAsset.duration.seconds
        let frameRate = videoTrack.nominalFrameRate
        let totalFrames = ceil(durationInSeconds * Double(frameRate))

        // Progress
        let totalUnits = Int64(totalFrames)
        let progress = Progress(totalUnitCount: totalUnits)

        // Setup video writer input
        let videoWriterInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: getVideoWriterSettings(bitrate: newBitrate, width: newWidth, height: newHeight))
        videoWriterInput.expectsMediaDataInRealTime = true
        videoWriterInput.transform = videoTrack.preferredTransform

        let videoWriter = try! AVAssetWriter(outputURL: destination, fileType: AVFileType.mov)
        videoWriter.add(videoWriterInput)

        // Setup video reader output
        let videoReaderSettings:[String : AnyObject] = [
            kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange) as AnyObject
        ]
        let videoReaderOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: videoReaderSettings)

        var videoReader: AVAssetReader!
        do{
            videoReader = try AVAssetReader(asset: videoAsset)
        }
        catch {
            let compressionError = CompressionError(title: error.localizedDescription, code: 401)
            completion(.onFailure(compressionError))
        }

        videoReader.add(videoReaderOutput)
        //setup audio writer
        let audioWriterInput = AVAssetWriterInput(mediaType: AVMediaType.audio, outputSettings: nil)
        audioWriterInput.expectsMediaDataInRealTime = false
        videoWriter.add(audioWriterInput)
        //setup audio reader
        let audioTrack = videoAsset.tracks(withMediaType: AVMediaType.audio).first
        var audioReader: AVAssetReader?
        var audioReaderOutput: AVAssetReaderTrackOutput?
        if(audioTrack != nil) {
            audioReaderOutput = AVAssetReaderTrackOutput(track: audioTrack!, outputSettings: nil)
            audioReader = try! AVAssetReader(asset: videoAsset)
            audioReader?.add(audioReaderOutput!)
        }
        videoWriter.startWriting()

        //start writing from video reader
        videoReader.startReading()
        videoWriter.startSession(atSourceTime: CMTime.zero)
        let processingQueue = DispatchQueue(label: "processingQueue1")

        var isFirstBuffer = true
        videoWriterInput.requestMediaDataWhenReady(on: processingQueue, using: {() -> Void in
            while videoWriterInput.isReadyForMoreMediaData {

                // Observe any cancellation
                if compressionOperation.cancel {
                    videoReader.cancelReading()
                    videoWriter.cancelWriting()
                    completion(.onCancelled)
                    return
                }

                // Update progress based on number of processed frames
                frameCount += 1
                if let handler = progressHandler {
                    progress.completedUnitCount = Int64(frameCount)
                    progressQueue.async { handler(progress) }
                }

                let sampleBuffer: CMSampleBuffer? = videoReaderOutput.copyNextSampleBuffer()

                if videoReader.status == .reading && sampleBuffer != nil {
                    videoWriterInput.append(sampleBuffer!)
                } else {
                    videoWriterInput.markAsFinished()
                    if videoReader.status == .completed {
                        if(audioReader != nil){
                            if(!(audioReader!.status == .reading) || !(audioReader!.status == .completed)){
                                //start writing from audio reader
                                audioReader?.startReading()
                                videoWriter.startSession(atSourceTime: CMTime.zero)
                                let processingQueue = DispatchQueue(label: "processingQueue2")

                                audioWriterInput.requestMediaDataWhenReady(on: processingQueue, using: {[weak self]() -> Void in
                                    while audioWriterInput.isReadyForMoreMediaData {
                                        let sampleBuffer: CMSampleBuffer? = audioReaderOutput?.copyNextSampleBuffer()
                                        if audioReader?.status == .reading && sampleBuffer != nil {
                                        
                                            if isFirstBuffer {
                                                let dict = CMTimeCopyAsDictionary(CMTimeMake(value: 1024, timescale: 44100), allocator: kCFAllocatorDefault);
                                                CMSetAttachment(sampleBuffer as CMAttachmentBearer, key: kCMSampleBufferAttachmentKey_TrimDurationAtStart, value: dict, attachmentMode: kCMAttachmentMode_ShouldNotPropagate);
                                                isFirstBuffer = false
                                            }
                                            audioWriterInput.append(sampleBuffer!)
                                        } else {
                                            audioWriterInput.markAsFinished()

                                            videoWriter.finishWriting(completionHandler: {() -> Void in
                                                completion(.onSuccess(destination))
                                            })

                                        }
                                    }
                                })
                            }
                        } else {
                            videoWriter.finishWriting(completionHandler: {() -> Void in
                                completion(.onSuccess(destination))
                            })
                        }
                    }
                }
            }
        })
        
        return compressionOperation
    }
    
    private func getBitrate(bitrate: Float, quality: VideoQuality) -> Int {
        
        if quality == .very_low {
            return Int(bitrate * 0.08)
        } else if quality == .low {
            return Int(bitrate * 0.1)
        } else if quality == .medium {
            return Int(bitrate * 0.2)
        } else if quality == .high {
            return Int(bitrate * 0.3)
        } else if quality == .very_high {
            return Int(bitrate * 0.5)
        } else {
            return Int(bitrate * 0.2)
        }
    }
    
    private func generateWidthAndHeight(
        width: CGFloat,
        height: CGFloat,
        keepOriginalResolution: Bool
    ) -> (width: Int, height: Int) {
        
        if (keepOriginalResolution) {
            return (Int(width), Int(height))
        }
        
        var newWidth: Int
        var newHeight: Int
        
        if width >= 1920 || height >= 1920 {
            
            newWidth = Int(width * 0.5 / 16) * 16
            newHeight = Int(height * 0.5 / 16 ) * 16
            
        } else if width >= 1280 || height >= 1280 {
            newWidth = Int(width * 0.75 / 16) * 16
            newHeight = Int(height * 0.75 / 16) * 16
        } else if width >= 960 || height >= 960 {
            if(width > height){
                newWidth = Int(MIN_HEIGHT * 0.95 / 16) * 16
                newHeight = Int(MIN_WIDTH * 0.95 / 16) * 16
            } else {
                newWidth = Int(MIN_WIDTH * 0.95 / 16) * 16
                newHeight = Int(MIN_HEIGHT * 0.95 / 16) * 16
            }
        } else {
            newWidth = Int(width * 0.9 / 16) * 16
            newHeight = Int(height * 0.9 / 16) * 16
        }
        
        return (newWidth, newHeight)
    }
    
    private func getVideoWriterSettings(bitrate: Int, width: Int, height: Int) -> [String : AnyObject] {
        
        let videoWriterCompressionSettings = [
            AVVideoAverageBitRateKey : bitrate
        ]
        
        let videoWriterSettings: [String : AnyObject] = [
            AVVideoCodecKey : AVVideoCodecType.h264 as AnyObject,
            AVVideoCompressionPropertiesKey : videoWriterCompressionSettings as AnyObject,
            AVVideoWidthKey : width as AnyObject,
            AVVideoHeightKey : height as AnyObject
        ]
        
        return videoWriterSettings
    }
    
}


//
//  VAVideoCompressor.swift
//  VAVideoCompressor
//
//  Created by Anton Vodolazkyi on 29.07.2018.
//  Copyright © 2018 Anton Vodolazkyi. All rights reserved.
//


public enum VAVideoConversionPreset {
    case `default`
    case veryLow
    case low
    case medium
    case high
    case veryHigh
}

public enum VAVideoConverterError: Error {
    case emptyTracks
    case fileAlreadyExist
    case failed
}

final class VAVideoCompressor {
    
    public static func exportAsynchronously(
        with asset: AVAsset,
        outputFileType: AVFileType,
        outputURL: URL,
        videoSettings: [String: Any],
        videoComposition: AVVideoComposition? = nil,
        audioSettings: [String: Any],
        audioMix: AVAudioMix? = nil,
        completion: @escaping (Error?) -> Void) {
        guard !FileManager.default.fileExists(atPath: outputURL.path) else {
            completion(VAVideoConverterError.fileAlreadyExist)
            return
        }
        let timeRange = CMTimeRange(start: .zero,end: asset.duration)
        let reader: AVAssetReader
        do {
            reader = try AVAssetReader(asset: asset)
        } catch let error {
            completion(error)
            return
        }
        
        let writer: AVAssetWriter
        do {
            writer = try AVAssetWriter(outputURL: outputURL, fileType: outputFileType)
        } catch let error {
            completion(error)
            return
        }
        reader.timeRange = timeRange
        writer.shouldOptimizeForNetworkUse = true
        
        let videoTracks = asset.tracks(withMediaType: .video)
        
        guard !videoTracks.isEmpty else {
            completion(VAVideoConverterError.emptyTracks)
            return
        }
        
        let videoOutput = AVAssetReaderVideoCompositionOutput(videoTracks: videoTracks, videoSettings: nil)
        videoOutput.alwaysCopiesSampleData = false
        
        if let videoComposition = videoComposition {
            videoOutput.videoComposition = videoComposition
        } else {
            videoOutput.videoComposition = buildDefaultVideoComposition(asset, videoSettings: videoSettings)
        }
        
        if reader.canAdd(videoOutput) {
            reader.add(videoOutput)
        }
        
        let videoInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
        videoInput.expectsMediaDataInRealTime = false
        
        if writer.canAdd(videoInput) {
            writer.add(videoInput)
        }
        
        let audioTracks = asset.tracks(withMediaType: .audio)
        
        var audioOutput: AVAssetReaderAudioMixOutput? = nil
        var audioInput: AVAssetWriterInput? = nil
        
        if !audioTracks.isEmpty {
            audioOutput = AVAssetReaderAudioMixOutput(audioTracks: audioTracks, audioSettings: nil)
            audioOutput?.alwaysCopiesSampleData = false
            audioOutput?.audioMix = audioMix
            
            if reader.canAdd(audioOutput!) {
                reader.add(audioOutput!)
            }
            
            audioInput = AVAssetWriterInput(mediaType: .audio, outputSettings: audioSettings)
            audioInput?.expectsMediaDataInRealTime = false
            
            if writer.canAdd(audioInput!) {
                writer.add(audioInput!)
            }
        }
        
        writer.startWriting()
        reader.startReading()
        writer.startSession(atSourceTime: timeRange.start)
        
        let group = DispatchGroup()
        
        if !videoTracks.isEmpty {
            group.enter()
            videoInput.requestMediaDataWhenReady(on: .global()) {
                if !encodeReadySamplesFromOutput(videoOutput, input: videoInput, reader: reader, writer: writer) {
                    group.leave()
                }
            }
        }
        
        if let audioOutput = audioOutput, let audioInput = audioInput {
            group.enter()
            audioInput.requestMediaDataWhenReady(on: .global(), using: {
                if !encodeReadySamplesFromOutput(audioOutput, input: audioInput, reader: reader, writer: writer) {
                    group.leave()
                }
            })
        }
        
        group.notify(queue: .main) {
            guard writer.status != .cancelled else {
                try? FileManager.default.removeItem(at: outputURL)
                return
            }
            
            if writer.status == .failed {
                writer.cancelWriting()
                try? FileManager.default.removeItem(at: outputURL)
                completion(VAVideoConverterError.failed)
            } else {
                writer.finishWriting {
                    completion(nil)
                }
            }
        }
    }
    
    private static func encodeReadySamplesFromOutput(
        _ output: AVAssetReaderOutput,
        input: AVAssetWriterInput,
        reader: AVAssetReader,
        writer: AVAssetWriter
        ) -> Bool {
        while input.isReadyForMoreMediaData {
            if let sampleBuffer = output.copyNextSampleBuffer() {
                if reader.status != .reading || writer.status != .writing {
                    return false
                }
                
                if !input.append(sampleBuffer) {
                    return false
                }
                
            } else {
                input.markAsFinished()
                return false
            }
        }
        return true
    }
    
    private static func buildDefaultVideoComposition(
        _ asset: AVAsset,
        videoSettings: [String: Any]) -> AVMutableVideoComposition {
        let videoComposition = AVMutableVideoComposition()
        let videoTrack = asset.tracks(withMediaType: .video)[0]
        
        var trackFrameRate: Float = 0
        if let videoCompressionProperties = videoSettings[AVVideoCompressionPropertiesKey] as? [String: Any],
            let frameRate = videoCompressionProperties[AVVideoAverageNonDroppableFrameRateKey] as? Float {
            trackFrameRate = frameRate
        } else {
            trackFrameRate = videoTrack.nominalFrameRate
        }
        
        if trackFrameRate == 0 {
            trackFrameRate = 30
        }
        
        videoComposition.frameDuration = CMTimeMake(value: 1, timescale: Int32(trackFrameRate))
        let targetSize = CGSize(
            width: videoSettings[AVVideoWidthKey] as? CGFloat ?? 0,
            height: videoSettings[AVVideoHeightKey] as? CGFloat ?? 0
        )
        var naturalSize = videoTrack.naturalSize
        var transform = videoTrack.preferredTransform
        
        if transform.ty == -560 {
            transform.ty = 0
        }
        
        if transform.tx == -560 {
            transform.tx = 0
        }
        
        let videoAngleInDegree  = atan2(transform.b, transform.a) * 180 / CGFloat.pi
        if videoAngleInDegree == 90 || videoAngleInDegree == -90 {
            let width = naturalSize.width
            naturalSize.width = naturalSize.height
            naturalSize.height = width
        }
        videoComposition.renderSize = naturalSize
        
        var ratio: CGFloat = 00
        let xratio = targetSize.width / naturalSize.width
        let yratio = targetSize.height / naturalSize.height
        ratio = min(xratio, yratio)
        
        let postWidth = naturalSize.width * ratio
        let postHeight = naturalSize.height * ratio
        let transx = (targetSize.width - postWidth) / 2
        let transy = (targetSize.height - postHeight) / 2
        
        var matrix = CGAffineTransform(translationX: transx / xratio, y: transy / yratio)
        matrix = matrix.scaledBy(x: ratio / xratio, y: ratio / yratio)
        transform = transform.concatenating(matrix)
        
        let passThroughInstruction = AVMutableVideoCompositionInstruction()
        passThroughInstruction.timeRange = CMTimeRangeMake(start: .zero, duration: asset.duration)
        
        let passThroughLayer = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
        passThroughLayer.setTransform(transform, at: .zero)
        passThroughInstruction.layerInstructions = [passThroughLayer]
        videoComposition.instructions = [passThroughInstruction]
        
        return videoComposition
    }
    
    private static func videoBitrateKbpsForPreset(_ preset: VAVideoConversionPreset) -> Int {
        switch preset {
        case .veryLow:
            return 400
        case .low:
            return 700
        case .medium:
            return 1100
        case .high:
            return 2500
        case .veryHigh:
            return 4000
        default:
            return 700
        }
    }
    
    static func videoSettingsForPreset(_ preset: VAVideoConversionPreset, size: CGSize) -> [String: Any] {
        let codecSettings = [AVVideoAverageBitRateKey: videoBitrateKbpsForPreset(preset) * 1000]
        return [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoCompressionPropertiesKey: codecSettings,
            AVVideoWidthKey: size.width,
            AVVideoHeightKey: size.height
        ]
    }
    
}


extension AVAsset {
    
    func videoSize() -> CGSize {
        let visual = AVMediaCharacteristic.visual
        let vTrack = tracks(withMediaCharacteristic: visual)[0]
        var error: NSError? = nil
        let keyPath = #keyPath(AVAssetTrack.naturalSize)
        if vTrack.statusOfValue(forKey: keyPath, error: &error) == .loaded {
            return vTrack.orientationBasedSize
        } else {
            var size = CGSize()
            let dg = DispatchGroup()
            dg.enter()
            vTrack.loadValuesAsynchronously(forKeys: [keyPath]) {
                size = vTrack.orientationBasedSize
                dg.leave()
            }
            dg.wait()
            return size
        }
    }
    
}

extension AVAssetTrack {
    
    var orientation: (UIInterfaceOrientation, AVCaptureDevice.Position) {
        var orientation: UIInterfaceOrientation = .unknown
        var device: AVCaptureDevice.Position = .unspecified
        let t = preferredTransform
        
        if (t.a == 0 && t.b == 1.0 && t.d == 0) {
            orientation = .portrait
            
            if t.c == 1.0 {
                device = .front
            } else if t.c == -1.0 {
                device = .back
            }
        } else if (t.a == 0 && t.b == -1.0 && t.d == 0) {
            orientation = .portraitUpsideDown
            
            if t.c == -1.0 {
                device = .front
            } else if t.c == 1.0 {
                device = .back
            }
        } else if (t.a == 1.0 && t.b == 0 && t.c == 0) {
            orientation = .landscapeRight
            
            if t.d == -1.0 {
                device = .front
            } else if t.d == 1.0 {
                device = .back
            }
        } else if (t.a == -1.0 && t.b == 0 && t.c == 0) {
            orientation = .landscapeLeft
            
            if t.d == 1.0 {
                device = .front
            } else if t.d == -1.0 {
                device = .back
            }
        }
        
        return (orientation, device)
    }
    
    var isPortrait: Bool {
        return orientation.0.isPortrait
    }
    
    var orientationBasedSize: CGSize {
        guard isPortrait else {
            return naturalSize
        }
        
        return CGSize(width: naturalSize.height, height: naturalSize.width)
    }
    
}
