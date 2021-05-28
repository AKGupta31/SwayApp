//
//  Date+Ext.swift
//  Sway
//
//  Created by Admin on 28/05/21.
//

import Foundation


extension Date {
    
    enum DateFormat: String {

        case yyyy_MM_dd = "yyyy-MM-dd"
        case yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss"
        case yyyyMMddTHHmmsssz = "yyyy-MM-dd'T'HH:mm:ssZ"
        case yyyyMMddHHmmssz = "yyyy-MM-ddHH:mm:ssZ"
        case yyyyMMddTHHmmssssZZZZZ = "yyyy-MM-dd'T'HH:mm:ss.ssZZZZZ"
        case yyyyMMddTHHmmssSSSXXX = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
    }
    
    static func getDate(from dateStr:String) ->Date{
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.yyyyMMddTHHmmssSSSXXX.rawValue
        return formatter.date(from: dateStr) ?? Date()
    }
    
    var timeAgoSince: String {
        let calendar = Calendar.current
        let now = Date()
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: self, to: now, options: [])

        if let year = components.year, year >= 2 {
            return "\(year)y ago"
        }

        if let year = components.year, year >= 1 {
            return "Last year"
        }

        if let month = components.month, month >= 2 {
            return "\(month) mon ago"
        }

        if let month = components.month, month >= 1 {
            return "Last month"
        }

        if let week = components.weekOfYear, week >= 2 {
            return "\(week)w ago"
        }

        if let week = components.weekOfYear, week >= 1 {
            return "Last week"
        }

        if let day = components.day, day >= 2 {
            return "\(day)d ago"
        }

        if let day = components.day, day >= 1 {
            return "Yesterday"
        }

        if let hour = components.hour, hour >= 2 {
            return "\(hour)h ago"
        }

        if let hour = components.hour, hour >= 1 {
            return "1 hour ago"
        }

        if let minute = components.minute, minute >= 2 {
            return "\(minute) minutes ago"
        }

        if let minute = components.minute, minute >= 1 {
            return "1 minute ago"
        }

        if let second = components.second, second >= 3 {
            return "\(second) seconds ago"
        }

        return "Just now"
    }
}
