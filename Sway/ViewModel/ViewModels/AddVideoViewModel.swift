//
//  AddVideoViewModel.swift
//  Sway
//
//  Created by Admin on 18/05/21.
//

import UIKit
import SDWebImage
enum WorkoutType:Int {
    case DANCE_WORKOUT = 1
    case HIIT_WORKOUT = 2
    case OTHER_CONTENT = 3
}

protocol AddVideoViewModelDelegate:BaseVMDelegate {
    func videoPostedSuccessfully()
}

class AddVideoViewModel:NSObject {
    
    var videoUrl:URL?
    let thumbnail:UIImage
    var mediaType:MediaTypes = .kImage
    var workoutType:WorkoutType = .DANCE_WORKOUT
    
    private var uploadedMediaUrl:String? = nil
    private var uploadedThumbnailUrl:String? = nil
    var caption:String? = nil
    weak var delegate:AddVideoViewModelDelegate?
    var isSubmitClicked = false
    var isEditMode = false
    var feedId:String = ""
    init(videoUrl:URL?,thumbnail:UIImage){
        self.videoUrl = videoUrl
        self.thumbnail = thumbnail
        super.init()
        mediaType = videoUrl == nil ? .kImage : .kVideo
        uploadFileToAws()
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
            } failure: { (error) in
                AlertView.showAlert(with: "Error!!!", message: error.localizedDescription)
            }
        }else {
            self.thumbnail.uploadImageToS3(uploadFolderName: "", compressionRatio: 1.0) {[weak self] (isSuccess, url, fileName) in
                if let sSelf = self {
                    sSelf.uploadedMediaUrl = url
                    if sSelf.isSubmitClicked {
                        sSelf.actionSubmit() // Call this function if user has already clicked on the submit post button
                    }
                }
            } progress: { (progress) in
                print("progress ",progress)
            } failure: { (error) in
                print("error ",error.localizedDescription)
            }
        }
        uploadThumbnail()
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
            print("progress ",progress)
        } failure: { (error) in
            print("error ",error.localizedDescription)
        }
    }
    
    func actionSubmit(){
        isSubmitClicked = true
        if self.uploadedMediaUrl == nil || self.uploadedThumbnailUrl == nil {
            print("its uploading still")
            (self.delegate as? BaseViewController)?.hideLoader()
        }else {
            let (isValid,message) = areFieldsValid()
            if isValid == false {
                delegate?.showAlert(with: "Opps!!!", message: message)
                return
            }
            FeedsEndPoint.postFeed(feedId:self.feedId, caption: caption!, feedType: workoutType, url: uploadedMediaUrl!, thumbnailUrl: uploadedThumbnailUrl!, mediaType: mediaType) { [weak self](response) in
                print("response ",response)
               
                if response.statusCode == 200 {
                    self?.delegate?.videoPostedSuccessfully()
                }else {
                    self?.delegate?.showAlert(with: "Error!!!", message: response.message)
                }
            } failure: {[weak self] (status) in
                self?.delegate?.showAlert(with: "Error!!!", message: status.msg)
            }

        }
    }
    
    func areFieldsValid() -> (Bool,String) {
        if caption == nil || caption?.isEmpty == true{
            return (false,"Please enter caption for the video")
        }
        return (true,"")
    }
    
}

extension AddVideoViewModel:UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        caption = textView.text
        delegate?.reloadData()
    }
}
