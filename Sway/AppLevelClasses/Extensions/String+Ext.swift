//
//  String+Ext.swift
//  Sway
//
//  Created by Admin on 12/04/21.
//

import Foundation

extension String {
    var localized:String {
        let language = "Base"
        if let path = Bundle.main.path(forResource: language, ofType: "lproj") {
            let bundle = Bundle(path: path)
            
            return NSLocalizedString(self, tableName: nil, bundle: bundle ?? Bundle.main, value: "", comment: "[\(self)]")
        }
        return ""
    }
    
    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func startsWith(string: String) -> Bool {
        guard let range = range(of: string, options:[.caseInsensitive]) else {
            return false
        }
        return range.lowerBound == startIndex
    }
}
