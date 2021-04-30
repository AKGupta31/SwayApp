//
//  LoginVC.swift
//  Sway
//
//  Created by Admin on 13/04/21.
//

import UIKit
import ViewControllerDescribable

class LoginVC: BaseViewController {
    @IBOutlet weak var lblSignup: UILabel!
    
    @available(iOS 13.0, *)
    private lazy var appleManager: AppleLoginManager = {
        return AppleLoginManager()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblSignup.setupLabelWithTappableArea(regularText: "Don’t have an account?", tappableText: "Sign up")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionLoginWithEmail(_ sender: UIButton) {
        self.navigationController?.push(LoginViaCredentialsVC.self)
    }
    
    @IBAction func actionLoginWithApple(_ sender: UIButton) {
        if #available(iOS 13.0, *) {
            appleManager.logIn(from: self)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func actionFacebook(_ sender: UIButton) {
        FacebookLoginManager.shared.login(viewController: self) { (response) in
            self.hideLoader()
        }
    }
    
    @IBAction func actionCross(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}


extension LoginVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.main
    }
}
