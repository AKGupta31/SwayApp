//
//  FeedsCell.swift
//  Sway
//
//  Created by Admin on 17/05/21.
//

import UIKit
import SDWebImage
import ActiveLabel
import GSPlayer


class FeedsCell: UITableViewCell {
    @IBOutlet weak var playerView: VideoPlayerView!
    @IBOutlet weak var btnComments: CustomTextLocationButton!
    
    @IBOutlet weak var imgPlay: UIImageView!
    @IBOutlet weak var lblPostUser: ActiveLabel!
    
    @IBOutlet weak var lblPostDescription: UILabel!
    
    @IBOutlet weak var btnLikes: CustomTextLocationButton!
    @IBOutlet weak var imgVideoPlaceholder: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var viewModel:FeedViewModel!
    var indexPath:IndexPath!
    var playerStateDidChanged:((VideoPlayerView.State) -> Void)?
    
    func setupData(viewModel:FeedViewModel,indexPath:IndexPath){
        self.indexPath = indexPath
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playerView.isHidden = true
        imgVideoPlaceholder.isHidden = false
        playerView.contentMode = .scaleAspectFill
    }
    
    
    func play() {
        if viewModel.mediaType == .kVideo,let videoUrl = viewModel.mediaUrl {
            print("play at indexPath ,",indexPath.row)
            print("play with url ,",videoUrl)
            playerView.play(for: videoUrl)
            playerView.isHidden = false
            playerView.contentMode = .scaleAspectFill
            playerView.stateDidChanged = {(state) in
                self.playerStateDidChanged?(state)
                switch state {
                case .playing:
                    self.playerView.gestureRecognizers?.removeAll()
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapOnPlayerView(_:)))
                    self.playerView.addGestureRecognizer(tapGesture)
                default:
                    break
                }
            }
        }
    }
    
    func pause(reason:VideoPlayerView.PausedReason) {
        if viewModel.mediaType == .kVideo {
            print("pause at indexPath ,",indexPath.row)
            playerView.pause(reason:reason)
        }
    }
    
    
    @objc func tapOnPlayerView(_ gesture:UITapGestureRecognizer){
//        if player != nil {
        if playerView.state == .playing {
            playerView.pause(reason: .userInteraction)
                self.imgPlay.image = UIImage(named: "ic_pause")
            }else {
                self.imgPlay.image = UIImage(named: "ic_play")
                playerView.resume()
            }
            self.imgPlay.isHidden = false
            UIView.animate(withDuration: 0.35) {
                self.imgPlay.alpha = 1.0
            } completion: { (isSuccess) in
                self.imgPlay.alpha = 0.0
                self.imgPlay.isHidden = true
            }
//        }
    }
    

}
