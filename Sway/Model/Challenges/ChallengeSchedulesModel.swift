//
//  ChallengeSchedulesModel.swift
//  Sway
//
//  Created by Admin on 25/06/21.
//

import Foundation

public class ChallengeSchedulesModel {
    public var challengeId : String?
    public var startDate : Int? // time in miliseconds from now
    public var endDate : Int? // time in miliseconds from now
    public var schedules : [Schedules]?
    
    
    init(challengeId:String,startDate:Int,endDate:Int,schedules:[Schedules]) {
        self.challengeId = challengeId
        self.startDate = startDate
        self.endDate = endDate
        self.schedules = schedules
    }

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [ChallengeSchedulesModel]
    {
        var models:[ChallengeSchedulesModel] = []
        for item in array
        {
            models.append(ChallengeSchedulesModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let json4Swift_Base = Json4Swift_Base(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Json4Swift_Base Instance.
*/
    required public init?(dictionary: NSDictionary) {

        challengeId = dictionary["challengeId"] as? String
        startDate = dictionary["startDate"] as? Int
        endDate = dictionary["endDate"] as? Int
        if (dictionary["schedules"] != nil) { schedules = Schedules.modelsFromDictionaryArray(array: dictionary["schedules"] as! NSArray) }
    }

        
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.challengeId, forKey: "challengeId")
        dictionary.setValue(self.startDate, forKey: "startDate")
        dictionary.setValue(self.endDate, forKey: "endDate")

        return dictionary
    }

}

public class Schedules {
    public var workoutId : String?
    public var startTime : Int?
    public var endTime : Int?
    public var dayOfTheWeek:Int?
    
/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let schedules_list = Schedules.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Schedules Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Schedules]
    {
        var models:[Schedules] = []
        for item in array
        {
            models.append(Schedules(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let schedules = Schedules(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Schedules Instance.
*/
    required public init?(dictionary: NSDictionary) {

        workoutId = dictionary["workoutId"] as? String
        startTime = dictionary["startTime"] as? Int
        endTime = dictionary["endTime"] as? Int
    }
    
        
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
    public func toDict() -> [String:Any] {

        var dictionary = [String:Any]()
        dictionary["workoutId"] = self.workoutId
        dictionary["startTime"] = self.startTime
        dictionary["endTime"] = self.endTime

        return dictionary
    }
    
    public func toParams() -> [String:Any] {

        var dictionary = [String:Any]()
        dictionary["workoutId"] = self.workoutId
        dictionary["startTime"] = (self.startTime ?? 0) * 60
        dictionary["endTime"] = (self.endTime ?? 0) * 60

        return dictionary
    }

}
