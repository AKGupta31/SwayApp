//
//  ScheduleLibraryWorkoutVC.swift
//  Sway
//
//  Created by Admin on 15/07/21.
//

import UIKit
import SnapKit
import ViewControllerDescribable
import Toast_Swift
import EasyTipView

class ScheduleLibraryWorkoutVC: BaseViewController,KDDragAndDropCollectionViewDataSource {
   
    
    @IBOutlet weak var btnAdd: CustomButton!
    @IBOutlet weak var verticalLinesView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var hoursView: UIView!
    @IBOutlet weak var daysStackView: UIStackView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var collectionViewDragItemsHeight: NSLayoutConstraint!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var collectionViewDragItems: KDDragAndDropCollectionView!
    @IBOutlet weak var stackViewCVs: UIStackView!
    @IBOutlet var collectionsViews:[KDDragAndDropCollectionView]!
    var tipView:EasyTipView?
    
    var data : [[WorkoutModel]] = [[WorkoutModel]]()
    var previousSchedules = [NewScheduleModel]()
    var itemToAddEdit:LibraryItemVM!
    private var dragAndDropManager : KDDragAndDropManager?
    var isEditMode = false
    var workoutIdToEdit:String?
    var refreshData:(()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPreviousSchedules()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func getPreviousSchedules(){
        showLoader()
        ChallengesEndPoint.getSchedules { [weak self](response) in
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
        self.dragAndDropManager = KDDragAndDropManager(
            canvas: self.view,
            collectionViews: cvs
        )
        
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
        
        let workoutScheduleDate = Calendar.sway.component(.day, from: model.startDate)
        let currentDate = Calendar.sway.component(.day, from: Date())
        if workoutScheduleDate <= currentDate{
            let currentHour = Calendar.sway.component(.hour, from: Date())
            if model.startTime <= currentHour {
                AlertView.showAlert(with: Constants.Messages.kError, message: Constants.Messages.kCantScheduleAtThisTime)
                return
            }
           
        }
        showLoader()
        ChallengesEndPoint.addSchedule(model: model, isUpdate: isEditMode) { (response) in
            self.hideLoader()
            if let code = response.statusCode ,code >= 200 && code < 300 {
                self.view.makeToast(response.message, duration: 1.0, position: .bottom) { (completed) in
                    self.navigationController?.popToRootViewController(animated: true)
                    self.refreshData?()
                }
            }else {
                AlertView.showAlert(with: Constants.Messages.kError, message: response.message)
            }
            
        } failure: { (status) in
            self.hideLoader()
            AlertView.showAlert(with: Constants.Messages.kError, message: status.msg)
        }
    }
        
    
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }  
}

//MARK: Private Methods
extension ScheduleLibraryWorkoutVC {
    
    private func setupData(){
        data.removeAll()
        if self.isEditMode == false{
            let model = WorkoutModel(title: itemToAddEdit.name)
            model.color = UIColor(named:"kThemeBlue")!
            model.isSelected = true
            model.workoutId = itemToAddEdit.id
            data.append([model])
        }else {
            data.append([WorkoutModel]())
        }
        let totalItems = 18
        let datesOfTheWeek = Date.getAllDaysOfTheCurrentWeek()
        for dayOfWeek in 1...7 { // traverse through day of the weeks
            var items2 = [WorkoutModel]()
            let date = datesOfTheWeek[dayOfWeek-1]
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
            let dayOfWeek = Weekday.getWeekDay(dayFromServer: schedule.dayOfWeek).rawValue
            let todayDayOfWeek = Calendar.sway.component(.weekday, from: Date())
            let arrayOfWorkoutModels = data[dayOfWeek]
            if let firstIndex = arrayOfWorkoutModels.firstIndex(where: {$0.startTime == Int(schedule.startTime! / 60)}) {
                
                let model = data[schedule.dayOfWeek][firstIndex]
                model.workoutId = schedule._id
                model.challengeTitle = schedule.challengeTitle
                model.title = schedule.workoutName ?? ""
                
                if itemToAddEdit != nil,itemToAddEdit.id == schedule.workoutId,schedule.category == .library,schedule.dayOfWeek == todayDayOfWeek{
                    model.isPreviouslyScheduled = false
                    model.color = UIColor(named: "kThemeBlue")!
                    model.isSelected = true
//                    self.itemToAddEdit.scheduleId = schedule._id
                }else {
                    model.isPreviouslyScheduled = true
                    model.color = UIColor(named: "kThemeNavyBlue")!
                }
                
                
//                if itemToAddEdit.id == schedule.workoutId {
//                    model.isPreviouslyScheduled = false
//                    model.color = UIColor(named: "kThemeBlue")!
//                    model.isSelected = true
//                }else {
//                    model.isPreviouslyScheduled = true
//                    model.color = UIColor(named: "kThemeNavyBlue")!
//                }
                data[schedule.dayOfWeek][firstIndex] = model
            }
        }
        
        self.collectionsViews.forEach({$0.reloadData()})
    }
    
    private func setupVerticalLines(){
        var x :CGFloat = 0
        let spacing:CGFloat = stackViewCVs.frame.width / 7
        
        //following line of code gets the dates for this current week
        let datesInThisWeek = Date.getAllDaysOfTheCurrentWeek()
        let todayIs = Date().get(.day)
        for i in 0..<7 {
            let layer = CALayer()
            layer.frame = CGRect(x: x, y: 0, width: 1, height: verticalLinesView.frame.height)
            layer.backgroundColor = UIColor(named: "kThemeNavyBlue_10")?.cgColor
            x +=  spacing
            verticalLinesView.layer.insertSublayer(layer, at: 0)
            
            /*****************SETUP DAYS**********/
            //Also setup days labels
            let date = datesInThisWeek[i]
            let containerHeight = daysStackView.frame.height
            let container = UIView(frame: CGRect(x: x, y: 0, width: spacing, height:containerHeight))
            container.layer.cornerRadius = 18.0
            container.clipsToBounds = true
            daysStackView.addArrangedSubview(container)
            let dateLabel = UILabel()
            let dateOfMonth = date.get(.day) // to get the date in 1,2,3 format i.e date only
            dateLabel.text = dateOfMonth.description
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
            
            if todayIs == dateOfMonth {
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

extension ScheduleLibraryWorkoutVC:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
//        if model.color == UIColor.clear {
//            cell.backgroundColor = UIColor.random().withAlphaComponent(0.25)
//        }else {
//            cell.backgroundColor = model.color
//        }
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
extension ScheduleLibraryWorkoutVC {
    func collectionView(_ collectionView: UICollectionView, dataItemForIndexPath indexPath: IndexPath) -> AnyObject {
        print(#function)
        return data[collectionView.tag][indexPath.item]
    }
    func collectionView(_ collectionView: UICollectionView, insertDataItem dataItem : AnyObject, atIndexPath indexPath: IndexPath) -> Void {
        print(#function)
        if let di = dataItem as? WorkoutModel,di.isPreviouslyScheduled == false{
            data[collectionView.tag].insert(di, at: indexPath.row)
        }
    }
    func collectionView(_ collectionView: UICollectionView, deleteDataItemAtIndexPath indexPath : IndexPath) -> Void {
        print(#function)
        if data[collectionView.tag][indexPath.item].isPreviouslyScheduled == false {
            data[collectionView.tag].remove(at: indexPath.item)
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

extension ScheduleLibraryWorkoutVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.challenge
    }
}
