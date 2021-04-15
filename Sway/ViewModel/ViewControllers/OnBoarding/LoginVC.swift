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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblSignup.setupLabelWithTappableArea(regularText: "Don’t have an account?", tappableText: "Sign up")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionLoginWithEmail(_ sender: UIButton) {
        self.navigationController?.push(LoginViaCredentialsVC.self)
    }
    
    

}


extension LoginVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.main
    }
}
