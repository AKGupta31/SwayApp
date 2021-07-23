//
//  ChallengeCompleteVC.swift
//  Sway
//
//  Created by Admin on 23/07/21.
//

import UIKit
import ViewControllerDescribable

class ChallengeCompleteVC: BaseViewController {

    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionSeeMyProgress(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 3
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    
    func setupUI(){
        let attributedString = NSMutableAttributedString(string: "Work out complete!", attributes: [
          .font: UIFont(name: "Poppins-Bold", size: 52.0)!,
          .foregroundColor: UIColor(red: 5.0 / 255.0, green: 9.0 / 255.0, blue: 53.0 / 255.0, alpha: 1.0)
        ])
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 94.0 / 255.0, green: 0.0, blue: 1.0, alpha: 1.0), range: NSRange(location: 9, length: 9))
        lblTitle.attributedText = attributedString
    }
    

   

}

extension ChallengeCompleteVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.challenge
    }
}
