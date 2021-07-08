//
//  WorkoutStartCDVC.swift
//  Sway
//
//  Created by Admin on 21/06/21.
//

import UIKit
import KDCircularProgress
import ViewControllerDescribable
import AVFoundation
import Player
class WorkoutStartCDVC: BaseViewController {

    @IBOutlet weak var lblStartIn: UILabel!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressViewInnerCircle: CustomView!
    @IBOutlet weak var progressView: UIView!
    var progress:KDCircularProgress!
    var timer:Timer!
    //PLAYER ITEMS
    @IBOutlet weak var playerView: UIView!
    
    @IBOutlet weak var playerProgressLabel: UILabel!
    @IBOutlet weak var playerProgressInnerCircle: CustomView!
    @IBOutlet weak var playerProgressView: UIView!
    
    var player:Player!
    
    var i = 10
    var progressCount:Double = 0
    
    let urlStr = "https://www.rmp-streaming.com/media/big-buck-bunny-360p.mp4"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        btnCross.isEnabled = false
        setupProgressView()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(actionTimer(_:)), userInfo: nil, repeats: true)
        
//        setupPlayer(url: <#T##URL?#>, cell: <#T##FeedsCell#>)
    }


    @objc func actionTimer(_ timer:Timer){
        i -= 1
        progressCount += 1
        if i <= 0{
            btnCross.isEnabled = true
            hideBlurOverlayView()
            timer.invalidate()
            if let url = URL(string: urlStr) {
                setupProgressView(for: url)
            }
        }
        progressLabel.text = i.description
        progress.animate(toAngle: 36 * progressCount, duration: 1, completion: nil)
    }
    
    func hideBlurOverlayView(){
        blurView.isHidden = true
        progressView.isHidden = true
        lblStartIn.isHidden = true
    }
    
    var playerItem:AVPlayerItem?
    func setupProgressView(for videoURL:URL){
        playerItem = AVPlayerItem(url: videoURL)
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(AVPlayerItem.status), let statusNumber = change?[.newKey] as? NSNumber {
            
            switch statusNumber.intValue {
            case AVPlayerItem.Status.readyToPlay.rawValue:
                let durationInSeconds = playerItem?.asset.duration.seconds ?? 0
                print("Ready to play. Duration (in seconds): \(durationInSeconds)")
            default: break
            }
        }
    }
    
    
    fileprivate func setupProgressView(){
        progress = KDCircularProgress(frame:progressView.bounds)
        progress.startAngle = -90
        progress.progressThickness = 0.2
        progress.trackThickness = 0.05
        progress.clockwise = true
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = false
        progress.roundedCorners = true
        progress.glowMode = .noGlow
        progress.set(colors: UIColor(named: "kThemeBlue")!)
        progress.trackColor = UIColor(named: "k124123132")!
        progress.progress = 0
        progressView.insertSubview(progress, at: 0)
        progressViewInnerCircle.backgroundColor = UIColor(named: "kThemeYellow")
    }
    
    @IBAction func actionInfo(_ sender: UIButton) {
        self.navigationController?.present(WorkoutInfoVC.self, navigationEnabled: false, animated: true, configuration: { (vc) in
            vc.modalPresentationStyle = .overFullScreen
        }, completion: nil)
    }
    
    @IBAction func actionCross(_ sender: UIButton) {
        self.navigationController?.present(WorkoutEndAlertVC.self, navigationEnabled: false, animated: false, configuration: { (vc) in
            vc.modalPresentationStyle = .fullScreen
        }, completion: nil)
    }
    
    

}

//MARK: -Player Methods
extension WorkoutStartCDVC {
    func setupPlayer(url:URL?,cell:FeedsCell){
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
        self.player.view.frame = cell.bounds
        self.player.fillMode = .resizeAspectFill
        self.addChild(self.player)
        cell.contentView.insertSubview(self.player.view, at: 1)
        startActivityIndicator(touchEnabled: true)
        //        cell.addSubview(self.player.view)
        
//        cell.bringSubviewToFront(cell.btnComments)
//        cell.bringSubviewToFront(cell.btnLikes)
//        let tapOnPlayer = UITapGestureRecognizer(target: self, action: #selector(tapOnPlayerView(_:)))
//        self.player.view.addGestureRecognizer(tapOnPlayer)
        self.player.didMove(toParent: self)
        self.player.playFromBeginning()
    }
}

extension WorkoutStartCDVC:PlayerDelegate ,PlayerPlaybackDelegate{
    
    func playerReady(_ player: Player) {
//        self.imgVideoThumb.isHidden = true
        self.stopActivityIndicator()
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
        
    }
    
    func playerCurrentTimeDidChange(_ player: Player) {
        
    }
    
    func playerPlaybackWillStartFromBeginning(_ player: Player) {
        
    }
    
    func playerPlaybackDidEnd(_ player: Player) {
        
    }
    
    func playerPlaybackWillLoop(_ player: Player) {
        
    }
    
    func playerPlaybackDidLoop(_ player: Player) {
        
    }
    
    
}

extension WorkoutStartCDVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.challenge
    }
}
