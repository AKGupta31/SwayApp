//
//  UIApplication+Ext.swift
//  Sway
//
//  Created by Admin on 19/04/21.
//

import UIKit

extension UIApplication {
    static var topViewController:UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
    
}
