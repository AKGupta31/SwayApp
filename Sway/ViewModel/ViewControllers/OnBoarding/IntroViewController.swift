//
//  IntroViewController.swift
//  Sway
//
//  Created by Admin on 15/04/21.
//

import UIKit
import ViewControllerDescribable

class IntroViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

extension IntroViewController:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.main
    }
}
