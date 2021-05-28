//
//  FeedsCell.swift
//  Sway
//
//  Created by Admin on 17/05/21.
//

import UIKit
import SDWebImage

class FeedsCell: UITableViewCell {

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
    }

}
