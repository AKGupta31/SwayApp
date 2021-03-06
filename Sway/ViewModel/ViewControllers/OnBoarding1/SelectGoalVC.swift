//
//  SelectGoalVC.swift
//  Sway
//
//  Created by Admin on 12/05/21.
//

import UIKit
import ViewControllerDescribable
import KDCircularProgress

class SelectGoalVC: BaseViewController {
    @IBOutlet weak var mainContainerView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackViewGoals: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressViewInnerCircle: UIView!
    var progress:KDCircularProgress!
    private var isSwipeGestureAdded = false
    
//    typealias GoalModel = (String)
    var goals = ["Lose Weight","Gain Muscle","Get Pre-baby Body Back","Have Fun","Dance More","Get Toned"]
    var selectedCount = 0 {
        didSet {
            if selectedCount > 0 {
                progressViewInnerCircle.backgroundColor = UIColor(named: "kThemeYellow")
                progress.set(colors: UIColor(named: "kThemeBlue")!)
            }else {
                progressViewInnerCircle.backgroundColor = UIColor(named: "k245246250")
                progress.set(colors: UIColor(named: "k124123132")!)
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        getActions()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.scrollView.frame.height > self.mainContainerView.frame.height {
                self.isSwipeGestureAdded = true
                let gesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeUp(_:)))
                self.mainContainerView.isUserInteractionEnabled = true
                gesture.direction = .up
                self.mainContainerView.addGestureRecognizer(gesture)
            }
        }
        // Do any additional setup after loading the view.
    }
    

    @objc func swipeUp(_ gesture:UISwipeGestureRecognizer){
        if gesture.direction == .up && selectedCount > 0 {
            self.getNavController()?.push(OnboardingEndVC.self,pushTransition: .vertical)
        }else if gesture.direction == .down {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func actionSkip(_ sender: UIButton) {
        updateStatus(goals: [])
        self.getNavController()?.push(OnboardingEndVC.self, animated: true, configuration: { (vc) in
            
        })
    }
    
    
    @objc func getActions(){
        var viewIndex = 0
        for subView  in stackViewGoals.subviews {
            if let hStackView = subView as? UIStackView {
                for subView in hStackView.subviews {
                    if let goalView = subView as? GoalOptionView {
                        goalView.model = GoalOptionModel(title: goals[viewIndex])
                        goalView.onClick = {[weak self](goalView) in
                            goalView.isSelected = !goalView.isSelected
                            if goalView.isSelected {
                                self?.selectedCount += 1
                            }else {
                                self?.selectedCount -= 1
                            }
                        }
                    }
                    viewIndex += 1
                }
            }
        }
    }
    
    func getSelectedGoalTitles() -> [String]{
       var goals = [String]()
        for subView  in stackViewGoals.subviews {
            if let hStackView = subView as? UIStackView {
                for subView in hStackView.subviews {
                    if let goalView = subView as? GoalOptionView {
                        if goalView.isSelected {
                            goals.append(goalView.model.title)
                        }
                    }
                }
            }
        }
        return goals
    }
    
    fileprivate func setupTitle(){
        let attributedString = NSMutableAttributedString(string: "What???s \nyour goal?\nMy goal is to...", attributes: [
            .font: UIFont(name: "Poppins-Bold", size: 52.0)!,
            .foregroundColor: UIColor(red: 5.0 / 255.0, green: 9.0 / 255.0, blue: 53.0 / 255.0, alpha: 1.0)
        ])
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 94.0 / 255.0, green: 0.0, blue: 1.0, alpha: 1.0), range: NSRange(location: 6, length: 13))
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
        progress.set(colors: UIColor(named: "k124123132")!)
        progress.trackColor = UIColor(red: 245/255, green: 246/255, blue: 250/255, alpha: 1.0)
        progress.progress = 1
        progressView.insertSubview(progress, at: 0)
        progressViewInnerCircle.backgroundColor = UIColor(named: "k245246250")
    }
    
    func updateStatus(goals:[String]){
        LoginRegisterEndpoint.updateOnboardingScreenStatus(key: "goal", value: goals) { (response) in
            if response.statusCode == 200 {
                SwayUserDefaults.shared.onBoardingScreenStatus = .CHALLENGE_SCREEN
            }
            
        } failure: { (status) in
            
        }

    }
    
}

extension SelectGoalVC:UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        if scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0 {
            print("scroll downward")
            if contentYoffset <= 0.0 {
                self.navigationController?.popViewController(animated: true)
            }
        }else {
            print("scroll upword")
            if selectedCount > 0 {
                let distanceFromBottom = scrollView.contentSize.height - contentYoffset
                if distanceFromBottom <= height {
                    updateStatus(goals: getSelectedGoalTitles())
                    getNavController()?.push(OnboardingEndVC.self,pushTransition: .vertical)
                }else {
                    print("don't call api")
                }
            }
        }
        
    }
}

extension SelectGoalVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.onBoarding
    }
}

