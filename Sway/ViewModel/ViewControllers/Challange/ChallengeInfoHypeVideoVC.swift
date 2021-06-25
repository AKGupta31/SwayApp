//
//  ChallengeInfoHypeVideoVC.swift
//  Sway
//
//  Created by Admin on 23/06/21.
//

import UIKit
import ViewControllerDescribable
import KDCircularProgress
import Player

class ChallengeInfoHypeVideoVC: BaseViewController {
    
    @IBOutlet weak var lblChallengeType: UILabel!
    @IBOutlet weak var progressViewInnerCircle: CustomView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnCross: UIButton!
    
    var viewModel:ChallengeViewModel!
    var progress:KDCircularProgress!
    var player:Player!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        edgesForExtendedLayout = [.bottom]
        extendedLayoutIncludesOpaqueBars = true
        self.setupPlayer(url: viewModel.videoUrl, on: playerView)
        setupLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        setupProgressView()
    }
    
    @IBAction func actionCross(_ sender: UIButton) {
        player.stop()
        stopActivityIndicator()
        player.playerDelegate = nil
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupLabel(){
        lblTitle.text = viewModel.title
    }
    
    @IBAction func actionViewDetails(_ sender: UIButton) {
        stopActivityIndicator()
        player.stop()
        player.playerDelegate = nil
        self.navigationController?.push(ChallengeDescriptionVC.self, animated: true, configuration: { (vc) in
            vc.viewModel = self.viewModel
        })
    }
    
}

extension ChallengeInfoHypeVideoVC:PlayerDelegate ,PlayerPlaybackDelegate{
    
    func playerReady(_ player: Player) {
        self.stopActivityIndicator()
        self.player.playFromBeginning()
    }
    
    func playerPlaybackStateDidChange(_ player: Player) {
        print("play back state",player.playbackState)
    }
    
    func playerBufferingStateDidChange(_ player: Player) {
        print("buffering state ",player.bufferingState)
    }
    
    func playerBufferTimeDidChange(_ bufferTime: Double) {
        
    }
    
    func player(_ player: Player, didFailWithError error: Error?) {
        AlertView.showAlert(with: "Error!", message: error?.localizedDescription ?? "Unknown error occurred")
    }
    
    func playerCurrentTimeDidChange(_ player: Player) {
        self.progress.progress = player.currentTimeInterval / player.maximumDuration
    }
    
    func playerPlaybackWillStartFromBeginning(_ player: Player) {
        
    }
    
    func playerPlaybackDidEnd(_ player: Player) {
//        player.playFromBeginning()
    }
    
    func playerPlaybackWillLoop(_ player: Player) {
        
    }
    
    func playerPlaybackDidLoop(_ player: Player) {
        
    }
    
    
}

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
    }
    
    
}

//MARK: -Player Methods
extension ChallengeInfoHypeVideoVC {
    func setupPlayer(url:URL?,on parent:UIView){
        guard let videoUrl = url else {return}
       
        if player == nil {
            self.player = Player()
            self.player.playerDelegate = self
            self.player.playbackDelegate = self
        } else {
            player.pause()
            player.removeFromParent()
            player.view.removeFromSuperview()
        }
        self.player.url = videoUrl
        self.player.volume = 1.0
        player.playbackResumesWhenEnteringForeground = false
        player.playbackResumesWhenBecameActive = false
            //videoUrl
        self.player.view.frame = parent.bounds
        self.player.fillMode = .resizeAspectFill
        self.addChild(self.player)
        parent.insertSubview(self.player.view, at: 0)
        startActivityIndicator(touchEnabled: true,tintColor:UIColor.white)
        self.player.didMove(toParent: self)
    }
}

extension ChallengeInfoHypeVideoVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.challenge
    }
}
