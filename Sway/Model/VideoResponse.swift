//
//  VideoResponse.swift
//  Sway
//
//  Created by Admin on 17/05/21.
//

import Foundation
struct VideoResponse : Codable {
    let statusCode : Int?
    let type : String?
    let message : String?
    let data : VideoData?

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
        data = try values.decodeIfPresent(VideoData.self, forKey: .data)
    }

}


struct VideoData : Codable {
    let status : String?
    let _id : String?
    let title : String?
    let description : String?
    let videoFor : Int?
    let media : Media?
    let createdAt : Int?
    let updatedAt : Int?
    let isShown : Bool?
    let url : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case _id = "_id"
        case title = "title"
        case description = "description"
        case videoFor = "videoFor"
        case media = "media"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case isShown = "isShown"
        case url = "url"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        videoFor = try values.decodeIfPresent(Int.self, forKey: .videoFor)
        media = try values.decodeIfPresent(Media.self, forKey: .media)
        createdAt = try values.decodeIfPresent(Int.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(Int.self, forKey: .updatedAt)
        isShown = try values.decodeIfPresent(Bool.self, forKey: .isShown)
        url = try values.decodeIfPresent(String.self, forKey: .url)
    }

}

struct Media : Codable {
    let url : String?
    let type : Int?
    let thumbnailImage : String?

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
