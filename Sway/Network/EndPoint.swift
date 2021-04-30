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
    case verifyEmail(email:String,otp:String)
    
    
    /// GET, POST or PUT method for each request
    var method:Alamofire.HTTPMethod {
        switch self {
        case .login,.socialRegister,.socialLogin:
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
        case .verifyEmail:
            return Constants.Networking.kBaseUrl + interMediate + "verify-email"
        }
    }
    
    /// parameters Dictionary for each request
    var parameters:[String:Any] {
        switch self {
        case .login(let email,let password):
            return ["email":email,"password":password,"deviceId":DataManager.shared.deviceId,"deviceToken":DataManager.shared.deviceToken]
        case .socialRegister(let socialId,let email,let firstName, let lastName,let type,let profilePicture):
            return ["socialLoginType":type.rawValue,"socialId":socialId,"email":email,"firstName":firstName,"lastName":lastName,"profilePicture":profilePicture,"deviceId":DataManager.shared.deviceId,"deviceToken":DataManager.shared.deviceToken]
        case .socialLogin(let type,let socialId):
            return ["socialLoginType":type.rawValue,"socialId":socialId,"deviceId":DataManager.shared.deviceId,"deviceToken":DataManager.shared.deviceToken]
        case .verifyEmail(let email,let otp):
            return ["email":email,"otp":otp,"deviceId":DataManager.shared.deviceId,"deviceToken":DataManager.shared.deviceToken]
        }
    }
    
    /// http header for each request (if needed)
    var header:HTTPHeaders? {
        let headers = ["platform":"2","timezone":"0","api_key":"1234","language":"en"]
        switch self {
        case .socialRegister,.socialLogin,.login:
            return HTTPHeaders(headers)
        case .verifyEmail:
//            let header = ["platform":"2","timezone":"0","api_key":"1234"]
            return HTTPHeaders(headers)
        
        }
    }
}

