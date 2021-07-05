//
//  HowOldVC.swift
//  Sway
//
//  Created by Admin on 11/05/21.
//

import UIKit
import ViewControllerDescribable
import KDCircularProgress

class HowOldVC: BaseViewController {
    @IBOutlet weak var mainContainerView: UIView!
    
    @IBOutlet weak var ageCollectionView: UICollectionView!
//    @IBOutlet weak var mainContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var progressViewInnerCircle: UIView!
    @IBOutlet weak var lblTitle: UILabel!
//    @IBOutlet weak var pickerView: UIPickerView!
   
    @IBOutlet weak var progressView: UIView!
    var progress:KDCircularProgress!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    var items = [Int]()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        // Do any additional setup after loading the view.
        setupTitle()
        for i in 12...80{
            items.append(i)
        }
        
        ageCollectionView.delegate = self
        ageCollectionView.dataSource = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.ageCollectionView.scrollToItem(at: IndexPath(row: 3, section: 0), at: .centeredVertically, animated: false)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.scrollViewDidScroll(self.ageCollectionView)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        mainContainerHeight.constant = 768 + self.view.safeAreaInsets.top
//        pickerView.subviews[1].backgroundColor = UIColor.clear
        if mainContainerView.frame.height < (self.view.frame.height - self.view.safeAreaInsets.top) {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeUp(_:)))
            self.mainContainerView.isUserInteractionEnabled = true
            gesture.direction = .up
            self.mainContainerView.addGestureRecognizer(gesture)
        }
    }
    
    @IBAction func actionQuestionMark(_ sender: UIButton) {
        self.getNavController()?.push(OnboardingStartVC.self, animated: true, configuration: { (vc) in
            vc.videoType = 2
        })
    }
    
    @IBAction func actionSkip(_ sender: UIButton) {
        updateStatus(age: 0)
        self.getNavController()?.push(SelectGoalVC.self)
    }
    
    
    @objc func swipeUp(_ gesture:UISwipeGestureRecognizer){
        if gesture.direction == .up {
            updateStatus(age: 0)
            self.getNavController()?.push(SelectGoalVC.self,pushTransition: .vertical)
        }
    }
    
    fileprivate func setupTitle(){
        let attributedString = NSMutableAttributedString(string: "How old\nare you?\nI am ...", attributes: [
          .font: UIFont(name: "Poppins-Bold", size: 52.0)!,
          .foregroundColor: UIColor(red: 5.0 / 255.0, green: 9.0 / 255.0, blue: 53.0 / 255.0, alpha: 1.0)
        ])
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 94.0 / 255.0, green: 0.0, blue: 1.0, alpha: 1.0), range: NSRange(location: 4, length: 4))
        lblTitle.attributedText = attributedString
        setupProgressView()
    }
    
    fileprivate func setupProgressView(){
        progress = KDCircularProgress(frame:progressView.bounds)
        progress.startAngle = -90
        progress.progressThickness = 0.2
        progress.trackThickness = 0.1
        progress.clockwise = false
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = false
        progress.roundedCorners = true
        progress.glowMode = .noGlow
        progress.set(colors: UIColor(named: "kThemeBlue")!)
        progress.trackColor = UIColor(red: 245/255, green: 246/255, blue: 250/255, alpha: 1.0)
        progress.progress = 0.5
        progressView.insertSubview(progress, at: 0)
        progressViewInnerCircle.backgroundColor = UIColor(named: "kThemeYellow")
    }
    

}


//extension HowOldVC:UIPickerViewDelegate,UIPickerViewDataSource {
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return items.count
//    }
//
//
//
////    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
////        labelPlus1.text = (row + 1).description
////        labelPlus2.text = (row + 2).description
////        labelMinus1.text = (row - 1).description
////        labelMinus2.text = (row - 2).description
////    }
//
//    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//        return 50
//    }
//
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//
//        pickerView.subviews.first?.subviews.last?.backgroundColor = UIColor.white
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width, height: 50))
//        let label = UILabel(frame: view.bounds)
//        let string = items[row].description
//        let attributedString = NSMutableAttributedString(string: string)
//        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Poppins-Bold", size:28)!, range: _NSRange(location: 0, length: string.count))
//        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "kThemeNavyBlue")!, range: _NSRange(location: 0, length: string.count))
//        label.attributedText = attributedString
//        label.textAlignment = .center
//        view.backgroundColor = UIColor.white
//        view.addSubview(label)
//
////        labelPlus1.text = (row + 1).description
////        labelPlus2.text = (row + 2).description
////        labelMinus1.text = (row - 1).description
////        labelMinus2.text = (row - 2).description
//        return view
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
////        labelPlus1.text = (row + 1).description
////        labelPlus2.text = (row + 2).description
////        labelMinus1.text = (row - 1).description
////        labelMinus2.text = (row - 2).description
//        return ""
//    }
//
//
//
//}

extension HowOldVC:UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView != ageCollectionView {
            if scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0 {
                print("scroll downward")
            }else {
                print("scroll upword")
                let height = scrollView.frame.size.height
                let contentYoffset = scrollView.contentOffset.y
                let distanceFromBottom = scrollView.contentSize.height - contentYoffset
                if distanceFromBottom <= height {
                    let selectedRow = ageCollectionView.centerIndexPath?.item ?? 6
                    updateStatus(age: items[selectedRow])
                    self.getNavController()?.push(SelectGoalVC.self,pushTransition: .vertical)
                }else {
                    print("don't call api")
                }
            }
            
        }
        
        
    }
    
    func updateStatus(age:Int){
        LoginRegisterEndpoint.updateOnboardingScreenStatus(key: "age", value: age) { (response) in
            if response.statusCode == 200 {
                SwayUserDefaults.shared.onBoardingScreenStatus = .PROFILE_GOAL
            }
        } failure: { (status) in
            
        }

    }
}


extension HowOldVC:UICollectionViewDataSource,UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCellWithLabelOnly", for: indexPath) as! CarouselCellWithLabelOnly
        cell.lblTitle.text = items[indexPath.row].description
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let textSize = NSAttributedString(string: items[indexPath.row].description, attributes: [NSAttributedString.Key.font:UIFont(name: "CircularStd-Medium", size: 55)!]).size()
//        return CGSize(
        let width = collectionView.frame.width
        return CGSize(width:width, height:width / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: collectionView.frame.height / 2, left: 0, bottom: collectionView.frame.height / 2, right: 0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let totalItems = items.count
        guard let centerIndex = ageCollectionView.centerIndexPath else {return}
        typealias ScaleAndCellIndex = (Int,CGFloat)
        
        let models:[ScaleAndCellIndex] = [(0,1),(-1,0.55),(1,0.55),(-2,0.36),(2,0.36)]
        for scaleModel in models {
            self.updateCell(at: scaleModel.0, to: centerIndex, with: scaleModel.1, totalItems: totalItems)
        }
        
//        if let middleCell = ageCollectionView.getCell(at: 0, to: centerIndex, totalItems: totalItems) as? CarouselCellWithLabelOnly {
//            middleCell.scalePercent = 1.0
//        }
//
//        if let previous1Cell = ageCollectionView.getCell(at: -1, to: centerIndex, totalItems: totalItems) as? CarouselCellWithLabelOnly {
//            previous1Cell.scalePercent = 0.55
//        }
        
//        if let next1Cell = ageCollectionView.getCell(at: 1, to: centerIndex, totalItems: totalItems) as? CarouselCellWithLabelOnly {
//            next1Cell.scalePercent = 0.55
//        }
//        if let previous2Cell = ageCollectionView.getCell(at: -2, to: centerIndex, totalItems: totalItems) as? CarouselCellWithLabelOnly {
//            previous2Cell.scalePercent = 0.36
//        }
//        if let next2Cell = ageCollectionView.getCell(at:2, to: centerIndex, totalItems: totalItems) as? CarouselCellWithLabelOnly {
//            next2Cell.scalePercent = 0.36
//        }
    }
    
    func updateCell(at index:Int,to centerIndex:IndexPath,with scale:CGFloat,totalItems:Int){
        if let cell = ageCollectionView.getCell(at:index, to: centerIndex, totalItems: totalItems) as? CarouselCellWithLabelOnly {
            cell.scalePercent = scale
        }
    }
    
}

extension HowOldVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.onBoarding
    }
}
