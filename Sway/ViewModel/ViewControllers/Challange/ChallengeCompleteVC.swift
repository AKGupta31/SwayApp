//
//  ChallengeCompleteVC.swift
//  Sway
//
//  Created by Admin on 23/07/21.
//

import UIKit
import ViewControllerDescribable
import FirebaseDynamicLinks

class ChallengeCompleteVC: BaseViewController {
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    var workoutVM:WorkoutDetailsViewModel!
    
    //MARK: Dynamic link Properties
    var link = DynamicLinkComponents()
    var strInvitationSubject = ""
    var strShortLinkUrl: String = ""
    var linkBuilder: DynamicLinkComponents?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getLink()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionSeeMyProgress(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 3
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func actionShare(_ sender: UIButton) {
        guard let url = URL(string: "https://sarahsway.page.link/sway") else {return}
        openShare(with: url)
//        showLoader()
//        self.linkBuilder?.shorten(completion: {[weak self] (url, warning, error) in
//            self?.hideLoader()
//            self?.strShortLinkUrl = url?.description ?? ""
//            guard let url = url, error == nil else {
//                return }
//
//            self?.openShare(with: url)
//
//        })
//
        
        
    }
    
    func openShare(with url:URL?){
        // image to share
        let image = UIImage(named: "ic_image_3")
        let text = "share options"
        // set up activity view controller
        let imageToShare:[Any] = [image!,text,url!]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        //        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
//        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    
    func setupUI(){
        let attributedString = NSMutableAttributedString(string: "Work out complete!", attributes: [
            .font: UIFont(name: "Poppins-Bold", size: 52.0)!,
            .foregroundColor: UIColor(red: 5.0 / 255.0, green: 9.0 / 255.0, blue: 53.0 / 255.0, alpha: 1.0)
        ])
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 94.0 / 255.0, green: 0.0, blue: 1.0, alpha: 1.0), range: NSRange(location: 9, length: 9))
        lblTitle.attributedText = attributedString
    }
    
    func getLink() {
//        let dynamicLinksDomainURIPrefix = "https://sarahsway.page.link"
//        let dynamicLinksDomainURIPrefix = websiteURIPrefix
        self.linkBuilder = DynamicLinkComponents(link: URL(string: "https://sarahsway.page.link")!, domainURIPrefix: "https://sarahsway.page.link")
//        self.linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: URL(string: dynamicLinksDomainURIPrefix)!)
        linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: Bundle.main.bundleIdentifier!)
        linkBuilder?.iOSParameters?.appStoreID = Constants.AppCredentials.AppStoreId
        linkBuilder?.androidParameters = DynamicLinkAndroidParameters(packageName: Bundle.main.bundleIdentifier!)
        guard let longDynamicLink = linkBuilder?.url else { return }
        strShortLinkUrl = longDynamicLink.description
    }
    
    
    
    
}

extension ChallengeCompleteVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.challenge
    }
}
