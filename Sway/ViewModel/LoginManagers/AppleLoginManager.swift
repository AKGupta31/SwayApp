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

    func logIn(from vc: UIViewController) {
        appleSignInDelegates = AppleLoginManagerDelegates(window: vc.view.window) { [weak self] (error,response) in
            if let error = error {
                self?.error(withMessage: error)
            } else {
                if let err = error {
                    print("error loginUserWithGoogleToken \(err)")
                    return
                }
                guard let statusCode = response?.statusCode else {return}
                if (statusCode >= 200 && statusCode < 300){
                    print("success")
                }
               
            }
        }

        let request = ASAuthorizationAppleIDProvider().createRequest()


        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = appleSignInDelegates
        controller.presentationContextProvider = appleSignInDelegates

        controller.performRequests()
    }

    func logInDidAppear(from vc: UIViewController) {
        appleSignInDelegates = AppleLoginManagerDelegates(window: vc.view.window) { [weak self] (error,response) in
            if let error = error {
                self?.error(withMessage: error)
            } else {
                if let err = error {
                    print("error loginUserWithGoogleToken \(err)")
                    return
                }
            }
        }

        let requests = [
            ASAuthorizationAppleIDProvider().createRequest(),
            ASAuthorizationPasswordProvider().createRequest()
        ]

        let controller = ASAuthorizationController(authorizationRequests: requests)
        controller.delegate = appleSignInDelegates
        controller.presentationContextProvider = appleSignInDelegates

        controller.performRequests()
    }
}
