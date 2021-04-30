//
//  Constants.swift
//  Sway
//
//  Created by Admin on 12/04/21.
//

import Foundation

typealias Params = [String:Any]

class Constants {
    
    
    struct Networking {
        static let kBaseUrl = "http://swaydevapi.appskeeper.in/api"
    }
    
    struct Notifications {
        static var hideLoader: Notification.Name {
            return Notification.Name("hideLoader")
        }
        
    }
    
}
