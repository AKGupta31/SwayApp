//
//  CommentCell.swift
//  Sway
//
//  Created by Admin on 27/05/21.
//

import UIKit
import SDWebImage

class CommentCell: UITableViewCell {
    @IBOutlet weak var lblComment: UILabel!
    
    @IBOutlet weak var imgViewUser: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgViewUser.clipsToBounds = true
        self.imgViewUser.contentMode = .scaleAspectFill
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imgViewUser.layer.cornerRadius = imgViewUser.frame.height / 2
    }
    
    func setupCell(viewModel:CommentViewModel){
        lblComment.attributedText = viewModel.commentWithUserName
        imgViewUser.sd_setImage(with: viewModel.profileImageUrl, placeholderImage: UIImage(named: "ic_upload_photo"), options: SDWebImageOptions.continueInBackground, context: nil)
        lblTime.text = viewModel.timeString
    }
}
