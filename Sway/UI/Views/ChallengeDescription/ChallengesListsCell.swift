//
//  ChallengesListsCell.swift
//  Sway
//
//  Created by Admin on 23/06/21.
//

import UIKit

class ChallengesListsCell: UITableViewCell {

    @IBOutlet weak var collectionViewChallengePerWeeks: UICollectionView!
    
    var workoutListsVMs:[WorkoutListsViewModel] = [WorkoutListsViewModel](){
        didSet {
            self.collectionViewChallengePerWeeks.reloadData()
        }
    }
    
    weak var delegate:WeekwiseChallengesCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionViewChallengePerWeeks.dataSource = self
        collectionViewChallengePerWeeks.delegate = self
        collectionViewChallengePerWeeks.reloadData()
        
//        self.backgroundColor = .red
//        collectionViewChallengePerWeeks.backgroundColor = .yellow
        
//        collectionViewChallengePerWeeks.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        // Initialization code
    }
}

extension ChallengesListsCell:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return workoutListsVMs.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1//workoutListsVMs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekwiseChallengesCell", for: indexPath) as! WeekwiseChallengesCell
        cell.workoutListVMs = workoutListsVMs[indexPath.row]
        cell.delegate = delegate
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width - 40
        return CGSize(width: width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let centerIndex = collectionViewChallengePerWeeks.centerIndexPath {
            let cellWidth = scrollView.frame.width - 40
            scrollView.setContentOffset(CGPoint(x: cellWidth * CGFloat(centerIndex.row), y: 0), animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let centerIndex = collectionViewChallengePerWeeks.centerIndexPath {
            let cellWidth = scrollView.frame.width - 40
            scrollView.setContentOffset(CGPoint(x: cellWidth * CGFloat(centerIndex.row), y: 0), animated: true)
        }
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if let centerIndex = collectionViewChallengePerWeeks.centerIndexPath {
//            let cellWidth = scrollView.frame.width - 40
//            scrollView.setContentOffset(CGPoint(x: cellWidth * CGFloat(centerIndex.row), y: 0), animated: true)
//        }
//    }
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        var cellSize: CGSize = CGSize(width: collectionView.bounds.size.width - 40, height: collectionView.bounds.height)
//
//        cellSize.width -= collectionView.contentInset.left * 2
//        cellSize.width -= collectionView.contentInset.right * 2
//        cellSize.height = cellSize.width
//
//        return cellSize
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        updateCellsLayout()
//    }
    
//    func updateCellsLayout()  {
//        guard let collectionView = collectionViewChallengePerWeeks else {return}
//        let centerX = collectionView.contentOffset.x + (collectionView.frame.size.width)/2
//
//        for cell in collectionView.visibleCells {
//            var offsetX = centerX - cell.center.x
//            if offsetX < 0 {
//                offsetX *= -1
//            }
//            cell.transform = CGAffineTransform.identity
//            let offsetPercentage = offsetX / (self.bounds.width * 2.7)
//            let scaleX = 1-offsetPercentage
//            cell.transform = CGAffineTransform(scaleX: scaleX, y: scaleX)
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right:40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    
}

//extension ChallengesListsCell : WeekwiseChallengesCellDelegate {
//    func viewDetails(viewModel: WorkoutViewModel) {
//        
//    }
//}
