//
//  AlertView.swift
//  Sway
//
//  Created by Admin on 29/04/21.
//

import UIKit

class AlertView {
    
    static func showAlert(with title:String?,message:String,on viewController:UIViewController? = nil){
        var presentingVC = viewController
        if presentingVC == nil {
            presentingVC = UIApplication.topViewController
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Ok", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action1)
        presentingVC?.present(alert, animated: true, completion: nil)
    }
    
    static func showNoInternetAlert(on viewController:UIViewController? = nil,actionRetry:((UIAlertAction) -> Void)? = nil){
        var presentingVC = viewController
        if presentingVC == nil {
            presentingVC = UIApplication.topViewController
        }
        let alert = UIAlertController(title:Constants.Messages.kError, message: Constants.Messages.kNoInternetConnection, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        let retry = UIAlertAction(title: "Retry", style: .default, handler: actionRetry)
        alert.addAction(ok)
        alert.addAction(retry)
        presentingVC?.present(alert, animated: true, completion: nil)
    }
}
