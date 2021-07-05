//
//  HowManyTimesAWeekVC.swift
//  Sway
//
//  Created by Admin on 03/06/21.
//

import UIKit
import ViewControllerDescribable

class HowManyTimesAWeekVC: BaseViewController {
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var totalItems = 10
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        // Do any additional setup after loading the view.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.scrollViewDidScroll(self.collectionView)
        }
    }
    
    fileprivate func setupTitle(){
        let string = "How many times a week do you want to work out?"
        let attributedString = NSMutableAttributedString(string: string, attributes: [
            .font: UIFont(name: "Poppins-Bold", size: 52.0)!,
            .foregroundColor: UIColor(named: "kThemeBlue")!
        ])
        attributedString.addAttribute(.foregroundColor, value: UIColor(named: "kThemeNavyBlue")!, range: NSRange(location: 14, length: string.count - 14))
        lblTitle.attributedText = attributedString
    }
    
    @IBAction func actionNext(_ sender: UIButton) {
        self.getNavController()?.push(PasswordChangeSuccessVC.self, animated: true, configuration: { (vc) in
            vc.type = .welcomeToSway
        })
    }
    
    @IBAction func actionSkip(_ sender: UIButton) {
    }
    
    
  
    
}

extension HowManyTimesAWeekVC:UICollectionViewDataSource,UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCell", for: indexPath) as! CarouselCell
        cell.lblTitle.text = indexPath.row.description + "x"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width-5) / 5
        return CGSize(width: width, height: width * 0.92)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellWidth = (collectionView.frame.width - 40) / 5
        return UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width / 2 - cellWidth / 2 , bottom: 0, right: UIScreen.main.bounds.width/2 - cellWidth/2)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard let centerIndex = collectionView.centerIndexPath else {return}
        if let middleCell = collectionView.getCell(at: 0, to: centerIndex, totalItems: totalItems) as? CarouselCell {
            middleCell.scalePercent = 1.0
            middleCell.lblTitle.textAlignment = .center
        }
        
        if let previous1Cell = collectionView.getCell(at: -1, to: centerIndex, totalItems: totalItems) as? CarouselCell {
            previous1Cell.scalePercent = 0.75
            previous1Cell.lblTitle.textAlignment = .left
        }
        
        if let previous2Cell = collectionView.getCell(at: -2, to: centerIndex, totalItems: totalItems) as? CarouselCell {
            previous2Cell.scalePercent = 0.5
            previous2Cell.lblTitle.textAlignment = .center
        }
        
        if let next1Cell = collectionView.getCell(at: 1, to: centerIndex, totalItems: totalItems) as? CarouselCell {
            next1Cell.scalePercent = 0.75
            next1Cell.lblTitle.textAlignment = .right
        }
        
        if let next2Cell = collectionView.getCell(at:2, to: centerIndex, totalItems: totalItems) as? CarouselCell {
            next2Cell.scalePercent = 0.5
            next2Cell.lblTitle.textAlignment = .center
        }
    }
    
}
extension UICollectionView {
    var centerIndexPath: IndexPath? {
        let visibleRect = CGRect(origin: contentOffset, size: bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath = indexPathForItem(at: visiblePoint)
        return visibleIndexPath
    }
    
    func getCell(at index:Int,to centerIndex:IndexPath,totalItems:Int) -> UICollectionViewCell?{
        if centerIndex.row + index < totalItems {
            if let cell = cellForItem(at: IndexPath(row: centerIndex.row + index, section: centerIndex.section)){
                return cell
            }
        }
        return nil
    }
}

extension HowManyTimesAWeekVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.challenge
    }
}
