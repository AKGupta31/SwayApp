//
//  HIITDetailsBanner.swift
//  Sway
//
//  Created by Admin on 21/06/21.
//

import UIKit

class HIITDetailsBanner: UITableViewCell {

    @IBOutlet weak var backButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var imgBanner: UIImageView!
    
    @IBOutlet weak var lblIntensity: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
