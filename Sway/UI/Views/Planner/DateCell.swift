//
//  DateCell.swift
//  Sway
//
//  Created by Admin on 19/07/21.
//

import UIKit

enum DateCellType:Int {
    case currentDate
    case selectedItem
    case normal
}

class DateCell: UICollectionViewCell {
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var lblDayOfMonth: UILabel!
    @IBOutlet weak var lblDayOfWeek: UILabel!
    
    var type:DateCellType = .normal{
        didSet {
            switch type {
            case .selectedItem :
                viewContent.backgroundColor = UIColor(named: "kThemeBlue")
                lblDayOfWeek.textColor = UIColor.white
                lblDayOfMonth.textColor = UIColor.white
            case .currentDate:
                viewContent.backgroundColor = UIColor(named: "kThemeYellow")
                lblDayOfWeek.textColor = UIColor(named: "kThemeNavyBlue")
                lblDayOfMonth.textColor = UIColor(named: "kThemeNavyBlue")
            case .normal:
                viewContent.backgroundColor = UIColor(named: "k5953_0.05")
                lblDayOfWeek.textColor = UIColor(named: "kThemeNavyBlue")
                lblDayOfMonth.textColor = UIColor(named: "kThemeNavyBlue")
            }
        }
    }
    
    func setupData(dateVM:DateViewModel){
        lblDayOfMonth.text = dateVM.dayOfTheMonth.description
        lblDayOfWeek.text = dateVM.dayOfWeek.shortName
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("view content ",viewContent.frame)
    }
}
