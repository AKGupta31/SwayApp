//
//  EmptyDataResponse.swift
//  Sway
//
//  Created by Admin on 04/05/21.
//

import Foundation
struct EmptyDataResponse : Codable {
    let statusCode : Int?
    let message : String?
    let type : String?
   

    enum CodingKeys: String, CodingKey {

        case statusCode = "statusCode"
        case message = "message"
        case type = "type"
    }

    init(statusCode:Int,message:String) {
        self.statusCode = statusCode
        self.message = message
        self.type = nil
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        type = try values.decodeIfPresent(String.self, forKey: .type)
    }

}
