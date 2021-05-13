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
    
    @IBOutlet weak var imgVideoThumb: UIImageView!
    var player:Player!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayer()
        // Do any additional setup after loading the view.
    }
    
   
    func setupPlayer(){
       
        self.player = Player()
        self.player.playerDelegate = self
        self.player.playbackDelegate = self
        self.player.url = URL(string: "http://techslides.com/demos/sample-videos/small.mp4")!
        self.player.view.frame = self.view.bounds
        self.player.fillMode = .resizeAspectFill
        self.addChild(self.player)
        self.playerView.addSubview(self.player.view)
        self.player.didMove(toParent: self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.player.playFromBeginning()
        }
    }
    
    @IBAction func actionSkip(_ sender: UIButton) {
        player.pause()
        player.playerDelegate = nil
        player.playbackDelegate = nil
        self.navigationController?.push(HowOldVC.self)
    }
}

extension OnboardingStartVC:PlayerDelegate ,PlayerPlaybackDelegate{
    func playerReady(_ player: Player) {
        self.imgVideoThumb.isHidden = true
    }
    
    func playerPlaybackStateDidChange(_ player: Player) {
        
    }
    
    func playerBufferingStateDidChange(_ player: Player) {
        
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
        player.playerDelegate = nil
        player.playbackDelegate = nil
        self.navigationController?.push(HowOldVC.self)
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
