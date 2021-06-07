//
//  SyncWithCalenderVC.swift
//  Sway
//
//  Created by Admin on 04/06/21.
//

import UIKit
import ViewControllerDescribable

class SyncWithCalenderVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension SyncWithCalenderVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.challenge
    }
}
