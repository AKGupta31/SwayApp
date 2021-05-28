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
    
    static func socialRegister(socialId: String, email: String, firstName:String,lastName:String, type: SocialMediaType, image: String, success: @escaping SuccessCompletionBlock<LoginResponse>, failure: @escaping ErrorFailureCompletionBlock) {
        Api.requestNew(endpoint: .socialRegister(socialId: socialId, email: email, firstName: firstName, lastName: lastName, type: type, profilePicture: image), type: LoginResponse.self, successHandler: success, failureHandler: failure)
    }
    
    static func socialLogin(socialId: String,type:SocialMediaType, success: @escaping SuccessCompletionBlock<LoginResponse>, failure: @escaping ErrorFailureCompletionBlock) {
        Api.requestNew(endpoint: .socialLogin(type: type, socialId: socialId), type: LoginResponse.self, successHandler: success, failureHandler: failure)
    }
    
    static func login(with email: String,password:String, success: @escaping SuccessCompletionBlock<LoginResponse>, failure: @escaping ErrorFailureCompletionBlock) {
        Api.requestNew(endpoint: .login(email: email, password: password), type: LoginResponse.self, successHandler: success, failureHandler: failure)
    }
    
    static func verifyEmail(with email: String,otp:String,type :VerifyOtpType = .LOGIN, success: @escaping SuccessCompletionBlock<VerifyOtpResponse>, failure: @escaping ErrorFailureCompletionBlock) {
        Api.requestNew(endpoint: .verifyEmail(email: email, otp: otp,type:type), type: VerifyOtpResponse.self, successHandler: success, failureHandler: failure)
    }
    
    static func getOtp(on email: String,success: @escaping SuccessCompletionBlock<EmptyDataResponse>, failure: @escaping ErrorFailureCompletionBlock) {
        Api.requestNew(endpoint: .getOtpOnEmail(email: email), type: EmptyDataResponse.self, successHandler: success, failureHandler: failure)
    }
    
    static func signup(token: String,fName:String,lName:String,password:String,imageUrl:String,success: @escaping SuccessCompletionBlock<EmptyDataResponse>, failure: @escaping ErrorFailureCompletionBlock) {
        Api.requestNew(endpoint: .signup(token: token, fName: fName, lName: lName, password: password, imageUrl: imageUrl), type: EmptyDataResponse.self, successHandler: success, failureHandler: failure)
    }
    
    static func forgotPassword(with email: String, success: @escaping SuccessCompletionBlock<EmptyDataResponse>, failure: @escaping ErrorFailureCompletionBlock) {
        Api.requestNew(endpoint: .forgotPassword(email: email), type: EmptyDataResponse.self, successHandler: success, failureHandler: failure)
    }
    
    static func resetPassword(with email: String,password:String, success: @escaping SuccessCompletionBlock<EmptyDataResponse>, failure: @escaping ErrorFailureCompletionBlock) {
        Api.requestNew(endpoint: .resetPassword(email: email, password: password), type: EmptyDataResponse.self, successHandler: success, failureHandler: failure)
    }
    
    static func updateOnboardingScreenStatus(key: String,value:Any, success: @escaping SuccessCompletionBlock<EmptyDataResponse>, failure: @escaping ErrorFailureCompletionBlock) {
        Api.requestNew(endpoint: .updateOnboardingStatus(key: key, value: value), type: EmptyDataResponse.self, successHandler: success, failureHandler: failure)
    }
    
    static func getVideos(type: Int,success: @escaping SuccessCompletionBlock<VideoResponse>, failure: @escaping ErrorFailureCompletionBlock) {
        Api.requestNew(endpoint: .getVideos(videoFor: type), type: VideoResponse.self, successHandler: success, failureHandler: failure)
    }
}
    
    
