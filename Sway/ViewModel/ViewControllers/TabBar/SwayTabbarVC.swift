//
//  SwayTabbarVC.swift
//  Sway
//
//  Created by Admin on 13/05/21.
//

import UIKit
import ViewControllerDescribable

class SwayTabbarVC: UITabBarController {


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

}

extension SwayTabbarVC {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if selectedIndex == 0 {
            print("selected index ",selectedIndex)
        }
//        if selectedIndex == 0 {
//            self.tabBar.backgroundImage = UIImage()
//            self.tabBar.backgroundColor = UIColor.clear
//        }else {
//            self.tabBar.backgroundColor = UIColor.white
//        }
    }
    
}

extension SwayTabbarVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.onBoarding
    }
}
