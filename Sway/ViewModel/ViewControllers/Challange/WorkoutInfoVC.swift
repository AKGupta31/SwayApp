//
//  ChallengeInfoVC.swift
//  Sway
//
//  Created by Admin on 21/06/21.
//

import UIKit
import ViewControllerDescribable

class WorkoutInfoVC: BaseViewController {
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var topViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var closeButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var gestureView: UIView!
    @IBOutlet weak var lblBodyPart: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        lblBodyPart.text = "Butt \u{25FD} " + "Legs \u{25FD} " + "Back"        // Do any additional setup after loading the view.
        
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(swipeDown(_:)))
        gestureView.isUserInteractionEnabled = true
        self.gestureView.addGestureRecognizer(swipeGesture)
    }

    @IBAction func actionClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func swipeDown(_ gesture:UIPanGestureRecognizer){
            if gesture.state == .ended || gesture.state == .recognized{
                if topViewTopConstraint.constant >= UIScreen.main.bounds.height / 2 {
                    self.dismiss(animated: true, completion: nil)
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
