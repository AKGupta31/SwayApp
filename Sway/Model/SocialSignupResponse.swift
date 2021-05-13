//
//  SocialSignupResponse.swift
//  Sway
//
//  Created by Admin on 19/04/21.
//



import Foundation
struct SocialSignupResponse : Codable {
    let statusCode : Int?
    let message : String?
    let type : String?
    let data : LoginResponseData?

    enum CodingKeys: String, CodingKey {

        case statusCode = "statusCode"
        case message = "message"
        case type = "type"
        case data = "data"
    }

    init(statusCode:Int,message:String) {
        self.statusCode = statusCode
        self.message = message
        self.type = nil
        self.data = nil
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        data = try values.decodeIfPresent(LoginResponseData.self, forKey: .data)
    }

}

struct SignupModel : Codable {
    let userId : String?
    let firstName : String?
    let lastName : String?
    let email : String?
    let userType : String?
    let accessToken : String?

    enum CodingKeys: String, CodingKey {

        case userId = "userId"
        case firstName = "firstName"
        case lastName = "lastName"
        case email = "email"
        case userType = "userType"
        case accessToken = "accessToken"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        userType = try values.decodeIfPresent(String.self, forKey: .userType)
        accessToken = try values.decodeIfPresent(String.self, forKey: .accessToken)
    }

}
