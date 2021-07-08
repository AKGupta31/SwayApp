//
//  StartWorkoutVideoWithTimerCell.swift
//  Sway
//
//  Created by Admin on 07/07/21.
//

import UIKit
import GSPlayer
import KDCircularProgress
import AVFoundation

class StartWorkoutVideoWithTimerCell: UITableViewCell {
    @IBOutlet weak var lblProgressCounter: UILabel!
    
    @IBOutlet weak var lblTitleTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var progressViewInnerCircle: CustomView!
    @IBOutlet weak var playerView: VideoPlayerView!
    @IBOutlet weak var progressViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var btnInfo: UIButton!
    @IBOutlet weak var lblReps: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgVideoThumb: UIImageView!
    
    var timer:Timer!
    
    var viewModel:MovementViewModel!
    var indexPath:IndexPath!
//    var progress:KDCircularProgress!
    var videoDidEnd:((IndexPath)->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        progressView.isHidden = true
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        progressView.isHidden = true
        imgVideoThumb.isHidden = false
//        pause(reason: .hidden)
    }

    func setupData(viewModel:MovementViewModel,indexPath:IndexPath){
        self.viewModel = viewModel
        self.indexPath = indexPath
        self.imgVideoThumb.sd_setImage(with: viewModel.videoThumb, completed: nil)
    }
    
//    func play() {
//        if let videoUrl = viewModel.mainVideoUrl {
//            progressView.isHidden = false
//            imgVideoThumb.isHidden = true
//            print("play at indexPath ,",indexPath.row)
//            print("play with url ,",videoUrl)
//            playerView.play(for: videoUrl)
//            playerView.isHidden = false
//            playerView.contentMode = .scaleAspectFill
//            playerView.stateDidChanged = {[weak self](state) in
//                switch state {
//                case .playing:
//                    self?.lblProgressCounter.text = Int(self!.playerView.totalDuration).description
//                    self?.setupProgressView()
//                    break
//                default:
//                    break
//                }
//            }
//            playerView.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: 30), queue: .main) { (time) in
//                if self.progress != nil {
//                    self.progress.progress =  time.seconds / self.playerView.totalDuration
//                }
//            }
//            playerView.playToEndTime = {[weak self] in
//                self?.pause(reason: .hidden)
//                self?.videoDidEnd?(self!.indexPath)
//            }
//        }
//    }
//
//    func pause(reason:VideoPlayerView.PausedReason) {
//        playerView.pause(reason:reason)
//    }

//    func setupProgressView(){
//        progress = KDCircularProgress(frame:progressView.bounds)
//        progress.startAngle = -90
//        progress.progressThickness = 0.2
//        progress.trackThickness = 0.05
//        progress.clockwise = true
//        progress.gradientRotateSpeed = 2
//        progress.roundedCorners = false
//        progress.roundedCorners = true
//        progress.glowMode = .noGlow
//        progress.set(colors: UIColor(named: "kThemeBlue")!)
//        progress.trackColor = UIColor(named: "k124123132")!
//        progress.progress = 0
//        progressView.insertSubview(progress, at: 0)
//        progressViewInnerCircle.backgroundColor = UIColor(named: "kThemeYellow")
//    }

}
