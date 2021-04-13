//
//  ResponseStatus.swift
//  Sway
//
//  Created by Admin on 12/04/21.
//

import Foundation

struct ResponseStatus {
    var code: Int
    var msg: String
    
    init(code: Int = 0, msg: String = "") {
        self.code = code
        self.msg = msg
    }
    
}
