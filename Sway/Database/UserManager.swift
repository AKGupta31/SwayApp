//
//  UserManager.swift
//  Sway
//
//  Created by Admin on 19/04/21.
//

import SwiftKeychainWrapper

class UserManager {
    
    class KeychainConstants {
        static let type = "type"
        static let secret = "secret"
        static let socialId = "socialId"
        static let kToken = ""
        static let kSecret = ""
        static let kUserId = ""
        static let kIsSavedToKeychain = "isSavedToKeyChain"
    }
    
    static func saveSocialMediaCredentials(type: SocialMediaType, token: String, socialId:String,userId: String, secret: String = "") {
        DataManager.shared.isLoggedIn = true
        _ = KeychainWrapper.standard.set(type.rawValue, forKey: KeychainConstants.type)
        _ = KeychainWrapper.standard.set(socialId, forKey: KeychainConstants.socialId)
        _ = KeychainWrapper.standard.set(token, forKey: KeychainConstants.kToken)
        _ = KeychainWrapper.standard.set(secret, forKey: KeychainConstants.kSecret)
        _ = KeychainWrapper.standard.set(userId, forKey: KeychainConstants.kUserId)
        UserDefaults.standard.set(true, forKey: KeychainConstants.kIsSavedToKeychain)
        print("saved social media credentials in keychain")
    }
}
