//
//  ChallengeBannerCell.swift
//  Sway
//
//  Created by Admin on 23/06/21.
//

import UIKit
import SDWebImage
class ChallengeBannerCell: UITableViewCell {

    @IBOutlet weak var lblType3: UILabel!
    @IBOutlet weak var smallBox2: UIView!
    @IBOutlet weak var lblType2: UILabel!
    @IBOutlet weak var smallBox1: UIView!
    @IBOutlet weak var lblType1: UILabel!
    @IBOutlet weak var backButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblChallengeName: UILabel!
    @IBOutlet weak var imgBanner: UIImageView!
//    @IBOutlet weak var lblChallengeType: UILabel!
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
        setupTypes()
//        lblChallengeType.text = ""
    }
    
    func setupTypes(){
        lblType3.isHidden = false
        smallBox2.isHidden = false
        let types = viewModel.types
        if types.count == 2 {
            lblType1.text = WorkoutType(rawValue: types.first!)?.displayCaptialized
            lblType2.text = WorkoutType(rawValue: types[1])?.displayCaptialized
            lblType3.text = viewModel.intensity.displayName
        }else if types.count == 1 {
            lblType1.text = WorkoutType(rawValue: types.first!)?.displayCaptialized
            lblType2.text = viewModel.intensity.displayName
            lblType3.isHidden = true
            smallBox2.isHidden = true
        }
    }
}
