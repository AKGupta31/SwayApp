//
//  OnboardingStartVC.swift
//  Sway
//
//  Created by Admin on 12/05/21.
//

import UIKit
import ViewControllerDescribable
import Player

class OnboardingStartVC: BaseViewController {
    @IBOutlet weak var playerView: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var imgVideoThumb: UIImageView!
    var player:Player?
    var videoType = 1
    private var videoResponse:VideoResponse!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getApiData()
        self.lblTitle.isHidden = true
        self.lblDescription.isHidden = true
        self.imgVideoThumb.isHidden = true
        if videoType == 2 {
            self.btnSkip.setImage(UIImage(named: "ic_cross_white_medium"), for: .normal)
            self.btnSkip.setTitle(nil, for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    
    func getApiData(){
        if self.videoType == 2 {
            guard let path = Bundle.main.path(forResource: "HowAgeAffectMyPlan", ofType:"mp4")else {
                return
            }
            let url = URL(fileURLWithPath: path)
            self.setupPlayer(videoUrl: url)
        }else {
            showLoader()
            LoginRegisterEndpoint.getVideos(type: videoType) { [weak self](response) in
                if response.statusCode == 200 {
                    guard let videoUrlStr = response.data?.media?.url,let videoUrl = URL(string: videoUrlStr) else {return}
                    self?.setupPlayer(videoUrl: videoUrl)
                }else {
                    self?.hideLoader()
                    AlertView.showAlert(with: "Error", message: response.message ?? "Unknown error")
                }
            } failure: {[weak self] (status) in
                self?.hideLoader()
                AlertView.showAlert(with: "Error", message: status.msg)
            }
        }
        

    }
    
   
    func setupPlayer(videoUrl:URL){
        self.player = Player()
        self.player?.playerDelegate = self
        self.player?.playbackDelegate = self
        self.player?.url = videoUrl
            //videoUrl
        self.player?.view.frame = self.view.bounds
        self.player?.fillMode = .resizeAspectFill
        self.player?.volume = 1.0
        self.addChild(self.player!)
        self.playerView.addSubview(self.player!.view)
        self.player?.didMove(toParent: self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.player?.playFromBeginning()
        }
        player?.playbackResumesWhenBecameActive = false
    }
    
    @IBAction func actionSkip(_ sender: UIButton) {
        if self.videoType == 2 {
            player?.pause()
            player?.playerDelegate = nil
            player?.playbackDelegate = nil
            self.navigationController?.popViewController(animated: true)
        }else if self.videoType == 1 {
            player?.stop()
//            updateStatus()
            //            self.navigationController?.push(HowOldVC.self)
        }
        
    }
    
    func updateStatus(){
        LoginRegisterEndpoint.updateOnboardingScreenStatus(key: "isIntroVideoOneSeen", value: true) { (response) in
            if response.statusCode == 200 {
                SwayUserDefaults.shared.onBoardingScreenStatus = .PROFILE_AGE
            }
            
        } failure: { (status) in
            
        }
    }
}

extension OnboardingStartVC:PlayerDelegate ,PlayerPlaybackDelegate{
    func playerReady(_ player: Player) {
//        self.imgVideoThumb.isHidden = true
        self.hideLoader()
    }
    
    func playerPlaybackStateDidChange(_ player: Player) {
       
    }
    
    func playerBufferingStateDidChange(_ player: Player) {
        if player.bufferingState == .ready {
            self.hideLoader()
        }else {
            self.showLoader()
        }
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
        if self.videoType == 2 {
            self.player?.playFromBeginning()
        }else if videoType == 1 {
            player.playerDelegate = nil
            player.playbackDelegate = nil
            player.url = nil
            player.removeFromParent()
            updateStatus()
            if var vcs = self.navigationController?.viewControllers {
                vcs.removeLast()
                vcs.append(HowOldVC.instantiated())
                self.navigationController?.setViewControllers(vcs, animated: true)
            }
//            self.navigationController?.push(HowOldVC.self)
            
        }
       
    }
    
    func playerPlaybackWillLoop(_ player: Player) {
        
    }
    
    func playerPlaybackDidLoop(_ player: Player) {
        
    }
    
    
}

extension OnboardingStartVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.onBoarding
    }
}
