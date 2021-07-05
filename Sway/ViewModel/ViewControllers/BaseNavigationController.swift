//
//  BaseNavigationController.swift
//  Sway
//
//  Created by Admin on 02/07/21.
//

import UIKit
import ViewControllerDescribable

enum PushTransition:Int {
    case vertical = 0
    case horizontal
}

class BaseNavigationController: UINavigationController {

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        
//        let transition:CATransition = CATransition()
//        transition.duration = 0.5
//        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
//        transition.type = CATransitionType.push
//        transition.subtype = CATransitionSubtype.fromTop
//        self.view.layer.add(transition, forKey: kCATransition)
        // Do any additional setup after loading the view.
    }
    
    func push<ViewController>(_ controllerDetails: ViewController.Type, animated: Bool = true,pushTransition:PushTransition = .horizontal, configuration: ((ViewController) -> Void)? = nil) where ViewController : UIViewController, ViewController : ViewControllerDescribable {
        
        if pushTransition == .vertical {
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromTop
            self.view.layer.add(transition, forKey: nil)
        }
        guard let viewController = UIStoryboard(name: controllerDetails.storyboardName).instantiateViewController(withIdentifier: controllerDetails.viewControllerId) as? ViewController else {
            return
        }
        (viewController as? BaseViewController)?.transitionType = pushTransition
        configuration?(viewController)
        
        pushViewController(viewController, animated: animated)
    }

    
    override func popViewController(animated: Bool) -> UIViewController? {
        let vcs = self.viewControllers
        if let secondLastVC = vcs[vcs.count - 1] as? BaseViewController {
            if secondLastVC.transitionType == .vertical {
                let transition:CATransition = CATransition()
                transition.duration = 0.5
                transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
                transition.type = CATransitionType.push
                transition.subtype = CATransitionSubtype.fromBottom
                self.view.layer.add(transition, forKey: kCATransition)
            }
        }
        return super.popViewController(animated: animated)
    }
    

}
