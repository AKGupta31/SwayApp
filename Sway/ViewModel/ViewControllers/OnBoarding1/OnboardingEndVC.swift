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
    }
    
    @IBAction func actionCross(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension OnboardingEndVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.onBoarding
    }
}

