//
//  PlannerItemCell.swift
//  Sway
//
//  Created by Admin on 19/07/21.
//

import UIKit
import SDWebImage

class PlannerItemCell: UITableViewCell {
    @IBOutlet weak var btnReschedule: UIButton!
    
    @IBOutlet weak var emptyPlannerView: GradientView!
    @IBOutlet weak var viewContent: CustomView!
    @IBOutlet weak var lblWorkoutName: UILabel!
    @IBOutlet weak var lblType1: UILabel!
    @IBOutlet weak var lblIntensity: UILabel!
    @IBOutlet weak var lblType2: UILabel!
    @IBOutlet weak var viewCompleted: CustomView!
    @IBOutlet weak var imgBanner: UIImageView!
    
    
    lazy var gradientLayer :CAGradientLayer = {
       let color = UIColor(red: 44/255, green: 43/255, blue: 39/255, alpha: 1.0)
        let layer = CAGradientLayer()
        layer.colors = [color,color.withAlphaComponent(0)]
        layer.opacity = 1.0
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        return layer
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewContent.layer.insertSublayer(gradientLayer, above: imgBanner.layer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.viewContent.bounds
    }

    
    func setupData(scheduleVM:DayWiseScheduleVM){
        imgBanner.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imgBanner.backgroundColor = UIColor.random()
        self.imgBanner.sd_setImage(with: scheduleVM.thumbnail, placeholderImage: UIImage(named: "Planner_Thumbnail"), options: .preloadAllFrames, context: nil)
        if scheduleVM.isPreviousSchedule {
            self.btnReschedule.isHidden = true
        }else {
            self.btnReschedule.isHidden = scheduleVM.isCompleted
        }
        self.viewCompleted.isHidden = !scheduleVM.isCompleted
        lblWorkoutName.text = scheduleVM.title
        lblIntensity.text = scheduleVM.intensity.displayName
    }
    

}
