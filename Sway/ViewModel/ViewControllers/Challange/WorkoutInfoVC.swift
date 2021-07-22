//
//  ChallengeInfoVC.swift
//  Sway
//
//  Created by Admin on 21/06/21.
//

import UIKit
import SDWebImage
import ViewControllerDescribable

class WorkoutInfoVC: BaseViewController {
    
    @IBOutlet weak var imgWorkout: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var topViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var closeButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var gestureView: UIView!
    @IBOutlet weak var lblBodyPart: UILabel!
    
    var infoVM:MovementViewModel!
    var wasPlayingVideoWhenComingToThisScreen = true
    var actionClose:((_ wasPlayingBefore:Bool)->())?
    override func viewDidLoad() {
        super.viewDidLoad()

        setupData()
        
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(swipeDown(_:)))
        gestureView.isUserInteractionEnabled = true
        self.gestureView.addGestureRecognizer(swipeGesture)
    }
    
    func setupData(){
        imgWorkout.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imgWorkout.sd_setImage(with: infoVM.videoThumb, completed: nil)
        lblName.text = infoVM.videoName
        lblDescription.text = infoVM.description
        lblBodyPart.text = infoVM.category.displayName
        
//        lblBodyPart.text = "Butt \u{25FD} " + "Legs \u{25FD} " + "Back"        // Do any additional setup after loading the view.
    }

    @IBAction func actionClose(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: {[weak self] in
            self?.actionClose?(self!.wasPlayingVideoWhenComingToThisScreen)
        })
    }
    
    @objc func swipeDown(_ gesture:UIPanGestureRecognizer){
        if gesture.state == .ended || gesture.state == .recognized{
            if topViewTopConstraint.constant >= UIScreen.main.bounds.height / 2 {
                self.dismiss(animated: true, completion: {[weak self] in
                    self?.actionClose?(self!.wasPlayingVideoWhenComingToThisScreen)
                })
            }else {
                topViewTopConstraint.constant = 44
                closeButtonBottomConstraint.constant = 24
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
            }
            
        }else if gesture.state == .changed {
            let translation = gesture.translation(in: self.view)
            self.closeButtonBottomConstraint.constant -= translation.y
            self.topViewTopConstraint.constant += translation.y
            gesture.setTranslation(.zero, in: self.view)
        }
        
    }
    
}

extension WorkoutInfoVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.challenge
    }
}
