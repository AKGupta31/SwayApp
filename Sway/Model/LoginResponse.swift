//
//  LoginResponse.swift
//  Sway
//
//  Created by Admin on 27/04/21.
//


import Foundation
struct LoginResponse : Codable {
    let statusCode : Int?
    let type : String?
    let message : String?
    let data : LoginResponseData?

    enum CodingKeys: String, CodingKey {

        case statusCode = "statusCode"
        case type = "type"
        case message = "message"
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
        type = try values.decodeIfPresent(String.self, forKey: .type)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(LoginResponseData.self, forKey: .data)
    }

}

struct LoginResponseData : Codable {
    let email : String?
    let isEmailVerified : Bool?
    let _id : String?
    let accessToken:String?
    let firstName: String?
    let lastName:String?
    let userType: String?
  

    enum CodingKeys: String, CodingKey {

        case email = "email"
        case isEmailVerified = "isEmailVerified"
        case _id = "_id"
        case accessToken = "accessToken"
        case firstName = "firstName"
        case lastName = "lastName"
        case userType = "userType"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        isEmailVerified = try values.decodeIfPresent(Bool.self, forKey: .isEmailVerified)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        accessToken = try values.decodeIfPresent(String.self, forKey: .accessToken)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
        userType = try values.decodeIfPresent(String.self, forKey: .userType)
    }

}
