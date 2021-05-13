//
//  TopRoundCornerView.swift
//  Sway
//
//  Created by Admin on 13/04/21.
//


import UIKit

final class TopRoundCornerView : UIView {
    
    private var shadowLayer: CAShapeLayer!
    
    @IBInspectable var cornerRadius:CGFloat = 10.0 {
        didSet {
            layoutSubviews()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topRight,.topLeft], cornerRadii: CGSize(width: 25, height: 25))
            shadowLayer.path = path.cgPath
            shadowLayer.fillColor = UIColor.white.cgColor
            layer.mask = shadowLayer
//        }
    }
    
}
