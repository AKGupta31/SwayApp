//
//  WorkoutButton.swift
//  Sway
//
//  Created by Admin on 19/05/21.
//

import UIKit

class WorkoutButton: CustomButton {

    override var isSelected: Bool{
        didSet {
            self.backgroundColor = UIColor(named: !isSelected ? "k5953_0.05" : "kThemeBlue")
            self.setTitleColor(UIColor(named: isSelected ? "White" : "kThemeNavyBlue"), for: .normal)
        }
    }
    
    

}
