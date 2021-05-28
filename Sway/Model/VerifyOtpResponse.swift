//
//  VerifyOtpResponse.swift
//  Sway
//
//  Created by Admin on 06/05/21.
//


import Foundation
struct VerifyOtpResponse : Codable {
    let statusCode : Int?
    let type : String?
    let message : String?
    let data : VerifyOtpData?

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
        data = try values.decodeIfPresent(VerifyOtpData.self, forKey: .data)
    }

}

struct VerifyOtpData : Codable {
    let email : String?
    let token : String?

    enum CodingKeys: String, CodingKey {
        case email = "email"
        case token = "token"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        token = try values.decodeIfPresent(String.self, forKey: .token)
    }

}
