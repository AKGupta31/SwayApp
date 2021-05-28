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
    
    @IBOutlet weak var mainContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var progressViewInnerCircle: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var labelPlus1: UILabel!
    @IBOutlet weak var labelPlus2: UILabel!
    @IBOutlet weak var labelMinus1: UILabel!
    @IBOutlet weak var labelMinus2: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
   
    @IBOutlet weak var progressView: UIView!
    var progress:KDCircularProgress!
    
    var items = [Int]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.tintColor = UIColor.white
        pickerView.backgroundColor = UIColor.white
        pickerView.subviews.first?.backgroundColor = UIColor.white
        pickerView.layer.sublayers?[0].backgroundColor = UIColor.white.cgColor
        
        // Do any additional setup after loading the view.
        setupTitle()
        for i in 12...80{
            items.append(i)
        }
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        mainContainerHeight.constant = 768 + self.view.safeAreaInsets.top
        pickerView.subviews[1].backgroundColor = UIColor.clear
        if mainContainerHeight.constant < (self.view.frame.height - self.view.safeAreaInsets.top) {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeUp(_:)))
            self.mainContainerView.isUserInteractionEnabled = true
            gesture.direction = .up
            self.mainContainerView.addGestureRecognizer(gesture)
        }
    }
    
    @IBAction func actionQuestionMark(_ sender: UIButton) {
        self.navigationController?.push(OnboardingStartVC.self, animated: true, configuration: { (vc) in
            vc.videoType = 2
        })
    }
    
    @IBAction func actionSkip(_ sender: UIButton) {
        updateStatus(age: 0)
        self.navigationController?.push(SelectGoalVC.self)
    }
    
    
    @objc func swipeUp(_ gesture:UISwipeGestureRecognizer){
        if gesture.direction == .up {
            updateStatus(age: 0)
            self.navigationController?.push(SelectGoalVC.self)
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
    

}


extension HowOldVC:UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    
    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        labelPlus1.text = (row + 1).description
//        labelPlus2.text = (row + 2).description
//        labelMinus1.text = (row - 1).description
//        labelMinus2.text = (row - 2).description
//    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        pickerView.subviews.first?.subviews.last?.backgroundColor = UIColor.white
        let view = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width, height: 50))
        let label = UILabel(frame: view.bounds)
        let string = items[row].description
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Poppins-Bold", size:28)!, range: _NSRange(location: 0, length: string.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "kThemeNavyBlue")!, range: _NSRange(location: 0, length: string.count))
        label.attributedText = attributedString
        label.textAlignment = .center
        view.backgroundColor = UIColor.white
        view.addSubview(label)
        
//        labelPlus1.text = (row + 1).description
//        labelPlus2.text = (row + 2).description
//        labelMinus1.text = (row - 1).description
//        labelMinus2.text = (row - 2).description
        return view
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        labelPlus1.text = (row + 1).description
        labelPlus2.text = (row + 2).description
        labelMinus1.text = (row - 1).description
        labelMinus2.text = (row - 2).description
        return ""
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
        progress.set(colors: UIColor(named: "k124123132")!)
        progress.trackColor = UIColor(red: 245/255, green: 246/255, blue: 250/255, alpha: 1.0)
        progress.progress = 0.5
        progressView.insertSubview(progress, at: 0)
        progressViewInnerCircle.backgroundColor = UIColor(named: "k245246250")
    }
  
}

extension HowOldVC:UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0 {
            print("scroll downward")
        }else {
            print("scroll upword")
            let height = scrollView.frame.size.height
            let contentYoffset = scrollView.contentOffset.y
            let distanceFromBottom = scrollView.contentSize.height - contentYoffset
            if distanceFromBottom <= height {
                let selectedRow = pickerView.selectedRow(inComponent: 0)
                updateStatus(age: items[selectedRow])
                self.navigationController?.push(SelectGoalVC.self)
            }else {
                print("don't call api")
            }
        }
        
        
    }
    
    func updateStatus(age:Int){
        
        LoginRegisterEndpoint.updateOnboardingScreenStatus(key: "age", value: age) { (response) in
            if response.statusCode == 200 {
                SwayUserDefaults.shared.onBoardingScreenStatus = .PROFILE_AGE
            }
        } failure: { (status) in
            
        }

    }
}

extension HowOldVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.onBoarding
    }
}
