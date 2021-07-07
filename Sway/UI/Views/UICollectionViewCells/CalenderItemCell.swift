//
//  CalenderItemCell.swift
//  Sway
//
//  Created by Admin on 16/06/21.
//


import UIKit

class CalenderItemCell: UICollectionViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    
    
    lazy var imageView:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ic_workout_small"))
        return imageView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.textColor = .white
        lblTitle.font = UIFont(name: "CircularStd-Bold", size: 10)
        lblTitle.minimumScaleFactor = 0.5
        addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
    }
}
