//
//  VideoUtility.swift
//  Sway
//
//  Created by Admin on 18/05/21.
//

import UIKit
import AVFoundation
import Photos
class VideoUtility {
    static let shared = VideoUtility()
    func getImageFromUrl(url:URL) -> UIImage? {
        do
           {
            let asset = AVURLAsset(url: url)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at:CMTimeMake(value: Int64(0), timescale: Int32(1)),actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
           }
        catch let error as NSError {
            print("Error generating thumbnail: \(error)")
            return nil
        }
    }
    
    func saveVideoToLibrary(url:URL,mediaType:MediaTypes,completion:((Bool, Error?) -> Void)?){
        PHPhotoLibrary.shared().performChanges({
            if mediaType == .kImage{
                PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: url)
            }else {
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
            }
            
        }) { saved, error in
            completion?(saved,error)
        }
    }
}
