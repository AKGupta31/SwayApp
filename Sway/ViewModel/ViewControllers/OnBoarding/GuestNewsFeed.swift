//
//  IntroViewController.swift
//  Sway
//
//  Created by Admin on 15/04/21.
//

import UIKit
import ViewControllerDescribable

class GuestNewsFeed: BaseViewController {
    
    @IBOutlet weak var lblSignIn: UILabel!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var blackGrdientView: UIView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        lblSignIn.setupLabelWithTappableAreaWhite(regularText: "Already have an account?", tappableText: "Log in")
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel))
        self.lblSignIn.isUserInteractionEnabled = true
        self.lblSignIn.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    
    @IBAction func actionSignup(_ sender: UIButton) {
        self.getNavController()?.push(SignupVC.self)
        
    }
    
    @objc private func tappedOnLabel(gesture: UITapGestureRecognizer) {
        guard let text = lblSignIn.text else {return}
        let nsString = NSString(string: text)
        let range = nsString.range(of: "Log in")
        
        if gesture.didTapAttributedTextInLabel(label: lblSignIn, inRange: range) {
            self.getNavController()?.push(LoginVC.self)
        }
    }
    
    

}

extension GuestNewsFeed:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.main
    }
}
