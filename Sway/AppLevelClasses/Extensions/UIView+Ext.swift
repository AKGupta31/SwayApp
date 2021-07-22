//
//  UIView+Ext.swift
//  Sway
//
//  Created by Admin on 03/06/21.
//

import UIKit

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: self, options: nil)?.first as! T
    }
    
    //Adds shadow to a specific view
    func addShadow(shadowColor: CGColor = UIColor.black.cgColor,
                   shadowOffset: CGSize = CGSize(width: 1.0, height: 8.0),
                   shadowOpacity: Float = 0.06,
                   shadowRadius: CGFloat = 6.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
    func removeShadow() {
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0
        layer.shadowRadius = 3
    }
}
