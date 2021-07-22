//
//  ChallengeLibraryItemCell.swift
//  Sway
//
//  Created by Admin on 13/07/21.
//

import UIKit
import SDWebImage

class ChallengeLibraryItemCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgVideoThumb: CustomImageView!
    
    @IBOutlet weak var btnAdd: CustomButton!
    @IBOutlet weak var lblDuration: UILabel!
    
    var isAdded:Bool = false {
        didSet {
            self.btnAdd.backgroundColor = UIColor(named: isAdded ? "kThemeYellow" : "White")
            self.btnAdd.borderWidth = isAdded ? 0 : 1
            self.btnAdd.setTitle(isAdded ? "ADDED" : "ADD", for: .normal)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupData(libraryVM:LibraryItemVM){
        imgVideoThumb.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imgVideoThumb.sd_setImage(with: libraryVM.videoThumb, completed: nil)
        self.isAdded = libraryVM.isAdded
        self.lblDuration.text = libraryVM.durationInMinutes
        self.lblName.text = libraryVM.name
    }

}
