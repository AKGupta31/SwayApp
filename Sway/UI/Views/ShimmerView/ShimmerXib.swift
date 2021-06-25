//
//  ShimmerXib.swift
//  Sway
//
//  Created by Admin on 10/06/21.
//

import UIKit

class ShimmerXib: UIView {

    @IBOutlet weak var shimmerView3: ShimmerView!
    @IBOutlet weak var shimmerView2: ShimmerView!
    @IBOutlet weak var shimmerView1: ShimmerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tag = 9999
        shimmerView1.layer.cornerRadius = 5.0
        shimmerView2.layer.cornerRadius = 5.0
        shimmerView3.layer.cornerRadius = 4.0
        shimmerView1.clipsToBounds = true
        shimmerView2.clipsToBounds = true
        shimmerView3.clipsToBounds = true
        
//        shimmerView1.startAnimating()
    }
    
    func startAnimating(){
        for subview in self.subviews {
            if let shimmer = subview as? ShimmerView {
                shimmer.startAnimating()
            }
        }
    }

}


