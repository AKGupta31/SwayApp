//
//  DataManager.swift
//  Sway
//
//  Created by Admin on 19/04/21.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    private init() {}
    
    var isLoggedIn = false
    var deviceId = "ashish"
    var deviceToken = "ashish123"
}
