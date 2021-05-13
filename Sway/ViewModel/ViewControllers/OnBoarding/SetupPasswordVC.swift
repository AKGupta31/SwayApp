//
//  SetupPasswordVC.swift
//  Sway
//
//  Created by Admin on 04/05/21.
//

import UIKit
import ViewControllerDescribable
import KDCircularProgress

enum PasswordStrength:String {
    case weak = "Weak Password"
    case moderate = "Moderate Password"
    case strong = "Strong Password"
    case invalid   = "Invalid Password"
}

enum SetPasswordType:String {
    case setPassword
    case resetPassword
}

class SetupPasswordVC: BaseViewController {

    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblStep: UILabel!
    @IBOutlet weak var btnResetPassword: CustomButton!
    @IBOutlet weak var confirmPasswordLogLabel: UILabel!
    @IBOutlet weak var passwordLogLabel: UILabel!
    @IBOutlet weak var progressViewInnerCircle: CustomView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var lblLoginTitle: UILabel!
    @IBOutlet weak var confirmPasswordField: CustomFloatingLabelField!
    @IBOutlet weak var passwordField: CustomFloatingLabelField!
    
    var firstName:String?
    var sirName:String?
    var email:String?
    var token:String?
    
    var isFieldsValid = false
    var progress:KDCircularProgress!
    var type:SetPasswordType = .setPassword
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .allEditingEvents)
        confirmPasswordField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .allEditingEvents)
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        updateTitle()
        passwordLogLabel.text = ""
        confirmPasswordLogLabel.text = ""
    }
    
    private func updateTitle(){
        if self.type == .setPassword {
            updateTitleAndViewsForSetPassword()
        }else if type == .resetPassword {
            updateTitleAndViewsForResetPassword()
        }
    }
    
    private func setupProgressView(){
        progress = KDCircularProgress(frame:progressView.bounds)
        progress.startAngle = -90
        progress.progressThickness = 0.2
        progress.trackThickness = 0.1
        progress.clockwise = false
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = false
        progress.roundedCorners = true
        progress.glowMode = .noGlow
        progress.set(colors: UIColor(named: "k124123132")!)
        progress.trackColor = UIColor(red: 245/255, green: 246/255, blue: 250/255, alpha: 1.0)
        progress.progress = 0.66
        progressView.insertSubview(progress, at: 0)
        progressViewInnerCircle.backgroundColor = UIColor(named: "k245246250")
    }
    
    @IBAction func actionPasswordEye(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        passwordField.isSecureTextEntry = !sender.isSelected
    }
    
    @IBAction func actionConfirmPasswordEye(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        confirmPasswordField.isSecureTextEntry = !sender.isSelected
    }
    
    @IBAction func actionResetPassword(_ sender: UIButton) {
        callSetPasswordApi()
    }
    
    
    
    func updateTitleAndViewsForSetPassword(){
        let attributedString = NSMutableAttributedString(string: "Set up your password", attributes: [
          .font: UIFont(name: "Poppins-Bold", size: 46.0)!,
          .foregroundColor: UIColor(red: 5.0 / 255.0, green: 9.0 / 255.0, blue: 53.0 / 255.0, alpha: 1.0)
        ])
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 94.0 / 255.0, green: 0.0, blue: 1.0, alpha: 1.0), range: NSRange(location: 12, length: 8))
        lblLoginTitle.attributedText = attributedString
        setupProgressView()
        btnResetPassword.isHidden = true
        lblStep.isHidden = false
    }
    
    func updateTitleAndViewsForResetPassword(){
        let attributedString = NSMutableAttributedString(string: "Reset your password", attributes: [
          .font: UIFont(name: "Poppins-Bold", size: 46.0)!,
          .foregroundColor: UIColor(red: 5.0 / 255.0, green: 9.0 / 255.0, blue: 53.0 / 255.0, alpha: 1.0)
        ])
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 94.0 / 255.0, green: 0.0, blue: 1.0, alpha: 1.0), range: NSRange(location: 11, length: 8))
        lblLoginTitle.attributedText = attributedString
        progressView.isHidden = true
        btnResetPassword.isHidden = false
        lblStep.isHidden = true
        lblDescription.text = "Enter your new password below. Your new password must be different from previous used passwords."
        
    }
    
}

extension SetupPasswordVC:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    @objc func textFieldDidChange(_ textField:UITextField){
        if textField == passwordField {
            updatePasswordLabel()
        }else if textField == confirmPasswordField {
            updateConfirmPasswordLabel()
        }
    }
    
    private func updatePasswordLabel(){
        guard let password = passwordField.text else {return}
        passwordLogLabel.text = Utility.getPasswordStrength(password: password).rawValue
    }
    
    private func updateConfirmPasswordLabel(){
        
        guard let confirmPassword = confirmPasswordField.text else {return}
        guard let password = passwordField.text else {return}
        
        if password.count >= 8 && password == confirmPassword {
            confirmPasswordLogLabel.text = "Correct"
            isFieldsValid = true
            if progress != nil {
                progress.set(colors: UIColor(named: "kThemeBlue")!)
            }
        }else {
            isFieldsValid = false
            confirmPasswordLogLabel.text = "Incorrect"
            if progress != nil {
                progress.set(colors: UIColor(named: "k124123132")!)
            }
            
        }
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let (isValid,_) = isAllFieldsValid()
        if isValid {
            progressViewInnerCircle.backgroundColor = UIColor(named: "kThemeYellow")
        }else {
            progressViewInnerCircle.backgroundColor = UIColor(named: "k245246250")
        }
    }
    
    func isAllFieldsValid() -> (Bool,String){
        if passwordField.text == nil || passwordField.text!.count == 0{
            return (false,"Please enter password")
        }else if passwordField.text != confirmPasswordField.text{
            return (false,"Passwords do not match")
        }
        return (true,"")
    }
}

extension SetupPasswordVC:UIScrollViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if isFieldsValid {
            let height = scrollView.frame.size.height
            let contentYoffset = scrollView.contentOffset.y
            let distanceFromBottom = scrollView.contentSize.height - contentYoffset
            
            if distanceFromBottom <= height {
                let (isValid,error) = isAllFieldsValid()
                if !isValid {
                    AlertView.showAlert(with: "Opps!!!", message: error)
                    return
                }
                self.navigationController?.push(SetProfilePictureVC.self, animated: true, configuration: { (vc) in
                    vc.firstName = self.firstName!
                    vc.password = self.passwordField.text!
                    vc.lastName = self.sirName!
                    vc.token = self.token!
                })
                
                
            }else {
                print("don't call api")
            }
        }
        
    }
    
    fileprivate func callSetPasswordApi(){
        if isFieldsValid {
            showLoader()
            LoginRegisterEndpoint.resetPassword(with: email!, password: passwordField.text!) {[weak self] (response) in
                self?.hideLoader()
                if response.statusCode == 200{
                    self?.navigationController?.push(PasswordChangeSuccessVC.self)
                }else {
                    AlertView.showAlert(with: "Error!!!", message: response.message ?? "Unknown error")
                }
            } failure: { (status) in
                AlertView.showAlert(with: "Error!!!", message: status.msg)
            }

        }
        
    }
}

extension SetupPasswordVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.main
    }
}

