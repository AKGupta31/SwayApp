//
//  BaseViewController.swift
//  Sway
//
//  Created by Admin on 13/04/21.
//

import UIKit
import ViewControllerDescribable
import SVProgressHUD

class BaseViewController:UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action:#selector(emptyViewTapped(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(hideLoader), name: Constants.Notifications.hideLoader, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self, name: Constants.Notifications.hideLoader, object: nil)
    }
    
    @objc func showLoader(){
        SVProgressHUD.show()
    }
    
    @objc func showProgress(progress:Float){
        DispatchQueue.main.async {
            SVProgressHUD.setDefaultMaskType(.clear)
            SVProgressHUD.showProgress(progress)
        }
        
    }
    
    @objc func hideLoader(){
        SVProgressHUD.dismiss()
    }
    
    @objc func emptyViewTapped(_ gesture:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
}


class BaseLoginVC:BaseViewController{
    
    func goToNextScreen(response:LoginResponse?){
        guard let profileSetup = response?.data?.profileStep else {
            return
        }
        let onBoardingStatus = OnboardingStatus(rawValue: profileSetup - 1) ?? .NONE
        SwayUserDefaults.shared.onBoardingScreenStatus = onBoardingStatus
        switch onBoardingStatus {
        case .NONE:
            self.navigationController?.push(OnboardingStartVC.self)
        case .INTRO__VIDEO_ONE:fallthrough
        case .INTRO__VIDEO_TWO:fallthrough
        case .INTRO__VIDEO_THREE:
            self.navigationController?.push(HowOldVC.self)
        case .PROFILE_AGE:
            self.navigationController?.push(SelectGoalVC.self)
        case .PROFILE_GOAL:
            self.navigationController?.push(OnboardingEndVC.self)
        case .CHALLENGE_SCREEN:
            self.navigationController?.push(SwayTabbarVC.self)
        }
    }
}

