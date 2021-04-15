//
//  LoginViaCredentialsVC.swift
//  Sway
//
//  Created by Admin on 14/04/21.
//

import UIKit
import ViewControllerDescribable

import SkyFloatingLabelTextField
class LoginViaCredentialsVC: BaseViewController {
    @IBOutlet weak var passwordField: CustomFloatingLabelField!
    @IBOutlet weak var btnPasswordEye: UIButton!
    
    @IBOutlet weak var signupLabel: UILabel!
    @IBOutlet weak var emailField: SkyFloatingLabelTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        signupLabel.setupLabelWithTappableArea(regularText: "Don’t have an account?", tappableText: "Sign up")
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel))
        self.signupLabel.addGestureRecognizer(tapGestureRecognizer)
        self.signupLabel.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }

    @IBAction func actionEye(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        passwordField.isSecureTextEntry = !sender.isSelected
    }
    
    
    @objc private func tappedOnLabel(gesture: UITapGestureRecognizer) {
        guard let text = signupLabel.text else {return}
        let nsString = NSString(string: text)
        let range = nsString.range(of: "Sign up")
        
        if gesture.didTapAttributedTextInLabel(label: signupLabel, inRange: range) {
            self.navigationController?.push(Register1VC.self)
        }
    }
    
    
}

extension LoginViaCredentialsVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.main
    }
}
