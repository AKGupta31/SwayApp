//
//  HIITDetailsVC.swift
//  Sway
//
//  Created by Admin on 21/06/21.
//

import UIKit
import ViewControllerDescribable
import SDWebImage

class HIITDetailsVC: BaseViewController {
    @IBOutlet weak var btnContinue: CustomButton!
    
    
    var viewModel:WorkoutDetailsViewModel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        tableView.contentInsetAdjustmentBehavior  = .never
        edgesForExtendedLayout = [.bottom]
        extendedLayoutIncludesOpaqueBars = true
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
        
        // Do any additional setup after loading the view.
        showLoader()
        viewModel.delegate = self
        viewModel.getDetails()
    }
    
    @IBAction func actionContinue(_ sender: UIButton) {
        let numberOfRows = viewModel.getNumberOfRows(in: 1)
        if viewModel.lastSeenItemIndex + 1 == numberOfRows {
            self.getNavController()?.push(RateChallengeVC.self, animated: true, configuration: { (vc) in
                vc.workoutId = self.viewModel.workoutId
                vc.challengeId = self.viewModel.challengeId
            })
        }else {(
            self.tableView(self.tableView, didSelectRowAt: IndexPath(row: viewModel.lastSeenItemIndex + 1, section: 1)))
            print("continue")
        }
    
       
    }
    
    
    
}

extension HIITDetailsVC :WorkoutDetailsViewModelDelegate {
    func reloadData() {
        hideLoader()
        tableView.reloadData()
    }
    
    func showAlert(with title: String?, message: String) {
        hideLoader()
        AlertView.showAlert(with: title, message: message)
    }
    
    
}

extension HIITDetailsVC:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let numberOfRows = viewModel.getNumberOfRows(in: 1)
      //  btnContinue.isEnabled = viewModel.lastSeenItemIndex >= numberOfRows - 1
//        btnContinue.backgroundColor = UIColor(named: "kThemeYellow")?.withAlphaComponent(btnContinue.isEnabled ? 1.0 : 0.6)
        return viewModel.getNumberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HIITDetailsBanner") as! HIITDetailsBanner
                cell.lblType.text = viewModel.workoutType.displayString
                cell.lblIntensity.text = viewModel.intensity.displayName
                cell.lblTitle.text = viewModel.title
                cell.imgBanner.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.imgBanner.sd_setImage(with: viewModel.bannerImageUrl, completed: nil)
                cell.btnBack.addTarget(self, action: #selector(actionBack(_:)), for: .touchUpInside)
                cell.backButtonTopConstraint.constant = self.view.safeAreaInsets.top + 8
                return cell
            }else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HIITDescriptionCell") as! HIITDescriptionCell
                viewModel.setupCell(cell: cell)
                return cell
            }
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HIITItemCell", for: indexPath) as! HIITItemCell
            viewModel.setupCell(cell: cell, indexPath: indexPath)
//            if indexPath.row == 0 {
//                cell.cellType = .next
//            }else {
//                cell.cellType = .normal
//            }
//            if indexPath.row == 0 {
//                cell.cellType = .completed
//            }else if indexPath.row == 1 {
//                cell.cellType = .next
//            }else {
//                cell.cellType = .normal
//            }
            
            return cell
        }
        
        return UITableViewCell()
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 && indexPath.section == 0{
            return tableView.frame.width
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == viewModel.lastSeenItemIndex + 1 {
            if let contentVM = viewModel.getContentVM(at: indexPath.row) {
                self.getNavController()?.push(HIITDetailsPendingStartVC.self, animated: true, configuration: { (vc) in
                    vc.viewModel = contentVM
                    vc.startWorkoutVCDelegate = self
                })
            }
        }
    }
    
    @objc func actionBack(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension HIITDetailsVC:StartWorkoutVCDelegate {
    func markWorkoutAsViewed(workoutId: String, circuitId: String) {
        viewModel.markWorkoutAsViewed(workoutId: workoutId, circuitId: circuitId)
    }
}

extension HIITDetailsVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.challenge
    }
}
