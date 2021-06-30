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
    
    var viewModel:WorkoutContentsVM!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = [.bottom]
        extendedLayoutIncludesOpaqueBars = true
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func actionStartWarmup(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension HIITDetailsPendingStartVC:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HIITDescriptionCell") as! HIITDescriptionCell
                viewModel.setupHeaderCell(cell: cell)
                cell.btnBack.addTarget(self, action: #selector(actionBack(_:)), for: .touchUpInside)
                return cell
            }
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HIITVideoItemCell", for: indexPath) as! HIITVideoItemCell
            viewModel.setupCell(cell: cell, for: indexPath)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func actionBack(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension HIITDetailsPendingStartVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.challenge
    }
}
