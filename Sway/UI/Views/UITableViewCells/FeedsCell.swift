//
//  FeedsCell.swift
//  Sway
//
//  Created by Admin on 17/05/21.
//

import UIKit
import SDWebImage
import ActiveLabel

class FeedsCell: UITableViewCell {
    @IBOutlet weak var btnComments: CustomTextLocationButton!
    
    @IBOutlet weak var lblPostUser: ActiveLabel!
    
    @IBOutlet weak var lblPostDescription: UILabel!
    
    @IBOutlet weak var btnLikes: CustomTextLocationButton!
    @IBOutlet weak var imgVideoPlaceholder: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var viewModel:FeedViewModel!
    
    func setupData(viewModel:FeedViewModel){
        self.viewModel = viewModel
        if viewModel.mediaType == .kImage {
            imgVideoPlaceholder.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imgVideoPlaceholder.sd_setImage(with: viewModel.mediaUrl, completed: nil)
        }else {
            imgVideoPlaceholder.sd_setImage(with: viewModel.thumbUrl, placeholderImage: UIImage(named: "ic_video_placeholder"), options: SDWebImageOptions.continueInBackground, context: nil, progress: nil, completed: nil)
        }
        
        self.btnLikes.setImage(UIImage(named: viewModel.isLiked ? "ic_liked" :
                                       "ic_like"), for: .normal)
        self.btnLikes.setTitle(viewModel.likeCount.description, for: .normal)
        self.btnComments.setTitle(viewModel.commentCount.description, for: .normal)
        
        lblPostUser.enabledTypes = [.mention]
        lblPostUser.mentionColor = UIColor.white
        lblPostDescription.text = viewModel.caption
        lblPostUser.text = "@\(viewModel.userName ?? "")"
        
    }

}
