//
//  SyncWithCalenderVC.swift
//  Sway
//
//  Created by Admin on 04/06/21.
//

import UIKit
import ViewControllerDescribable
import EventKit


enum SyncWithCalendarScreenType:Int {
    case syncWithCalendar
    case challengeAccepted
}
class SyncWithCalenderVC: BaseViewController {
    @IBOutlet weak var btnSkip: UIButton!
    
    @IBOutlet weak var btnICalendar: CustomButton!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    var schedulesModel:ChallengeSchedulesModel!
    var eventStore:EKEventStore!
    
    var screenType:SyncWithCalendarScreenType = .syncWithCalendar
    var numberOfWeeks = 0 // necessary for screen type challengeAccepted
    var challengeTitle:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = [.bottom]
        extendedLayoutIncludesOpaqueBars = true
        if screenType == .syncWithCalendar {
            eventStore = EKEventStore()
        }else {
            btnSkip.isHidden = true
        }
        setupLabels()
        
        // Do any additional setup after loading the view.
        
    }
    @IBAction func actionSkip(_ sender: UIButton) {
        self.navigationController?.push(SyncWithCalenderVC.self, animated: true, configuration: { (vc) in
            vc.screenType = .challengeAccepted
            vc.numberOfWeeks = self.numberOfWeeks
            vc.challengeTitle = self.challengeTitle
        })
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupLabels(){
        if screenType == .syncWithCalendar {
            let attributedString = NSMutableAttributedString(string: "Sync with  your Calendar", attributes: [
                .font: UIFont(name: "Poppins-Bold", size: 40.0)!,
                .foregroundColor: UIColor(red: 94.0 / 255.0, green: 0.0, blue: 1.0, alpha: 1.0)
            ])
            attributedString.addAttributes([
                .font: UIFont(name: "Poppins-Bold", size: 52.0)!,
                .foregroundColor: UIColor(red: 5.0 / 255.0, green: 9.0 / 255.0, blue: 53.0 / 255.0, alpha: 1.0)
            ], range: NSRange(location: 0, length: 9))
            self.lblTitle.attributedText = attributedString
            self.lblDescription.text = "Sync with your google or iCal to keep track of your workouts."
        }else if screenType == .challengeAccepted{
            let attributedString = NSMutableAttributedString(string: "Challenge accepted!", attributes: [
                .font: UIFont(name: "Poppins-Bold", size: 52.0)!,
                .foregroundColor: UIColor(red: 5.0 / 255.0, green: 9.0 / 255.0, blue: 53.0 / 255.0, alpha: 1.0)
            ])
            attributedString.addAttribute(.foregroundColor, value: UIColor(red: 94.0 / 255.0, green: 0.0, blue: 1.0, alpha: 1.0), range: NSRange(location: 10, length: 9))
            lblTitle.attributedText = attributedString
            lblDescription.text = "You accepted \(numberOfWeeks) Weeks \(challengeTitle). We’re excited to kickstart your fitness journey with you!"
            btnICalendar.setTitle("VIEW MY PLANNER", for: .normal)
        }
    }
    
    @IBAction func actionSaveCalenderEvent(_ sender: UIButton) {
        if screenType == .syncWithCalendar {
            isICalenderAuthorized(isAuthorized: { (isAuthorized) in
                if isAuthorized {
                    if let model = self.schedulesModel ,let schedules = model.schedules {
                        let end = EKRecurrenceEnd(end:Date(milliseconds: model.endDate!))
                        let rule = EKRecurrenceRule(recurrenceWith: .weekly, interval: 1, end: end)
                        
                        for schedule in schedules {
                            if let dayOfTheWeek = schedule.dayOfTheWeek,let weekday = Weekday(rawValue: dayOfTheWeek) {
                                let startDate = Date.today().next(weekday)
                                let startDateWithTime = Calendar.current.date(bySettingHour: schedule.startTime!, minute: 0, second: 0, of:startDate)
                                
                                let endDateWithTime = Calendar.current.date(byAdding: .hour, value: 1, to: startDateWithTime ?? startDate) ?? startDate.addingTimeInterval(60 * 60)
                                print("start date ",endDateWithTime.getFormattedDate(format: .yyyyMMddHHmmss))
                                
                                print("end date ",endDateWithTime.getFormattedDate(format: .yyyyMMddHHmmss))
                                if let date = startDateWithTime {
                                    self.insertEvent(title: "Workout", startDate: date, endDate: endDateWithTime, recurenceRule: rule)
                                }
                                
                                
                            }else {
                                continue
                            }
                            
                        }
                        self.navigationController?.push(SyncWithCalenderVC.self, animated: true, configuration: { (vc) in
                            vc.screenType = .challengeAccepted
                            vc.numberOfWeeks = self.numberOfWeeks
                            vc.challengeTitle = self.challengeTitle
                        })
                    }
                }else {
                    AlertView.showAlert(with: "Error!", message: "Please authorize app for calender events from settings")
                }
            })
        }else {
            self.navigationController?.popToRootViewController(animated: true)
            self.tabBarController?.selectedIndex = 1
        }
        
        
        
    }
    
    
    
    
    func isICalenderAuthorized(isAuthorized:((Bool)->())?){
        // 1
        
        
        // 2
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            isAuthorized?(true)
        //            insertEvent(store: eventStore)
        case .denied:
            print("Access denied")
            isAuthorized?(false)
        case .notDetermined:
            // 3
            eventStore.requestAccess(to: .event, completion:
                                        {(granted: Bool, error: Error?) -> Void in
                                            isAuthorized?(granted)
                                        })
        default:
            print("Case default")
        }
    }
    
    func insertEvent(title:String,startDate:Date,endDate:Date,recurenceRule:EKRecurrenceRule) {
        guard let store = self.eventStore else {return}
        let event:EKEvent = EKEvent(eventStore: store)
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.notes = "This is a note"
        event.calendar = store.defaultCalendarForNewEvents
        event.addRecurrenceRule(recurenceRule)
        do {
            try store.save(event, span: .thisEvent)
            print("Saved Event")
        } catch let error as NSError {
            print("failed to save event with error : \(error)")
        }
        
    }
    
}

extension SyncWithCalenderVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.challenge
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

// MARK: Helper methods

enum Weekday: Int {
    case monday = 1, tuesday = 2, wednesday = 3, thursday = 4, friday = 5, saturday = 6, sunday = 7
    
    var name:String {
        return String(describing: self)
    }
}
extension Date {
    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }
    
    
    
    enum SearchDirection {
        case next
        case previous
        
        var calendarSearchDirection: Calendar.SearchDirection {
            switch self {
            case .next:
                return .forward
            case .previous:
                return .backward
            }
        }
    }
}
