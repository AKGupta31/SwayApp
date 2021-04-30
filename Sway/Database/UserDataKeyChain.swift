//
//  UserDataKeyChain.swift
//  Sway
//
//  Created by Admin on 19/04/21.
//

import Foundation

import Foundation

struct UserDataKeychain: Keychain {
    // Make sure the account name doesn't match the bundle identifier!
    var account = "com.sway.SignInWithApple.Details"
    var service = "userIdentifier"

    typealias DataType = UserData
}
