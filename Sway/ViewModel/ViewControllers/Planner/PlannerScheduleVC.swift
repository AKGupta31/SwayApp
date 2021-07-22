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

class PlannerScheduleVC: BaseViewController,KDDragAndDropCollectionViewDataSource {
    
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
    var itemToAddEdit:LibraryItemVM!
    private var dragAndDropManager : KDDragAndDropManager?
    var isEditMode = false
    var workoutIdToEdit:String?
    var refreshData:(()->())?
    var scheduleWeekDateVM:DateViewModel! // date to get the schdules for that particular week
    var viewOnly:Bool = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
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
        if viewOnly {
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
        if viewOnly == false {
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
        
        let workoutScheduleDate = Calendar.current.component(.day, from: model.startDate)
        let currentDate = Calendar.current.component(.day, from: Date())
        if workoutScheduleDate <= currentDate{
            let currentHour = Calendar.current.component(.hour, from: Date())
            if model.startTime <= currentHour {
                AlertView.showAlert(with: Constants.Messages.kError, message: Constants.Messages.kCantScheduleAtThisTime)
                return
            }
           
        }
        showLoader()
        ChallengesEndPoint.addSchedule(model: model, isUpdate: isEditMode) { (response) in
            self.hideLoader()
            if let code = response.statusCode ,code >= 200 && code < 300 {
                self.view.makeToast(response.message, duration: 1, position: .bottom) { [weak self](completed) in
                    self?.navigationController?.popToRootViewController(animated: true)
                    self?.refreshData?()
                }
            }else {
                AlertView.showAlert(with: Constants.Messages.kError, message: response.message)
            }
            
        } failure: { (status) in
            self.hideLoader()
            AlertView.showAlert(with: Constants.Messages.kError, message: status.msg)
        }
    }
        
    
    @IBAction func actionWorkoutPlanner(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: Private Methods
extension PlannerScheduleVC {
    
    private func setupData(){
        data.removeAll()
        if self.isEditMode == false && itemToAddEdit != nil{
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
            let arrayOfWorkoutModels = data[schedule.dayOfWeek]
            if let firstIndex = arrayOfWorkoutModels.firstIndex(where: {$0.startTime == Int(schedule.startTime! / 60)}) {
                let model = data[schedule.dayOfWeek][firstIndex]
                model.workoutId = schedule._id
                if itemToAddEdit != nil,itemToAddEdit.id == schedule.workoutId {
                    model.isPreviouslyScheduled = false
                    model.color = UIColor(named: "kThemeBlue")!
                    model.isSelected = true
                }else {
                    model.isPreviouslyScheduled = true
                    model.color = UIColor(named: "kThemeNavyBlue")!
                }
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
        //        cell.lblTitle.text = model.dummyDisplayName//"Workout"
        //        cell.lblTitle.text = model.title
        cell.backgroundColor = model.color
        //cell.imageView.isHidden = model.isSelected == false
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

extension PlannerScheduleVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.planner
    }
}
