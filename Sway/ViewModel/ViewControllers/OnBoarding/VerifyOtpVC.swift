//
//  VerifyOtpVC.swift
//  Sway
//
//  Created by Admin on 30/04/21.
//

import UIKit
//import OTPFieldView
import ViewControllerDescribable

class VerifyOtpVC: BaseViewController {
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var resendLabel: UILabel!
    @IBOutlet weak var otpView: OTPFieldView!
    
    var email:String = ""
    var password:String = ""
    var enteredOtp = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOtpView()
    }
    
    func setupOtpView(){
        self.otpView.fieldsCount = 4
        self.otpView.fieldBorderWidth = 2
        self.otpView.defaultBorderColor = UIColor(named: "kThemeNavyBlue_20")!
        self.otpView.activeCursorBoxColor = UIColor(named: "kThemeNavyBlue")!
        self.otpView.cursorColor = UIColor(named: "kThemeNavyBlue")!
        self.otpView.displayType = .roundedCorner
        self.otpView.fieldSize = 50
        self.otpView.separatorSpace = 16
        self.otpView.shouldAllowIntermediateEditing = false
        self.otpView.delegate = self
        self.otpView.initializeUI()
    }
    

    @IBAction func actionVerify(_ sender: UIButton) {
        showLoader()
        LoginRegisterEndpoint.verifyEmail(with: email, otp: enteredOtp) { [weak self](response) in
            self?.hideLoader()
            if let code = response.statusCode,code >= 200 && code < 300 {
//                self.view.makeToast("Otp verified successfully", duration: 3.0, position: .center)
                self?.view.makeToast("Otp verified successfully", duration: 3.0, position: .center) { (isSuccess) in
                    if isSuccess {
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }else {
                AlertView.showAlert(with: "Error!!!", message: response.message ?? "")
            }
        } failure: { (status) in
            AlertView.showAlert(with: "Error!!!", message: status.msg)
        }

    }
    
    @IBAction func actionCross(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension VerifyOtpVC: OTPFieldViewDelegate {
    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        return false
    }
    
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otp otpString: String) {
        enteredOtp = otpString
        print("OTPString: \(otpString)")
    }
}

extension VerifyOtpVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.main
    }
}
