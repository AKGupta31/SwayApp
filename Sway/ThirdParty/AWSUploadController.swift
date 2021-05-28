//
//  AWSUploadController.swift
//  Kenzie
//
//  Created by AirHireMe on 15/04/20.
//  Copyright © 2020 AirHireMe. All rights reserved.
//

import Foundation
import AWSCore
import AWSS3
import UIKit
import AVKit
import AVFoundation


typealias progressBlock = (_ progress: Double) -> Void //2
typealias completionBlock = (_ response: Any?, _ error: Error?) -> Void //3

class AWSUploadController {
    // MARK: CANCEL REQUEST
    //=======================
    static func cancelAllRequest() {
        AWSS3TransferUtility.default().enumerateToAssignBlocks(forUploadTask: { (uploadTask: AWSS3TransferUtilityUploadTask, _:  AutoreleasingUnsafeMutablePointer<(@convention(block) (AWSS3TransferUtilityTask, Progress) -> Void)?>?, _: AutoreleasingUnsafeMutablePointer<(@convention(block) (AWSS3TransferUtilityUploadTask, Error?) -> Void)?>?) in
            uploadTask.cancel()
            print(#function)
        }, downloadTask: nil)
    }
    
    static func cancelRequest(fileName: String) {
        AWSS3TransferUtility.default().enumerateToAssignBlocks(forUploadTask: { (uploadTask: AWSS3TransferUtilityUploadTask, _:  AutoreleasingUnsafeMutablePointer<(@convention(block) (AWSS3TransferUtilityTask, Progress) -> Void)?>?, _: AutoreleasingUnsafeMutablePointer<(@convention(block) (AWSS3TransferUtilityUploadTask, Error?) -> Void)?>?) in
            if uploadTask.key == fileName {
                uploadTask.cancel()
            }
            print(#function)
        }, downloadTask: nil)
    }
    
    // MARK: Setting S3 server with the credentials...
    // =========================================
    /// Set up Amazon s3 (For image uploading) with pool ID
    static func setupAmazonS3(withPoolID poolID: String) {
        
        let credentialsProvider = AWSCognitoCredentialsProvider( regionType: .USEast1,
                                                                 identityPoolId: poolID)
        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
    
    static func deleteS3Object(fileName: String) {
        let s3 = AWSS3.default()
        if let deleteObjectRequest = AWSS3DeleteObjectRequest() {
            deleteObjectRequest.bucket = Constants.S3BucketCredentials.s3BucketName
            deleteObjectRequest.key = fileName
            s3.deleteObject(deleteObjectRequest).continueWith { (task: AWSTask) -> AnyObject? in
                if let error = task.error {
                    print("Error occurred: \(error)")
                    return nil
                }
                print("Deleted successfully.")
                return nil
            }
        } else {
            print("Something went wrong")
        }
    }
    
    ///upload file func without use of delegates : - it is using closures
    static func uploadFileToAWS(file: FileUploadModel,
                                success: @escaping(_ url: String, _ uri: String) -> Void,
                                progress: ((_ progressPercent:Float) -> Void)? = nil,
                                faliure: @escaping(_ message: String) -> Void) {
        
        guard let imageURL = URL(string: file.uri) else { return }
        let fileExt = imageURL.pathExtension
        //        let name = "\(Constants.S3BucketCredentials.s3BucketName)\(Int(Date().timeIntervalSince1970))_\(String.randomString(length: 8))\(file.contentType == .image ? ".jpeg" : ".mp4")"
        
        let name = "\(Constants.S3BucketCredentials.s3BucketName)\(Int(Date().timeIntervalSince1970))_\(String.randomString(length: 8))\("." + fileExt)"
        
        let expression = AWSS3TransferUtilityUploadExpression()
        let transferUtility = AWSS3TransferUtility.default()
        expression.progressBlock = {(task, status) in
            print(Date())
            print(status.fractionCompleted)
            DispatchQueue.main.async(execute: {
                progress?(Float(status.fractionCompleted))
            })
        }
        
        // For public read
        expression.setValue("public-read", forRequestParameter: "x-amz-acl")
        expression.setValue("public-read", forRequestHeader: "x-amz-acl" )
        
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                if let error = error {
                    print("Upload failed with error: (\(error.localizedDescription))")
                    faliure(error.localizedDescription)
                }
                
                else {
                    let url = URL(string: Constants.S3BucketCredentials.s3BaseUrl)
                    let publicURL = url?.appendingPathComponent(name).absoluteString
                    success(publicURL ?? "", imageURL.absoluteString)
                    print("uploading end at =====> \(Date())")
                }
            })
        }
        DispatchQueue.main.async {
            transferUtility.uploadFile(imageURL, bucket: Constants.S3BucketCredentials.s3BucketName, key: name, contentType: file.contentType == .image ? "image/jpeg" : "video/mp4", expression: expression, completionHandler: completionHandler).continueWith { (task) -> Any? in
                
                
                if let error = task.error {
                    print("error is: \(error.localizedDescription)")
                    print(task.error ?? "")
                }
                
                if let _ = task.result {
                    print(task)
                    print(task.result ?? "")
                }
                return nil
            }
        }
    }
    
  
    
    func uploadVideoToS3(url: URL,
                         success: @escaping (Bool, String, String) -> Void,
                         progress: @escaping (CGFloat) -> Void,
                         failure: @escaping (Error) -> Void) {
        
        let expression = AWSS3TransferUtilityUploadExpression()
        let transferUtility = AWSS3TransferUtility.default()
        let pathExt = url.pathExtension
        let name = "\(Int(Date().timeIntervalSince1970))." + pathExt
        let progressBlock: AWSS3TransferUtilityProgressBlock = {(task, progres) in
            DispatchQueue.main.async(execute: {
                progress(CGFloat(progres.fractionCompleted))
            })
        }
        
        expression.progressBlock = progressBlock
        expression.setValue("public-read", forRequestParameter: "x-amz-acl")
        expression.setValue("public-read", forRequestHeader: "x-amz-acl" )
        
        let completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                if let error = error {
                    print("Failed with error: \(error)")
                    failure(error)
                } else {
                    let imageURL = "\(Constants.S3BucketCredentials.s3BaseUrl)\(name)"
                    print(imageURL)
                    success(true, imageURL, name)
                }
            })
        }
        do {
            let data = try  Data(contentsOf: url)
            transferUtility.uploadData(
                data,
                bucket: "\(Constants.S3BucketCredentials.s3BucketName)",
                key: "\(name)",
                contentType: "video/mp4",
                expression: expression,
                completionHandler: completionHandler).continueWith { (task) -> AnyObject? in
                    if let error = task.error {
                        print("Error: \(error.localizedDescription)")
                        failure(error)
                    }
                    
                    if task.result != nil {
                        // Do something with uploadTask.
                    }
                    return nil
                }
        }catch {
            print("error ",error.localizedDescription)
        }
    }
    
}



extension UIImage {
    
    // MARK: - Uploading image function with S3 server...
    //==========================================
    func uploadImageToS3(uploadFolderName: String,
                         compressionRatio: CGFloat = 0.7,
                         success: @escaping (Bool, String, String) -> Void,
                         progress: @escaping (CGFloat) -> Void,
                         failure: @escaping (Error) -> Void) {
        
        let expression = AWSS3TransferUtilityUploadExpression()
        let transferUtility = AWSS3TransferUtility.default()
        let name = "\(Int(Date().timeIntervalSince1970)).png"
        
        // MARK: - Compressing image before making upload request...
        guard let data = self.jpegData(compressionQuality: compressionRatio) else {
            let err = NSError(domain: "Error while compressing the image.", code: 01, userInfo: nil)
            failure(err)
            return
        }
        
        let progressBlock: AWSS3TransferUtilityProgressBlock = {(task, progres) in
            DispatchQueue.main.async(execute: {
                progress(CGFloat(progres.fractionCompleted))
            })
        }
        
        expression.progressBlock = progressBlock
        expression.setValue("public-read", forRequestParameter: "x-amz-acl")
        expression.setValue("public-read", forRequestHeader: "x-amz-acl" )
        
        let completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                if let error = error {
                    print("Failed with error: \(error)")
                    failure(error)
                } else {
                    let imageURL = "\(Constants.S3BucketCredentials.s3BaseUrl)\(name)"
                    print(imageURL)
                    success(true, imageURL, name)
                }
            })
        }
        transferUtility.uploadData(
            data,
            bucket: "\(Constants.S3BucketCredentials.s3BucketName)",
            key: "\(name)",
            contentType: "image/png",
            expression: expression,
            completionHandler: completionHandler).continueWith { (task) -> AnyObject? in
                if let error = task.error {
                    print("Error: \(error.localizedDescription)")
                    failure(error)
                }
                
                if task.result != nil {
                    // Do something with uploadTask.
                }
                return nil
            }
    } 
}

final class FileUploadModel: Hashable, Equatable {
    
    var uri: String = ""
    var url: String = ""
    var aspectRatio = ""
    
    var contentType : S3MediaType = .image
    
    var progress: Float = 0.0 {
        didSet {
            self.progressUpdateClosure?(progress)
        }
    }
    
    var progressUpdateClosure:((_ progress: Float)->())?
    
    var stateChanged: ((_ newState: FileUploadStatus)-> Void)?
    
    fileprivate weak var uploadRequest:AWSS3TransferUtilityUploadTask?
    //    fileprivate weak var uploadRequest: AWSS3TransferManagerUploadRequest?
    var status: FileUploadStatus = .unknown {
        didSet {
            if status == .canceled {
                let _ = self.uploadRequest?.cancel()
            }
            self.stateChanged?(self.status)
        }
    }
    
    func getImage(_ block: ((_ img: UIImage?) -> Void)?) {
        
        DispatchQueue.global().async {
            if let url = URL(string: self.uri), let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    block?(UIImage(data: data))
                }
            } else {
                DispatchQueue.main.async {
                    block?(nil)
                }
            }
        }
    }
    
    init(uri: String, contentType: S3MediaType = .image) {
        self.uri = uri
        self.contentType = contentType
    }
    
    init(uri: String, url: String , aspectRatio : String = "1" , contentType : S3MediaType = .image) {
        self.uri = uri
        self.url = url
        self.aspectRatio = aspectRatio
        self.contentType = contentType
        
        self.status = self.uri == self.url ? .success : .failed
    }
    
    private init() { }
    
    func update(url: String, status: FileUploadStatus) {
        self.url = url
        self.status = status
    }
    
    func update(progress: Float, status: FileUploadStatus) {
        self.progress = progress
        self.status = status
    }
    
    func update(status: FileUploadStatus) {
        self.status = status
    }
    
    static func models(arrURI:[String]) -> [FileUploadModel] {
        var a:[FileUploadModel] = []
        for item in arrURI {
            a.append(FileUploadModel(uri: item))
        }
        return a
    }
    
    static func == (lhs: FileUploadModel, rhs: FileUploadModel) -> Bool {
        return (lhs.uri == rhs.uri)
    }
    
    var hashValue: Int {
        return uri.hashValue
    }
}

enum FileUploadStatus {
    case success
    case uploading
    case canceled
    case failed
    case unknown
}
