//
//  PlannerSchedulesResponse.swift
//  Sway
//
//  Created by Admin on 21/07/21.
//


import Foundation
struct PlannerSchedulesDayWiseResponse : Codable {
    let statusCode : Int?
    let data : DayWiseResponseData?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case statusCode = "statusCode"
        case data = "data"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode)
        data = try values.decodeIfPresent(DayWiseResponseData.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}

struct DayWiseResponseData : Codable {
    let schedules : [PlannerDaywiseModel]?

    enum CodingKeys: String, CodingKey {

        case schedules = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        schedules = try values.decodeIfPresent([PlannerDaywiseModel].self, forKey: .schedules)
    }

}

struct PlannerDaywiseModel : Codable {
    let _id : String?
    let userId : String?
    let startDate : Double?
    let endDate : Double?
    let workoutId : String?
    let startTime : Double?
    let endTime : Double?
    let dayOfTheWeek : Double?
    let type : String?
    let challengeId : String?
    let challengeTitle : String?
    let workoutName : String?
    let intensityLevel : String?
    let workOutType : String?

    enum CodingKeys: String, CodingKey {

        case _id = "_id"
        case userId = "userId"
        case startDate = "startDate"
        case endDate = "endDate"
        case workoutId = "workoutId"
        case startTime = "startTime"
        case endTime = "endTime"
        case dayOfTheWeek = "dayOfTheWeek"
        case type = "type"
        case challengeId = "challengeId"
        case challengeTitle = "challengeTitle"
        case workoutName = "workoutName"
        case intensityLevel = "intensityLevel"
        case workOutType = "workOutType"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
        startDate = try values.decodeIfPresent(Double.self, forKey: .startDate)
        endDate = try values.decodeIfPresent(Double.self, forKey: .endDate)
        workoutId = try values.decodeIfPresent(String.self, forKey: .workoutId)
        startTime = try values.decodeIfPresent(Double.self, forKey: .startTime)
        endTime = try values.decodeIfPresent(Double.self, forKey: .endTime)
        dayOfTheWeek = try values.decodeIfPresent(Double.self, forKey: .dayOfTheWeek)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        challengeId = try values.decodeIfPresent(String.self, forKey: .challengeId)
        challengeTitle = try values.decodeIfPresent(String.self, forKey: .challengeTitle)
        workoutName = try values.decodeIfPresent(String.self, forKey: .workoutName)
        intensityLevel = try values.decodeIfPresent(String.self, forKey: .intensityLevel)
        workOutType = try values.decodeIfPresent(String.self, forKey: .workOutType)
    }

}
