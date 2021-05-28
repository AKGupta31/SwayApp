//
//  PredefinedCommentsCell.swift
//  Sway
//
//  Created by Admin on 26/05/21.
//

import UIKit

class PredefinedCommentsCell: UICollectionViewCell {
    
    
    @IBOutlet weak var lblComment: UILabel!
    func setupData(comment:PredefinedComment){
        self.lblComment.text = comment.name
    }
}
