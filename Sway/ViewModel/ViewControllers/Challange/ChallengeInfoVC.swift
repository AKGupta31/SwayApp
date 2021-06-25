//
//  ChallengeInfoVC.swift
//  Sway
//
//  Created by Admin on 21/06/21.
//

import UIKit
import ViewControllerDescribable

class ChallengeInfoVC: BaseViewController {
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblBodyPart: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        lblBodyPart.text = "Butt \u{25FD} " + "Legs \u{25FD} " + "Back"        // Do any additional setup after loading the view.
    }

    @IBAction func actionClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ChallengeInfoVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.challenge
    }
}
