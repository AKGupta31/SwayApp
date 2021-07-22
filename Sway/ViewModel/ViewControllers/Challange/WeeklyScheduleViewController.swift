//
//  WeeklyScheduleView.swift
//  ShimmerAnimationComplete
//
//  Created by Admin on 14/06/21.
//  Copyright © 2021 Jha, Vasudha. All rights reserved.
//

import UIKit
import ViewControllerDescribable
class WeeklyScheduleViewController: BaseViewController,KDDragAndDropCollectionViewDataSource {
    @IBOutlet weak var verticalLinesView: UIView!
    @IBOutlet weak var btnNext: CustomButton!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var collectionViewDragItemsHeight: NSLayoutConstraint!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var daysStackView: UIStackView!
    @IBOutlet weak var hoursView: UIView!
    @IBOutlet weak var collectionViewDragItems: KDDragAndDropCollectionView!
    
    @IBOutlet weak var stackViewCVs: UIStackView!
    @IBOutlet var collectionsViews:[KDDragAndDropCollectionView]!
    private var dragAndDropManager : KDDragAndDropManager?
    var data : [[WorkoutModel]] = [[WorkoutModel]]()
    
    var challengeVM:ChallengeViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = [.bottom]
        extendedLayoutIncludesOpaqueBars = true
        challengeVM.delegate = self
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.setupVerticalLines()
            self.setupHourLabels()
            self.setupDaysLabels()
            self.shadowView.addShadow(shadowColor: UIColor(named: "kThemeNavyBlue")!.cgColor, shadowOffset: CGSize(width: 0, height: 3), shadowOpacity: 0.1, shadowRadius: 8.0)
            self.collectionsViews.forEach({$0.reloadData()})
        }
        
        lblDescription.text = "Drag and drop your \(challengeVM.weeklyWorkoutCount) workouts to the times you will work out. You can change this any time"
        btnNext.isUserInteractionEnabled = false
        btnNext.backgroundColor = UIColor(named: "kThemeYellow")?.withAlphaComponent(0.6)
        
    }

    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionNext(_ sender: UIButton) {
        var schedules = [Schedules]()
        if collectionViewDragItems.numberOfItems(inSection: 0) <= challengeVM.weeklyWorkoutCount {
            for (collectionIndex,collectionView) in self.data.enumerated() {
                for (timeIndex,workoutModel) in collectionView.enumerated() {
                    if workoutModel.isSelected {
                        var scheduleDic :[String:Any] = ["workoutId":workoutModel.workoutId ?? ""]
                        scheduleDic["startTime"] = (timeIndex + 5)
                        scheduleDic["endTime"] = (timeIndex + 5 + 1)
                        
                        if let schedule = Schedules(dictionary: NSDictionary(dictionary: scheduleDic)) {
                            schedule.dayOfTheWeek = collectionIndex
                            schedules.append(schedule)
                        }
                    }
                }
            }
            showLoader()
            challengeVM.createChallenge(schedules: schedules, isSkip: false)
        }
    }
    
    @IBAction func actionSkip(_ sender: UIButton) {
        showLoader()
        challengeVM.createChallenge(schedules: [Schedules](), isSkip: true)
    }
    
    
    
}

extension WeeklyScheduleViewController:ChallengeViewModelDelegate {
    func reloadData() {}
    func showAlert(with title: String?, message: String) {
        hideLoader()
        AlertView.showAlert(with: title, message: message)
    }
    
    func challengeCreatedSuccessfully(challenge: ChallengeSchedulesModel,isSkip:Bool) {
        hideLoader()
        self.getNavController()?.push(SyncWithCalenderVC.self, animated: true, configuration: { (vc) in
            vc.schedulesModel = challenge
//            vc.challengeTitle = self.challengeVM.title ?? ""
//            vc.numberOfWeeks = self.challengeVM.weeksCount ?? 0
            vc.screenType = isSkip ? .challengeAccepted : .syncWithCalendar
            vc.challengeVM = self.challengeVM
        })
    }
}
//MARK: Private Methods
extension WeeklyScheduleViewController {
    
    private func setupData(){
        if let workoutDetailsVM = challengeVM.getWorkoutListVMs().first {
            self.data.append(workoutDetailsVM.getWorkoutModels())
        }
//        self.data.append(items1)
        let totalItems = 18
        for _ in 0..<7{
            var items2 = [WorkoutModel]()
            for i in  0..<totalItems {
                items2.append(WorkoutModel(id:i , color: UIColor.clear))
            }
            data.append(items2)
        }
    }
    
   private func setupVerticalLines(){
        var x :CGFloat = 0
    let spacing:CGFloat = stackViewCVs.frame.width / 7
        repeat {
            let layer = CALayer()
            layer.frame = CGRect(x: x, y: 0, width: 1, height: verticalLinesView.frame.height)
            layer.backgroundColor = UIColor(named: "kThemeNavyBlue_10")?.cgColor
            x +=  spacing
            verticalLinesView.layer.insertSublayer(layer, at: 0)
        }while (floor(x + spacing) <= verticalLinesView.frame.width)
    }
    
    
   private func setupDaysLabels(){
        self.daysStackView.subviews.forEach { (view) in
            view.backgroundColor = UIColor.clear
            if let label = view as? UILabel {
                label.font = UIFont(name: "CircularStd-Bold", size: 12)
                label.textColor = UIColor(named: "kThemeNavyBlue")
            }
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

extension WeeklyScheduleViewController:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
                if let
                    draggingPathOfCellBeingDragged = kdCollectionView.draggingPathOfCellBeingDragged {
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
        cell.imageView.isHidden = model.isSelected == false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewDragItems {
            if let image = UIImage(named: "ic_workout_small") {
                return CGSize(width: image.size.width + 26, height: 36)
            }
            return CGSize(width: 52, height: 36)
        }
        let width :CGFloat = stackViewCVs.frame.width / 7
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
extension WeeklyScheduleViewController {
    func collectionView(_ collectionView: UICollectionView, dataItemForIndexPath indexPath: IndexPath) -> AnyObject {
        print(#function)
        return data[collectionView.tag][indexPath.item]
    }
    func collectionView(_ collectionView: UICollectionView, insertDataItem dataItem : AnyObject, atIndexPath indexPath: IndexPath) -> Void {
        print(#function)
            if let di = dataItem as? WorkoutModel {
                data[collectionView.tag].insert(di, at: indexPath.row)
            }
    }
    func collectionView(_ collectionView: UICollectionView, deleteDataItemAtIndexPath indexPath : IndexPath) -> Void {
        print(#function)
        data[collectionView.tag].remove(at: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, moveDataItemFromIndexPath from: IndexPath, toIndexPath to : IndexPath) -> Void {
        print(#function)
        let fromDataItem: WorkoutModel = data[collectionView.tag][from.item]
        data[collectionView.tag].remove(at: from.item)
        data[collectionView.tag].insert(fromDataItem, at: to.item)
        btnNext.isUserInteractionEnabled = true
        btnNext.backgroundColor = UIColor(named: "kThemeYellow")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, indexPathForDataItem dataItem: AnyObject) -> IndexPath? {
        
        print(#function)
        guard let candidate = dataItem as? WorkoutModel else { return nil }
        
        for (i,item) in data[collectionView.tag].enumerated() {
            if candidate != item { continue }
            return IndexPath(item: i, section: 0)
        }
        return nil
    }
    
    func collectionView(_ collectionView: UICollectionView, cellIsDraggableAtIndexPath indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, cellIsDroppableAtIndexPath indexPath: IndexPath) -> Bool {
//        if collectionView == collectionViewDragItems {
//            return false
//        }
//        let isAlreadyExistsAnotherElement = data[collectionView.tag].first(where: {$0.isSelected})?.isSelected
//        print(" is exists ",isAlreadyExistsAnotherElement)
//        let model = data[collectionView.tag][indexPath.row]
//        if model.rowTag != collectionView.tag{
//            return false
//        }
        print("collection view tag",collectionView.tag)
        return true
    }
    
}
extension WeeklyScheduleViewController:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.challenge
    }
}
