//
//  ChallengeLibraryFiltersCell.swift
//  Sway
//
//  Created by Admin on 13/07/21.
//

import UIKit

class ChallengeLibraryFiltersCell: UICollectionViewCell {
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var itemView: UIView!
    
    @IBOutlet weak var lblItemName: UILabel!
    
    var isSelectedCell:Bool = false {
        didSet {
            self.lblItemName.textColor = UIColor(named: isSelectedCell ? "White" : "kThemeNavyBlue")
            self.itemView.backgroundColor = UIColor(named: isSelectedCell ? "kThemeNavyBlue" : "k5953_0.05")
        }
    }
}
