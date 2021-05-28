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
    let profileStep : Int?
    let user : User?
    enum CodingKeys: String, CodingKey {

        case profileStep = "profileStep"
        case user = "user"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        profileStep = try values.decodeIfPresent(Int.self, forKey: .profileStep)
        user = try values.decodeIfPresent(User.self, forKey: .user)
    }

}

struct User : Codable {
    let _id : String?
    let isIntroVideoOneSeen : Bool?
    let isIntroVideoTwoSeen : Bool?
    let firstName : String?
    let lastName : String?
    let fullName : String?
    let isFacebookLogin : Bool?
    let isGoogleLogin : Bool?
    let isAppleLogin : Bool?
    let isEmailVerified : Bool?
    let profilePicture : String?
    let isProfileComplete : Bool?
    let userType : String?
    let status : String?
    let salt : String?
    let hash : String?
    let email : String?
    let createdAt : Int?
    let updatedAt : Int?
    let accessToken : String?

    enum CodingKeys: String, CodingKey {

        case _id = "_id"
        case isIntroVideoOneSeen = "isIntroVideoOneSeen"
        case isIntroVideoTwoSeen = "isIntroVideoTwoSeen"
        case firstName = "firstName"
        case lastName = "lastName"
        case fullName = "fullName"
        case isFacebookLogin = "isFacebookLogin"
        case isGoogleLogin = "isGoogleLogin"
        case isAppleLogin = "isAppleLogin"
        case isEmailVerified = "isEmailVerified"
        case profilePicture = "profilePicture"
        case isProfileComplete = "isProfileComplete"
        case userType = "userType"
        case status = "status"
        case salt = "salt"
        case hash = "hash"
        case email = "email"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case accessToken = "accessToken"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        isIntroVideoOneSeen = try values.decodeIfPresent(Bool.self, forKey: .isIntroVideoOneSeen)
        isIntroVideoTwoSeen = try values.decodeIfPresent(Bool.self, forKey: .isIntroVideoTwoSeen)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
        fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
        isFacebookLogin = try values.decodeIfPresent(Bool.self, forKey: .isFacebookLogin)
        isGoogleLogin = try values.decodeIfPresent(Bool.self, forKey: .isGoogleLogin)
        isAppleLogin = try values.decodeIfPresent(Bool.self, forKey: .isAppleLogin)
        isEmailVerified = try values.decodeIfPresent(Bool.self, forKey: .isEmailVerified)
        profilePicture = try values.decodeIfPresent(String.self, forKey: .profilePicture)
        isProfileComplete = try values.decodeIfPresent(Bool.self, forKey: .isProfileComplete)
        userType = try values.decodeIfPresent(String.self, forKey: .userType)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        salt = try values.decodeIfPresent(String.self, forKey: .salt)
        hash = try values.decodeIfPresent(String.self, forKey: .hash)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        createdAt = try values.decodeIfPresent(Int.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(Int.self, forKey: .updatedAt)
        accessToken = try values.decodeIfPresent(String.self, forKey: .accessToken)
    }

}

