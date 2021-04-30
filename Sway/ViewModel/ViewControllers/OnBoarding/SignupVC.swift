//
//  SignupVC.swift
//  Sway
//
//  Created by Admin on 13/04/21.
//

import UIKit
import ViewControllerDescribable
class SignupVC: BaseViewController {

    @IBOutlet weak var lblLogin: UILabel!
    @available(iOS 13.0, *)
    private lazy var appleManager: AppleLoginManager = {
        return AppleLoginManager()
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        lblLogin.setupLabelWithTappableArea(regularText: "Already have an account?", tappableText: "Log in")
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel))
        self.lblLogin.isUserInteractionEnabled = true
        self.lblLogin.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionAppleSignup(_ sender: UIButton) {
        if #available(iOS 13.0, *) {
            appleManager.logIn(from: self)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func actionGoogleSignIn(_ sender: UIButton) {
        GoogleSignInManager.shared.signIn(presentingVC: self) { (response) in
            self.hideLoader()
        }
    }
    
    @IBAction func actionFacebookSignup(_ sender: UIButton) {
        FacebookLoginManager.shared.login(viewController: self) { (response) in
            self.hideLoader()
        }
    }
    
    
    @objc private func tappedOnLabel(gesture: UITapGestureRecognizer) {
        guard let text = lblLogin.text else {return}
        let nsString = NSString(string: text)
        let range = nsString.range(of: "Log in")
        
        if gesture.didTapAttributedTextInLabel(label: lblLogin, inRange: range) {
            self.navigationController?.push(LoginVC.self)
        }
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension SignupVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.main
    }
}
