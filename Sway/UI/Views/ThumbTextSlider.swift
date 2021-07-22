//
//  ThumbTextSlider.swift
//  Sway
//
//  Created by Admin on 12/07/21.
//


import UIKit

class ThumbTextSlider: UISlider {
    var thumbTextLabel: UILabel = UILabel()
    
    private var thumbFrame: CGRect {
        return thumbRect(forBounds: bounds, trackRect: trackRect(forBounds: bounds), value: value)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let frame = thumbFrame
        thumbTextLabel.frame = CGRect(x: frame.origin.x, y: frame.origin.y - frame.height, width: frame.width, height: frame.height)
        let sliderValue = String(format:"%.1f", value)
        thumbTextLabel.text = sliderValue
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(thumbTextLabel)
        thumbTextLabel.textAlignment = .center
        thumbTextLabel.layer.zPosition = layer.zPosition + 1
    }
}
