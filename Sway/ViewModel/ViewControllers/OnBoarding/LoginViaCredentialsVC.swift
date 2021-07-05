//
//  LoginViaCredentialsVC.swift
//  Sway
//
//  Created by Admin on 14/04/21.
//

import UIKit
import ViewControllerDescribable
import Toast_Swift

import SkyFloatingLabelTextField

enum LoginResponseTypes:String {
    case emailNotVerified = "EMAIL_NOT_VERIFIED"
}

class LoginViaCredentialsVC: BaseLoginVC {
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
            self.getNavController()?.push(Register1VC.self)
        }
    }
    
    @IBAction func actionLogin(_ sender: UIButton) {
       
        if let message = isValidFields(),message.isEmpty == false{
            AlertView.showAlert(with: "Error!", message: message)
            return
        }
        guard let email = emailField.text?.trimmingCharacters(in: .whitespaces) else {return}
        guard let password = passwordField.text else {return}
        showLoader()
        LoginRegisterEndpoint.login(with: email, password: password) {[weak self]
            (response) in
            self?.hideLoader()
            if let statusCode = response.statusCode,statusCode >= 200 && statusCode < 300{
                DataManager.shared.setLoggedInUser(user: response.data)
                self?.goToNextScreen(response: response)
//                self?.navigationController?.push(OnboardingStartVC.self)
            }else{
                //failures cases
                if response.type == LoginResponseTypes.emailNotVerified.rawValue {
                    self?.getNavController()?.push(VerifyOtpVC.self, animated: true, configuration: { (vc) in
                        vc.email = email
                        vc.type = .LOGIN
                    })
//                    self.navigationController?.push(VerifyOtpVC.self)
                }else {
                    AlertView.showAlert(with: "Error", message: response.message ?? "Unknown error")
                }
                
                
            }
        } failure: { (status) in
            AlertView.showAlert(with: "Error", message: status.msg)
        }

        
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionForgotPassword(_ sender: UIButton) {
        self.getNavController()?.push(ForgotPasswordVC.self)
    }
    
    func isValidFields() -> String?{
        let email = emailField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let password = passwordField.text ?? ""
        if email.isEmpty && password.isEmpty {
            return "Please enter email and password."
        }else if email.isEmpty == false && password.isEmpty {
            return "Password is required."
        }else if email.isEmpty && password.isEmpty == false {
            return "Email is required."
        }
        var message :String? = nil
        if !Utility.isValidEmailAddress(email: email){
            message = "This email address is invalid."
        }else if !Utility.isValidPassword(password: password) {
            message = "This password is too short."
        }
        return message
    }
    
}

extension LoginViaCredentialsVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.main
    }
}
