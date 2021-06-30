//
//  WeekwiseChallengesCell.swift
//  Sway
//
//  Created by Admin on 23/06/21.
//

import UIKit

protocol WeekwiseChallengesCellDelegate:class {
    func viewDetails(viewModel:WorkoutViewModel)
}


class WeekwiseChallengesCell: UICollectionViewCell {
    
    
    @IBOutlet weak var lblWeekTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    weak var delegate:WeekwiseChallengesCellDelegate?
    var workoutListVMs:WorkoutListsViewModel! {
        didSet {
            lblWeekTitle.text = workoutListVMs.weekTitle
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
}


extension WeekwiseChallengesCell:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutListVMs == nil ? 0 : workoutListVMs.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutVideoItemCell", for: indexPath) as! WorkoutVideoItemCell
        if let workoutVM = workoutListVMs.getWorkoutVM(at: indexPath.row){
            cell.setupData(workoutVM:workoutVM )
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let workoutVM = workoutListVMs.getWorkoutVM(at: indexPath.row){
            delegate?.viewDetails(viewModel: workoutVM)
        }
    }
    
    
}
