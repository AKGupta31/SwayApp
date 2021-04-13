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
    
    
    /// GET, POST or PUT method for each request
    var method:Alamofire.HTTPMethod {
        switch self {
        case .login:
            return .post
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
        switch self {
        case .login:
            return Constants.Networking.kBaseUrl + "login"
        }
    }
    
    /// parameters Dictionary for each request
    var parameters:[String:Any] {
        switch self {
        case .login(let email,let password):
            return ["email":email,"password":password]
            
        }
    }
    
    /// http header for each request (if needed)
    var header:HTTPHeaders? {
        switch self {
        case .login:
            return nil
        default:
            return ["Authorization":"Bearer "]
        }
    }
}

