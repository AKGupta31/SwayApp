//
//  WorkoutEndAlertVC.swift
//  Sway
//
//  Created by Admin on 22/06/21.
//

import UIKit
import ViewControllerDescribable
import KDCircularProgress

class WorkoutEndAlertVC: BaseViewController {

    @IBOutlet weak var progressViewInnerCircle: CustomView!
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var lblProgress: UILabel!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var lblEndYourWorkout: UILabel!
    @IBOutlet weak var lblAreYouSure: UILabel!
    
    
    var actionResume:((WorkoutEndAlertVC,UIButton?)->())?
    var actionQuit:((WorkoutEndAlertVC,UIButton?)->())?
    
    var progress:KDCircularProgress!
    var timer:Timer!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupProgressView()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(actionTimer(_:)), userInfo: nil, repeats: true)
    }
    
    var i = 10
    var progressCount:Double = 0
    @objc func actionTimer(_ timer:Timer){
        i -= 1
        progressCount += 1
        if i <= 0{
            timer.invalidate()
            self.dismiss(animated: true, completion: nil)
            self.actionQuit?(self,nil)
        }
        lblProgress.text = i.description
        progress.animate(toAngle: 36 * progressCount, duration: 1, completion: nil)
        
    }
    
    func setupLabels(){
        let attributedString = NSMutableAttributedString(string: "Are you sure you want  to end your workout?", attributes: [
          .font: UIFont(name: "Poppins-Bold", size: 36.0)!,
          .foregroundColor: UIColor(white: 1.0, alpha: 1.0)
        ])
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 222.0 / 255.0, green: 239.0 / 255.0, blue: 6.0 / 255.0, alpha: 1.0), range: NSRange(location: 26, length: 17))
        lblAreYouSure.attributedText = attributedString
    }
    

    @IBAction func actionResume(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.actionResume?(self,sender)
    }
    
    @IBAction func actionQuit(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.actionQuit?(self,sender)
    }
    
    fileprivate func setupProgressView(){
        progress = KDCircularProgress(frame:progressView.bounds)
        progress.startAngle = -90
        progress.progressThickness = 0.2
        progress.trackThickness = 0.05
        progress.clockwise = true
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = false
        progress.roundedCorners = true
        progress.glowMode = .noGlow
        progress.set(colors: UIColor(named: "kThemeBlue")!)
        progress.trackColor = UIColor(named: "k124123132")!
        progress.progress = 0
        progressView.insertSubview(progress, at: 0)
        progressViewInnerCircle.backgroundColor = UIColor(named: "kThemeYellow")
    }
    
}


extension WorkoutEndAlertVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.challenge
    }
}
