//
//  FeedModel.swift
//  Sway
//
//  Created by Admin on 21/05/21.
//




import Foundation
struct FeedsResponse : Codable {
    let statusCode : Int?
    let type : String?
    var message : String = "Unknown error"
    let data : FeedData?

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
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? "Unknown error"
        data = try values.decodeIfPresent(FeedData.self, forKey: .data)
    }

}

struct FeedData : Codable {
    let feeds : [FeedModel]?
    let total : Int?
    let pageNo : Int?
    let totalPage : Int?
    let nextHit : Int?
    let limit : Int?

    enum CodingKeys: String, CodingKey {

        case feeds = "data"
        case total = "total"
        case pageNo = "pageNo"
        case totalPage = "totalPage"
        case nextHit = "nextHit"
        case limit = "limit"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        feeds = try values.decodeIfPresent([FeedModel].self, forKey: .feeds)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
        pageNo = try values.decodeIfPresent(Int.self, forKey: .pageNo)
        totalPage = try values.decodeIfPresent(Int.self, forKey: .totalPage)
        nextHit = try values.decodeIfPresent(Int.self, forKey: .nextHit)
        limit = try values.decodeIfPresent(Int.self, forKey: .limit)
    }

}


struct FeedModel : Codable {
    let _id : String?
    var likeCount : Int = 0
    let commentCount : Int?
    let adminApproved : Int?
    let isAdmin : Bool?
    let userId : String?
    let caption : String?
    let feedType : String?
    let title : String?
    let media : FeedMedia?
    var isLike : Bool = false
    var user:UserModel?

    enum CodingKeys: String, CodingKey {

        case _id = "_id"
        case likeCount = "likeCount"
        case commentCount = "commentCount"
        case adminApproved = "adminApproved"
        case isAdmin = "isAdmin"
        case userId = "userId"
        case caption = "caption"
        case feedType = "feedType"
        case title = "title"
        case media = "media"
        case isLike = "isLike"
        case user = "userData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        likeCount = try values.decodeIfPresent(Int.self, forKey: .likeCount) ?? 0
        commentCount = try values.decodeIfPresent(Int.self, forKey: .commentCount)
        adminApproved = try values.decodeIfPresent(Int.self, forKey: .adminApproved)
        isAdmin = try values.decodeIfPresent(Bool.self, forKey: .isAdmin)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
        caption = try values.decodeIfPresent(String.self, forKey: .caption)
        feedType = try values.decodeIfPresent(String.self, forKey: .feedType)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        media = try values.decodeIfPresent(FeedMedia.self, forKey: .media)
        isLike = try values.decodeIfPresent(Bool.self, forKey: .isLike) ?? false
        user = try values.decodeIfPresent(UserModel.self, forKey: .user)
    }

}


struct FeedMedia : Codable {
    let url : String?
    let type : Int?
    let thumbnailImage:String?

    enum CodingKeys: String, CodingKey {
        case url = "url"
        case type = "type"
        case thumbnailImage = "thumbnailImage"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        type = try values.decodeIfPresent(Int.self, forKey: .type)
        thumbnailImage = try values.decodeIfPresent(String.self, forKey: .thumbnailImage)
    }

}
