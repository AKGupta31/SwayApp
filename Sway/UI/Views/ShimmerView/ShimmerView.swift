//
//  ShimmerView.swift
//  Sway
//
//  Created by Admin on 10/06/21.
//

import UIKit

class ShimmerView: UIView {

    var gradientColorOne : CGColor = UIColor(white: 0.85, alpha: 1.0).cgColor
    var gradientColorTwo : CGColor = UIColor(white: 0.95, alpha: 1.0).cgColor
    
    func addGradientLayer() -> CAGradientLayer {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [gradientColorOne, gradientColorTwo, gradientColorOne]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        self.layer.addSublayer(gradientLayer)
        
        return gradientLayer
    }
    
    func addAnimation() -> CABasicAnimation {
       
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.repeatCount = .infinity
        animation.duration = 0.9
        return animation
    }
    
    func startAnimating() {
        
        let gradientLayer = addGradientLayer()
        let animation = addAnimation()
       
        gradientLayer.add(animation, forKey: animation.keyPath)
    }

}

extension UIView {
    func addUpAnimation() -> CABasicAnimation {
       
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = [self.frame.midX,self.frame.midY]
        animation.toValue = [self.frame.midX,self.frame.midY + 36]
        animation.repeatCount = .infinity
        animation.duration = 0.7
        animation.fillMode = .both
        animation.autoreverses = true
        return animation
    }
    
    func startSwipeUpAnimating() {
        let upAnimation = addUpAnimation()
        self.layer.add(upAnimation, forKey: upAnimation.keyPath)
    }
}
