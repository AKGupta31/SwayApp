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
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel))
        self.lblSignup.isUserInteractionEnabled = true
        self.lblSignup.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionLoginWithEmail(_ sender: UIButton) {
        self.navigationController?.push(LoginViaCredentialsVC.self)
    }
    
    @IBAction func actionLoginWithApple(_ sender: UIButton) {
        if #available(iOS 13.0, *) {
            showLoader()
            appleManager.logIn(from: self) { [weak self](isSuccess, response) in
                self?.hideLoader()
                if isSuccess {
                    self?.navigationController?.push(HomeVC.self)
//                    self?.view.makeToast("Login Success", duration: 3.0, position: .center)
                }else {
                    AlertView.showAlert(with: "Error!!!", message: response?.message ?? "Unknown error")
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func actionFacebook(_ sender: UIButton) {
        self.showLoader()
        FacebookLoginManager.shared.login(viewController: self) {[weak self] (isSuccess,response) in
            self?.hideLoader()
            if isSuccess {
                DataManager.shared.setLoggedInUser(user: response?.data)
                self?.navigationController?.push(HomeVC.self)
//                self.view.makeToast("Login Success", duration: 3.0, position: .center)
            }else {
                AlertView.showAlert(with: "Error!!!", message: response?.message ?? "Unknown error")
            }
           
            
        }
    }
    
    @IBAction func actionCross(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func tappedOnLabel(gesture: UITapGestureRecognizer) {
        guard let text = lblSignup.text else {return}
        let nsString = NSString(string: text)
        let range = nsString.range(of: "Sign up")
        
        if gesture.didTapAttributedTextInLabel(label: lblSignup, inRange: range) {
            if let vcs = self.navigationController?.viewControllers,vcs.count >= 2, let  _ = vcs[vcs.count - 2] as? SignupVC{
                self.navigationController?.popViewController(animated: true)
            }else{
                self.navigationController?.push(SignupVC.self)
            }
           
        }
    }
    
    
}


extension LoginVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.main
    }
}
