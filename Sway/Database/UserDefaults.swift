//
//  UserDefaults.swift
//  Sway
//
//  Created by Admin on 06/05/21.
//

import Foundation

enum OnboardingStatus:Int {
    case NONE = 500
    case INTRO__VIDEO_ONE = 511
    case INTRO__VIDEO_TWO = 512
    case INTRO__VIDEO_THREE = 513
    case PROFILE_AGE = 514
    case PROFILE_GOAL = 515
    case CHALLENGE_SCREEN = 516
}

class SwayUserDefaults {
    
    
   static let shared = SwayUserDefaults()
    private init(){}
    
    struct Keys{
        static let kLoggedInUser = "LoggedInUser"
        static let kOnBoardingStatus = "OnBoardingStatus"
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
            return OnboardingStatus(rawValue:status) ?? .NONE
        }set {
            UserDefaults.standard.setValue(newValue.rawValue, forKey: Keys.kOnBoardingStatus)
        }
    }

    
}
