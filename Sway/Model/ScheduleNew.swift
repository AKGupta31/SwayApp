//
//  ScheduleNew.swift
//  Sway
//
//  Created by Admin on 16/07/21.
//

import Foundation

struct SchedulesResponse : Codable {
    let statusCode : Int?
    let type : String?
    let message : String?
    let data : ScheduleData?

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
        data = try values.decodeIfPresent(ScheduleData.self, forKey: .data)
    }

}

struct ScheduleData : Codable {
    let schedules : [NewScheduleModel]?
    let startDate : Int?
    let endDate : Int?

    enum CodingKeys: String, CodingKey {

        case schedules = "data"
        case startDate = "startDate"
        case endDate = "endDate"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        schedules = try values.decodeIfPresent([NewScheduleModel].self, forKey: .schedules)
        startDate = try values.decodeIfPresent(Int.self, forKey: .startDate)
        endDate = try values.decodeIfPresent(Int.self, forKey: .endDate)
    }

}

struct NewScheduleModel : Codable {
    var challengeId : String?
    var challengeTitle : String?
    var endDate : Double?
    var endTime : Double?
    var _id : String?
    var startDate : Double?
    var startTime : Double?
    private var type : String?
    var userId : String?
    var workoutId : String?
    var workoutName : String?
    private var dayOfTheWeek:Int?
    var userWorkoutId:String?

    enum CodingKeys: String, CodingKey {

        case challengeId = "challengeId"
        case challengeTitle = "challengeTitle"
        case endDate = "endDate"
        case endTime = "endTime"
        case _id = "_id"
        case startDate = "startDate"
        case startTime = "startTime"
        case type = "type"
        case userId = "userId"
        case workoutId = "workoutId"
        case workoutName = "workoutName"
        case dayOfTheWeek = "dayOfTheWeek"
        case userWorkoutId = "userWorkoutId"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            challengeId = try values.decodeIfPresent(String.self, forKey: .challengeId)
            challengeTitle = try values.decodeIfPresent(String.self, forKey: .challengeTitle)
            endDate = try values.decodeIfPresent(Double.self, forKey: .endDate)
            endTime = try values.decodeIfPresent(Double.self, forKey: .endTime)
            _id = try values.decodeIfPresent(String.self, forKey: ._id)
            startDate = try values.decodeIfPresent(Double.self, forKey: .startDate)
            startTime = try values.decodeIfPresent(Double.self, forKey: .startTime)
            type = try values.decodeIfPresent(String.self, forKey: .type)
            userId = try values.decodeIfPresent(String.self, forKey: .userId)
            workoutId = try values.decodeIfPresent(String.self, forKey: .workoutId)
            workoutName = try values.decodeIfPresent(String.self, forKey: .workoutName)
            dayOfTheWeek = try values.decodeIfPresent(Int.self, forKey: .dayOfTheWeek)
            userWorkoutId = try values.decodeIfPresent(String.self, forKey: .userWorkoutId)
        }catch {
            print("error",error.localizedDescription)
        }
    }
    
    public func toParamsForChallengeSchedule() -> [String:Any] {
        var dictionary = [String:Any]()
        dictionary["workoutId"] = self.workoutId
        dictionary["startTime"] = (self.startTime ?? 0) * 60
        dictionary["endTime"] = (self.endTime ?? 0) * 60
        dictionary["dayOfTheWeek"] = (self.dayOfTheWeek ?? 1)
        return dictionary
    }
    
    var dayOfWeek:Int {
        return Weekday.getWeekDay(dayFromServer: dayOfTheWeek ?? 1).rawValue
    }
    
    var category:WorkoutCategory {
        if let type = self.type {
            return WorkoutCategory(rawValue: type) ?? .library
        }
        return .library
    }
    
}
