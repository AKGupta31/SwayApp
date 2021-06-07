//
//  SubscriptionVC.swift
//  Sway
//
//  Created by Admin on 02/06/21.
//

import UIKit
import ViewControllerDescribable

class SubscriptionVC: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblTermsAndPrivacy: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        scrollView.contentInsetAdjustmentBehavior = .never
        setupLabels()
        // Do any additional setup after loading the view.
    }
    
    
    func setupLabels(){
        let attributedString = NSMutableAttributedString(string: "By continuing you accept our Privacy Policy and Terms of Use", attributes: [
          .font: UIFont(name: "CircularStd-Book", size: 14.0)!,
          .foregroundColor: UIColor(red: 5.0 / 255.0, green: 9.0 / 255.0, blue: 53.0 / 255.0, alpha: 1.0),
          .kern: 0.63
        ])
        attributedString.addAttributes([
          .font: UIFont(name: "CircularStd-Bold", size: 14.0)!,
          .foregroundColor: UIColor(red: 94.0 / 255.0, green: 0.0, blue: 1.0, alpha: 1.0)
        ], range: NSRange(location: 29, length: 14))
        attributedString.addAttributes([
          .font: UIFont(name: "CircularStd-Bold", size: 14.0)!,
          .foregroundColor: UIColor(red: 94.0 / 255.0, green: 0.0, blue: 1.0, alpha: 1.0)
        ], range: NSRange(location: 48, length: 12))
        lblTermsAndPrivacy.attributedText = attributedString
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SubscriptionVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.anonymous
    }
}
