//
//  CarouselCell.swift
//  Sway
//
//  Created by Admin on 04/06/21.
//

import UIKit

class CarouselCell: UICollectionViewCell {
    
    var scalePercent:CGFloat = 0{
        didSet {
            UIView.animate(withDuration: 0.25) {
                self.scalingView.transform = CGAffineTransform(scaleX: self.scalePercent, y: self.scalePercent)
            }
            let textColor = UIColor(named: "kThemeNavyBlue")!
            if scalePercent >= 1.0 {
                self.scalingView.layer.borderWidth = showBorder ? 2 : 0
                self.lblTitle.textColor = textColor
            }else if scalePercent >= 0.75 {
                self.scalingView.layer.borderWidth = 0
                self.lblTitle.textColor = textColor.withAlphaComponent(0.7)
            }else if scalePercent >= 0.5 {
                self.scalingView.layer.borderWidth = 0
                self.lblTitle.textColor = textColor.withAlphaComponent(0.3)
            }
//            scalingView.transform = CGAffineTransform(scaleX: scalePercent, y: scalePercent)
        }
    }
    
    var showBorder:Bool = true
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.scalingView.layer.cornerRadius = self.scalingView.frame.width / 4.5
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.scalingView.layer.borderWidth = showBorder ? 2 : 0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.scalingView.clipsToBounds = true
        scalingView.layer.borderWidth = 2.0
        scalingView.layer.borderColor = UIColor(named: "kThemeNavyBlue")?.withAlphaComponent(0.3).cgColor
    }
    
    @IBOutlet weak var scalingView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
}


class CarouselCellWithLabelOnly: UICollectionViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    
    var scalePercent:CGFloat = 0{
        didSet {
            UIView.animate(withDuration: 0.25) {
                self.lblTitle.transform = CGAffineTransform(scaleX: self.scalePercent, y: self.scalePercent)
            }
            let textColor = UIColor(named: "kThemeNavyBlue")!
            self.lblTitle.textColor = textColor.withAlphaComponent(scalePercent)
        }
    }
    

}
