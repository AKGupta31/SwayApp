//
//  CommentsResponse.swift
//  Sway
//
//  Created by Admin on 27/05/21.
//

import Foundation
struct CommentsResponse : Codable {
    let statusCode : Int?
    let type : String?
    let message : String?
    let commentData : CommentData?

    enum CodingKeys: String, CodingKey {

        case statusCode = "statusCode"
        case type = "type"
        case message = "message"
        case commentData = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        commentData = try values.decodeIfPresent(CommentData.self, forKey: .commentData)
    }

}


struct CommentData : Codable {
    let comments : [CommentModel]?
    let total : Int?
    let pageNo : Int?
    let totalPage : Int?
    let nextHit : Int?
    let limit : Int?

    enum CodingKeys: String, CodingKey {

        case comments = "data"
        case total = "total"
        case pageNo = "pageNo"
        case totalPage = "totalPage"
        case nextHit = "nextHit"
        case limit = "limit"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        comments = try values.decodeIfPresent([CommentModel].self, forKey: .comments)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
        pageNo = try values.decodeIfPresent(Int.self, forKey: .pageNo)
        totalPage = try values.decodeIfPresent(Int.self, forKey: .totalPage)
        nextHit = try values.decodeIfPresent(Int.self, forKey: .nextHit)
        limit = try values.decodeIfPresent(Int.self, forKey: .limit)
    }

}


struct CommentModel: Codable {
    let _id : String?
    let status : String?
    let comment : String?
    let postId : String?
    let userData : UserModel?
    let createdAt : String?
    let updatedAt : String?

    enum CodingKeys: String, CodingKey {

        case _id = "_id"
        case status = "status"
        case comment = "comment"
        case postId = "postId"
        case userData = "userData"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        comment = try values.decodeIfPresent(String.self, forKey: .comment)
        postId = try values.decodeIfPresent(String.self, forKey: .postId)
        userData = try values.decodeIfPresent(UserModel.self, forKey: .userData)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }

}


struct UserModel : Codable {
    let userId : String?
    let profilePicture : String?
    let name : String?
    let firstName : String?
    let lastName : String?

    enum CodingKeys: String, CodingKey {

        case userId = "userId"
        case profilePicture = "profilePicture"
        case name = "name"
        case firstName = "firstName"
        case lastName = "lastName"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
        profilePicture = try values.decodeIfPresent(String.self, forKey: .profilePicture)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
    }

}

struct PostCommentResponse : Codable {
    let statusCode : Int?
    let type : String?
    let message : String?
    let comment:CommentModel?
    
    enum CodingKeys: String, CodingKey {

        case statusCode = "statusCode"
        case type = "type"
        case message = "message"
        case comment = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        comment = try values.decodeIfPresent(CommentModel.self, forKey: .comment)
    }
    
}
