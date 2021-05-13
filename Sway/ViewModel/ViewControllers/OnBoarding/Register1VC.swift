//
//  Register1VC.swift
//  Sway
//
//  Created by Admin on 15/04/21.
//

import UIKit
import ViewControllerDescribable
import KDCircularProgress


class Register1VC: BaseViewController {
    
    @IBOutlet weak var progressViewInnerCircle: CustomView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var lblLoginTitle: UILabel!
    
    @IBOutlet weak var sirnameField: CustomFloatingLabelField!
    @IBOutlet weak var firstNameField: CustomFloatingLabelField!
    @IBOutlet weak var emailField: CustomFloatingLabelField!
    
    var progress:KDCircularProgress!
    var isAllValid = false
    var isAlreadyCallingApi = false
    
    //MARK: Social Login Credentials
    var firstName:String?
    var lastName:String?
    var email:String?
    var socialId:String?
    var image:String?
    var type:VerifyOtpType = .SIGNUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let attributedString = NSMutableAttributedString(string: "Let’s create\n your account", attributes: [
            .font: UIFont(name: "Poppins-Bold", size: 46.0)!,
            .foregroundColor: UIColor(named: "kThemeBlue")!
        ])
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 5.0 / 255.0, green: 9.0 / 255.0, blue: 53.0 / 255.0, alpha: 1.0), range: NSRange(location: 0, length: 6))
        attributedString.addAttribute(.foregroundColor, value: UIColor(named: "kThemeNavyBlue")!, range: NSRange(location: 12, length: 6))
        lblLoginTitle.attributedText = attributedString
        scrollView.delegate = self
        emailField.delegate = self
        firstNameField.delegate = self
        sirnameField.delegate = self
        setupProgressView()
        
        if self.type == .SOCIAL_SIGNUP {
            emailField.text = email
            firstNameField.text = firstName
            sirnameField.text = lastName
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
   
    
  
    fileprivate func setupProgressView(){
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
        progress.progress = 0.33
        progressView.insertSubview(progress, at: 0)
        progressViewInnerCircle.backgroundColor = UIColor(named: "k245246250")
    }
    
    @IBAction func actionCross(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension Register1VC:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let (isValid,_) = isAllFieldsValid()
        self.isAllValid = isValid
        if isValid {
            progressViewInnerCircle.backgroundColor = UIColor(named: "kThemeYellow")
            progress.set(colors: UIColor(named: "kThemeBlue")!)
        }else {
            progressViewInnerCircle.backgroundColor = UIColor(named: "k245246250")
            progress.set(colors: UIColor(named: "k124123132")!)
        }
    }
}

extension Register1VC:UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if isAllValid && !isAlreadyCallingApi{
            let height = scrollView.frame.size.height
            let contentYoffset = scrollView.contentOffset.y
            let distanceFromBottom = scrollView.contentSize.height - contentYoffset
            if distanceFromBottom <= height {
                let (isValid,error) = isAllFieldsValid()
                if !isValid {
                    AlertView.showAlert(with: "Opps!!!", message: error)
                    isAlreadyCallingApi = false
                    return
                }
                showLoader()
                LoginRegisterEndpoint.getOtp(on: emailField.text!) { [weak self](response) in
                    self?.hideLoader()
                    self?.isAlreadyCallingApi = false
                    if let statusCode = response.statusCode,statusCode == 200 {
                        self?.navigationController?.push(VerifyOtpVC.self, animated: true, configuration: { (vc) in
                            vc.email = self?.emailField.text ?? ""
                            vc.type = self?.type ?? .SIGNUP
                            vc.firstName = self?.firstNameField.text ?? ""
                            vc.sirName = self?.sirnameField.text ?? ""
                            vc.socialId = self?.socialId
                            vc.image = self?.image
                        })
                    }else {
                        AlertView.showAlert(with: "Error!!!", message: response.message ?? "Unknown Error")
                    }
                    
                } failure: { [weak self](status) in
                    self?.isAlreadyCallingApi = false
                    self?.hideLoader()
                    AlertView.showAlert(with: "Error!!!", message: status.msg)
                }
                
            }else {
                print("don't call api")
            }
        }
    }
    
    func isAllFieldsValid() -> (Bool,String){
        if firstNameField.text == nil || firstNameField.text!.count == 0{
            return (false,"First name cannot be empty")
        }else if sirnameField.text == nil || sirnameField.text!.count == 0{
            return (false,"Surname cannot be empty")
        }else if emailField.text == nil || !Utility.isValidEmailAddress(email: emailField.text!) {
            return (false,"Invalid email address".localized)
        }
        return (true,"")
    }
}



extension Register1VC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable{
        return UIStoryboard.Name.main
    }
}

func makeCircle(atLocation location: CGPoint, radius: CGFloat, percent: CGFloat) -> UIBezierPath? {
    let path = UIBezierPath()
    path.addArc(
        withCenter: location,
        radius: radius,
        startAngle: 0.0,
        endAngle: (.pi * 2.0) * percent,
        clockwise: true)
    path.addLine(to: location)
    path.close()
    return path
}
//
