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
        case mmmddYYYY = "MMM dd, yyyy"
    }
    
    static func getDate(from dateStr:String) ->Date{
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.yyyyMMddTHHmmssSSSXXX.rawValue
        return formatter.date(from: dateStr) ?? Date()
    }
    
    func getFormattedDate(format:DateFormat) ->String{
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.string(from: self)
    }
    
    
    var timeAgoSince: String {
        let calendar = Calendar.sway
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
    
    
    static func getAllDaysOfTheCurrentWeek() -> [Date] {
        let calendar = Calendar.sway
        let today = calendar.startOfDay(for: Date())
        return getAllDaysOfTheWeek(for: today)
    }
    
    static func getAllDaysOfTheWeek(for date:Date) -> [Date] {
        let calendar = Calendar.sway
        let today = calendar.startOfDay(for: date)
        var week = [Date]()
        if let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) {
            for i in 0...6 {
                if let day = calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                    week += [day]
                }
            }
        }
        return week
    }
}


extension Date {
    
    static func today() -> Date {
        return Date()
    }
    
    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.next,
                   weekday,
                   considerToday: considerToday)
    }
    
    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.previous,
                   weekday,
                   considerToday: considerToday)
    }
    
    func get(_ direction: SearchDirection,
             _ weekDay: Weekday,
             considerToday consider: Bool = false) -> Date {
        
        let dayName = weekDay.name
        
        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
        
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        
        let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1
        
        let calendar = Calendar(identifier: .gregorian)
        
        if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
            return self
        }
        
        var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
        nextDateComponent.weekday = searchWeekdayIndex
        
        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy: .nextTime,
                                     direction: direction.calendarSearchDirection)
        
        return date!
    }
    
}

enum Weekday: Int {
    case monday = 1, tuesday = 2, wednesday = 3, thursday = 4, friday = 5, saturday = 6, sunday = 7
    
    var name:String {
        return String(describing: self)
    }
    
    var dayOfTheWeekIntWRTAndroid:Int {
        switch self {
        case .sunday:
            return 1
        case .monday:
            return 2
        case .tuesday:
            return 3
        case .wednesday:
            return 4
        case .thursday:
            return 5
        case .friday:
            return 6
        case .saturday:
            return 7
        }
    }
    
    static func getWeekDay(dayFromServer:Int) -> Weekday {
        switch dayFromServer {
        case 1:
            return .sunday
        case 2:
            return .monday
        case 3:
            return .tuesday
        case 4:
            return .wednesday
        case 5:
            return .thursday
        case 6:
            return .friday
        case 7:
            return .saturday
        default:
            return .monday
        }
    }
    
    var weekday:Int {
        switch self {
        case .sunday:
            return 1
        case .monday:
            return 2
        case .tuesday:
            return 3
        case .wednesday:
            return 4
        case .thursday:
            return 5
        case .friday:
            return 6
        case .saturday:
            return 7
        }
    }
    
    
    var shortName:String {
        switch self {
        case .monday:
            return "MON"
        case .tuesday:
            return "TUE"
        case .wednesday:
            return "WED"
        case .thursday:
            return "THU"
        case .friday:
            return "FRI"
        case .saturday:
            return "SAT"
        case .sunday:
            return "SUN"
        }
    }
}


extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.sway) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.sway) -> Int {
        return calendar.component(component, from: self)
    }
}


extension Date {
    public func setTime(hour: Int, min: Int, sec: Int, timeZoneAbbrev: String = "UTC") -> Date? {
        let x: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let cal = Calendar.sway
        var components = cal.dateComponents(x, from: self)
        
        //        components.timeZone = TimeZone(abbreviation: timeZoneAbbrev)
        components.hour = hour
        components.minute = min
        components.second = sec
        return cal.date(from: components)
    }
}


extension Date {
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.sway.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
}
