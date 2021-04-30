//
//  AppleLoginManager.swift
//  Sway
//
//  Created by Admin on 19/04/21.
//

import Foundation
import UIKit
import AuthenticationServices


@available(iOS 13.0, *)
class AppleLoginManager: SocialLoginManager {
    private var appleSignInDelegates: AppleLoginManagerDelegates?

    func logIn(from vc: UIViewController,callback:LoginSuccessBlock?) {
        appleSignInDelegates = AppleLoginManagerDelegates(window: vc.view.window, onSignedIn: callback)
        
        /* PREVIOUSLY USED CODE*/
       /* appleSignInDelegates = AppleLoginManagerDelegates(window: vc.view.window) { [weak self] (isSuccess,response) in
            if isSuccess {
                
            }else {
                
            }
            if let error = error {
                (vc as? BaseViewController)?.hideLoader()
                self?.error(withMessage: error)
            } else {
                guard let statusCode = response?.statusCode else {return}
                if (statusCode >= 200 && statusCode < 300){
                    print("success")
                    callback?(true,response)
                }else {
                    callback?(false,response)
                    print("failure")
                }
            }
        } */

        let request = ASAuthorizationAppleIDProvider().createRequest()


        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = appleSignInDelegates
        controller.presentationContextProvider = appleSignInDelegates

        controller.performRequests()
    }

//    func logInDidAppear(from vc: UIViewController) {
//        appleSignInDelegates = AppleLoginManagerDelegates(window: vc.view.window) { [weak self] (isSuccess,response) in
//            if isSuccess {
//                
//            }else {
//                self?.error(withMessage: response?.message ?? "")
//            }
//        }
//
//        let requests = [
//            ASAuthorizationAppleIDProvider().createRequest(),
//            ASAuthorizationPasswordProvider().createRequest()
//        ]
//
//        let controller = ASAuthorizationController(authorizationRequests: requests)
//        controller.delegate = appleSignInDelegates
//        controller.presentationContextProvider = appleSignInDelegates
//
//        controller.performRequests()
//    }
}
