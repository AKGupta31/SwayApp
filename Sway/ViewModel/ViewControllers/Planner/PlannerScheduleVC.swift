//
//  PlannerScheduleVC.swift
//  Sway
//
//  Created by Admin on 20/07/21.
//

import UIKit
import SnapKit
import ViewControllerDescribable
import Toast_Swift
import EasyTipView
//import 

enum WorkoutCategory :String{
    case challenge = "challenge"
    case library = "library"
}

enum PlannerScheduleVCType:Int {
    case viewOnly
    case rescheduleOnCurrentWeek
    case rescheduleOnOtherWeek
}

enum ChallengeUpdateType:String {
    case currentWeek = "current_week"
    case allWeeks = "all_weeks"
    
}

class PlannerScheduleVC: BaseViewController,KDDragAndDropCollectionViewDataSource {
    
    @IBOutlet weak var btnAllWeeks: UIButton!
    @IBOutlet weak var btnThisWeek: UIButton!
    @IBOutlet weak var allWeeksAlertView: UIView!
    @IBOutlet weak var btnAdd: CustomButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var verticalLinesView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var hoursView: UIView!
    @IBOutlet weak var daysStackView: UIStackView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var collectionViewDragItemsHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionViewDragItems: KDDragAndDropCollectionView!
    @IBOutlet weak var stackViewCVs: UIStackView!
    @IBOutlet var collectionsViews:[KDDragAndDropCollectionView]!
    
    var data : [[WorkoutModel]] = [[WorkoutModel]]()
    var previousSchedules = [NewScheduleModel]()
    var itemToAddEdit:DayWiseScheduleVM!
    private var dragAndDropManager : KDDragAndDropManager?
    var refreshData:(()->())?
    var type:PlannerScheduleVCType = .viewOnly
    var dateOfWeek:Date!
    private var datesForCurrentWeek:[Date]!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    var tipView:EasyTipView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentWeek = Date.getAllDaysOfTheWeek(for: dateOfWeek)
        datesForCurrentWeek = currentWeek
        getPreviousSchedules()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func getPreviousSchedules(){
        showLoader()
//        let weekDays = Date.getAllDaysOfTheWeek(for: dateOfWeek)
        let startDateOfWeekWithStartOfTheDay = Calendar.sway.startOfDay(for: datesForCurrentWeek.first!)
        guard let endDate = Calendar.sway.date(byAdding: .day, value: 7, to: startDateOfWeekWithStartOfTheDay) else {
            return
        }
        ChallengesEndPoint.getSchedules(startDate: startDateOfWeekWithStartOfTheDay.millisecondsSince1970, endDate: endDate.millisecondsSince1970) { [weak self](response) in
            self?.hideLoader()
            if let schedules = response.data?.schedules {
                self?.previousSchedules = schedules
                self?.setupData()
            }
        } failure: { (status) in
            self.hideLoader()
            AlertView.showAlert(with: Constants.Messages.kError, message: status.msg)
        }
    }
    
    fileprivate func setupUI(){
        allWeeksAlertView.isHidden = true
        if self.type == .viewOnly {
            lblTitle.text = "Your workout schedule"
        }
        self.tabBarController?.tabBar.isHidden = true
        extendedLayoutIncludesOpaqueBars = true
        setupData()
        self.collectionsViews.forEach({$0.animating = true})
        var cvs = [KDDragAndDropCollectionView]()
        cvs.append(collectionViewDragItems)
        collectionsViews.forEach({cvs.append($0)})
        collectionsViews?.forEach { (cv) in
            cv.isScrollEnabled = false
        }
        if self.type != .viewOnly  {
            self.dragAndDropManager = KDDragAndDropManager(
                canvas: self.view,
                collectionViews: cvs
            )
        }
        
        self.bottomView.addShadow(shadowColor: UIColor(named: "kThemeNavyBlue")!.cgColor, shadowOffset: CGSize(width: 0, height: -5), shadowOpacity: 0.1, shadowRadius: 2)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.setupVerticalLines()
            self.setupHourLabels()
            self.shadowView.addShadow(shadowColor: UIColor(named: "kThemeNavyBlue")!.cgColor, shadowOffset: CGSize(width: 0, height: 3), shadowOpacity: 0.1, shadowRadius: 8.0)
            self.collectionsViews.forEach({$0.reloadData()})
        }
        btnAdd.isUserInteractionEnabled = false
        btnAdd.backgroundColor = UIColor(named: "kThemeYellow")?.withAlphaComponent(0.6)
    }
    
    
    @IBAction func actionAdd(_ sender: UIButton) {
        tipView?.removeFromSuperview()
        //show <all weeks / this week> alert view for category type challenge
        if itemToAddEdit.category == .challenge {
            allWeeksAlertView.isHidden = false
            return
        }
        
        // else for library type just simply update workout id with schedule id as we need to put schedule id to update the schedule
        var wm:WorkoutModel?
        data.forEach { (workoutsArray) in
            workoutsArray.forEach { (model) in
                if model.isSelected {
                    wm = model
                }
            }
        }
        guard let model = wm, model.startDate != nil && model.endDate != nil else {
            AlertView.showAlert(with: Constants.Messages.kError, message: "Something is wrong please try again and go back")
            return
        }
        if model.startDate.millisecondsSince1970 <= Date().millisecondsSince1970{
            let calendar = Calendar.sway
            let currentHour = calendar.component(.hour, from: Date())
            if model.startTime <= currentHour {
                AlertView.showAlert(with: Constants.Messages.kError, message: Constants.Messages.kCantScheduleAtThisTime)
                return
            }
           
        }
        showLoader()
        model.workoutId = itemToAddEdit.scheduleId // update workout id with schedule id
        ChallengesEndPoint.addSchedule(model: model, isUpdate: self.type != .viewOnly) { [weak self](response) in
            self?.handleEmptyDataResponse(response: response)
        } failure: { (status) in
            self.hideLoader()
            AlertView.showAlert(with: Constants.Messages.kError, message: status.msg)
        }
    }
    
    func handleEmptyDataResponse(response:EmptyDataResponse){
        self.hideLoader()
        if let code = response.statusCode ,code >= 200 && code < 300 {
            self.view.makeToast(response.message, duration: 1, position: .bottom) { [weak self](completed) in
                self?.dismiss(animated: true, completion: nil)
                self?.refreshData?()
            }
        }else {
            AlertView.showAlert(with: Constants.Messages.kError, message: response.message)
        }
    }
        
    
    @IBAction func actionWorkoutPlanner(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Actions Popup
    
    @IBAction func actionUpdate(_ sender: UIButton) {
        let updateFor :ChallengeUpdateType = btnThisWeek.isSelected ? .currentWeek : .allWeeks
        var wm:WorkoutModel?
        data.forEach { (workoutsArray) in
            workoutsArray.forEach { (model) in
                if model.isSelected {
                    wm = model
                }
            }
        }
        guard let model = wm ,let scheduleModel = self.previousSchedules.first(where: {$0._id == itemToAddEdit.scheduleId})else {
            AlertView.showAlert(with: Constants.Messages.kError, message: "Something is wrong please try again and go back")
            return
        }
        showLoader()
        ChallengesEndPoint.updateChallengeSchedule(updateFor: updateFor, model: model, scheduleModel:scheduleModel) { [weak self](response) in
            self?.handleEmptyDataResponse(response: response)
        } failure: { (status) in
            self.hideLoader()
            AlertView.showAlert(with: Constants.Messages.kError, message: status.msg)
        }
        
    }
    @IBAction func actionDiscard(_ sender: UIButton) {
        allWeeksAlertView.isHidden = true
    }
    
    @IBAction func actionAllWeeks(_ sender: UIButton) {
        btnAllWeeks.isSelected = false
        btnThisWeek.isSelected = false
        sender.isSelected = true
    }
    
    @IBAction func actionThisWeek(_ sender: UIButton) {
        btnAllWeeks.isSelected = false
        btnThisWeek.isSelected = false
        sender.isSelected = true
    }
    
    @IBAction func actionPreviousWeek(_ sender: UIButton) {
        tipView?.removeFromSuperview()
        let todaysWeek = Date.getAllDaysOfTheCurrentWeek()
        guard let firstDayOfThisWeek = todaysWeek.first else {return}
        let startOfFirstDayOfThisWeek = Calendar.sway.startOfDay(for: firstDayOfThisWeek)
        guard let previousWeekDay = Calendar.sway.date(byAdding: .day, value: -7, to: dateOfWeek) else {
            return
        }
        let previousWeek = Date.getAllDaysOfTheWeek(for: previousWeekDay)
        guard let firstDayOfNextWeek = previousWeek.first else {return}
        let startOfFirstDayOfNextWeek = Calendar.sway.startOfDay(for: firstDayOfNextWeek)
        if type != .viewOnly {
            if startOfFirstDayOfNextWeek < startOfFirstDayOfThisWeek {
                AlertView.showAlert(with: "Alert!", message: "You can't reschedule on previous weeks")
                return
            }else if startOfFirstDayOfNextWeek == startOfFirstDayOfThisWeek {
                self.type = .rescheduleOnCurrentWeek
            }else {
                self.type = .rescheduleOnOtherWeek
            }
        }else {
            // check if user can't go before signup date
            if previousWeekDay < DataManager.shared.signupDate {
                AlertView.showAlert(with: "Alert!", message: "You can't go before signup date")
                return
            }
        }
        self.dateOfWeek = previousWeekDay
        datesForCurrentWeek = previousWeek
        getPreviousSchedules()
        setupVerticalLines()
    }
    
    @IBAction func actionNextWeek(_ sender: UIButton) {
        tipView?.removeFromSuperview()
        guard let nextWeekStart = Calendar.sway.date(byAdding: .day, value: 7, to: dateOfWeek) else {
            return
        }
        guard let next3MonthsFromNow = Calendar.sway.date(byAdding: .day, value: 90, to: Date()) else {return}
        
        
        if nextWeekStart > next3MonthsFromNow {
            AlertView.showAlert(with: "Alert!", message: "You can't go more than 90 days from today")
            return
        }
        self.dateOfWeek = nextWeekStart
        self.type = type == .viewOnly ? .viewOnly : .rescheduleOnOtherWeek
        let currentWeek = Date.getAllDaysOfTheWeek(for: dateOfWeek)
        datesForCurrentWeek = currentWeek
        getPreviousSchedules()
        setupVerticalLines()
    }
    
}

extension PlannerScheduleVC{

}

//MARK: Private Methods
extension PlannerScheduleVC {
    
    private func setupData(){
        data.removeAll()
        if self.type == .rescheduleOnOtherWeek && itemToAddEdit != nil{
            let model = WorkoutModel(title: itemToAddEdit.title ?? "")
            model.color = UIColor(named:"kThemeBlue")!
            model.isSelected = true
            model.workoutId = itemToAddEdit.scheduleId ?? itemToAddEdit.workoutId
            model.category = itemToAddEdit.category
            data.append([model])
        }else {
            data.append([WorkoutModel]())
        }
        let totalItems = 18
        let datesOfTheWeek = datesForCurrentWeek//Date.getAllDaysOfTheWeek(for: self.dateOfWeek)
        for dayOfWeek in 1...7 { // traverse through day of the weeks
            var items2 = [WorkoutModel]()
            guard let date = datesOfTheWeek?[dayOfWeek-1] else {continue}
            for i in  0..<totalItems { // traverse through timings like 5 am , 6 am etc
                let model = WorkoutModel(id:i)
                model.dayOfTheWeek = dayOfWeek
                var calendar = Calendar(identifier: .gregorian)
                calendar.timeZone = TimeZone.current
                let startOfDate = calendar.startOfDay(for: date)
                model.startDate =  calendar.date(byAdding: .hour, value: i + 5, to: startOfDate)//
                model.endDate =  calendar.date(byAdding: .hour, value: i + 5 + 1, to: startOfDate)
                model.startTime = i + 5
                model.endTime = i + 5 + 1 // 1 hour extra
                items2.append(model)
            }
            data.append(items2)
        }
        
        for schedule in previousSchedules {
            let arrayOfWorkoutModels = data[schedule.dayOfWeek]
            if let firstIndex = arrayOfWorkoutModels.firstIndex(where: {($0.startTime == Int(schedule.startTime! / 60))}){
                let model = data[schedule.dayOfWeek][firstIndex]
                model.workoutId = schedule._id
                model.title = schedule.workoutName ?? ""
                model.challengeTitle = schedule.challengeTitle
                if type == .rescheduleOnCurrentWeek {
                    if itemToAddEdit != nil,itemToAddEdit.workoutId == schedule.workoutId,itemToAddEdit.category == schedule.category{
                        model.isPreviouslyScheduled = false
                        model.color = UIColor(named: "kThemeBlue")!
                        model.isSelected = true
                        self.itemToAddEdit.scheduleId = schedule._id
                    }else {
                        model.isPreviouslyScheduled = true
                        model.color = UIColor(named: "kThemeNavyBlue")!
                    }
                }else {
                    model.isPreviouslyScheduled = true
                    model.color = UIColor(named: "kThemeNavyBlue")!
                }
                data[schedule.dayOfWeek][firstIndex] = model
            }
        }
        self.collectionViewDragItems.reloadData()
        self.collectionsViews.forEach({$0.reloadData()})
    }
    
    private func setupVerticalLines(){
        daysStackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
        verticalLinesView.layer.sublayers?.removeAll()
        var x :CGFloat = 0
        let spacing:CGFloat = stackViewCVs.frame.width / 7
        
        //following line of code gets the dates for this current week
//        let datesInThisWeek = Date.getAllDaysOfTheCurrentWeek()
        let datesInThisWeek =  datesForCurrentWeek//Date.getAllDaysOfTheWeek(for:dateOfWeek)
//        let todaysDate = Date().get(.day)
        let today = Date().get(.day,.month,.year)
        for i in 0..<7 {
            let layer = CALayer()
            layer.frame = CGRect(x: x, y: 0, width: 1, height: verticalLinesView.frame.height)
            layer.backgroundColor = UIColor(named: "kThemeNavyBlue_10")?.cgColor
            x +=  spacing
            verticalLinesView.layer.insertSublayer(layer, at: 0)
            
            /*****************SETUP DAYS**********/
            //Also setup days labels
            guard let date = datesInThisWeek?[i] else {
                continue
            }
            let containerHeight = daysStackView.frame.height
            let container = UIView(frame: CGRect(x: x, y: 0, width: spacing, height:containerHeight))
            container.layer.cornerRadius = 18.0
            container.clipsToBounds = true
            daysStackView.addArrangedSubview(container)
            let dateLabel = UILabel()
            let dateMonthYear = date.get(.day,.month,.year)//Calendar.sway.component(.day, from: date)
            dateLabel.text = dateMonthYear.day?.description
            dateLabel.textAlignment = .center
            dateLabel.backgroundColor = .clear
            dateLabel.font = UIFont(name: "CircularStd-Bold", size: 25)
            container.addSubview(dateLabel)
            dateLabel.snp.makeConstraints { (maker) in
                maker.leading.trailing.equalToSuperview()
                maker.bottom.equalToSuperview().inset(6)
            }
            
            //add day
            let weekDayLabel = UILabel()
            weekDayLabel.text = (Weekday(rawValue: i+1) ?? Weekday.monday).shortName
            weekDayLabel.textAlignment = .center
            weekDayLabel.backgroundColor = .clear
            weekDayLabel.font = UIFont(name: "CircularStd-Bold", size: 12)
            container.addSubview(weekDayLabel)
            weekDayLabel.snp.makeConstraints { (maker) in
                maker.leading.trailing.equalToSuperview()
                maker.top.equalToSuperview().inset(9)
            }
            
            if today.day == dateMonthYear.day && today.month == dateMonthYear.month && today.year == dateMonthYear.year {
                dateLabel.textColor = .white
                weekDayLabel.textColor = .white
                container.backgroundColor = .blue//UIColor(named: "kThemeBlue")
            }else {
                dateLabel.textColor = UIColor(named: "kThemeNavyBlue")
                weekDayLabel.textColor = UIColor(named: "kThemeNavyBlue")
                container.backgroundColor = .white
            }
            
            /*****************END OF DAYS SETUP*****************/
            
        }
        
    }
    
    
    private func setupHourLabels(){
        hoursView.backgroundColor = .clear
        var y :CGFloat = 0
        let spacing:CGFloat = 32
        let timings = ["5 AM","6 AM","7 AM","8 AM","9 AM","10 AM","11 AM","12 PM","1 PM","2 PM","3 PM","4 PM","5 PM","6 PM","7 PM","8 PM","9 PM","10 PM"]
        for (_,time) in timings.enumerated() {
            let layer = CALayer()
            layer.frame = CGRect(x: 0, y: y, width: hoursView.frame.width, height: 16)
            y +=  spacing
            let textLayer = CATextLayer()
            textLayer.frame = CGRect(x: 0, y: 0, width: layer.frame.width, height: 24)
            textLayer.alignmentMode = .center
            textLayer.string = NSAttributedString(string:time,
                                                  attributes: [
                                                    NSAttributedString.Key.foregroundColor:UIColor(named: "kThemeNavyBlue_40")!,NSAttributedString.Key.font:UIFont(name: "CircularStd-Book", size: 12)!])
            layer.addSublayer(textLayer)
            hoursView.layer.addSublayer(layer)
        }
    }
}

extension PlannerScheduleVC:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewDragItems {
            let count = data[collectionView.tag].count
            collectionViewDragItemsHeight.constant = count > 0 ? 60 : 0
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
            //            collectionView.backgroundColor = UIColor.yellow
        }
        return data[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewDragItems {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DragItemCell", for: indexPath) as! DragItemCell
            let model = data[collectionView.tag][indexPath.item]
            cell.lblTitle.isHidden = true
            cell.isHidden = false
            //            cell.lblTitle.text = model.dummyDisplayName // "Workout" + indexPath.row.description
            //            cell.backgroundColor = UIColor.random()
            //            cell.lblTitle.text = data[collectionView.tag][indexPath.item].title
            cell.viewContent.backgroundColor = model.color
            if let kdCollectionView = collectionView as? KDDragAndDropCollectionView {
                
                if let draggingPathOfCellBeingDragged = kdCollectionView.draggingPathOfCellBeingDragged {
                    if draggingPathOfCellBeingDragged.item == indexPath.item {
                        cell.isHidden = true
                    }
                }
            }
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalenderItemCell", for: indexPath) as! CalenderItemCell
        let model = data[collectionView.tag][indexPath.item]
        cell.lblTitle.isHidden = true
        cell.backgroundColor = model.color
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewDragItems {
            if let image = UIImage(named: "ic_workout_small") {
                return CGSize(width: image.size.width + 26, height: 36)
            }
            return CGSize(width: 52, height: 36)
        }
        let width :CGFloat = stackViewCVs.frame.width / 7 - 2
        return CGSize(width: width, height: 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == collectionViewDragItems {
            return UIEdgeInsets(top: 0, left: 16, bottom: 8, right: 16)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tipView?.removeFromSuperview()
        let item = data[collectionView.tag][indexPath.row]
        guard let cell = collectionView.cellForItem(at: indexPath),item.isSelected == true || item.isPreviouslyScheduled else {
            return
        }
        
        var preferences = EasyTipView.Preferences()
        preferences.drawing.font = UIFont(name: "Futura-Medium", size: 13)!
        preferences.drawing.foregroundColor = UIColor.white
        preferences.drawing.backgroundColor = UIColor(hue:0.46, saturation:0.99, brightness:0.6, alpha:1)
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.top
        
        
        var text = "Workout : \(item.title)"
        if let challenge = item.challengeTitle,challenge.isEmpty == false {
            text += "\nChallenge : \(challenge)"
        }
        tipView = EasyTipView(text: text, preferences: preferences)
        tipView?.show(forView: cell, withinSuperview: self.view)
    }
    
}

//MARK: Drag KDDragDropView
extension PlannerScheduleVC {
    func collectionView(_ collectionView: UICollectionView, dataItemForIndexPath indexPath: IndexPath) -> AnyObject {
        print(#function)
        return data[collectionView.tag][indexPath.item]
    }
    func collectionView(_ collectionView: UICollectionView, insertDataItem dataItem : AnyObject, atIndexPath indexPath: IndexPath) -> Void {
        print(#function)
        if let di = dataItem as? WorkoutModel,di.isPreviouslyScheduled == false{
            data[collectionView.tag].insert(di, at: indexPath.row)
            btnAdd.isUserInteractionEnabled = true
            btnAdd.backgroundColor = UIColor(named: "kThemeYellow")
        }
    }
    func collectionView(_ collectionView: UICollectionView, deleteDataItemAtIndexPath indexPath : IndexPath) -> Void {
        print(#function)
        if data[collectionView.tag][indexPath.item].isPreviouslyScheduled == false {
            data[collectionView.tag].remove(at: indexPath.item)
            btnAdd.isUserInteractionEnabled = true
            btnAdd.backgroundColor = UIColor(named: "kThemeYellow")
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, moveDataItemFromIndexPath from: IndexPath, toIndexPath to : IndexPath) -> Void {
        print(#function)
        let fromDataItem: WorkoutModel = data[collectionView.tag][from.item]
        data[collectionView.tag].remove(at: from.item)
        
        let toItem = data[collectionView.tag][to.item]
        
        fromDataItem.startDate = toItem.startDate
        fromDataItem.endDate = toItem.endDate
        fromDataItem.dayOfTheWeek = toItem.dayOfTheWeek
        fromDataItem.startTime = toItem.startTime
        fromDataItem.endTime = toItem.endTime
        
        data[collectionView.tag].insert(fromDataItem, at: to.item)
        btnAdd.isUserInteractionEnabled = true
        btnAdd.backgroundColor = UIColor(named: "kThemeYellow")
    }
    
    func collectionView(_ collectionView: UICollectionView, indexPathForDataItem dataItem: AnyObject) -> IndexPath? {
        
       
        guard let candidate = dataItem as? WorkoutModel ,candidate.isPreviouslyScheduled == false else {
            print(#function," return nil")
            return nil
        }
        
        for (i,item) in data[collectionView.tag].enumerated() {
            if candidate != item { continue }
            print(#function ," return \(i)")
            return IndexPath(item: i, section: 0)
            
        }
        return nil
    }
    
    func collectionView(_ collectionView: UICollectionView, cellIsDraggableAtIndexPath indexPath: IndexPath) -> Bool {
        if data[collectionView.tag][indexPath.row].isPreviouslyScheduled {
            return false
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, cellIsDroppableAtIndexPath indexPath: IndexPath) -> Bool {
        if data[collectionView.tag][indexPath.row].isPreviouslyScheduled {
            return false
        }
        print("collection view tag",collectionView.tag)
        return true
    }
    
}

extension PlannerScheduleVC {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        tipView?.removeFromSuperview()
    }
}

extension PlannerScheduleVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.planner
    }
}


