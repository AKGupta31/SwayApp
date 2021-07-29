//
//  ChallengesResponse.swift
//  Sway
//
//  Created by Admin on 23/06/21.
//



/*
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/
import Foundation
struct GetChallengesResponse : Codable {
    let statusCode : Int?
    let type : String?
    let data : ChallengeData?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case statusCode = "statusCode"
        case type = "type"
        case data = "data"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        data = try values.decodeIfPresent(ChallengeData.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}


struct ChallengeData : Codable {
    let challenges : [ChallengeModel]?
    let total : Int?
    let page : Int?
    let total_page : Int?
    let next_hit : Int?
    let limit : Int?

    enum CodingKeys: String, CodingKey {

        case challenges = "data"
        case total = "total"
        case page = "page"
        case total_page = "total_page"
        case next_hit = "next_hit"
        case limit = "limit"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        challenges = try values.decodeIfPresent([ChallengeModel].self, forKey: .challenges)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
        page = try values.decodeIfPresent(Int.self, forKey: .page)
        total_page = try values.decodeIfPresent(Int.self, forKey: .total_page)
        next_hit = try values.decodeIfPresent(Int.self, forKey: .next_hit)
        limit = try values.decodeIfPresent(Int.self, forKey: .limit)
    }

}

struct ChallengeModel : Codable {
    let _id : String?
    let status : String?
    let totalUsersCount : Int?
    let activeUsersCount : Int?
    let defaultBool : Bool?
    let title : String?
    let description : String?
    let video : ChallengeVideo?
    let coverPicture : CoverPicture?
    let numberOfWeeks : Int?
    let weeklyWorkoutCount : Int?
    let createdAt : Int?
    let updatedAt : Int?
    let workoutDetails : [WorkoutDetails]?
    let average:Int?
    var workOutTypes:[String]?
    var intensityLevel:String?

    enum CodingKeys: String, CodingKey {

        case _id = "_id"
        case status = "status"
        case totalUsersCount = "totalUsersCount"
        case activeUsersCount = "activeUsersCount"
        case defaultBool = "default"
        case title = "title"
        case description = "description"
        case video = "video"
        case coverPicture = "coverPicture"
        case numberOfWeeks = "numberOfWeeks"
        case weeklyWorkoutCount = "weeklyWorkoutCount"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case workoutDetails = "workoutDetails"
        case average = "average"
        case workOutTypes = "workOutTypes"
        case intensityLevel = "intensityLevel"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        totalUsersCount = try values.decodeIfPresent(Int.self, forKey: .totalUsersCount)
        activeUsersCount = try values.decodeIfPresent(Int.self, forKey: .activeUsersCount)
        defaultBool = try values.decodeIfPresent(Bool.self, forKey: .defaultBool)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        video = try values.decodeIfPresent(ChallengeVideo.self, forKey: .video)
        coverPicture = try values.decodeIfPresent(CoverPicture.self, forKey: .coverPicture)
        numberOfWeeks = try values.decodeIfPresent(Int.self, forKey: .numberOfWeeks)
        weeklyWorkoutCount = try values.decodeIfPresent(Int.self, forKey: .weeklyWorkoutCount)
        createdAt = try values.decodeIfPresent(Int.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(Int.self, forKey: .updatedAt)
        workoutDetails = try values.decodeIfPresent([WorkoutDetails].self, forKey: .workoutDetails)
        average = try values.decodeIfPresent(Int.self, forKey: .average)
        do {
            workOutTypes = try values.decodeIfPresent([String].self, forKey: .workOutTypes)
            intensityLevel = try values.decodeIfPresent(String.self, forKey: .intensityLevel)
        }catch {
            print("erroor ",error.localizedDescription)
        }
       
        
    }

}

struct CoverPicture : Codable {
    let url : String?
    let thumbnailImage : String?
    let type : Int?

    enum CodingKeys: String, CodingKey {

        case url = "url"
        case thumbnailImage = "thumbnailImage"
        case type = "type"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        thumbnailImage = try values.decodeIfPresent(String.self, forKey: .thumbnailImage)
        type = try values.decodeIfPresent(Int.self, forKey: .type)
    }

}


struct ChallengeVideo : Codable {
    let url : String?
    let thumbnailImage : String?
    let type : Int?

    enum CodingKeys: String, CodingKey {

        case url = "url"
        case thumbnailImage = "thumbnailImage"
        case type = "type"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        thumbnailImage = try values.decodeIfPresent(String.self, forKey: .thumbnailImage)
        type = try values.decodeIfPresent(Int.self, forKey: .type)
    }

}

struct WorkoutDetails : Codable {
    let week : Int?
    let workouts : [Workout]?

    enum CodingKeys: String, CodingKey {

        case week = "week"
        case workouts = "workouts"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        week = try values.decodeIfPresent(Int.self, forKey: .week)
        workouts = try values.decodeIfPresent([Workout].self, forKey: .workouts)
    }

}

struct Workout : Codable {
    let workoutId : String?
    let status : String?
    let name : String?
    let duration : Int?
    let imageUrl : String?

    enum CodingKeys: String, CodingKey {

        case workoutId = "workoutId"
        case status = "status"
        case name = "name"
        case duration = "duration"
        case imageUrl = "imageUrl"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        workoutId = try values.decodeIfPresent(String.self, forKey: .workoutId)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        duration = try values.decodeIfPresent(Int.self, forKey: .duration)
        imageUrl = try values.decodeIfPresent(String.self, forKey: .imageUrl)
    }

}

struct ChallengeDetailResponse : Codable {
    let statusCode : Int?
    let type : String?
    let data : ChallengeModel?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case statusCode = "statusCode"
        case type = "type"
        case data = "data"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        data = try values.decodeIfPresent(ChallengeModel.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}
