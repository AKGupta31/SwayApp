//
//  ChallengeSelectionCell.swift
//  Sway
//
//  Created by Admin on 18/06/21.
//

import UIKit
import SDWebImage

class ChallengeSelectionCell: UICollectionViewCell {
    @IBOutlet weak var viewRecommented: CustomView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblRecommended: UILabel!
    @IBOutlet weak var imgChallengeBanner: UIImageView!
    @IBOutlet weak var lblWorkoutType: UILabel!
    @IBOutlet weak var viewContent: UIView!
    
    func setupData(viewModel:ChallengeViewModel){
        lblTitle.text = viewModel.title
        imgChallengeBanner.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imgChallengeBanner.sd_setImage(with: viewModel.bannerUrl, completed: nil)
        lblWorkoutType.text = ""
    }
}
