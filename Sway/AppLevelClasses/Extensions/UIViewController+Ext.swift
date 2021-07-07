//
//  UIViewController+Ext.swift
//  Sway
//
//  Created by Admin on 28/05/21.
//

import UIKit
@available(iOS 13.0, *)
extension UIViewController {
    @objc override var scene: UIScene? {
        // Try walking the responder chain
        var res = self.next?.scene
        if (res == nil) {
            // That didn't work. Try asking my parent view controller
            res = self.parent?.scene
        }
        if (res == nil) {
            // That didn't work. Try asking my presenting view controller
            res = self.presentingViewController?.scene
        }

        return res
    }
}

@available(iOS 13.0, *)
extension UIScene {
    @objc override var scene: UIScene? {
        return self
    }
}

@available(iOS 13.0, *)
extension UIResponder {
    @objc var scene: UIScene? {
        return nil
    }
}

extension UIViewController {
    var isModal: Bool {
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            return true
        } else if let navigationController = navigationController, navigationController.presentingViewController?.presentedViewController == navigationController {
            return true
        } else if let tabBarController = tabBarController, tabBarController.presentingViewController is UITabBarController {
            return true
        } else {
            return false
        }
    }
}
