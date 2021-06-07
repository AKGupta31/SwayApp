//
//  SocialLoginManager.swift
//  Sway
//
//  Created by Admin on 19/04/21.
//


import Foundation
import UIKit

class SocialLoginManager {
    func showAlertViewForEmail(viewController: UIViewController, successHandler: @escaping (String) -> Void, failureHandler: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: "log_in_sign_in".localized, message: "log_in_popup_email_message".localized, preferredStyle: .alert)

        let saveAction = UIAlertAction(title: "log_in_sign_in".localized, style: .default, handler: {
            alert -> Void in

            let emailTextField = alertController.textFields![0] as UITextField

            guard let email = emailTextField.text else {failureHandler("log_in_popup_no_email_message".localized); return}

            successHandler(email)
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            failureHandler("log_in_popup_no_email_message".localized)
        })

        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "log_in_email_hint".localized
        }

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        viewController.present(alertController, animated: true, completion: nil)
    }

    func error(withMessage message: String) {
        DataManager.shared.isLoggedIn = false
        if let topVc = UIApplication.topViewController {
            AlertView.showAlert(with: "Error", message: message, on: topVc)
        }
        
    }
}
