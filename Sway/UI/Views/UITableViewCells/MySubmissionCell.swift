//
//  MySubmissionCell.swift
//  Sway
//
//  Created by Admin on 21/05/21.
//

import UIKit
import SDWebImage


class MySubmissionCell: UICollectionViewCell {
    
    @IBOutlet weak var viewMyStatus: UIView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var btnLikeCount: UIButton!
    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var btnSaveToDevice: UIButton!
    @IBOutlet weak var btnEditPost: UIButton!
    @IBOutlet weak var btnCrossThreeDots: UIButton!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var overlay: UIView!
    
    var viewModel:FeedViewModel!
    
    var isApproved = false {
        didSet {
            btnLikeCount.isHidden = !isApproved
            if isApproved {
                viewMyStatus.backgroundColor = UIColor(named: "kThemeBlue")
            }else{
                viewMyStatus.backgroundColor = UIColor.clear
            }
        }
    }
    
    lazy var editGradient:CAGradientLayer = {
        let layer = CAGradientLayer()
        let color = UIColor(red: 44/255, green: 43/255, blue: 39/255, alpha:1.0)
        layer.colors = [color.cgColor,color.withAlphaComponent(0).cgColor]
        layer.locations = [1,0]
        layer.opacity = 0.8
        return layer
    }()
    
    
    var isEditMode = false {
        didSet {
            editView.isHidden = !isEditMode
            if isApproved {
                btnLikeCount.isHidden = isEditMode
            }
            
//            if isEditMode {
//                viewMyStatus.backgroundColor = UIColor.clear
//                //overlay.isHidden = isEditMode
//            }else if isApproved{
//                viewMyStatus.isHidden =
//                //overlay.isHidden = false
//            }
            btnCrossThreeDots.setImage(UIImage(named: isEditMode ? "ic_cross_white" : "ic_menu"), for: .normal)
            if isEditMode {
                editGradient.frame = editView.bounds
                editView.layer.insertSublayer(editGradient, at: 0)
            }
        }
    }
    
    func setupData(viewModel:FeedViewModel){
        self.viewModel = viewModel
        if viewModel.mediaType == .kImage {
            imgThumbnail.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imgThumbnail.sd_setImage(with: viewModel.mediaUrl, completed: nil)
        }else {
            imgThumbnail.sd_setImage(with: viewModel.thumbUrl, placeholderImage: UIImage(named: "ic_video_placeholder"), options: SDWebImageOptions.continueInBackground, context: nil, progress: nil, completed: nil)
        }
        isApproved = viewModel.status == .APPROVED
        isEditMode = false
        lblStatus.text = viewModel.status == .APPROVED ? "Approved" : "Submitted"
        btnLikeCount.setTitle(viewModel.likeCount.description, for: .normal)
        btnEditPost.isHidden = viewModel.status == .NOT_APPROVED
    }
    
    @IBAction func actionCross(_ sender: UIButton) {
        isEditMode = !isEditMode
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
