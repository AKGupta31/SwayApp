//
//  HIITDetailsVC.swift
//  Sway
//
//  Created by Admin on 21/06/21.
//

import UIKit
import ViewControllerDescribable

class HIITDetailsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInsetAdjustmentBehavior  = .never
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
        // Do any additional setup after loading the view.
    }
    
}

extension HIITDetailsVC:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HIITDetailsBanner") as! HIITDetailsBanner
                return cell
            }else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HIITDescriptionCell") as! HIITDescriptionCell
                return cell
            }
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HIITItemCell", for: indexPath) as! HIITItemCell
            if indexPath.row == 0 {
                cell.cellType = .completed
            }else if indexPath.row == 1 {
                cell.cellType = .next
            }else {
                cell.cellType = .normal
            }
            cell.lblNumber.text = (indexPath.row + 1).description 
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            self.navigationController?.push(HIITDetailsPendingStartVC.self, animated: true, configuration: { (vc) in
                
            })
        }
    }
    
}

extension HIITDetailsVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.challenge
    }
}
