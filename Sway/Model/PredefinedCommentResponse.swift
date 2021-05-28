//
//  PredefinedCommentResponse.swift
//  Sway
//
//  Created by Admin on 27/05/21.
//

import Foundation

struct PredefinedCommentsResponse : Codable {
    let statusCode : Int?
    let type : String?
    let comments : CommentsArray?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case statusCode = "statusCode"
        case type = "type"
        case comments = "data"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        comments = try values.decodeIfPresent(CommentsArray.self, forKey: .comments)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}

struct CommentsArray : Codable {
    let comments : [PredefinedComment]?

    enum CodingKeys: String, CodingKey {
        case comments = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        comments = try values.decodeIfPresent([PredefinedComment].self, forKey: .comments)
    }
}

struct PredefinedComment : Codable {
    let id : String?
    let name:String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}



