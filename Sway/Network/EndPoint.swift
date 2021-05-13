//
//  EndPoint.swift
//  Sway
//
//  Created by Admin on 12/04/21.
//

import Foundation
import Alamofire

enum Endpoint {
    
    case login(email:String,password:String)
    case socialRegister(socialId: String, email: String, firstName: String,lastName:String, type: SocialMediaType, profilePicture: String)
    case socialLogin(type:SocialMediaType,socialId:String)
    case verifyEmail(email:String,otp:String,type:VerifyOtpType)
    case getOtpOnEmail(email:String)
    case signup(token: String,fName:String,lName:String,password:String,imageUrl:String)
    case forgotPassword(email:String)
    case resetPassword(email:String,password:String)

    
    
    /// GET, POST or PUT method for each request
    var method:Alamofire.HTTPMethod {
        switch self {
        case .login,.socialRegister,.socialLogin,.getOtpOnEmail,.signup,.forgotPassword,.resetPassword:
            return .post
        case .verifyEmail:
            return .get
        }
    }
    
    /// URLEncoding used for GET requests and JSONEncoding for POST and PUT requests
    var encoding:Alamofire.ParameterEncoding {
        switch self.method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    /// URL string for each request
    var path: String {
        let interMediate = "/v1/user/"
        switch self {
        case .login:
            return Constants.Networking.kBaseUrl + interMediate + "login"
        case .socialRegister,.socialLogin:
            return Constants.Networking.kBaseUrl + interMediate + "social-signup"
        case .verifyEmail(_ ,_,let type):
            switch type {
            case .FORGOT_PASSWORD:
                return Constants.Networking.kBaseUrl + interMediate + "verify-forgot-otp"
            default:
                return Constants.Networking.kBaseUrl + interMediate + "verify-email"
            }
        case .getOtpOnEmail:
            return  Constants.Networking.kBaseUrl + interMediate + "send-otp"
        case .signup:
            return  Constants.Networking.kBaseUrl + interMediate + "signup"
        case .forgotPassword:
            return  Constants.Networking.kBaseUrl + interMediate + "forgot-password"
        case .resetPassword:
            return Constants.Networking.kBaseUrl + interMediate + "reset-password"
        }
    }
    
    /// parameters Dictionary for each request
    var parameters:[String:Any] {
        switch self {
        case .login(let email,let password):
            return ["email":email,"password":password,"deviceId":DataManager.shared.deviceId,"deviceToken":DataManager.shared.deviceToken]
        case .socialRegister(let socialId,let email,let firstName, let lastName,let type,let profilePicture):
            var dictionary =  ["socialLoginType":type.rawValue,"socialId":socialId,"email":email,"firstName":firstName,"lastName":lastName,"deviceId":DataManager.shared.deviceId,"deviceToken":DataManager.shared.deviceToken]
            if profilePicture.isEmpty == false {
                dictionary["profilePicture"] = profilePicture
            }
            return dictionary
        case .socialLogin(let type,let socialId):
            return ["socialLoginType":type.rawValue,"socialId":socialId,"deviceId":DataManager.shared.deviceId,"deviceToken":DataManager.shared.deviceToken]
        case .verifyEmail(let email,let otp,_):
            return ["email":email,"otp":otp]
        case .getOtpOnEmail(let email):
            return  ["email":email]
        case .signup(let token,let fName,let lName,let password, let imageUrl):
            var dictionary = ["token":token,
                              "firstName": fName,
                              "lastName": lName,
                              "password": password]
            if imageUrl.isEmpty == false {
                dictionary["profilePicture"] = imageUrl
            }
            return dictionary
        case .forgotPassword(let email):
            return ["email":email]
        case .resetPassword(let email,let password):
            return ["email":email,"password":password]
        }
    }
    
    /// http header for each request (if needed)
    var header:HTTPHeaders? {
        let headers = ["platform":"2","timezone":"0","api_key":"1234","language":"en"]
        switch self {
        case .socialRegister,.socialLogin,.login,.getOtpOnEmail,.signup,.forgotPassword,.resetPassword:
            return HTTPHeaders(headers)
        case .verifyEmail:
//            let header = ["platform":"2","timezone":"0","api_key":"1234"]
            return HTTPHeaders(headers)
        
        
        }
    }
}

