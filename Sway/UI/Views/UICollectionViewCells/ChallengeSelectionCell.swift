//
//  ChallengeSelectionCell.swift
//  Sway
//
//  Created by Admin on 18/06/21.
//

import UIKit
import SDWebImage

class ChallengeSelectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var lblType3: UILabel!
    @IBOutlet weak var smallBox2: UIView!
    @IBOutlet weak var lblType2: UILabel!
    @IBOutlet weak var smallBox1: UIView!
    @IBOutlet weak var lblType1: UILabel!
    
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
        setupTypes(viewModel: viewModel)
    }
    
    func setupTypes(viewModel:ChallengeViewModel){
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
