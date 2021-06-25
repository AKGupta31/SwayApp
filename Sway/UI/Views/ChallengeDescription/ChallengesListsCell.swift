//
//  ChallengesListsCell.swift
//  Sway
//
//  Created by Admin on 23/06/21.
//

import UIKit

class ChallengesListsCell: UITableViewCell {

    @IBOutlet weak var collectionViewChallengePerWeeks: UICollectionView!
    
    var workoutDetailsVMs:[WorkoutDetailsViewModel] = [WorkoutDetailsViewModel](){
        didSet {
            self.collectionViewChallengePerWeeks.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionViewChallengePerWeeks.dataSource = self
        collectionViewChallengePerWeeks.delegate = self
        collectionViewChallengePerWeeks.reloadData()
        // Initialization code
    }
}

extension ChallengesListsCell:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return workoutDetailsVMs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekwiseChallengesCell", for: indexPath) as! WeekwiseChallengesCell
        cell.workoutDetailsVM = workoutDetailsVMs[indexPath.row]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width - 40
        return CGSize(width: width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 50)
    }

    
}
