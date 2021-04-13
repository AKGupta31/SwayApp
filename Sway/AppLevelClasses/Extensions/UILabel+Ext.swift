//
//  UILabel+Ext.swift
//  Sway
//
//  Created by Admin on 13/04/21.
//

import UIKit


extension UILabel {
    func setupLabelWithTappableArea(regularText: String, tappableText: String,regularTextSize:CGFloat = 14,tappableTextSize:CGFloat = 14) {
        let wholeText = regularText + " " + tappableText
        let attributedString = NSMutableAttributedString(string: wholeText)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "kThemeNavyBlue")!, range: NSRange(location: 0, length:regularText.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "kThemeBlue")!, range: NSRange(location: regularText.count+1, length: tappableText.count))
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.getCSFontBold(size: tappableTextSize), range: NSRange(location: regularText.count+1, length: tappableText.count))
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.getCSFontBold(size: regularTextSize), range: NSRange(location: 0, length: regularText.count))
        self.attributedText = attributedString
    }
}
