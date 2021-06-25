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
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupData(workoutVM:WorkoutViewModel){
        imgVideoThumb.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imgVideoThumb.sd_setImage(with: workoutVM.thumbnailUrl, completed: nil)
        lblVideoName.text = workoutVM.name
        lblTime.text = workoutVM.durationInMinutes
    }

}
