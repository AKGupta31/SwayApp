//
//  HomeVC.swift
//  Sway
//
//  Created by Admin on 06/05/21.
//

import UIKit
import ViewControllerDescribable

class HomeVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionOut(_ sender: UIButton) {
        DataManager.shared.setLoggedInUser(user: nil)
        let navigationController = UINavigationController(rootViewController: LoginVC.instantiated())
        navigationController.setNavigationBarHidden(true, animated: false)
        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate{
            sceneDelegate.window?.rootViewController = navigationController
        }
    }
    


}

extension HomeVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.main
    }
}
