//
//  FacebookLoginManager.swift
//  Sway
//
//  Created by Admin on 22/04/21.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

typealias LoginSuccessBlock = ((_ success:Bool,LoginResponse?) -> ())

class FacebookLoginManager {
    
    var responseCallback:LoginSuccessBlock?
    static let shared = FacebookLoginManager()
    
    private init(){}
    
    func login(viewController: UIViewController,callBack:@escaping LoginSuccessBlock) {
        self.responseCallback = callBack
        let loginManager = LoginManager()
        
        // login to Facebook in order to obtain token
        loginManager.logOut()
        loginManager.authType = .reauthorize
        loginManager.logIn(permissions: [Permission.publicProfile, Permission.email], viewController: viewController) {(loginResult) in
            switch loginResult {
            case .failed:
                let response = LoginResponse(statusCode: 500, message: "Login failed: Connection to social media account failed")
                self.responseCallback?(false,response)
//                AlertView.showAlert(with: "Error", message: "Login failed: Connection to social media account failed",on: viewController)
//                break
            case .cancelled:
                let response = LoginResponse(statusCode: 500, message: "Login failed: Connection to social media account cancelled by user")
                self.responseCallback?(false,response)
//                AlertView.showAlert(with: "Error", message: "Login failed: Connection to social media account cancelled by user",on: viewController)
                
            case .success(_, _, let accessToken):
                //                 try to login with this token to the backend
                LoginRegisterEndpoint.socialLogin(socialId: accessToken!.userID, type: .facebook) {[weak self] (response) in
                    if let statusCode = response.statusCode,statusCode >= 200 && statusCode < 300 {
                        self?.responseCallback?(true,response)
                    }else {
                        self?.requestEmailAndNameFromFB(accessToken: accessToken!, viewController: viewController)
                    }
                } failure: { [weak self] (status) in
                    self?.requestEmailAndNameFromFB(accessToken: accessToken!, viewController: viewController)
                }
            }
        }
    }
    
    
    
    func requestEmailAndNameFromFB(accessToken:FBSDKCoreKit.AccessToken,viewController:UIViewController){
        let req = GraphRequest(graphPath: "me", parameters: ["fields":"email,first_name,last_name,picture.type(large)"], tokenString: accessToken.tokenString, version: nil, httpMethod: .get)
        req.start { (connection, result, error) in
            if(error == nil) {
                print("result \(String(describing: result))")
                if let dic = result as? [String:Any]{
                    let email = dic["email"] as? String ?? ""
                    let firstName = dic["first_name"] as? String ?? ""
                    let lastName = dic["last_name"] as? String ?? ""
                    let socialId = dic["id"] as? String ?? ""
                    var image = ""
                    if let data = dic["picture"] as? [String:Any],let imageDic = data["data"] as? [String:Any]{
                        image = imageDic["url"] as? String ?? ""
                    }
                    if email.isEmpty || firstName.isEmpty || lastName.isEmpty {
                        var nav:UINavigationController?
                        if let topVC = UIApplication.topViewController{
                            if let navigationController = topVC as? UINavigationController {
                                nav = navigationController
                            }else {
                                nav = topVC.navigationController
                            }
                        }
                        (viewController as? BaseViewController)?.hideLoader()
                        (viewController as? BaseViewController)?.getNavController()?.push(Register1VC.self, animated: true, configuration: { (vc) in
                            vc.type = .SOCIAL_SIGNUP
                            vc.email = email
                            vc.firstName = firstName
                            vc.lastName = lastName
                            vc.socialId = socialId
                            vc.image = image
                        })
                    }else {
                        LoginRegisterEndpoint.socialRegister(socialId: socialId, email: email, firstName: firstName, lastName: lastName, type: .facebook, image: image) { [weak self](response) in
                            print(response)
                            if response.statusCode == 200{
                                self?.responseCallback?(true,response)
                            }else if response.type == "EMAIL_ALREADY_EXIST" {
                                LoginRegisterEndpoint.socialLogin(socialId: socialId, type: .facebook) { (response) in
                                    if response.statusCode == 200 {
                                        self?.responseCallback?(true,response)
                                    }else {
                                        self?.responseCallback?(false,response)
                                    }
                                } failure: { (status) in
                                    let loginResponse = LoginResponse(statusCode: status.code, message: status.msg)
                                    self?.responseCallback?(false,loginResponse)
                                }

                            } else {
                                self?.responseCallback?(false,response)
                            }
                            
                        } failure: { (status) in
                            print(status)
                            let response = LoginResponse(statusCode: status.code, message: status.msg)
                            self.responseCallback?(false,response)
//                            AlertView.showAlert(with: "Error", message: status.msg)
                        }
                    }
                    
                    
                }
                
            } else {
                AlertView.showAlert(with: "Error", message: error?.localizedDescription ?? "")
                print("error \(String(describing: error))")
            }
        }
    }
    
    func getEmailForUser(viewController: UIViewController, successHandler: @escaping (String) -> Void, failureHandler: @escaping (String) -> Void) {
        // if login failed then we try to obtain this account's email in order to use it to register in the backend
        let graphRequest:GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields" : "email, name, id"])
        
        graphRequest.start { (graphRequestConnection, result, error) in
            if error != nil {
                self.showAlertViewForEmail(viewController: viewController, successHandler: successHandler, failureHandler: failureHandler)
            } else {
                if let result = result as? [String:String],
                   let email: String = result["email"] {
                    successHandler(email)
                } else {
                    self.showAlertViewForEmail(viewController: viewController, successHandler: successHandler, failureHandler: failureHandler);
                }
            }
        }
    }
    
    func showAlertViewForEmail(viewController: UIViewController, successHandler: @escaping (String) -> Void, failureHandler: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: "log_in_sign_in".localized, message: "log_in_popup_email_message".localized, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "log_in_sign_in".localized, style: .default, handler: {
            alert -> Void in
            
            let emailTextField = alertController.textFields![0] as UITextField
            
            guard let email = emailTextField.text else {failureHandler("log_in_popup_no_email_message".localized); return}
            
            successHandler(email)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            failureHandler("log_in_popup_no_email_message".localized)
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "log_in_email_hint".localized
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
