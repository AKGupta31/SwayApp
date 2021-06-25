//
//  TabItemView.swift
//  Sway
//
//  Created by Admin on 17/06/21.
//

import UIKit

class TabItemView: UIView {
    
    lazy var bottomLine:UIView = {
        let line = UIView(frame: CGRect(x: 0, y: self.frame.height - 2, width: self.frame.width, height: 2))
        line.backgroundColor = UIColor(named: "kThemeNavyBlue")
        return line
    }()
    
    
    
//    lazy var unSelectedBottomLine :UIView = {
//        let line = UIView(frame: CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width, height: 1))
//        line.backgroundColor = UIColor(named: "k124123132")
//        return line
//    }()

    @IBInspectable var isSelected:Bool = false {
        didSet {
            self.addSubview(bottomLine)
            self.bottomLine.backgroundColor = UIColor(named: isSelected ? "kThemeBlue" : "k124123132")?.withAlphaComponent(isSelected ? 1.0 : 0.2)
            self.bottomLine.frame.size.height = isSelected ? 2 : 1
            for subView in self.subviews {
                if let label = subView as? UILabel {
                    label.textColor = UIColor(named: "kThemeNavyBlue")?.withAlphaComponent(isSelected ? 1.0 : 0.3)
                }
            }
        }
    }
    
    

}
