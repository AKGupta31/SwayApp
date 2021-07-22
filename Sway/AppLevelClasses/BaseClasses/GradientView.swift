//
//  GradientView.swift
//  Sway
//
//  Created by Admin on 20/07/21.
//

import UIKit


class
GradientView:CustomView {
    
    @IBInspectable
    var startColor: UIColor = .white

    @IBInspectable
    var endColor: UIColor = .black
    
    @IBInspectable var opacity:CGFloat = 1.0
    
    @IBInspectable var angleInDegrees:CGFloat = 90.0

    private let gradientLayerName = "Gradient"

    override func layoutSubviews() {
        super.layoutSubviews()
        setupGradient()
    }

    private func setupGradient() {
        var gradient: CAGradientLayer? = layer.sublayers?.first { $0.name == gradientLayerName } as? CAGradientLayer
        if gradient == nil {
            gradient = CAGradientLayer()
            gradient?.name = gradientLayerName
            layer.addSublayer(gradient!)
        }
        gradient?.opacity = Float(0.1)
        gradient?.frame = bounds
        gradient?.colors = [startColor.cgColor, endColor.cgColor]
        gradient?.zPosition = -1
        
        
        let alpha: Float = Float(angleInDegrees / 360)
        let startPointX = powf(
            sinf(2 * Float.pi * ((alpha + 0.75) / 2)),
            2
        )
        let startPointY = powf(
            sinf(2 * Float.pi * ((alpha + 0) / 2)),
            2
        )
        let endPointX = powf(
            sinf(2 * Float.pi * ((alpha + 0.25) / 2)),
            2
        )
        let endPointY = powf(
            sinf(2 * Float.pi * ((alpha + 0.5) / 2)),
            2
        )
        
        gradient?.endPoint = CGPoint(x: CGFloat(endPointX),y: CGFloat(endPointY))
        gradient?.startPoint = CGPoint(x: CGFloat(startPointX), y: CGFloat(startPointY))
    }

}
