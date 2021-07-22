//
//  FiltersResponse.swift
//  Sway
//
//  Created by Admin on 13/07/21.
//

import Foundation

import Foundation
struct FiltersResponse : Codable {
    var statusCode : Int = 400
    var type : String?
    var message : String?
    var data : FiltersResponseData?

    enum CodingKeys: String, CodingKey {

        case statusCode = "statusCode"
        case type = "type"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode) ?? 400
            type = try values.decodeIfPresent(String.self, forKey: .type)
            message = try values.decodeIfPresent(String.self, forKey: .message)
            data = try values.decodeIfPresent(FiltersResponseData.self, forKey: .data)
        }catch {
            print("error",error)
        }
       
    }

}

struct FiltersResponseData : Codable {
    let filters : [FilterModel]?

    enum CodingKeys: String, CodingKey {
        case filters = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        filters = try values.decodeIfPresent([FilterModel].self, forKey: .filters)
    }

}

enum FilterType:String {
    case movement = "MOVEMENT_CATEGORY"
    case workoutType = "WORKOUT_TYPE"
}

class FilterModel : Codable {
    let name : String?
    let value : String?
    let type : String?
    var isSelected = false

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case value = "value"
        case type = "type"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        type = try values.decodeIfPresent(String.self, forKey: .type)
    }

    var filterType:FilterType {
        if let typeName = self.type {
            return FilterType(rawValue: typeName) ?? .workoutType
        }
        return .workoutType
    }
    
}

