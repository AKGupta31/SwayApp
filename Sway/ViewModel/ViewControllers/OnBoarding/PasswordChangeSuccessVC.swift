//
//  PasswordChangeSuccessVC.swift
//  Sway
//
//  Created by Admin on 10/05/21.
//

import UIKit
import ViewControllerDescribable

enum PasswordChangeSuccessVCType:Int {
    case passwordChange
    case postSubmitted
    case welcomeToSway
    
    var mainImageName:String {
        switch self {
        case .passwordChange:
            return "PasswordChange"
        case .postSubmitted:
            return "ic_post_submitted"
        case .welcomeToSway:
            return "WelcomeToSway"
        }
    }
}

class PasswordChangeSuccessVC: BaseViewController {

    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var titlelmageView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    var type:PasswordChangeSuccessVCType = .passwordChange
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.titlelmageView.image = UIImage(named: type.mainImageName)
        if type == .postSubmitted {
            setupLabelForPostSubmitted()
            lblDescription.isHidden = true
            lblDescription.text = nil
        }else if type == .welcomeToSway{
            setupLabelForWelcomeToSway()
            lblDescription.text = "Congratulations! Subscription is successful. Let’s get started on your fitness journey!"
        } else {
            setupLabelForPasswordChanged()
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionCross(_ sender: UIButton) {
        if self.type == .postSubmitted {
            self.navigationController?.popViewController(animated: true)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    @IBAction func actionNext(_ sender: UIButton) {
        if self.type == .postSubmitted {
            self.navigationController?.popToRootViewController(animated: true)
        }else if type == .welcomeToSway {
            self.navigationController?.push(SyncWithCalenderVC.self, animated: true, configuration: nil)
        } else{
            guard var viewControllers = self.navigationController?.viewControllers else {return}
            viewControllers.removeLast()
            viewControllers.removeLast()
            viewControllers.removeLast()
            viewControllers.removeLast()
            viewControllers.removeLast()
            let loginVC = LoginViaCredentialsVC.instantiated()
            viewControllers.append(loginVC)
            self.navigationController?.setViewControllers(viewControllers, animated: true)
        }
    }
    
    fileprivate func setupLabelForPasswordChanged(){
        let attributedString = NSMutableAttributedString(string: "Password \nchanged", attributes: [
          .font: UIFont(name: "Poppins-Bold", size: 52.0)!,
          .foregroundColor: UIColor(red: 94.0 / 255.0, green: 0.0, blue: 1.0, alpha: 1.0)
        ])
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 5.0 / 255.0, green: 9.0 / 255.0, blue: 53.0 / 255.0, alpha: 1.0), range: NSRange(location: 8, length: 2))
        attributedString.addAttributes([
          .font: UIFont(name: "Poppins-Bold", size: 40.0)!,
          .foregroundColor: UIColor(red: 5.0 / 255.0, green: 9.0 / 255.0, blue: 53.0 / 255.0, alpha: 1.0)
        ], range: NSRange(location: 10, length: 7))
        lblTitle.attributedText = attributedString
    }
    
    func setupLabelForPostSubmitted(){
        let attributedString = NSMutableAttributedString(string: "Your Post has been submitted for review!", attributes: [
          .font: UIFont(name: "Poppins-Bold", size: 52.0)!,
          .foregroundColor: UIColor(red: 5.0 / 255.0, green: 9.0 / 255.0, blue: 53.0 / 255.0, alpha: 1.0)
        ])
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 94.0 / 255.0, green: 0.0, blue: 1.0, alpha: 1.0), range: NSRange(location: 19, length: 21))
        lblTitle.attributedText = attributedString

    }
    
    func setupLabelForWelcomeToSway(){
        let attributedString = NSMutableAttributedString(string: "Welcome\nto SWAY", attributes: [
          .font: UIFont(name: "Poppins-Bold", size: 52.0)!,
          .foregroundColor: UIColor(red: 94.0 / 255.0, green: 0.0, blue: 1.0, alpha: 1.0)
        ])
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 5.0 / 255.0, green: 9.0 / 255.0, blue: 53.0 / 255.0, alpha: 1.0), range: NSRange(location: 8, length: 7))
        lblTitle.attributedText = attributedString

    }
    

}

extension PasswordChangeSuccessVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.main
    }
}
