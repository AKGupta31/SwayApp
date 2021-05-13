//
//  IntroViewController.swift
//  Sway
//
//  Created by Admin on 15/04/21.
//

import UIKit
import ViewControllerDescribable

class IntroViewController: BaseViewController {
    @IBOutlet weak var blackGrdientBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var blackGrdientView: UIView!
    
    lazy var gradientLayer:CAGradientLayer = {
        let gl = CAGradientLayer()
        let color = UIColor(red: 44/255, green: 43/255, blue: 39/255, alpha: 1.0)
        gl.colors = [color.withAlphaComponent(0).cgColor,color.cgColor]
        return gl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blackGrdientBottomConstraint.constant =  -UIScreen.main.bounds.height / 2
        self.blackGrdientView.isHidden = true
        self.blackGrdientView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeUp(_:)))
        self.blackGrdientView.isUserInteractionEnabled = true
        gesture.direction = .up
        self.blackGrdientView.addGestureRecognizer(gesture)
    }
    
    @objc func tapOnView(_ gesture:UITapGestureRecognizer){
        self.navigationController?.push(SignupVC.self)
    }
    
    @objc func swipeUp(_ gesture:UISwipeGestureRecognizer){
        if gesture.direction == .up {
            self.navigationController?.push(GuestNewsFeed.self)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.gradientLayer.frame = self.blackGrdientView.bounds
            self.blackGrdientBottomConstraint.constant = 0
            self.blackGrdientView.isHidden = false
            UIView.animate(withDuration: 1.0) {
                self.view.layoutIfNeeded()
            } completion: { (isSuccess) in
                
            }

        }
    }

}

extension IntroViewController:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.main
    }
}
