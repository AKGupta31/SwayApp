//
//  OnboardingEndVC.swift
//  Sway
//
//  Created by Admin on 12/05/21.
//

import UIKit
import ViewControllerDescribable

class OnboardingEndVC: BaseViewController {

    @IBOutlet weak var lblTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func actionViewMyChallange(_ sender: UIButton) {
        updateStatus()
        self.getNavController()?.push(SwayTabbarVC.self)
    }
    
    @IBAction func actionCross(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateStatus(){
        LoginRegisterEndpoint.updateOnboardingScreenStatus(key: "isChallengeScreenSeen", value: true) { (response) in
            if response.statusCode == 200 {
                SwayUserDefaults.shared.onBoardingScreenStatus = .HOME_SCREEN
            }
        } failure: { (status) in
            
        }
    }
}


extension OnboardingEndVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.onBoarding
    }
}

