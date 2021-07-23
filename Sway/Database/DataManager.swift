//
//  DataManager.swift
//  Sway
//
//  Created by Admin on 19/04/21.
//

import Foundation

extension Calendar {
    
    static var sway:Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone.current
        calendar.firstWeekday = 2
        return calendar
    }
}

class DataManager {
    static let shared = DataManager()
    
    private init() {
    }

    var isLoggedIn = false
    var loggedInUser:LoginResponseData? = nil
    var deviceId = "ashishadafada"
    var deviceToken = "ashish1233222"
    var predefinedComments = [PredefinedComment]()
    
    func setLoggedInUser(user:LoginResponseData?){
        SwayUserDefaults.shared.loggedInUser = user
        loggedInUser = user
        isLoggedIn = user != nil
        SwayUserDefaults.shared.onBoardingScreenStatus = .INTRO__VIDEO_ONE
    }
}
