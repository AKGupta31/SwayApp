//
//  BaseViewController.swift
//  Sway
//
//  Created by Admin on 13/04/21.
//

import UIKit
import ViewControllerDescribable
import SVProgressHUD

class BaseViewController:UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action:#selector(emptyViewTapped(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(hideLoader), name: Constants.Notifications.hideLoader, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self, name: Constants.Notifications.hideLoader, object: nil)
    }
    
    @objc func showLoader(){
        DispatchQueue.main.async {
            SVProgressHUD.show()
            SVProgressHUD.setDefaultMaskType(.clear)
        }
        
    }
    
    @objc func hideLoader(){
        SVProgressHUD.dismiss()
    }
    
    @objc func emptyViewTapped(_ gesture:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
}


