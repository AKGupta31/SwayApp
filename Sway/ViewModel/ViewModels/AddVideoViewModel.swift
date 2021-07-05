//
//  AddVideoViewModel.swift
//  Sway
//
//  Created by Admin on 18/05/21.
//

import UIKit
import SDWebImage
import AVFoundation

enum WorkoutType:Int {
    case DANCE_WORKOUT = 1
    case HIIT_WORKOUT = 2
    case OTHER_CONTENT = 3
    
    var displayString:String {
        switch self {
        case .HIIT_WORKOUT:
            return "HIIT"
        case .DANCE_WORKOUT:
            return "DANCE"
        case .OTHER_CONTENT:
            return "DANCE + HIIT"
        }
    }
}

protocol AddVideoViewModelDelegate:BaseVMDelegate {
    func videoPostedSuccessfully()
    func textViewDidChange(_ textView:UITextView)
}

class AddVideoViewModel:NSObject {
    
    var videoUrl:URL?
    var thumbnail:UIImage
    var mediaType:MediaTypes = .kImage
    var workoutType:WorkoutType = .DANCE_WORKOUT
    
    private var uploadedMediaUrl:String? = nil
    private var uploadedThumbnailUrl:String? = nil
    var caption:String? = nil
    var otherContentDescription:String? = nil
    weak var delegate:AddVideoViewModelDelegate?
    var isSubmitClicked = false
    var isEditMode = false
    var feedId:String = ""
    var isAlreadyUploading = false
    var originalVideoUrl:URL?

    
    init(videoUrl:URL?,thumbnail:UIImage){
        self.originalVideoUrl = videoUrl
        self.thumbnail = thumbnail
        super.init()
        mediaType = originalVideoUrl == nil ? .kImage : .kVideo
        compressIfVideoThenUpload()
//        uploadFileToAws()
    }
    
    func compressIfVideoThenUpload(){
        if let vUrl = self.originalVideoUrl {
            let lastPath  = vUrl.lastPathComponent
            
            let newDirectory = DirectoryUtility.getPath(folder: FolderNames.kCompressedVideos.rawValue)
            let destinationUrl = newDirectory.appendingPathComponent(lastPath)
          
//            let originalSize = NSData(contentsOf: originalVideoUrl!)
//            let sizeinMB = ByteCountFormatter.string(fromByteCount: Int64((originalSize?.length)!), countStyle: .file)
//            print("size in mb original ",sizeinMB)


            let compression =   LightCompressor.init().compressVideo(source: vUrl, destination: destinationUrl, quality: VideoQuality.high, progressQueue: .main) { (progress) in
                print("compression progress",progress)
            } completion: { [weak self](result) in
                switch result{
                case .onSuccess(let url):
                    self?.videoUrl = url
                    self?.uploadFileToAws()
                    
                case .onFailure(let error):
                    self?.videoUrl = self?.originalVideoUrl
                    if error.code == 151 {
                        self?.delegate?.showAlert(with: Constants.Messages.kError, message: error.title)
                    }else {
                        self?.delegate?.showAlert(with: Constants.Messages.kError, message: "There is some error in the video.Please try another one.")
                    }
                    self?.uploadFileToAws()
                case .onCancelled:
                    self?.delegate?.showAlert(with: Constants.Messages.kError, message: "Video upload cancelled by you")
                default:
                    break
                }
            }


        }else {
            uploadFileToAws()
        }
        
    }
    
    //for editing the media
    func updateMedia(videoUrl:URL?,thumbnail:UIImage){
        self.isAlreadyUploading = false
        self.uploadedMediaUrl = nil
        self.uploadedThumbnailUrl = nil
        self.originalVideoUrl = videoUrl
//        self.videoUrl = videoUrl
        self.thumbnail = thumbnail
        mediaType = videoUrl == nil ? .kImage : .kVideo
        compressIfVideoThenUpload()
//        uploadFileToAws()
    }
    
    init(feedViewModel:FeedViewModel,thumbnail:UIImage) {
        self.videoUrl = feedViewModel.mediaUrl
        self.mediaType = feedViewModel.mediaType
        self.uploadedMediaUrl = feedViewModel.mediaUrl?.absoluteString
        self.uploadedThumbnailUrl = feedViewModel.thumbUrl?.absoluteString
        self.thumbnail = thumbnail
        super.init()
        self.caption = feedViewModel.caption
        self.workoutType = feedViewModel.workoutType
        isEditMode  = true
        self.feedId = feedViewModel.feedId
    }
    
    func uploadFileToAws(){
        if Api.isConnectedToNetwork() {
            isAlreadyUploading = true
            if let url = videoUrl {
                AWSUploadController.init().uploadVideoToS3(url: url) { [weak self] (isSuccess, url, fileName) in
                    print("success ",isSuccess)
                    print("url 1 ",url)
                    print("url2 ",fileName)
                    if let sSelf = self {
                        sSelf.uploadedMediaUrl = url
                        if sSelf.isSubmitClicked {
                            sSelf.actionSubmit() // Call this function if user has already clicked on the submit post button
                        }
                    }
                } progress: { (progress) in
                    print("progress ",progress)
                } failure: {[weak self] (error) in
                    self?.isAlreadyUploading = false
                    AlertView.showAlert(with: "Error", message: error.localizedDescription)
                }
            } else {
                self.thumbnail.uploadImageToS3(uploadFolderName: "", compressionRatio: 1.0) {[weak self] (isSuccess, url, fileName) in
                    if let sSelf = self {
                        sSelf.uploadedMediaUrl = url
                        if sSelf.isSubmitClicked {
                            sSelf.actionSubmit() // Call this function if user has already clicked on the submit post button
                        }
                    }
                } progress: { (progress) in
                    print("progress ",progress)
                } failure: { [weak self] (error) in
                    self?.isAlreadyUploading = false
                    print("error ",error.localizedDescription)
                }
            }
            uploadThumbnail()
            
        }else {
            delegate?.showAlert(with: "Error", message: "Internet connection appears to be offline")
        }
    }
    
    private func uploadThumbnail(){
        guard let data = thumbnail.jpegData(compressionQuality: 1) else {return}
        let imageData = NSData(data:data)
        let sizeInKB = CGFloat(imageData.count)/1000.0
        print("actual size of image in KB: %f ",sizeInKB)
        var compressionQuality :CGFloat = 0.5
        if sizeInKB > 100{
            compressionQuality = 100 / sizeInKB
        }
        self.thumbnail.uploadImageToS3(uploadFolderName: "", compressionRatio: compressionQuality) {[weak self] (isSuccess, url, fileName) in
            if let sSelf = self {
                sSelf.uploadedThumbnailUrl = url
                if sSelf.isSubmitClicked {
                    sSelf.actionSubmit() // Call this function if user has already clicked on the submit post button
                }
            }
            
        } progress: { (progress) in
            print("progress thumbnail ",progress)
        } failure: { (error) in
            print("error ",error.localizedDescription)
        }
    }
    
    func actionSubmit(){
        if Api.isConnectedToNetwork() {
            isSubmitClicked = true
            (self.delegate as? BaseViewController)?.showLoader()
            if (self.uploadedMediaUrl == nil || self.uploadedThumbnailUrl == nil ) && isAlreadyUploading == false{
                uploadFileToAws()
            } else if (self.uploadedMediaUrl == nil || self.uploadedThumbnailUrl == nil) {
                print("its uploading still")
            }else {
                let (isValid,message) = areFieldsValid()
                if isValid == false {
                    delegate?.showAlert(with: "Oops", message: message)
                    return
                }
                FeedsEndPoint.postFeed(feedId:self.feedId, caption: caption!, feedType: workoutType, url: uploadedMediaUrl!, thumbnailUrl: uploadedThumbnailUrl!, mediaType: mediaType, otherContentDescription: otherContentDescription) { [weak self](response) in
                    print("response ",response)
                    
                    if response.statusCode == 200 {
                        self?.delegate?.videoPostedSuccessfully()
                    }else {
                        self?.delegate?.showAlert(with: "Error", message: response.message)
                    }
                } failure: {[weak self] (status) in
                    self?.delegate?.showAlert(with: "Error", message: status.msg)
                }
                
            }
        }else {
            delegate?.showAlert(with: "Error", message: "Internet connection appears to be offline")
        }
        
    }
    
    func areFieldsValid() -> (Bool,String) {
        if caption == nil || caption?.isEmpty == true{
            return (false,"Please enter caption for the video")
        }else if self.workoutType == .OTHER_CONTENT && (otherContentDescription == nil || otherContentDescription?.isEmpty == true) {
            return (false,"Please enter description for the video content")
        }
        return (true,"")
    }
    
}

extension AddVideoViewModel:UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.tag == 1 {
            caption = textView.text
        }else if textView.tag == 2 {
            otherContentDescription = textView.text
        }
        delegate?.reloadData()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.textViewDidChange(textView)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let char = text.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
               return true
            }
        }
        if textView.text.count <= 120 {
            return true
        }
        return false
    }
    
}
