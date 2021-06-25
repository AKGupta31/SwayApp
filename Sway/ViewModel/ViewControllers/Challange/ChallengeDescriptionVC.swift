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
       
        // Do any additional setup after loading the view.
    }
    

    @IBAction func actionJoin(_ sender: UIButton) {
        self.navigationController?.push(WeeklyScheduleViewController.self, animated: true, configuration: { (vc) in
            vc.challengeVM = self.viewModel
        })
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
    
    func challengeCreatedSuccessfully(challenge: ChallengeSchedulesModel) {}

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
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChallengeDescriptionCell", for: indexPath) as! ChallengeDescriptionCell
            cell.setupData(viewModel: self.viewModel)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChallengesListsCell", for: indexPath) as! ChallengesListsCell
            cell.workoutDetailsVMs = viewModel.getWorkoutDetailsVMs()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            return 550
        }
        return UITableView.automaticDimension
    }
    
}

extension ChallengeDescriptionVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.challenge
    }
}
