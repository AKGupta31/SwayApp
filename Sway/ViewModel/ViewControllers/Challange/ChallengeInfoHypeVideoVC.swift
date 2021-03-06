//
//  ChallengeInfoHypeVideoVC.swift
//  Sway
//
//  Created by Admin on 23/06/21.
//

import UIKit
import ViewControllerDescribable
import KDCircularProgress
import GSPlayer
import AVFoundation

class ChallengeInfoHypeVideoVC: BaseViewController {
    
    @IBOutlet weak var imgPlay: UIImageView!
    @IBOutlet weak var lblChallengeType: UILabel!
    @IBOutlet weak var lblIntensity: UILabel!
    @IBOutlet weak var progressViewInnerCircle: CustomView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnCross: UIButton!
    
    var viewModel:ChallengeViewModel!
    var progress:KDCircularProgress!
    var player:VideoPlayerView = {
        let playerView = VideoPlayerView()
        playerView.contentMode = .scaleAspectFill
        return playerView
    }()
//    var player:Player!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        edgesForExtendedLayout = [.bottom]
        extendedLayoutIncludesOpaqueBars = true
        imgPlay.isHidden = true
        setupLabel()
        self.setupPlayer(url: viewModel.videoUrl, on: playerView)
        self.view.backgroundColor = .black
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
//        setupProgressView()
    }
    
    @IBAction func actionCross(_ sender: UIButton) {
        pause(reason: .userInteraction)
//        if player != nil {
//            player.stop()
//            player.playerDelegate = nil
//        }
//
        stopActivityIndicator(inSelf: false) {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    func setupLabel(){
        lblTitle.text = viewModel.title
    }
    
    @IBAction func actionViewDetails(_ sender: UIButton) {
      viewDetails()
    }
    
    @objc func swipeUp(_ gesture:UISwipeGestureRecognizer){
        if gesture.direction == .up {
            viewDetails()
        }
    }
    
    private func viewDetails(){
        stopActivityIndicator()
        player.pause(reason: .userInteraction)
//        if player != nil {
//            player.stop()
//            player.playerDelegate = nil
//        }
        self.getNavController()?.push(ChallengeDescriptionVC.self,animated: true, pushTransition: .vertical, configuration: { (vc) in
            vc.viewModel = self.viewModel
        })
    }
    
    func pause(reason:VideoPlayerView.PausedReason) {
        player.pause(reason: reason)
    }
    
    
}

//extension ChallengeInfoHypeVideoVC:PlayerDelegate ,PlayerPlaybackDelegate{
//
//    func playerReady(_ player: Player) {
//        self.stopActivityIndicator()
//        self.player.playFromBeginning()
//    }
//
//    func playerPlaybackStateDidChange(_ player: Player) {
//        print("play back state",player.playbackState)
//    }
//
//    func playerBufferingStateDidChange(_ player: Player) {
//        print("buffering state ",player.bufferingState)
//    }
//
//    func playerBufferTimeDidChange(_ bufferTime: Double) {
//
//    }
//
//    func player(_ player: Player, didFailWithError error: Error?) {
//        AlertView.showAlert(with: "Error!", message: error?.localizedDescription ?? "Unknown error occurred")
//    }
//
//    func playerCurrentTimeDidChange(_ player: Player) {
//        self.progress.progress = player.currentTimeInterval / player.maximumDuration
//    }
//
//    func playerPlaybackWillStartFromBeginning(_ player: Player) {
//
//    }
//
//    func playerPlaybackDidEnd(_ player: Player) {
////        player.playFromBeginning()
//    }
//
//    func playerPlaybackWillLoop(_ player: Player) {
//
//    }
//
//    func playerPlaybackDidLoop(_ player: Player) {
//
//    }
//
//
//}

extension ChallengeInfoHypeVideoVC {
    fileprivate func setupProgressView(){
        progress = KDCircularProgress(frame:progressView.bounds)
        progress.startAngle = -90
        progress.progressThickness = 0.2
        progress.trackThickness = 0.1
        progress.clockwise = true
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = false
        progress.roundedCorners = true
        progress.glowMode = .noGlow
        progress.set(colors: UIColor(named: "kThemeBlue")!)
        progress.trackColor = UIColor(red: 245/255, green: 246/255, blue: 250/255, alpha: 0.3)
        progress.progress = 0
        progressView.insertSubview(progress, at: 0)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeUp(_:)))
        swipeUp.direction = .up
        self.progressView.addGestureRecognizer(swipeUp)
    }
    
    
}

//MARK: -Player Methods
extension ChallengeInfoHypeVideoVC {
    func setupPlayer(url:URL?,on parent:UIView){
        if Api.isConnectedToNetwork() {
            guard let videoUrl = url else {return}
//            if player == nil {
//                self.player = Player()
//                self.player.playerDelegate = self
//                self.player.playbackDelegate = self
//            } else {
//                player.pause()
//                player.removeFromParent()
//                player.view.removeFromSuperview()
//            }
//            self.player.url = videoUrl
//            self.player.volume = 1.0
//            player.playbackResumesWhenEnteringForeground = false
//            player.playbackResumesWhenBecameActive = false
//            //videoUrl
//            self.player.view.frame = parent.bounds
//            self.player.fillMode = .resizeAspectFill
//            let tapOnPlayer = UITapGestureRecognizer(target: self, action: #selector(tapOnPlayerView(_:)))
//            self.player.view.addGestureRecognizer(tapOnPlayer)
//            self.addChild(self.player)
//            parent.insertSubview(self.player.view, at: 0)
//            startActivityIndicator(style:.large,touchEnabled: true,tintColor:UIColor.white)
//            self.player.didMove(toParent: self)
//            let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeUp(_:)))
//            swipeUp.direction = .up
//            self.player.view.addGestureRecognizer(swipeUp)
            
            
            
            player.frame = self.view.bounds
            self.playerView.insertSubview(player, belowSubview: self.progressView)
            let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeUp(_:)))
            swipeUp.direction = .up
            player.addGestureRecognizer(swipeUp)
            
            let tapOnPlayer = UITapGestureRecognizer(target: self, action: #selector(tapOnPlayerView(_:)))
            player.addGestureRecognizer(tapOnPlayer)
//            player.isAutoReplay = true
            player.stateDidChanged = { [weak self] state in
                guard let `self` = self else { return }
                switch state {
                case .loading:
                    self.startActivityIndicator(style: .medium, inSelf: true, touchEnabled: true)
                
                case .playing:
                    self.stopActivityIndicator()
                    self.imgPlay.image = UIImage(named: "ic_pause")
                    self.setupProgressView()
                case .paused:
                    self.stopActivityIndicator()
                    self.imgPlay.image = UIImage(named: "ic_play")
                default:
                   break
                }
                self.imgPlay.isHidden = false
                UIView.animate(withDuration: 0.35) {
                    self.imgPlay.alpha = 1.0
                } completion: { (isSuccess) in
                    self.imgPlay.alpha = 0.0
                    self.imgPlay.isHidden = true
                }
            }
            self.startActivityIndicator(style: .medium, inSelf: true, touchEnabled: true)
            player.play(for: videoUrl)
            
            self.player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.2, preferredTimescale: 10), queue: .main) {[weak self] (time) in
                if let progressView = self?.progress,let playerView = self?.player{
                    var newProgress = time.seconds / playerView.totalDuration
                    print("new progress ",newProgress)
                    if newProgress.isNaN || newProgress > 1{
                        newProgress = 1.0
                    }
                    progressView.progress = newProgress
                }
            }
//            self.player.playToEndTime = {[weak self] in
//                print("play to end time")
//            }
//
            
            
        }else {
            AlertView.showNoInternetAlert(on: self) { [weak self](retryAction) in
                self?.setupPlayer(url: url, on: parent)
            }
        }
        
    }
    
    @objc func tapOnPlayerView(_ gesture:UITapGestureRecognizer){
//        if player != nil {
            if player.state == .playing {
                player.pause()
                self.imgPlay.image = UIImage(named: "ic_pause")
            }else {
                self.imgPlay.image = UIImage(named: "ic_play")
                player.resume()
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

extension ChallengeInfoHypeVideoVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.challenge
    }
}
