//
//  ViewImageVC.swift
//  Sway
//
//  Created by Admin on 26/05/21.
//

import UIKit
import ViewControllerDescribable

class ViewImageVC: BaseViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var image:UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = image

    }
    
    @IBAction func actionCross(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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

extension ViewImageVC: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.home
    }
}
