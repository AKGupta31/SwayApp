//
//  WorkoutModel.swift
//  Sway
//
//  Created by Admin on 16/06/21.
//

import UIKit

final class WorkoutModel: NSObject, NSItemProviderWriting, NSItemProviderReading, Codable {
    var title:String = ""
    var isSelected = false
    var id = 0
    var color:UIColor = .clear
    var workoutId:String?
    var isPreviouslyScheduled = false
    
    var startDate:Date!
    var endDate:Date!
    var dayOfTheWeek = 1
    var startTime:Int = 5
    var endTime:Int = 6

    
    init(title:String) {
        self.title = title
    }
    init(id:Int) {
        self.id = id
    }
    
    init(id: Int,color: UIColor = UIColor.clear) {
        self.id    = id
        self.color = color
    }
    
    func toParams(isUpdate:Bool) -> [String:Any]{
//        let dayOfTheWeekWrtAndroid = self.dayOfTheWeek
        let day = Weekday(rawValue: self.dayOfTheWeek) ?? .monday
        let startOfTheDay = Calendar.current.startOfDay(for: Date())
        let components = DateComponents(hour: 23, minute: 59, second: 59)
        let endOfDay = Calendar.current.date(byAdding: components, to: startOfTheDay)!
        var params :[String:Any] = [
            "startDate": startOfTheDay.millisecondsSince1970,
            "endDate": endOfDay.millisecondsSince1970,
            "startTime": self.startTime * 60, // in minutes
            "endTime": self.endTime * 60,  //in minutes
            "dayOfTheWeek": day.dayOfTheWeekIntWRTAndroid
            ]
        if isUpdate {
            params["scheduleId"] = self.workoutId ?? "" // in case of edit we have already updated workout id with schedule id
        }else {
            params["workoutId"] = self.workoutId ?? ""
        }
        return params
    }

    
    
    static var writableTypeIdentifiersForItemProvider: [String] {
        //We know that we want to represent our object as a data type, so we'll specify that
        return [("" as String)]
    }
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        let progress = Progress(totalUnitCount: 100)
        do {
            //Here the object is encoded to a JSON data object and sent to the completion handler
            let data = try JSONEncoder().encode(self)
            progress.completedUnitCount = 100
            completionHandler(data, nil)
        } catch {
            completionHandler(nil, error)
        }
        return progress
    }
    static var readableTypeIdentifiersForItemProvider: [String] {
        //We know we want to accept our object as a data representation, so we'll specify that here
        return [("") as String]
    }
    //This function actually has a return type of Self, but that really messes things up when you are trying to return your object, so if you mark your class as final as I've done above, the you can change the return type to return your class type.
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> WorkoutModel {
        let decoder = JSONDecoder()
        do {
            //Here we decode the object back to it's class representation and return it
            let subject = try decoder.decode(WorkoutModel.self, from: data)
            return subject
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    
    init(from decoder: Decoder) throws {
        
    }

    func encode(to encoder: Encoder) throws {
        
    }
    
    
}
