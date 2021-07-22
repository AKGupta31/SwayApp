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
    
    
    @IBOutlet weak var lblResults: UILabel!
    
    @IBOutlet weak var cvFilters: UICollectionView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tableViewLibraryItems: UITableView!
    @IBOutlet weak var libraryView: UIView!
    @IBOutlet weak var challengesView: UIView!
    
    @IBOutlet weak var cvChallenges: UICollectionView!
    @IBOutlet weak var stackViewTab: UIStackView!
    @IBOutlet weak var pagingLayout: UPCarouselFlowLayout!
    
    @IBOutlet weak var paginationLayout: UPCarouselFlowLayout!
    @IBOutlet weak var pageControlView: UIView!
    var viewModel:ChallengeSelectionVM!
    var libraryVM:LibraryListingViewModel!
    var pageControl:AdvancedPageControlView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.libraryVM = LibraryListingViewModel(delegate: self)
        cvChallenges.dataSource = self
        cvChallenges.delegate = self
        cvChallenges.reloadData()
        cvChallenges.contentInsetAdjustmentBehavior  = .never
        cvFilters.dataSource = self
        cvFilters.delegate = self
        self.edgesForExtendedLayout = .bottom
        self.extendedLayoutIncludesOpaqueBars = false
        libraryView.isHidden = true
        searchField.delegate = libraryVM
        searchField.addTarget(self, action: #selector(didChangeText(_:)), for: .allEditingEvents)
        searchField.clearButtonMode = .whileEditing
        searchField.attributedPlaceholder = NSAttributedString(string: "Search Sway Library", attributes: [NSAttributedString.Key.foregroundColor:UIColor(named: "kThemeNavyBlue")!])
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
                switch sender.tag {
                case 0:
                    libraryView.isHidden = true
                case 1:
                    libraryView.isHidden = false
                default:
                    break
                }
            }
        }
        
        
    }
    
}
extension ChallengeSelectionVC:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cvFilters {
            return libraryVM.allFilters.count
        }
        return viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == cvFilters {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChallengeLibraryFiltersCell", for: indexPath) as! ChallengeLibraryFiltersCell
            let model = libraryVM.allFilters[indexPath.row]
            cell.lblItemName.text = model.name
            cell.isSelectedCell = model.isSelected
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChallengeSelectionCell", for: indexPath) as! ChallengeSelectionCell
        cell.setupData(viewModel: viewModel.getChallengeVM(at: indexPath.row))
        cell.viewContent.backgroundColor = UIColor.random()
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == cvFilters {
            let model = libraryVM.allFilters[indexPath.row]
            let string = NSAttributedString(string: model.name ?? "", attributes: [NSAttributedString.Key.font:UIFont(name: "CircularStd-Medium", size: 12)!])
            return CGSize(width: string.size().width + 30 + 10, height: 31)
        }
        return CGSize(width: collectionView.frame.width * 0.75, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == cvFilters {
            return UIEdgeInsets(top: 0, left: 11, bottom: 0, right: 11)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == cvFilters {
            libraryVM.allFilters[indexPath.row].isSelected =  !libraryVM.allFilters[indexPath.row].isSelected
            collectionView.reloadItems(at: [indexPath])
            showLoader()
            libraryVM.refreshData()
            return
        }
        self.getNavController()?.push(ChallengeInfoHypeVideoVC.self, animated: true) { (vc) in
            vc.viewModel = self.viewModel.getChallengeVM(at: indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.cvChallenges && pageControl != nil{
            if let centerIndex = (scrollView as? UICollectionView)?.centerIndexPath {
                pageControl.setPage(centerIndex.row)
            }
        }
     
    }
    
}
extension ChallengeSelectionVC:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return libraryVM.numberOfItems
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChallengeLibraryItemCell", for: indexPath) as! ChallengeLibraryItemCell
        cell.btnAdd.tag = indexPath.row
        cell.btnAdd.addTarget(self, action: #selector(addClicked(_:)), for: .touchUpInside)
        cell.setupData(libraryVM: libraryVM.libraryItemViewModel(at: indexPath.row))
        if indexPath.row == libraryVM.numberOfItems - 1 {
            libraryVM.loadMoreData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func addClicked(_ sender:UIButton){
        if let cell = tableViewLibraryItems.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? ChallengeLibraryItemCell {
            self.getNavController()?.push(ScheduleLibraryWorkoutVC.self, animated: true, configuration: { (vc) in
                vc.itemToAddEdit = self.libraryVM.libraryItemViewModel(at: sender.tag)
                vc.isEditMode = cell.isAdded
                vc.refreshData = { [weak self] in
                    self?.libraryVM.refreshData()
                }
            })
//            if cell.isAdded == false {
//                cell.isAdded = true
//            }
        }
    }
    
}

extension ChallengeSelectionVC :ChallengeSelectionVMDelegate,LibraryListingVMDelegate{
    func reloadFilters() {
        cvFilters.reloadData()
    }
    
    func reloadData() {
        hideLoader()
        cvChallenges.reloadData()
        setupPageControl()
    }
    
    func showAlert(with title: String?, message: String) {
        hideLoader()
        AlertView.showAlert(with: title, message: message)
    }
    
    func reloadLibrary() {
        if libraryVM.isFiltersOrSearchApplied {
            lblResults.text = "Results (\(libraryVM.numberOfItems))"
        }else {
            lblResults.text = "Workouts"
        }
        hideLoader()
        self.tableViewLibraryItems.reloadData()
    }
    
    @objc func didChangeText(_ textField: UITextField) {
        libraryVM.searchStr = textField.text ?? ""
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
