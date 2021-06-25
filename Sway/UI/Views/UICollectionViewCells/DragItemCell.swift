//
//  DragItemCell.swift
//  Sway
//
//  Created by Admin on 16/06/21.
//

import UIKit

class DragItemCell: UICollectionViewCell {
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContent.layer.cornerRadius = 5.0
        viewContent.clipsToBounds = true
        lblTitle.textColor = .white
        lblTitle.font = UIFont(name: "CircularStd-Medium", size: 16)
    }
}
