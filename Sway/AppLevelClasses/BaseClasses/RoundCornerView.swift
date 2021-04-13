//
//  RoundCornerView.swift
//  Sway
//
//  Created by Admin on 13/04/21.
//

import UIKit

class RoundCornerView:UIView {
    @IBInspectable var isRoundCorner:Bool = true
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}


