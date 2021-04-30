//
//  LoginResponse.swift
//  Sway
//
//  Created by Admin on 27/04/21.
//

import Foundation

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

    enum CodingKeys: String, CodingKey {

        case email = "email"
        case isEmailVerified = "isEmailVerified"
        case _id = "_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        isEmailVerified = try values.decodeIfPresent(Bool.self, forKey: .isEmailVerified)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
    }

}
