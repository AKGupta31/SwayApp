//
//  AppleLoginManagersDelegate.swift
//  Sway
//
//  Created by Admin on 19/04/21.
//
import Foundation
import AuthenticationServices

class AppleLoginManagerDelegates: NSObject {

    private let signInCompletion: LoginSuccessBlock?
    private weak var window: UIWindow!

    init(window: UIWindow?, onSignedIn:LoginSuccessBlock?) {
        self.window = window
        self.signInCompletion = onSignedIn
    }
}

@available(iOS 13.0, *)
extension AppleLoginManagerDelegates: ASAuthorizationControllerDelegate {
    private func registerNewAccount(credential: ASAuthorizationAppleIDCredential) {
        // 1
        let userData = UserData(email: credential.email!,
                                name: credential.fullName!,
                                identifier: credential.user)
        
        
        //2
        //prompt user for user profile image
        
        let profileImage = ""

        // 2
    
        let keychain = UserDataKeychain()
        do {
            try keychain.store(userData)
        } catch {
            self.signInCompletion?(false,nil)
        }

        // 3

        guard let identityToken = credential.identityToken else {return}

        let token = String(data: identityToken, encoding: .utf8) ?? ""
        LoginRegisterEndpoint.socialRegister(socialId: credential.user, email:userData.email, firstName: userData.name.givenName ?? "", lastName: userData.name.middleName ?? " " + (userData.name.familyName ?? " "), type: .apple, image: "https://i.picsum.photos/id/182/200/300.jpg?hmac=W6MnOpe7fP0LlNAyWl6rzWbjyLOM3ix2TXRcFx7vEPE") { [weak self](socialSignupResponse) in
            if let statusCode = socialSignupResponse.statusCode,statusCode >= 200 && statusCode < 300 {
                self?.signInCompletion?(true,socialSignupResponse)
                UserManager.saveSocialMediaCredentials(type: .apple, token: token, socialId: token, userId: credential.user)
            }else {
                self?.signInCompletion?(false,socialSignupResponse)
            }
           
            
        } failure: { [weak self] (status) in
            let socialSignupResponse = SocialSignupResponse(statusCode: status.code, message: status.msg)
            self?.signInCompletion?(false,socialSignupResponse)
        }
    }

    private func signInWithExistingAccount(credential: ASAuthorizationAppleIDCredential) {
        guard let identityToken = credential.identityToken else {return}

        let token = String(data: identityToken, encoding: .utf8) ?? ""
        
        LoginRegisterEndpoint.socialLogin(socialId: credential.user, type: .apple) { [weak self](response) in
            if let code = response.statusCode,code >= 200 && code > 300 {
                self?.signInCompletion?(true,response)
                UserManager.saveSocialMediaCredentials(type: .apple, token: token, socialId: token, userId: credential.user)
            }else {
                self?.signInCompletion?(false,response)
            }
            
        } failure: { (status) in
            let response = SocialSignupResponse(statusCode: status.code, message: status.msg)
            self.signInCompletion?(false,response)
//            self.signInCompletion(status.msg,nil)
        }
    }

    private func signInWithUserAndPassword(credential: ASPasswordCredential) {
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIdCredential as ASAuthorizationAppleIDCredential:
            if let _ = appleIdCredential.email, let _ = appleIdCredential.fullName {
                registerNewAccount(credential: appleIdCredential)
            } else {
                signInWithExistingAccount(credential: appleIdCredential)
            }
            break
        case let passwordCredential as ASPasswordCredential:
            signInWithUserAndPassword(credential: passwordCredential)
            break
        default:
            break
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let response = SocialSignupResponse(statusCode:500, message: error.localizedDescription)
        self.signInCompletion?(false,response)
//        self.signInCompletion(error.localizedDescription,nil)
    }
}

@available(iOS 13.0, *)
extension AppleLoginManagerDelegates: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.window
    }
}
