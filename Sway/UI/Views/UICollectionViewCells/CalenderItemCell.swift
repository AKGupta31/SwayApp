//
//  CalenderItemCell.swift
//  Sway
//
//  Created by Admin on 16/06/21.
//


import UIKit

class CalenderItemCell: UICollectionViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.textColor = .white
        lblTitle.font = UIFont(name: "CircularStd-Bold", size: 10)
    }
}
