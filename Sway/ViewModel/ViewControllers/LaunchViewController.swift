//
//  ViewController.swift
//  Sway
//
//  Created by Admin on 12/04/21.
//

import UIKit
import ViewControllerDescribable

class LaunchViewController: BaseViewController {

    var completion:((LaunchViewController)->())?
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.completion?(self)
        }
    }

}

extension LaunchViewController:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.main
    }
}
