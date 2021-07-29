//
//  WorkoutDetailsResponse.swift
//  Sway
//
//  Created by Admin on 28/06/21.
//




import Foundation
//struct WorkoutDetailsResponse : Codable {
//    let statusCode : Int?
//    let type : String?
//    let message : String?
//    let data : WorkoutResponseData?
//
//    enum CodingKeys: String, CodingKey {
//
//        case statusCode = "statusCode"
//        case type = "type"
//        case message = "message"
//        case data = "data"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode)
//        type = try values.decodeIfPresent(String.self, forKey: .type)
//        message = try values.decodeIfPresent(String.self, forKey: .message)
//        data = try values.decodeIfPresent(WorkoutResponseData.self, forKey: .data)
//    }
//
//}


//struct WorkoutResponseData : Codable {
//    let _id : String?
//    let status : String?
//    let name : String?
//    let intensityLevel : String?
//    let workOutType : String?
//    let description : String?
//    let contents : [Content]?
//    let imageUrl : String?
//    let spaceRecommendation : String?
//    let equipmentRequired:Bool?
//
//    enum CodingKeys: String, CodingKey {
//
//        case _id = "_id"
//        case status = "status"
//        case name = "name"
//        case intensityLevel = "intensityLevel"
//        case workOutType = "workOutType"
//        case description = "description"
//        case contents = "content"
//        case imageUrl = "imageUrl"
//        case spaceRecommendation = "spaceRecommendation"
//        case equipmentRequired = "equipmentRequired"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        _id = try values.decodeIfPresent(String.self, forKey: ._id)
//        status = try values.decodeIfPresent(String.self, forKey: .status)
//        name = try values.decodeIfPresent(String.self, forKey: .name)
//        intensityLevel = try values.decodeIfPresent(String.self, forKey: .intensityLevel)
//        workOutType = try values.decodeIfPresent(String.self, forKey: .workOutType)
//        description = try values.decodeIfPresent(String.self, forKey: .description)
//        contents = try values.decodeIfPresent([Content].self, forKey: .contents)
//        imageUrl = try values.decodeIfPresent(String.self, forKey: .imageUrl)
//        spaceRecommendation = try values.decodeIfPresent(String.self, forKey: .spaceRecommendation)
//        equipmentRequired = try values.decodeIfPresent(Bool.self, forKey: .equipmentRequired)
//    }
//
//}


//struct Content : Codable {
//    let _id : String?
//    let name : String?
//    let description : String?
//    let movement : [Movement]?
//    let totalCount : Int?
//    let toalHistoryCount : Int?
//    let isSeen : Bool?
//    let equipmentRequired:Bool?
//    let intensityLevel : String?
//
//    enum CodingKeys: String, CodingKey {
//
//        case _id = "_id"
//        case name = "name"
//        case description = "description"
//        case movement = "movement"
//        case totalCount = "totalCount"
//        case toalHistoryCount = "toalHistoryCount"
//        case isSeen = "isSeen"
//        case equipmentRequired = "equipmentRequired"
//        case intensityLevel = "intensityLevel"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        _id = try values.decodeIfPresent(String.self, forKey: ._id)
//        name = try values.decodeIfPresent(String.self, forKey: .name)
//        description = try values.decodeIfPresent(String.self, forKey: .description)
//        movement = try values.decodeIfPresent([Movement].self, forKey: .movement)
//        totalCount = try values.decodeIfPresent(Int.self, forKey: .totalCount)
//        toalHistoryCount = try values.decodeIfPresent(Int.self, forKey: .toalHistoryCount)
//        isSeen = try values.decodeIfPresent(Bool.self, forKey: .isSeen)
//        equipmentRequired = try values.decodeIfPresent(Bool.self, forKey: .equipmentRequired)
//        intensityLevel = try values.decodeIfPresent(String.self, forKey: .intensityLevel)
//    }
//
//}


//struct Movement : Codable {
//    let exerciseFor : [String]?
//    let _id : String?
//    let name : String?
//    let repetationDuration : RepetationDuration?
//    let description : String?
//    let media : WorkoutMedia?
//    let equipmentRequired : Bool?
//    let intensityLevel : String?
//
//    enum CodingKeys: String, CodingKey {
//
//        case exerciseFor = "exerciseFor"
//        case _id = "_id"
//        case name = "name"
//        case repetationDuration = "repetationDuration"
//        case description = "description"
//        case media = "media"
//        case equipmentRequired = "equipmentRequired"
//        case intensityLevel = "intensityLevel"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        exerciseFor = try values.decodeIfPresent([String].self, forKey: .exerciseFor)
//        _id = try values.decodeIfPresent(String.self, forKey: ._id)
//        name = try values.decodeIfPresent(String.self, forKey: .name)
//        repetationDuration = try values.decodeIfPresent(RepetationDuration.self, forKey: .repetationDuration)
//        description = try values.decodeIfPresent(String.self, forKey: .description)
//        media = try values.decodeIfPresent(WorkoutMedia.self, forKey: .media)
//        equipmentRequired = try values.decodeIfPresent(Bool.self, forKey: .equipmentRequired)
//        intensityLevel = try values.decodeIfPresent(String.self, forKey: .intensityLevel)
//    }
//
//}

//struct RepetationDuration : Codable {
//    let type : Int?
//    let count : Int?
//
//    enum CodingKeys: String, CodingKey {
//
//        case type = "type"
//        case count = "count"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        type = try values.decodeIfPresent(Int.self, forKey: .type)
//        count = try values.decodeIfPresent(Int.self, forKey: .count)
//    }
//
//}


struct WorkoutMedia : Codable {
    let imageUrl : String?
    let mainVideoUrl : String?
    let instructorVideoUrl : String?

    enum CodingKeys: String, CodingKey {

        case imageUrl = "imageUrl"
        case mainVideoUrl = "mainVideoUrl"
        case instructorVideoUrl = "instructorVideoUrl"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        imageUrl = try values.decodeIfPresent(String.self, forKey: .imageUrl)
        mainVideoUrl = try values.decodeIfPresent(String.self, forKey: .mainVideoUrl)
        instructorVideoUrl = try values.decodeIfPresent(String.self, forKey: .instructorVideoUrl)
    }

}




struct WorkoutDetailsResponse : Codable {
    let statusCode : Int?
    let type : String?
    let message : String?
    let data : WorkoutResponseData?

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
        data = try values.decodeIfPresent(WorkoutResponseData.self, forKey: .data)
    }

}


struct WorkoutResponseData : Codable {
    let _id : String?
    let status : String?
    let name : String?
    let intensityLevel : String?
    let workOutType : String?
    let difficultyLevel:String?
    let description : String?
    var contents : [Content]?
    let imageUrl : ImageUrl?
    let equipmentRequired : Bool
    let spaceRecommendation : String?

    enum CodingKeys: String, CodingKey {

        case _id = "_id"
        case status = "status"
        case name = "name"
        case intensityLevel = "intensityLevel"
        case workOutType = "workOutType"
        case difficultyLevel = "difficultyLevel"
        case description = "description"
        case contents = "content"
        case imageUrl = "imageUrl"
        case equipmentRequired = "equipmentRequired"
        case spaceRecommendation = "spaceRecommendation"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        intensityLevel = try values.decodeIfPresent(String.self, forKey: .intensityLevel)
        workOutType = try values.decodeIfPresent(String.self, forKey: .workOutType)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        contents = try values.decodeIfPresent([Content].self, forKey: .contents)
        imageUrl = try values.decodeIfPresent(ImageUrl.self, forKey: .imageUrl)
        equipmentRequired = try values.decodeIfPresent(Bool.self, forKey: .equipmentRequired) ?? false
        spaceRecommendation = try values.decodeIfPresent(String.self, forKey: .spaceRecommendation)
        difficultyLevel = try values.decodeIfPresent(String.self, forKey: .difficultyLevel)
    }

}

struct ImageUrl : Codable {
    let url : String?
    let type : Int?

    enum CodingKeys: String, CodingKey {

        case url = "url"
        case type = "type"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        type = try values.decodeIfPresent(Int.self, forKey: .type)
    }

}


struct Content : Codable {
    let id:String?
    let name : String?
    let description : String?
    let movement : [Movement]?
    let totalCount : Int?
    let toalHistoryCount : Int?
    var isSeen : Bool = false
    let equipmentRequired:Bool
    let intensityLevel : String?
    let duration:Int?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case description = "description"
        case movement = "movement"
        case totalCount = "totalCount"
        case toalHistoryCount = "toalHistoryCount"
        case isSeen = "isSeen"
        case equipmentRequired = "equipmentRequired"
        case intensityLevel = "intensityLevel"
        case id = "_id"
        case duration = "duration"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        movement = try values.decodeIfPresent([Movement].self, forKey: .movement)
        totalCount = try values.decodeIfPresent(Int.self, forKey: .totalCount)
        toalHistoryCount = try values.decodeIfPresent(Int.self, forKey: .toalHistoryCount)
        isSeen = try values.decodeIfPresent(Bool.self, forKey: .isSeen) ?? false
        equipmentRequired = try values.decodeIfPresent(Bool.self, forKey: .equipmentRequired) ?? false
        intensityLevel = try values.decodeIfPresent(String.self, forKey: .intensityLevel)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        duration = try values.decodeIfPresent(Int.self, forKey: .duration)
    }

}


struct Movement : Codable {
    let exerciseFor : [String]?
    let name : String?
    let repetationDuration : RepetationDuration?
    let media : WorkoutMedia?
    let description:String?
    let movementCategory:Int?

    enum CodingKeys: String, CodingKey {

        case exerciseFor = "exerciseFor"
        case name = "name"
        case repetationDuration = "repetationDuration"
        case media = "media"
        case description = "description"
        case movementCategory = "movementCategory"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        exerciseFor = try values.decodeIfPresent([String].self, forKey: .exerciseFor)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        repetationDuration = try values.decodeIfPresent(RepetationDuration.self, forKey: .repetationDuration)
        media = try values.decodeIfPresent(WorkoutMedia.self, forKey: .media)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        movementCategory = try values.decodeIfPresent(Int.self, forKey: .movementCategory)
    }

}

struct RepetationDuration : Codable {
    let count : Int?
    let type : Int?
    let duration:Int?

    enum CodingKeys: String, CodingKey {

        case count = "count"
        case type = "type"
        case duration = "duration"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        count = try values.decodeIfPresent(Int.self, forKey: .count)
        type = try values.decodeIfPresent(Int.self, forKey: .type)
        duration = try values.decodeIfPresent(Int.self, forKey: .duration)
    }

}
