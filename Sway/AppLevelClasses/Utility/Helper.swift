//
//  Helper.swift
//  Sway
//
//  Created by Admin on 02/06/21.
//

//This class contains custom methods to reuse

import UIKit


class Helper {
    private init(){}
    static let shared = Helper()
    func addNoDataLabel(strMessage: String,to view:UIView,offSet:CGPoint = .zero) -> UIView {
        let bgView = UIView(frame: view.bounds)
        bgView.backgroundColor = UIColor.white
        let topOffSet = offSet.y
        let noDataLabel = UILabel(frame:CGRect(x: 36, y: view.bounds.midY + topOffSet, width: view.frame.width - 72, height: 72))
        noDataLabel.text = strMessage
        noDataLabel.textColor = UIColor(named: "kThemeNavyBlue_50")
        noDataLabel.textAlignment = .center
        noDataLabel.numberOfLines = 0
        noDataLabel.font = UIFont(name: "CircularStd-Book", size: 14)
        bgView.addSubview(noDataLabel)
        return bgView
    }
    
}
