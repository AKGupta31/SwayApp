//
//  CustomView.swift
//  Sway
//
//  Created by Admin on 13/04/21.
//

import UIKit



class CustomView:UIView {
    
    @IBInspectable var borderColor:UIColor = .clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var selectedBorderColor:UIColor = .clear
    @IBInspectable var borderWidth:CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    var isSelected = false {
        didSet {
            self.layer.borderColor = selectedBorderColor.cgColor
        }
    }
    
    @IBInspectable var cornerRadius:CGFloat = 10.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
        }
    }
    
    @IBInspectable var isCircle:Bool = true{
        didSet {
            self.layer.cornerRadius = self.frame.height / 2
            self.clipsToBounds = true
        }
    }
}


class CustomImageView:UIImageView {
    
    @IBInspectable var borderColor:UIColor = .clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var selectedBorderColor:UIColor = .clear
    @IBInspectable var borderWidth:CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    var isSelected = false {
        didSet {
            self.layer.borderColor = selectedBorderColor.cgColor
        }
    }
    
    @IBInspectable var cornerRadius:CGFloat = 10.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
        }
    }
    
    @IBInspectable var isCircle:Bool = true{
        didSet {
            self.layer.cornerRadius = self.frame.height / 2
            self.clipsToBounds = true
        }
    }
}
