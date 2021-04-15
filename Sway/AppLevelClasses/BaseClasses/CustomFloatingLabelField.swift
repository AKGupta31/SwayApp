//
//  CustomFloatingLabelField.swift
//  Sway
//
//  Created by Admin on 14/04/21.
//

import UIKit
import SkyFloatingLabelTextField

class CustomFloatingLabelField:SkyFloatingLabelTextField {
    
    
    @IBInspectable var changeSelectedTitleFormat: Bool{
        get{
            return false
        }
        set (isChange) {
            if isChange{
                fix(textField: self)
            }
        }
    }
    override func titleLabelRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
        return CGRect(x: bounds.minX - 13, y: -24, width: bounds.width, height: bounds.height)
    }
    
    func fix(textField: SkyFloatingLabelTextField) {
        textField.titleFormatter = { $0 }
    }
}
