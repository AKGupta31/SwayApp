//
//  WorkoutItemCell.swift
//  Sway
//
//  Created by Admin on 23/06/21.
//

import UIKit
import SDWebImage


class WorkoutVideoItemCell: UITableViewCell {
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblVideoName: UILabel!
    @IBOutlet weak var imgVideoThumb: CustomImageView!

    @IBOutlet weak var viewContent: CustomView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func setupData(workoutVM:WorkoutViewModel){
        imgVideoThumb.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imgVideoThumb.sd_setImage(with: workoutVM.thumbnailUrl, completed: nil)
        lblVideoName.text = workoutVM.name
        lblTime.text = workoutVM.durationInMinutes
    }

}
