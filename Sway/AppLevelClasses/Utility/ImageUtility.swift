//
//  ImageUtility.swift
//  Sway
//
//  Created by Admin on 03/06/21.
//

import UIKit
class ImageUtility {
    private init(){}
    static let shared = ImageUtility()
    
    /*
     maxSize : is maximum size of the image in KB
     */
    func getCompressedImage(originalImage:UIImage,maxSize:CGFloat) -> UIImage{
        guard let data = originalImage.jpegData(compressionQuality: 1) else {return originalImage}
        let imageData = NSData(data:data)
        let sizeInKB = CGFloat(imageData.count)/1000.0
        print("actual size of image in KB: %f ",sizeInKB)
        var compressionQuality :CGFloat = 0.5
        if sizeInKB > maxSize{
            compressionQuality = maxSize / sizeInKB
        }
        guard let newImageData = originalImage.jpegData(compressionQuality: compressionQuality) else {
            return originalImage
        }
        let newImage = UIImage(data: newImageData)
        return newImage ?? originalImage
    }
}
