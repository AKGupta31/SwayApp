//
//  HIITDescriptionCell.swift
//  Sway
//
//  Created by Admin on 21/06/21.
//

import UIKit

class HIITDescriptionCell: UITableViewCell {
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var lblSpaceValue: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblDurationUnit: UILabel!
    @IBOutlet weak var imgTime: UIImageView!
    @IBOutlet weak var lblIntensityLevel: UILabel!
    @IBOutlet weak var imgIntensity: UIImageView!
    @IBOutlet weak var lblEquipment: UILabel!
    @IBOutlet weak var lblEquipmentYesNo: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgEquipments: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
