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
        let weekDay = Calendar.current.component(.weekday, from: dateModel.date)
        
        //getWeekDay() - since ios takes 1 as sunday and 2 as monday but in our enum we are taking 1 as monday and 2 tuesday and 7 as sunday
        dayOfWeek = Weekday.getWeekDay(dayFromServer: weekDay)
    }
    var dayOfTheMonth:Int = 1
    var dayOfWeek:Weekday = .monday
    
    var getFormattedDate:String {
        return dateModel.date.getFormattedDate(format: .mmmddYYYY)
    }
    
    var startDateEndDateInMilis:(Int,Int) {
        let startOfDay = Calendar.current.startOfDay(for: dateModel.date)
        let components = DateComponents(hour: 23, minute: 59, second: 59)
        let endOfDay = Calendar.current.date(byAdding: components, to: startOfDay)!
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
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        guard let signupDate = formatter.date(from: "2021/01/01") else {
           return
        }
        guard let yearBeforeDate = Calendar.current.date(byAdding: .day,value:-365,to: Date()) else {
            return
        }
        let fromDate:Date!
        if signupDate < yearBeforeDate {
            fromDate = yearBeforeDate
        }else {
            fromDate = signupDate
        }
        
        guard let toDate = Calendar.current.date(byAdding: .day,value:90,to: Date()) else {
            return
        }
        let datesBetweenToAndFromDates = Date.dates(from: fromDate, to: toDate)
        datesBetweenToAndFromDates.forEach { (date) in
            self.calendarItems.append(DateModel(date: date))
        }
        
        //set the current date index
        currentDateIndex = calendarItems.firstIndex(where: {Calendar.current.isDate($0.date, equalTo: Date(), toGranularity: .day)}) ?? 0
        self.delegate?.reloadDates(isInitial: isInitial, currentDateIndex: currentDateIndex)
        if isInitial {
            getDayWiseSchedulesForSelectedDate()
        }
    }
    
    func getDateViewModel(at indexPath:IndexPath) -> DateViewModel {
        return DateViewModel(dateModel: calendarItems[indexPath.row])
    }
    
    func getDayWiseScheduleVM(at index:Int) -> DayWiseScheduleVM {
        return DayWiseScheduleVM(model: dayWiseSchedules[index])
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

class DayWiseScheduleVM {
    let model:PlannerDaywiseModel
    init(model:PlannerDaywiseModel) {
        self.model = model
    }
}
