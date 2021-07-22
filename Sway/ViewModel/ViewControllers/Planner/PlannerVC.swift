//
//  PlannerVC.swift
//  Sway
//
//  Created by Admin on 03/06/21.
//

import UIKit

class PlannerVC: BaseViewController {
    
    
    @IBOutlet weak var tableViewSchedules: UITableView!
    @IBOutlet weak var lblSelectedItemDate: UILabel!
    @IBOutlet weak var datesCollectionView: UICollectionView!
    var viewModel:PlannerViewModel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoader()
        viewModel = PlannerViewModel(delegate: self)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
//        self.navigationController?.push(ChallengeDescriptionVC.self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    @IBAction func actionWorkoutPlanner(_ sender: UIButton) {
        self.navigationController?.present(PlannerScheduleVC.self, navigationEnabled: false, animated: true, configuration: { (vc) in
            let vm = self.viewModel.getDateViewModel(at: IndexPath(row: self.viewModel.selectedDateIndex, section: 0))
            vc.scheduleWeekDateVM = vm
            vc.modalPresentationStyle = .fullScreen
            vc.viewOnly = true
        }, completion: nil)
    }
    
    
}

extension PlannerVC:UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? (viewModel.numberOfSchedules > 0 ? viewModel.numberOfSchedules : 1) : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlannerItemCell") as! PlannerItemCell
            let numberOfScedules = viewModel.numberOfSchedules
            cell.viewContent.isHidden = numberOfScedules <= 0
            cell.emptyPlannerView.isHidden = numberOfScedules > 0
            return cell
        }
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        let addToPlannerButton = CustomButton()
        addToPlannerButton.backgroundColor = UIColor(named: "kThemeYellow")
        addToPlannerButton.setTitle("ADD TO PLANNER", for: .normal)
        addToPlannerButton.setTitleColor(UIColor(named: "kThemeNavyBlue"), for: .normal)
        addToPlannerButton.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 14)
        addToPlannerButton.cornerRadius = 8.05
        cell.addSubview(addToPlannerButton)
        addToPlannerButton.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview().inset(16)
            maker.top.equalToSuperview().inset(10)
            maker.bottom.equalToSuperview().inset(10)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? viewModel.numberOfSchedules > 0 ? UITableView.automaticDimension : 183 : 77
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            self.getNavController()?.push(PlannerWorkoutsVC.self, animated: true, pushTransition: .horizontal, configuration: { (vc) in
                
            })
        }
    }
}

extension PlannerVC:PlannerViewModelDelegate {
    func reloadDates(isInitial: Bool, currentDateIndex: Int) {
        self.datesCollectionView.reloadData()
        if isInitial {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                self.datesCollectionView.scrollToItem(at: IndexPath(row: currentDateIndex, section: 0), at: .left, animated: false)
            }
        }
    }
    
    func reloadData() {
        self.hideLoader()
        tableViewSchedules.reloadData()
    }
    
    func showAlert(with title: String?, message: String) {
        AlertView.showAlert(with: title, message: message,on: self)
    }
}

extension PlannerVC:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfDates
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
        let dateVM = viewModel.getDateViewModel(at: indexPath)
        cell.setupData(dateVM: dateVM)
        cell.type = indexPath.row == viewModel.selectedDateIndex ? .selectedItem : indexPath.row == viewModel.currentDateIndex ? .currentDate : .normal
//        if indexPath.row == viewModel.selectedDateIndex {
//            cell.viewContent.backgroundColor = UIColor(named: "kThemeBlue")
//        }else if indexPath.row == viewModel.currentDateIndex {
//            cell.viewContent.backgroundColor = UIColor(named: "kThemeYellow")
//        }else {
//            cell.viewContent.backgroundColor = UIColor(named: "k5953_0.05")
//        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 68, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 9, bottom: 0, right: 9)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return  0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return  0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dateVM = viewModel.getDateViewModel(at: indexPath)
        lblSelectedItemDate.text = dateVM.getFormattedDate
        viewModel.selectedDateIndex = indexPath.row
        collectionView.reloadData()
        showLoader()
        viewModel.getDayWiseSchedulesForSelectedDate()
    }
}
