//
//  WeekwiseChallengesCell.swift
//  Sway
//
//  Created by Admin on 23/06/21.
//

import UIKit

class WeekwiseChallengesCell: UICollectionViewCell {
    
    
    @IBOutlet weak var lblWeekTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var workoutDetailsVM:WorkoutDetailsViewModel! {
        didSet {
            lblWeekTitle.text = workoutDetailsVM.weekTitle
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
        return workoutDetailsVM == nil ? 0 : workoutDetailsVM.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutVideoItemCell", for: indexPath) as! WorkoutVideoItemCell
        if let workoutVM = workoutDetailsVM.getWorkoutVM(at: indexPath.row){
            cell.setupData(workoutVM:workoutVM )
        }
        return cell
    }
    
    
}
