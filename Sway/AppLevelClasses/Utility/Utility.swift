//
//  Utility.swift
//  Sway
//
//  Created by Admin on 19/04/21.
//

import UIKit

class Utility {
    
    
    static func isValidEmailAddress(email:String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = email as NSString
            let results = regex.matches(in: email, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    static func isValidPassword(password:String) -> Bool {
        return password.count >= 6
    }
    
    static func getHiddenMiddleCharatersOfEmail(email:String) ->String{
        let emailArray = email.components(separatedBy: "@")
        guard let domain = emailArray.last else {return ""}
        guard let emailName = emailArray.first else {return ""}
        var newString = ""
        for (index,char) in emailName.enumerated() {
            if index == 0 || index == emailName.count - 1 {
                newString += String(char)
            }else {
                newString += "*"
            }
        }
        return newString+"@"+domain
    }
    
    static func getPasswordStrength(password:String) -> PasswordStrength {
        let passwordRegx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,16}$"
        let weak1Regex = "^[A-Z0-9].{8,16}$"
        let weak2Regex = "^[a-z0-9].{8,16}$"
        
        let moderateRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d].{8,16}$"
        if NSPredicate(format: "SELF MATCHES %@", passwordRegx).evaluate(with: password) {
            return .strong
        }else if NSPredicate(format: "SELF MATCHES %@", moderateRegex).evaluate(with: password){
            return .moderate
        }
        else if NSPredicate(format: "SELF MATCHES %@", weak1Regex).evaluate(with: password){
            return .weak
        }else if NSPredicate(format: "SELF MATCHES %@", weak2Regex).evaluate(with: password){
            return .weak
        }
        return .invalid
    }

}
