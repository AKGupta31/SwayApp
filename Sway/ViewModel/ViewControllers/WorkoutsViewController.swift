//
//  WorkoutsViewController.swift
//  Sway
//
//  Created by Admin on 17/06/21.
//

import UIKit

class WorkoutsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.push(ChallengeSelectionVC.self)
    }

}
