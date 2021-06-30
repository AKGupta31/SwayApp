//
//  ChallengeSelectionVC.swift
//  Sway
//
//  Created by Admin on 17/06/21.
//

import UIKit
import ViewControllerDescribable
import UPCarouselFlowLayout

class ChallengeSelectionVC: BaseViewController {
    @IBOutlet weak var cvChallenges: UICollectionView!
    @IBOutlet weak var stackViewTab: UIStackView!
    @IBOutlet weak var pagingLayout: UPCarouselFlowLayout!
    
    @IBOutlet weak var paginationLayout: UPCarouselFlowLayout!
    @IBOutlet weak var pageControlView: UIView!
    var viewModel:ChallengeSelectionVM!
    
    var pageControl:AdvancedPageControlView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cvChallenges.dataSource = self
        cvChallenges.delegate = self
        cvChallenges.reloadData()

        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        if viewModel == nil {
            showLoader()
            viewModel = ChallengeSelectionVM(with:self)
        }else if viewModel == nil || viewModel.numberOfItems <= 0 {
            showLoader()
            viewModel.refreshData()
        }
    }
    
    func setupPageControl(){
        //EXTENDED DOT PAGE CONTROL
        if pageControl != nil {
            pageControl.removeFromSuperview()
        }
        pageControl = AdvancedPageControlView(frame: pageControlView.bounds)
        pageControl.drawer = ExtendedDotDrawer(numberOfPages: viewModel.numberOfItems,
                                               height: 6,
                                               width: 6, space: 8,
                                               indicatorColor: UIColor(named: "kThemeNavyBlue")!,
                                               dotsColor: UIColor(named: "PageControl")!,
                                               borderWidth: 0.0
                                               )
        
        pageControlView.addSubview(pageControl)
        
        //FLEXIBLE PAGE CONTROL
        /*
         
         if pageControl == nil {
         pageControl = FlexiblePageControl()
         pageControlView.addSubview(pageControl)
         }
         pageControl.numberOfPages = viewModel.numberOfItems
         pageControl.center = CGPoint(x: pageControlView.frame.width / 2, y: pageControlView.frame.height / 2)
         
         // color
         pageControl.pageIndicatorTintColor = UIColor(named: "PageControl")!
         pageControl.currentPageIndicatorTintColor = UIColor(named: "kThemeNavyBlue")!
         
         // size
         let config = FlexiblePageControl.Config(
         displayCount: 7,
         dotSize: 10,
         dotSpace: 4,
         smallDotSizeRatio: 0.7,
         mediumDotSizeRatio: 0.9
         )
         pageControl.setConfig(config) */
    }
    
    
    
    
    @IBAction func actionTab(_ sender: UIButton) {
        for (index,view) in stackViewTab.arrangedSubviews.enumerated() {
            if let tabView = view as? TabItemView {
                tabView.isSelected = sender.tag == index
            }
        }
        
        
    }
    
}
extension ChallengeSelectionVC:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChallengeSelectionCell", for: indexPath) as! ChallengeSelectionCell
        cell.setupData(viewModel: viewModel.getChallengeVM(at: indexPath.row))
        cell.viewContent.backgroundColor = UIColor.random()
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.75, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.push(ChallengeInfoHypeVideoVC.self, animated: true) { (vc) in
            vc.viewModel = self.viewModel.getChallengeVM(at: indexPath.row)
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.cvChallenges && pageControl != nil{
            if let centerIndex = (scrollView as? UICollectionView)?.centerIndexPath {
                pageControl.setPage(centerIndex.row)
            }
        }
     
    }
    
}

extension ChallengeSelectionVC :ChallengeSelectionVMDelegate{
    func reloadData() {
        hideLoader()
        cvChallenges.reloadData()
        setupPageControl()
    }
    
    func showAlert(with title: String?, message: String) {
        hideLoader()
        AlertView.showAlert(with: title, message: message)
    }
    
}
extension ChallengeSelectionVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.challenge
    }
}


extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}
