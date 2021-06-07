//
//  ForgotPasswordVC.swift
//  Sway
//
//  Created by Admin on 07/05/21.
//

import UIKit
import ViewControllerDescribable

class ForgotPasswordVC: BaseViewController {
    
    
    
    @IBOutlet weak var btnSend: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var emailField: CustomFloatingLabelField!
    private var isEmailValid = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown(_:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        // Do any additional setup after loading the view.
    }
    
    fileprivate func setupUI(){
        let attributedString = NSMutableAttributedString(string: "Forgot Password?", attributes: [
          .font: UIFont(name: "Poppins-Bold", size: 46.0)!,
          .foregroundColor: UIColor(red: 5.0 / 255.0, green: 9.0 / 255.0, blue: 53.0 / 255.0, alpha: 1.0)
        ])
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 94.0 / 255.0, green: 0.0, blue: 1.0, alpha: 1.0), range: NSRange(location: 0, length: 6))
        lblTitle.attributedText = attributedString
        emailField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .allEditingEvents)
    }
    
    @IBAction func actionSend(_ sender: UIButton) {
        if isEmailValid {
            showLoader()
            LoginRegisterEndpoint.getOtp(on: self.emailField!.text!, type: .FORGOT_PASSWORD) {[weak self] (response) in
                self?.hideLoader()
                if response.statusCode == 200 {
                    self?.navigationController?.push(VerifyOtpVC.self, animated: true, configuration: { (vc) in
                        vc.email = self!.emailField.text!
                        vc.type = .FORGOT_PASSWORD
                    })
                }else {
                    AlertView.showAlert(with: "Error", message: response.message)
                }
            } failure: { [weak self](response) in
                self?.hideLoader()
                AlertView.showAlert(with: "Error", message: response.msg)
            }

//            LoginRegisterEndpoint.forgotPassword(with: self.emailField.text!) {[weak self] (response) in
//                self?.hideLoader()
//                if response.statusCode == 200 {
//                    self?.navigationController?.push(VerifyOtpVC.self, animated: true, configuration: { (vc) in
//                        vc.email = self!.emailField.text!
//                        vc.type = .FORGOT_PASSWORD
//                    })
//                }else {
//                    AlertView.showAlert(with: "Error", message: response.message ?? "Unknown error")
//                }
//
//            } failure: { (response) in
//                AlertView.showAlert(with: "Error", message: response.msg)
//            }

        }
    }
    
    @objc func textFieldDidChange(_ textField:UITextField){
        guard let text = textField.text else {return}
        if Utility.isValidEmailAddress(email: text) == true {
            btnSend.backgroundColor = UIColor(named: "kThemeYellow")
            btnSend.setTitleColor(UIColor(named: "kThemeNavyBlue"), for: .normal)
            isEmailValid = true
        }else {
            btnSend.setTitleColor(UIColor(named: "k124123132"), for: .normal)
            btnSend.backgroundColor = UIColor(named: "k245246250")
            isEmailValid = false
        }
    }
    
    @objc func swipeDown(_ gesture:UISwipeGestureRecognizer){
        if gesture.direction == .down {
            self.navigationController?.popViewController(animated: true)
        }
    }

}

extension ForgotPasswordVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.main
    }
}

