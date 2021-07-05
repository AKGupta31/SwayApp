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
    
    @IBOutlet weak var imgSwipeUp: UIImageView!
    lazy var gradientLayer:CAGradientLayer = {
        let gl = CAGradientLayer()
        let color = UIColor(red: 44/255, green: 43/255, blue: 39/255, alpha: 1.0)
        gl.colors = [color.withAlphaComponent(0).cgColor,color.cgColor]
        return gl
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var tapGesture:UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blackGrdientBottomConstraint.constant =  -UIScreen.main.bounds.height / 2
        self.blackGrdientView.isHidden = true
        self.blackGrdientView.layer.insertSublayer(gradientLayer, at: 0)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnView(_:)))
        self.view.addGestureRecognizer(tapGesture!)
    }
    

    
    @objc func tapOnView(_ gesture:UITapGestureRecognizer){
        self.getNavController()?.push(GuestNewsFeed.self)
    }
    
    @objc func swipeUp(_ gesture:UISwipeGestureRecognizer){
        if gesture.direction == .up {
            self.getNavController()?.push(GuestNewsFeed.self,pushTransition: .vertical)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.blackGrdientView.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if self.tapGesture != nil{
                self.view.removeGestureRecognizer(self.tapGesture!)
            }
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeUp(_:)))
            self.view.isUserInteractionEnabled = true
            gesture.direction = .up
            self.view.addGestureRecognizer(gesture)
            self.gradientLayer.frame = self.blackGrdientView.bounds
            self.blackGrdientBottomConstraint.constant = 0
            self.blackGrdientView.isHidden = false
            UIView.animate(withDuration: 1.0) {
                self.view.layoutIfNeeded()
            } completion: { (isSuccess) in
                self.imgSwipeUp.startSwipeUpAnimating()
            }

        }
    }

}

extension IntroViewController:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.main
    }
}
