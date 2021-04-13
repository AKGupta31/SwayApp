//
//  ViewController.swift
//  Sway
//
//  Created by Admin on 12/04/21.
//

import UIKit
import ViewControllerDescribable

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.push(SignupVC.self, animated: false, configuration: nil)
        // Do any additional setup after loading the view.
    }

}

