//
//  ChallengeDescriptionCell.swift
//  Sway
//
//  Created by Admin on 23/06/21.
//

import UIKit

class ChallengeDescriptionCell: UITableViewCell {
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblAvgTime: UILabel!
    @IBOutlet weak var lblDurationWeeks: UILabel!
    @IBOutlet weak var lblParticipants: UILabel!
    
    
    var viewModel:ChallengeViewModel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupData(viewModel:ChallengeViewModel){
        self.viewModel = viewModel
        lblParticipants.text = viewModel.participants?.description
        lblDurationWeeks.text = viewModel.weeksCount?.description
        lblDescription.text = viewModel.description
        lblAvgTime.text = viewModel.average?.description
    }

}
