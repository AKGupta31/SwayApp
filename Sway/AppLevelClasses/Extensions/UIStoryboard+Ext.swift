//
//  UIStoryboard+Ext.swift
//  Sway
//
//  Created by Admin on 13/04/21.
//

import UIKit
import ViewControllerDescribable
extension UIStoryboard {
   enum Name: String, StoryboardNameDescribable {
       case main = "Main"
       case onBoarding = "Onboarding"
       case home = "Feed"
       case anonymous = "Anonymous"
       case challenge = "Challenge"
   }
}
