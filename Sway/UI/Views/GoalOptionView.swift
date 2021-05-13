//
//  GoalOptionView.swift
//  Sway
//
//  Created by Admin on 12/05/21.
//

import UIKit

class GoalOptionView: UIView {

    private var overlayView:UIView? = nil
    var onClick:((GoalOptionView) ->())? = nil
    var isSelected:Bool = false {
        didSet {
            if isSelected{
                getOverlayView()?.removeFromSuperview()
            }else {
                self.addSubview(getOverlayView()!)
            }
        }
    }
    
    private func getOverlayView() -> UIView?{
        if overlayView != nil {
            return overlayView
        }
        overlayView = UIView(frame: self.bounds)
        overlayView?.backgroundColor = UIColor.white.withAlphaComponent(0.75)
        return overlayView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 28
        self.clipsToBounds = true
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor(named: "kThemeNavyBlue")?.withAlphaComponent(isSelected ? 1 : 0.3).cgColor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    private func initialize(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapOnSelf(_:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
        self.isSelected = false
    }
    
    @objc func tapOnSelf(_ gesture:UITapGestureRecognizer){
        self.onClick?(self)
    }

}
