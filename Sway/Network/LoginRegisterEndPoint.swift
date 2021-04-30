//
//  LoginRegisterEndPoint.swift
//  Sway
//
//  Created by Admin on 12/04/21.
//

import Foundation

enum SocialMediaType: String {
    case facebook = "FACEBOOK"
    case google = "GOOGLE"
    case apple = "APPLE"
}


class LoginRegisterEndpoint {
    
    /* Reference Function
    static func login(email: String, password: String, isForRefreshToken: Bool = false, success: @escaping SuccessCompletionBlock<LoginResponse>, failure: @escaping
                        ErrorFailureCompletionBlock) {
        
        Api.requestNew(endpoint: Endpoint.login(email: email, password: password, isForRefreshToken: isForRefreshToken), type: LoginResponse.self, successHandler: success, failureHandler: failure)
    }
 */
    
    static func socialRegister(socialId: String, email: String, firstName:String,lastName:String, type: SocialMediaType, image: String, success: @escaping SuccessCompletionBlock<SocialSignupResponse>, failure: @escaping ErrorFailureCompletionBlock) {
        Api.requestNew(endpoint: .socialRegister(socialId: socialId, email: email, firstName: firstName, lastName: lastName, type: type, profilePicture: image), type: SocialSignupResponse.self, successHandler: success, failureHandler: failure)
    }
    
    static func socialLogin(socialId: String,type:SocialMediaType, success: @escaping SuccessCompletionBlock<SocialSignupResponse>, failure: @escaping ErrorFailureCompletionBlock) {
        Api.requestNew(endpoint: .socialLogin(type: type, socialId: socialId), type: SocialSignupResponse.self, successHandler: success, failureHandler: failure)
    }
    
    static func login(with email: String,password:String, success: @escaping SuccessCompletionBlock<LoginResponse>, failure: @escaping ErrorFailureCompletionBlock) {
        Api.requestNew(endpoint: .login(email: email, password: password), type: LoginResponse.self, successHandler: success, failureHandler: failure)
    }
    
    static func verifyEmail(with email: String,otp:String, success: @escaping SuccessCompletionBlock<LoginResponse>, failure: @escaping ErrorFailureCompletionBlock) {
        Api.requestNew(endpoint: .verifyEmail(email: email, otp: otp), type: LoginResponse.self, successHandler: success, failureHandler: failure)
    }
}
    
    
