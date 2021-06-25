//
//  HIITDetailsPendingStartVC.swift
//  Sway
//
//  Created by Admin on 21/06/21.
//

import UIKit
import ViewControllerDescribable

class HIITDetailsPendingStartVC: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        // Do any additional setup after loading the view.
    }
    

}

extension HIITDetailsPendingStartVC:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HIITDescriptionCell") as! HIITDescriptionCell
                return cell
            }
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HIITVideoItemCell", for: indexPath) as! HIITVideoItemCell
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}

extension HIITDetailsPendingStartVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.challenge
    }
}
