//
//  ChallengeDescriptionVC.swift
//  Sway
//
//  Created by Admin on 08/06/21.
//

import UIKit
import ViewControllerDescribable

class ChallengeDescriptionVC: BaseViewController {

    @IBOutlet weak var mainTableView: UITableView!
    
    var viewModel:ChallengeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.contentInsetAdjustmentBehavior  = .never
        edgesForExtendedLayout = [.bottom]
        extendedLayoutIncludesOpaqueBars = true
        if viewModel != nil {
            viewModel.delegate = self
            showLoader()
            viewModel.getDetails()
        }
        mainTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
       
        // Do any additional setup after loading the view.
    }
    

    @IBAction func actionJoin(_ sender: UIButton) {
        if Api.isConnectedToNetwork() {
            if let workoutDetailsVM = viewModel.getWorkoutListVMs().first ,workoutDetailsVM.getWorkoutModels().count > 0{
                self.getNavController()?.push(WeeklyScheduleViewController.self, animated: true, configuration: { (vc) in
                    vc.challengeVM = self.viewModel
                })
            }else {
                if viewModel != nil {
                    showLoader()
                    viewModel.getDetails { [weak self] in
                        self?.reloadData()
                        self?.actionJoin(sender)
                    }
                }
            }
        }else {
            AlertView.showNoInternetAlert(on: self) { [weak self ](action) in
                self?.actionJoin(sender)
            }
        }
        
        
        
    }
    

}

extension ChallengeDescriptionVC:ChallengeViewModelDelegate {
    func reloadData() {
        hideLoader()
        self.mainTableView.reloadData()
    }
    
    func showAlert(with title: String?, message: String) {
        hideLoader()
        AlertView.showAlert(with: title, message: message)
    }
    
    func challengeCreatedSuccessfully(challenge: ChallengeSchedulesModel,isSkip:Bool) {}

}

extension ChallengeDescriptionVC:UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChallengeBannerCell", for: indexPath) as! ChallengeBannerCell
            cell.setupData(viewModel: self.viewModel)
            cell.btnBack.addTarget(self, action: #selector(actionBack(_:)), for: .touchUpInside)
            cell.btnCross.addTarget(self, action: #selector(actionBack(_:)), for: .touchUpInside)
            cell.backButtonTopConstraint.constant = self.view.safeAreaInsets.top + 8
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChallengeDescriptionCell", for: indexPath) as! ChallengeDescriptionCell
            cell.setupData(viewModel: self.viewModel)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChallengesListsCell", for: indexPath) as! ChallengesListsCell
            cell.workoutListsVMs = viewModel.getWorkoutListVMs()
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            return CGFloat((viewModel.weeklyWorkoutCount * 121) + 65)
        }
        return UITableView.automaticDimension
    }
    
    @objc func actionBack(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
}


//MARK: Challenge Cell Item Delegate
extension ChallengeDescriptionVC:WeekwiseChallengesCellDelegate {
    func viewDetails(viewModel: WorkoutViewModel) {
        if let workoutId = viewModel.id {
            self.getNavController()?.push(HIITDetailsVC.self, animated: true, configuration: { (vc) in
                vc.viewModel = WorkoutDetailsViewModel(workoutId: workoutId,challengeId:viewModel.challengeId
                )
            })
        }else {
            showAlert(with: "Error!", message: "No workout found")
        }
       
    }
}

extension ChallengeDescriptionVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.challenge
    }
}
