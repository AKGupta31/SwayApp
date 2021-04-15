//
//  BaseViewController.swift
//  Sway
//
//  Created by Admin on 13/04/21.
//

import UIKit
import ViewControllerDescribable

class BaseViewController:UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action:#selector(emptyViewTapped(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func emptyViewTapped(_ gesture:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
}

