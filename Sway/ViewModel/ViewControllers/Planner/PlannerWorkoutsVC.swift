//
//  PlannerWorkoutsVC.swift
//  Sway
//
//  Created by Admin on 21/07/21.
//

import UIKit
import ViewControllerDescribable

class PlannerWorkoutsVC: BaseViewController {

    @IBOutlet weak var collectionViewFilters: UICollectionView!
    @IBOutlet weak var tableViewWorkouts: UITableView!
    @IBOutlet weak var lblResult: UILabel!
    var libraryVM:LibraryListingViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoader()
        self.libraryVM = LibraryListingViewModel(delegate: self)
        self.tabBarController?.tabBar.isHidden = false
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: self.tabBarController!.tabBar.frame.height, right: 0)
        self.tableViewWorkouts.contentInset = adjustForTabbarInsets
        self.tableViewWorkouts.scrollIndicatorInsets = adjustForTabbarInsets
        // Do any additional setup after loading the view.
    }
    
//MARK: Search
    
    @IBAction func actionSearch(_ sender: UIButton) {
        self.getNavController()?.push(SearchPlannerVC.self, animated: true, pushTransition: .horizontal, configuration: { (vc) in
            vc.searchString = self.libraryVM.searchStr
            vc.searchAction = {[weak self](searchString) in
                self?.libraryVM.searchStr = searchString
                self?.showLoader()
                self?.libraryVM.refreshData()
            }
        })
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension PlannerWorkoutsVC:LibraryListingVMDelegate {
    func reloadLibrary() {
        if libraryVM.isFiltersOrSearchApplied {
            lblResult.text = "Results (\(libraryVM.numberOfItems))"
        }else {
            lblResult.text = "Recommended"
        }
        hideLoader()
        self.tableViewWorkouts.reloadData()
    }
    
    func reloadFilters() {
        collectionViewFilters.reloadData()
    }
    
    func reloadData() {}
    
    func showAlert(with title: String?, message: String) {
        AlertView.showAlert(with: title, message: message,on: self)
    }
    
}

extension PlannerWorkoutsVC:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return libraryVM.allFilters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChallengeLibraryFiltersCell", for: indexPath) as! ChallengeLibraryFiltersCell
        let model = libraryVM.allFilters[indexPath.row]
        cell.lblItemName.text = model.name
        cell.isSelectedCell = model.isSelected
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = libraryVM.allFilters[indexPath.row]
        let string = NSAttributedString(string: model.name ?? "", attributes: [NSAttributedString.Key.font:UIFont(name: "CircularStd-Medium", size: 12)!])
        return CGSize(width: string.size().width + 30 + 10, height: 31)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 11, bottom: 0, right: 11)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        libraryVM.allFilters[indexPath.row].isSelected =  !libraryVM.allFilters[indexPath.row].isSelected
        collectionView.reloadItems(at: [indexPath])
        showLoader()
        libraryVM.refreshData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension PlannerWorkoutsVC:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if libraryVM.numberOfItems <= 0 {
            tableView.backgroundView = Helper.shared.addNoDataLabel(strMessage: "No record found", to: tableView,offSet: CGPoint(x: 0, y: -75))
        }else{
            tableView.backgroundView = nil
        }
        return libraryVM.numberOfItems
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChallengeLibraryItemCell", for: indexPath) as! ChallengeLibraryItemCell
        cell.btnAdd.tag = indexPath.row
        cell.btnAdd.addTarget(self, action: #selector(addClicked(_:)), for: .touchUpInside)
        cell.setupData(libraryVM: libraryVM.libraryItemViewModel(at: indexPath.row))
        if indexPath.row == libraryVM.numberOfItems - 1 {
            libraryVM.loadMoreData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let workoutvm = libraryVM.libraryItemViewModel(at: indexPath.row)
//        self.getNavController()?.push(WorkoutInfoVC.self, animated: true, pushTransition: .vertical, configuration: { (vc) in
//
//        })
//    }
    
    @objc func addClicked(_ sender:UIButton){
        if let cell = tableViewWorkouts.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? ChallengeLibraryItemCell {
            self.getNavController()?.push(ScheduleLibraryWorkoutVC.self, animated: true, configuration: { (vc) in
                vc.itemToAddEdit = self.libraryVM.libraryItemViewModel(at: sender.tag)
                vc.isEditMode = cell.isAdded
                vc.refreshData = { [weak self] in
                    self?.libraryVM.refreshData()
                }
            })
        }

        
//        if let cell = tableViewWorkouts.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? ChallengeLibraryItemCell {
//            self.getNavController()?.push(PlannerScheduleVC.self, animated: true, configuration: { (vc) in
//                vc.itemToAddEdit = self.libraryVM.libraryItemViewModel(at: sender.tag)
//                vc.isEditMode = cell.isAdded
//                vc.refreshData = { [weak self] in
//                    self?.libraryVM.refreshData()
//                }
//            })
//        }
    }
    
}

extension PlannerWorkoutsVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.planner
    }
}

