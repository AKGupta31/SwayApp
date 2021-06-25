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
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var collectionViewDragItemsHeight: NSLayoutConstraint!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var daysStackView: UIStackView!
    @IBOutlet weak var hoursView: UIView!
    @IBOutlet weak var collectionViewDragItems: KDDragAndDropCollectionView!
    
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
        self.dragAndDropManager = KDDragAndDropManager(
            canvas: self.view,
            collectionViews: cvs
        )
        self.bottomView.addShadow(shadowColor: UIColor(named: "kThemeNavyBlue")!.cgColor, shadowOffset: CGSize(width: 0, height: -2), shadowOpacity: 0.25, shadowRadius: 5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.setupVerticalLines()
            self.setupHourLabels()
            self.setupDaysLabels()
            self.shadowView.addShadow(shadowColor: UIColor(named: "kThemeNavyBlue")!.cgColor, shadowOffset: CGSize(width: 0, height: 3), shadowOpacity: 0.1, shadowRadius: 8.0)
        }
    }

    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionNext(_ sender: UIButton) {
        var schedules = [Schedules]()
        if collectionViewDragItems.numberOfItems(inSection: 0) <= 0 {
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
            challengeVM.createChallenge(schedules: schedules)
        }
    }
    
    @IBAction func actionSkip(_ sender: UIButton) {
        
    }
    
    
    
}

extension WeeklyScheduleViewController:ChallengeViewModelDelegate {
    func reloadData() {}
    func showAlert(with title: String?, message: String) {
        hideLoader()
        AlertView.showAlert(with: title, message: message)
    }
    
    func challengeCreatedSuccessfully(challenge: ChallengeSchedulesModel) {
        hideLoader()
        self.navigationController?.push(SyncWithCalenderVC.self, animated: true, configuration: { (vc) in
            vc.schedulesModel = challenge
            vc.challengeTitle = self.challengeVM.title ?? ""
            vc.numberOfWeeks = self.challengeVM.weeksCount ?? 0
        })
    }
}
//MARK: Private Methods
extension WeeklyScheduleViewController {
    
    private func setupData(){
        if let workoutDetailsVM = challengeVM.getWorkoutDetailsVMs().first {
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
        let spacing:CGFloat = 56
        repeat {
            let layer = CALayer()
            layer.frame = CGRect(x: x, y: 0, width: 1, height: verticalLinesView.frame.height)
            layer.backgroundColor = UIColor.lightGray.cgColor
            x +=  spacing
            verticalLinesView.layer.insertSublayer(layer, at: 0)
        }while (x + spacing <= verticalLinesView.frame.width)
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
            collectionView.backgroundColor = UIColor.yellow
        }
        return data[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewDragItems {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DragItemCell", for: indexPath) as! DragItemCell
            cell.lblTitle.text = "Workout"
            cell.backgroundColor = UIColor.random()
//            cell.lblTitle.text = data[collectionView.tag][indexPath.item].title
            cell.viewContent.backgroundColor = data[collectionView.tag][indexPath.item].color
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
        cell.lblTitle.text = "Workout"
//        cell.lblTitle.text = model.title
            cell.backgroundColor = model.color
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewDragItems {
            return CGSize(width: 88, height: 36)
        }
        let width :CGFloat = 56
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
