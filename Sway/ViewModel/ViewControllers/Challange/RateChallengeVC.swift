//
//  RateChallengeVC.swift
//  Sway
//
//  Created by Admin on 12/07/21.
//

import UIKit
import ViewControllerDescribable

enum Ratings:Int {
    case hard = 1
    case impossible = 2
    case justPerfect = 3
    case good = 4
    case great = 5
    
    var displayName:String {
        switch self {
        case .hard:
            return "Hard"
        case .impossible:
            return "Impossible"
        case .justPerfect:
            return "Just perfect"
        case .good:
            return "Good"
        case .great:
            return "Great"
        }
    }
    
}

class RateChallengeVC: BaseViewController {

    @IBOutlet weak var rateSlider: UISlider!
    @IBOutlet weak var lblTitle: UILabel!
    let step :Double = 1
    var ratings:Ratings = .justPerfect {
        didSet {
            lblRatings.text = ratings.displayName
        }
        
    }
    
    @IBOutlet weak var lblRatings: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    var workoutId:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        rateSlider.setThumbImage(UIImage(named: "ic_rateslider_thumb"), for: .normal)
        rateSlider.setMinimumTrackImage(UIImage(), for: .normal)
        rateSlider.setMaximumTrackImage(UIImage(), for: .normal)
        self.rateSlider.value = 3
        rateSlider.addTarget(self, action: #selector(sliderDidChangeValue(_:)), for: .valueChanged)
        ratings = .justPerfect
        setupLabel()
        // Do any additional setup after loading the view.
    }
    
    func setupLabel(){
        let attributedString = NSMutableAttributedString(string: "How was \n your workout?", attributes: [
            .font: UIFont(name: "Poppins-Bold", size: 52.0)!,
            .foregroundColor: UIColor(named: "kThemeNavyBlue")!
        ])
        attributedString.addAttribute(.foregroundColor, value: UIColor(named: "kThemeBlue")!, range: NSRange(location: 7, length: 12))
        lblTitle.attributedText = attributedString
    }
    
    @objc func sliderDidChangeValue(_ slider:UISlider){
        let roundedStepValue = round(Double(slider.value) / step) * step
        slider.value = Float(roundedStepValue)
        let intVal = Int(roundedStepValue)
        if let ratings = Ratings(rawValue: intVal){
            self.ratings = ratings
        }
    }
    
    
    @IBAction func actionFinish(_ sender: UIButton) {
        if workoutId.isEmpty == false {
            showLoader()
            ChallengesEndPoint.rateWorkout(for: self.workoutId, rating: ratings) {[weak self] (response) in
                self?.hideLoader()
                if let statusCode = response.statusCode, statusCode >= 200 && statusCode < 300 {
                    if let secondVCInNavigationStack = self?.navigationController?.viewControllers[2] {
                        self?.navigationController?.popToViewController(secondVCInNavigationStack, animated: true)
                    }
                   
                }else {
                    AlertView.showAlert(with: Constants.Messages.kError, message: response.message)
                }
            } failure: { [weak self](status) in
                self?.hideLoader()
                AlertView.showAlert(with: Constants.Messages.kError, message: status.msg)
            }

        }
    }
    
    @IBAction func actionCross(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension RateChallengeVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.challenge
    }
}
