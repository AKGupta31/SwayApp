//
//  Register1VC.swift
//  Sway
//
//  Created by Admin on 15/04/21.
//

import UIKit
import ViewControllerDescribable

class Register1VC: BaseViewController {

    @IBOutlet weak var lblLoginTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let attributedString = NSMutableAttributedString(string: "Let’s create your account", attributes: [
          .font: UIFont(name: "Poppins-Bold", size: 46.0)!,
          .foregroundColor: UIColor(named: "kThemeBlue")!
        ])
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 5.0 / 255.0, green: 9.0 / 255.0, blue: 53.0 / 255.0, alpha: 1.0), range: NSRange(location: 0, length: 6))
        attributedString.addAttribute(.foregroundColor, value: UIColor(named: "kThemeNavyBlue")!, range: NSRange(location: 12, length: 6))
        lblLoginTitle.attributedText = attributedString
        // Do any additional setup after loading the view.
    }
   
    @IBAction func actionCross(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

}

extension Register1VC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable{
        return UIStoryboard.Name.main
    }
}
