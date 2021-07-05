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
    
    func getNavController() -> BaseNavigationController?{
        return self.navigationController as? BaseNavigationController
    }
    
    var transitionType:PushTransition = .horizontal
    
//    override var navigationController: BaseNavigationController?{
//        return
//    }
    
    fileprivate var activityIndicatorTag: Int { return 999999 }
    
    var addTapGestureToView:Bool = true {
        didSet {
            if addTapGestureToView {
                let tap = UITapGestureRecognizer(target: self, action:#selector(emptyViewTapped(_:)))
                self.view.addGestureRecognizer(tap)
            }
           
        }
    }
    
//    var showTabBar:Bool = false{
//        didSet {
//            if showTabBar == false {
//
//            }else {
//                edgesForExtendedLayout = []
//                extendedLayoutIncludesOpaqueBars = false
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = [.bottom]
        extendedLayoutIncludesOpaqueBars = true
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
    
    func startActivityIndicator(style: UIActivityIndicatorView.Style = .medium, location: CGPoint? = nil, inSelf: Bool = false,touchEnabled:Bool = false,tintColor:UIColor = UIColor.gray) {
        
        let loc = location ?? CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        
        DispatchQueue.main.async{
            
            let activityIndicator = UIActivityIndicatorView(style: style)
            
            activityIndicator.tag = self.activityIndicatorTag
            
            activityIndicator.center = loc
            activityIndicator.hidesWhenStopped = true
            activityIndicator.tintColor = tintColor
            activityIndicator.startAnimating()
            
            if inSelf == true {
                self.view.isUserInteractionEnabled = touchEnabled
                self.view.addSubview(activityIndicator)
            } else {
                self.navigationController?.view.isUserInteractionEnabled = touchEnabled
                self.navigationController?.view.addSubview(activityIndicator)
                self.navigationController?.view.backgroundColor = UIColor.white
            }
        }
    }
    
    func stopActivityIndicator(inSelf: Bool = false, completion: @escaping () -> Void = {}) {
        DispatchQueue.main.async { [weak self] in
            let view: UIView? = inSelf ? self?.view : self?.navigationController?.view
            
            if let activityIndicator = view?.subviews.filter(
                { $0.tag == self?.activityIndicatorTag}).first as? UIActivityIndicatorView {
                view?.isUserInteractionEnabled = true
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
            
            completion()
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
        let onBoardingStatus = OnboardingStatus(rawValue: profileSetup) ?? .INTRO__VIDEO_ONE
        SwayUserDefaults.shared.onBoardingScreenStatus = onBoardingStatus
        switch onBoardingStatus {
        case .INTRO__VIDEO_ONE:fallthrough
        case .INTRO__VIDEO_TWO:fallthrough
        case .INTRO__VIDEO_THREE:
            self.getNavController()?.push(OnboardingStartVC.self)
        case .PROFILE_AGE:
            self.getNavController()?.push(HowOldVC.self)
        case .PROFILE_GOAL:
            self.getNavController()?.push(SelectGoalVC.self)
        case .CHALLENGE_SCREEN:
            self.getNavController()?.push(OnboardingEndVC.self)
        case .HOME_SCREEN:
            self.getNavController()?.push(SwayTabbarVC.self)
        }
    }
}


class BaseTabBarViewController:BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = [.left,.right,.top]
        self.extendedLayoutIncludesOpaqueBars = false
    }
}
