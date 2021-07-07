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
    
    
    lazy var imageView:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ic_workout_small"))
        return imageView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContent.layer.cornerRadius = 5.0
        viewContent.clipsToBounds = true
        lblTitle.textColor = .white
        lblTitle.font = UIFont(name: "CircularStd-Medium", size: 16)
        addSubview(imageView)
       
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.center = CGPoint(x: self.frame.width / 2 - 5, y: self.frame.height / 2)
    }
}
