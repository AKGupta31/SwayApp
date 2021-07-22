//
//  UserDefaults.swift
//  Sway
//
//  Created by Admin on 06/05/21.
//

import Foundation

enum OnboardingStatus:Int {
//    case NONE = 500
    case INTRO__VIDEO_ONE = 511
    case INTRO__VIDEO_TWO = 512
    case INTRO__VIDEO_THREE = 513
    case PROFILE_AGE = 514
    case PROFILE_GOAL = 515
    case CHALLENGE_SCREEN = 516
    case HOME_SCREEN = 517
}

class SwayUserDefaults {
    
    
   static let shared = SwayUserDefaults()
    private init(){}
    
    struct Keys{
        static let kLoggedInUser = "LoggedInUser"
        static let kOnBoardingStatus = "OnBoardingStatus"
        static let kPlannerSearchStrings = "PlannerSearchStrings"
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
    
    var onBoardingScreenStatus:OnboardingStatus {
        get {
            let status = UserDefaults.standard.integer(forKey: Keys.kOnBoardingStatus)
            return OnboardingStatus(rawValue:status) ?? .INTRO__VIDEO_ONE
        }set {
            UserDefaults.standard.setValue(newValue.rawValue, forKey: Keys.kOnBoardingStatus)
        }
    }
    
    var searchList:[String] {
        get {
            let searchStrs = UserDefaults.standard.array(forKey: Keys.kPlannerSearchStrings) as? [String]
            return searchStrs ?? [String]()
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Keys.kPlannerSearchStrings)
        }
    }

    
}
