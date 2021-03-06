//
//  PlannerViewModel.swift
//  Sway
//
//  Created by Admin on 19/07/21.
//

import UIKit

struct DateModel {
    let date:Date
    init(date:Date) {
        self.date = date
    }
}

class DateViewModel {
    
    private let dateModel:DateModel!
    init(dateModel:DateModel) {
        self.dateModel = dateModel
        self.dayOfTheMonth = dateModel.date.get(.day)
        let weekDay = Calendar.sway.component(.weekday, from: dateModel.date)
        
        //getWeekDay() - since ios takes 1 as sunday and 2 as monday but in our enum we are taking 1 as monday and 2 tuesday and 7 as sunday
        dayOfWeek = Weekday.getWeekDay(dayFromServer: weekDay)
    }
    var dayOfTheMonth:Int = 1
    var dayOfWeek:Weekday = .monday
    
    var getFormattedDate:String {
        return dateModel.date.getFormattedDate(format: .mmmddYYYY)
    }
    
    var startDateEndDateInMilis:(Int64,Int64) {
        let weekDays = Date.getAllDaysOfTheWeek(for: dateModel.date)
        let startOfDay = Calendar.sway.startOfDay(for: weekDays.first!)//dateModel.date)
        
        let endDateOfWeek = Calendar.sway.startOfDay(for: weekDays.last!)//weekDays.last!
        let components = DateComponents(hour: 0, minute: 0, second: -1)
        let endOfDay = Calendar.sway.date(byAdding: components, to: endDateOfWeek)!
        return (startOfDay.millisecondsSince1970,endOfDay.millisecondsSince1970)
    }
}

protocol PlannerViewModelDelegate:BaseVMDelegate {
    func reloadDates(isInitial:Bool,currentDateIndex:Int)
}

class PlannerViewModel: NSObject {

    private var calendarItems = [DateModel]()
    
    var numberOfDates:Int {
        return calendarItems.count
    }
    var currentDateIndex:Int = 0
    var selectedDateIndex:Int = 0
    
    weak var delegate:PlannerViewModelDelegate?
    //MARK: Properties Schedules
    var dayWiseSchedules:[PlannerDaywiseModel]!
    var numberOfSchedules:Int {
        return dayWiseSchedules.count
    }
    
    init(delegate:PlannerViewModelDelegate?) {
        super.init()
        dayWiseSchedules = [PlannerDaywiseModel]()
        self.delegate = delegate
        setupDates(isInitial: true)
    }
    
    func setupDates(isInitial:Bool){
        let signupDate = DataManager.shared.signupDate
        guard let yearBeforeDate = Calendar.sway.date(byAdding: .day,value:-365,to: Date()) else {
            return
        }
        let fromDate:Date!
        if signupDate < yearBeforeDate {
            fromDate = yearBeforeDate
        }else {
            fromDate = signupDate
        }
        
        guard let toDate = Calendar.sway.date(byAdding: .day,value:90,to: Date()) else {
            return
        }
        let datesBetweenToAndFromDates = Date.dates(from: fromDate, to: toDate)
        datesBetweenToAndFromDates.forEach { (date) in
            self.calendarItems.append(DateModel(date: date))
        }
        
        //set the current date index
        currentDateIndex = calendarItems.firstIndex(where: {Calendar.sway.isDate($0.date, equalTo: Date(), toGranularity: .day)}) ?? 0
        self.delegate?.reloadDates(isInitial: isInitial, currentDateIndex: currentDateIndex)
        if isInitial {
            selectedDateIndex = currentDateIndex
            getDayWiseSchedulesForSelectedDate()
        }
    }
    
    func getDateViewModel(at indexPath:IndexPath) -> DateViewModel {
        return DateViewModel(dateModel: calendarItems[indexPath.row])
    }
    
    func getDayWiseScheduleVM(at index:Int) -> DayWiseScheduleVM {
        return DayWiseScheduleVM(model: dayWiseSchedules[index])
    }
    
    func getDateFromSelectedIndex()->Date {
        return calendarItems[selectedDateIndex].date
    }
    
}

extension PlannerViewModel {
    func getDayWiseSchedulesForSelectedDate(){
        DispatchQueue.global(qos: .background).async {
            let dateVM = self.getDateViewModel(at: IndexPath(row: self.selectedDateIndex, section: 0))
            let (startDate,endDate) = dateVM.startDateEndDateInMilis
            PlannerEndPoint.getSchedule(startDate: startDate, endDate: endDate, dayOfWeek: dateVM.dayOfWeek.dayOfTheWeekIntWRTAndroid) { [weak self](response) in
                if let schedules = response.data?.schedules {
                    self?.dayWiseSchedules = schedules
                }
                DispatchQueue.main.async {
                    self?.delegate?.reloadData()
                }
            } failure: { [weak self](status) in
                DispatchQueue.main.async {
                    self?.delegate?.showAlert(with: Constants.Messages.kError, message: status.msg)
                }
            }
        }
        
    }
}

enum Intensity:String {
    case low = "1"
    case medium = "2"
    case high = "3"
    
    var displayName:String {
        switch self {
        case .low:
            return "Low Intensity"
        case .medium:
            return "Medium Intensity"
        case .high:
            return "High Intensity"
        }
    }
    
    var shortName:String {
        switch self {
        case .low:
            return "Low"
        case .medium:
            return "Medium"
        case .high:
            return "High"
        }
    }
}

enum DifficultyLevel:String {
    case beginner = "1"
    case regular = "2"
    case advance = "3"
    
    var displayName:String {
        switch self {
        case .beginner:
            return "Beginner"
        case .regular:
            return "Regular"
        case .advance:
            return "Advanced"
        }
    }
}

class DayWiseScheduleVM {
    private let model:PlannerDaywiseModel
    var scheduleId:String?
    
    init(model:PlannerDaywiseModel) {
        self.model = model
        self.scheduleId = model._id
    }
    var workoutId:String?{
        return model.workoutId
    }
    
    var isPreviousSchedule:Bool {
        let currentDateMilis = Calendar.sway.startOfDay(for: Date()).millisecondsSince1970
        return Int64(model.startDate ?? 0) < currentDateMilis
    }
    
    var thumbnail:URL? {
        guard let url = model.imageModel?.url else {return nil}
        return URL(string: url)
    }
    
    var isCompleted:Bool {
        return model.isCompleted
    }
    var title:String? {
        return model.workoutName
    }
    var intensity:Intensity {
        return Intensity(rawValue: model.intensityLevel ?? "1") ?? .medium
    }
    
    var category:WorkoutCategory {
        return WorkoutCategory(rawValue: model.type ?? "library") ?? WorkoutCategory.library
    }
    
    var difficultyLevel:DifficultyLevel {
        if let level = model.difficultyLevel{
            return DifficultyLevel(rawValue: level) ?? DifficultyLevel.beginner
        }
        return .beginner
    }
    
    var workoutType:WorkoutType {
        if let type = model.workOutType ,let typeInt = Int(type){
            return WorkoutType(rawValue: typeInt) ?? .HIIT_WORKOUT
        }
        return .HIIT_WORKOUT
    }
    
    
}
