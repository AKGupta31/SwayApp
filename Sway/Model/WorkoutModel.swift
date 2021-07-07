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
    var rowTag = 0
    var workoutId:String?
    var dummyDisplayName = ""
    
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
