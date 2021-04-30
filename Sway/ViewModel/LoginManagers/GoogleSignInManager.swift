//
//  GoogleSignInManager.swift
//  Sway
//
//  Created by Admin on 22/04/21.
//

import UIKit
import GoogleSignIn


class GoogleSignInManager:NSObject,GIDSignInDelegate {
   
    private override init(){}
    static let shared = GoogleSignInManager()
    var responseCallback:LoginSuccessBlock?
    var viewController:UIViewController?
    func signIn(presentingVC:UIViewController,callback:LoginSuccessBlock?){
        self.responseCallback = callback
        self.viewController = presentingVC
        GIDSignIn.sharedInstance()?.presentingViewController = presentingVC
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance().signIn()
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            
            GoogleSignInManager.shared.login(idToken: user.authentication.idToken, accessToken: user.authentication.accessToken, email: user.profile.email, userId: user.userID, user: user)
        } else {
            if let topVc = UIApplication.topViewController {
                AlertView.showAlert(with: "Error!!!", message: error.localizedDescription, on: topVc)
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        NotificationCenter.default.post(Notification(name: Constants.Notifications.hideLoader))
        AlertView.showAlert(with: "Error!!!", message: error.localizedDescription)
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        
    }
}

extension GoogleSignInManager {
    func login(idToken: String, accessToken: String, email: String, userId: String,user:GIDGoogleUser) {
        // try to login with this token to the backend
        (viewController as? BaseViewController)?.showLoader()
        LoginRegisterEndpoint.socialLogin(socialId: userId, type: .google) { [weak self](response) in
            if let statusCode = response.statusCode,statusCode >= 200 && statusCode < 300 {
                DataManager.shared.isLoggedIn = true
                UserManager.saveSocialMediaCredentials(type: .google, token: accessToken, socialId: idToken, userId: response.signupModel?.userId ?? "")
                self?.responseCallback?(response)
            }else {
                //failure
                LoginRegisterEndpoint.socialRegister(socialId: userId, email: email, firstName: user.profile.givenName, lastName: user.profile.familyName, type: .google,image:user.profile.imageURL(withDimension: 0)!.path) { (response) in
                    self?.handleResponse(response: response)
                } failure: { (error) in
                    DataManager.shared.isLoggedIn = false
                    NotificationCenter.default.post(Notification(name: Constants.Notifications.hideLoader))
                    AlertView.showAlert(with: "Error!!!", message: error.msg)
                }
            }
          
        } failure: { (status) in
            LoginRegisterEndpoint.socialRegister(socialId: userId, email: email, firstName: user.profile.givenName, lastName: user.profile.familyName, type: .google,image: user.profile.imageURL(withDimension: 0)!.path) { [weak self](response) in
                self?.handleResponse(response: response)
            } failure: { (error) in
                DataManager.shared.isLoggedIn = false
                NotificationCenter.default.post(Notification(name: Constants.Notifications.hideLoader))
                AlertView.showAlert(with: "Error!!!", message: status.msg)
            }
        }
    }
    
    func handleResponse(response:SocialSignupResponse){
        if let statusCode = response.statusCode,statusCode >= 200 && statusCode < 300 {
            self.responseCallback?(response)
        }else {
            DataManager.shared.isLoggedIn = false
            NotificationCenter.default.post(Notification(name: Constants.Notifications.hideLoader))
            AlertView.showAlert(with: "Error!!!", message: response.message ?? "")
        }
    }
    
}
