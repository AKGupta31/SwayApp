//
//  HIITItemCell.swift
//  Sway
//
//  Created by Admin on 21/06/21.
//

import UIKit

enum HIITCellType:Int {
    case completed = 0
    case next
    case normal
}

class HIITItemCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var customRectangularView: CustomView!
    
    @IBOutlet weak var viewContent: CustomView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var imgTick: UIImageView!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    
    var cellType :HIITCellType = .normal {
        didSet {
            btnNext.isHidden = true
            switch cellType {
            case .completed:
                viewContent.backgroundColor = UIColor(named: "kThemeBlue")
                imgTick.isHidden = false
                lblNumber.isHidden = true
                lblDuration.textColor =
                    UIColor.white.withAlphaComponent(0.6)
                lblName.textColor = .white
                lblName.text = (lblName.text ?? "") + " - Completed"
            case .next:
                btnNext.isHidden = false
                lblName.text = (lblName.text ?? "") + " - Next"
                fallthrough
            case .normal:
                viewContent.backgroundColor = UIColor(named: "k5953_0.05")
                imgTick.isHidden = true
                lblNumber.isHidden = false
                lblDuration.textColor = UIColor(named: "k124123132")?.withAlphaComponent(0.6)
                lblName.textColor = UIColor(named: "kThemeNavyBlue")
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgTick.isHidden = true
    }
    
    



}
