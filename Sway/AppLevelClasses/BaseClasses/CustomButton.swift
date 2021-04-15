//
//  CustomButton.swift
//  Sway
//
//  Created by Admin on 14/04/21.
//

import UIKit

class CustomButton:UIButton {
    
    @IBInspectable var borderColor:UIColor = .clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var borderWidth:CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius:CGFloat = 10.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
        }
    }
    
    
}

class CustomTextLocationButton:UIButton {
    
    @IBInspectable var spacing :CGFloat = 6.0
    override func layoutSubviews() {
        super.layoutSubviews()
        if let image = self.imageView?.image {
                   let imageSize: CGSize = image.size
            self.titleEdgeInsets = UIEdgeInsets(top: spacing, left: -imageSize.width, bottom: -(imageSize.height), right: 0.0)
                   let labelString = NSString(string: self.titleLabel!.text!)
            let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel!.font!])
            self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
               }
    }
}
