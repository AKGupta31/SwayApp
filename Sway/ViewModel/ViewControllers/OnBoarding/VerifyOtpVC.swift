//
//  VerifyOtpVC.swift
//  Sway
//
//  Created by Admin on 30/04/21.
//

import UIKit
//import OTPFieldView
import ViewControllerDescribable

enum VerifyOtpType:Int {
    case SIGNUP
    case LOGIN
    case FORGOT_PASSWORD
    case SOCIAL_SIGNUP
}

class VerifyOtpVC: BaseLoginVC {
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnVerify: CustomButton!
    @IBOutlet weak var resendLabel: UILabel!
    @IBOutlet weak var otpView: OTPFieldView!
    
    var email:String = ""
    var firstName = ""
    var sirName = ""
    //MARK: Social Signup 
    var socialId:String?
    var image:String?
    
    
    private var enteredOtp = ""
    var type:VerifyOtpType = .SIGNUP
    private var isAlreadyCallingApi = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOtpView()
        if email.isEmpty == false {
            self.descriptionLabel.text = "We have sent code to your email: \(Utility.getHiddenMiddleCharatersOfEmail(email: self.email))"
        }
        resendLabel.setupLabelWithTappableArea(regularText: "Didn’t receive code?", tappableText: "Resend")
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel))
        self.resendLabel.isUserInteractionEnabled = true
        self.resendLabel.addGestureRecognizer(tapGestureRecognizer)
        updateTypeBaseAttributes()
    }
    
    func updateTypeBaseAttributes(){
        switch type {
        case .FORGOT_PASSWORD:
            btnVerify.setTitle("RESET PASSWORD", for: .normal)
            setupTitleForForgotPassword()
        default:
            setupTitleForEmailVerification()
        }
    }
    
    private func setupTitleForEmailVerification(){
        let attributedString = NSMutableAttributedString(string: "Email Verification", attributes: [
            .font: UIFont(name: "Poppins-Bold", size: 46.0)!,
            .foregroundColor: UIColor(red: 5.0 / 255.0, green: 9.0 / 255.0, blue: 53.0 / 255.0, alpha: 1.0)
        ])
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 94.0 / 255.0, green: 0.0, blue: 1.0, alpha: 1.0), range: NSRange(location: 0, length: 5))
        lblTitle.attributedText = attributedString
    }
    
    private func setupTitleForForgotPassword(){
        let attributedString = NSMutableAttributedString(string: "Forgot Password?", attributes: [
            .font: UIFont(name: "Poppins-Bold", size: 46.0)!,
            .foregroundColor: UIColor(red: 5.0 / 255.0, green: 9.0 / 255.0, blue: 53.0 / 255.0, alpha: 1.0)
        ])
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 94.0 / 255.0, green: 0.0, blue: 1.0, alpha: 1.0), range: NSRange(location: 0, length: 6))
        lblTitle.attributedText = attributedString
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
        LoginRegisterEndpoint.verifyEmail(with: email, otp: enteredOtp,type: self.type) { [weak self](response) in
            self?.hideLoader()
            if let code = response.statusCode,code >= 200 && code < 300 {
                self?.view.makeToast("Otp verified successfully", duration: 1.0, position: .bottom) { (isSuccess) in
                    //                    if isSuccess {
                    if self?.type == .SIGNUP {
                        self?.getNavController()?.push(SetupPasswordVC.self, animated: true, configuration: { (vc) in
                            vc.email = self?.email
                            vc.firstName = self?.firstName
                            vc.sirName = self?.sirName
                            vc.token = response.data?.token
                            vc.type = .setPassword
                        })
                    }else if self?.type == .LOGIN {
                        self?.navigationController?.popViewController(animated: true)
                    }else if self?.type == .FORGOT_PASSWORD {
                        self?.getNavController()?.push(SetupPasswordVC.self, animated: true, configuration: { (vc) in
                            vc.type = .resetPassword
                            vc.email = self?.email
                        })
                    }else if self?.type == .SOCIAL_SIGNUP{
                        self?.showLoader()
                        LoginRegisterEndpoint.socialRegister(socialId: self!.socialId!, email: self!.email, firstName: self!.firstName, lastName: self!.sirName, type: .facebook, image: self!.image!) { [weak self](response) in
                            self?.hideLoader()
                            if response.statusCode == 200 {
                                self?.goToNextScreen(response: response)
                            }else {
                                AlertView.showAlert(with: "Error", message: response.message ?? "Unkown error")
                            }
                        } failure: { (status) in
                            print(status)
                            AlertView.showAlert(with: "Error", message: status.msg)
                        }
                    }
                }
            }else {
                AlertView.showAlert(with: "Error", message: response.message ?? "")
            }
        } failure: { (status) in
            AlertView.showAlert(with: "Error", message: status.msg)
        }
        
    }
    
    @IBAction func actionCross(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension VerifyOtpVC: OTPFieldViewDelegate {
    
    @objc private func tappedOnLabel(gesture: UITapGestureRecognizer) {
        guard let text = resendLabel.text else {return}
        let nsString = NSString(string: text)
        let range = nsString.range(of: "Resend")
        
        if gesture.didTapAttributedTextInLabel(label: resendLabel, inRange: range),!isAlreadyCallingApi {
            showLoader()
            
            LoginRegisterEndpoint.getOtp(on: email,type:self.type) { [weak self](response) in
                self?.hideLoader()
                self?.isAlreadyCallingApi = false
                if let statusCode = response.statusCode,statusCode == 200 {
                    self?.view.makeToast("OTP has been resend on your email id", duration: 1.0, position: .bottom)
                }else {
                    AlertView.showAlert(with: "Error", message: response.message)
                }
                
            } failure: { [weak self](status) in
                self?.isAlreadyCallingApi = false
                self?.hideLoader()
                AlertView.showAlert(with: "Error", message: status.msg)
            }
        }
    }
    
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
