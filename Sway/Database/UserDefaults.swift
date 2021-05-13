//
//  UserDefaults.swift
//  Sway
//
//  Created by Admin on 06/05/21.
//

import Foundation

class SwayUserDefaults {
    
    
   static let shared = SwayUserDefaults()
    private init(){}
    
    struct Keys{
        static let kLoggedInUser = "LoggedInUser"
    }
    
    var loggedInUser:LoginResponseData? {
        set {
            
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: Keys.kLoggedInUser)
            }
        }
        get {
            if let savedPerson = UserDefaults.standard.object(forKey: Keys.kLoggedInUser) as? Data {
                let decoder = JSONDecoder()
                if let loadedPerson = try? decoder.decode(LoginResponseData.self, from: savedPerson) {
                    return loadedPerson
                }
            }
            return nil
        }
    }

    
}
