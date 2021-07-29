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
//        static let kBaseUrl = "http://swaystgapi.appskeeper.in/api"
//        static let kBaseUrl = "http://swayqaapi.appskeeper.in/api"
        static let kBaseUrl = "http://swaydevapi.appskeeper.in/api"
    }
    
    struct Notifications {
        static var hideLoader: Notification.Name {
            return Notification.Name("hideLoader")
        }
        
    }
    
    struct S3BucketCredentials{
        static let s3PoolApiKey = "us-east-1:b1f250f2-66a7-4d07-96e9-01817149a439"
        static let s3BucketName = "appinventiv-development"
        static let s3BaseUrl = "https://appinventiv-development.s3.amazonaws.com/"
    }
    
    struct Messages {
        static let kError = "Error!"
        static let kAlert = "Alert"
        static let kUnknownError = "Unknown error"
        static let kNoInternetConnection = "Internet connection appears to be offline"
        static let kSelectVideo = "Video(1 min max)"
        static let kAreYouSureToDeleteThePost = "Are you sure you want to delete the post"
        static let kCantScheduleAtThisTime = "You can't schedule event at this time. Please propose new time"
    }
}

// MARK: - Media Enum
enum MediaTypes : String {
    case kImage  = "public.image"
    case kVideo  = "public.movie"
    
    var intVal:Int {
        switch self {
        case .kImage:
            return 1
        case .kVideo:
            return 2
        }
    }
}

enum S3MediaType: Int {
    case image = 1
    case video = 2
}

enum ViewController:String {
    case StartWorkoutVC = "StartWorkoutVC"
    case HIITDetailsPendingStartVC = "HIITDetailsPendingStartVC"
}


