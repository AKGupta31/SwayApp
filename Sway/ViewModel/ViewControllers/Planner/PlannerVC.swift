//
//  PlannerVC.swift
//  Sway
//
//  Created by Admin on 03/06/21.
//

import UIKit

class PlannerVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.push(HowManyTimesAWeekVC.self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    
}
