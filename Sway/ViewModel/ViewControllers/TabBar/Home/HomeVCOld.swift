//
//  HomeVCOld.swift
//  Sway
//
//  Created by Admin on 21/05/21.
//

import UIKit
import ViewControllerDescribable

class HomeVCOld: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionSignout(_ sender: UIButton) {
        DataManager.shared.setLoggedInUser(user: nil)
        if var viewControllers = self.navigationController?.viewControllers {
            viewControllers.removeAll()
            viewControllers.append(LoginVC.instantiated())
            self.navigationController?.setViewControllers(viewControllers, animated: true)
        }
        
    }
    
    

}

extension HomeVCOld :ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.main
    }
}
