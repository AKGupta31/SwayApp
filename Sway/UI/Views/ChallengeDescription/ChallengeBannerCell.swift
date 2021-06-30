//
//  ChallengeBannerCell.swift
//  Sway
//
//  Created by Admin on 23/06/21.
//

import UIKit
import SDWebImage
class ChallengeBannerCell: UITableViewCell {

    @IBOutlet weak var backButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblChallengeName: UILabel!
    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var lblChallengeType: UILabel!
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    var viewModel:ChallengeViewModel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupData(viewModel:ChallengeViewModel){
        self.viewModel = viewModel
        lblChallengeName.text = viewModel.title
        imgBanner.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imgBanner.sd_setImage(with: viewModel.bannerUrl, completed: nil)
        lblChallengeType.text = ""
    }
}
