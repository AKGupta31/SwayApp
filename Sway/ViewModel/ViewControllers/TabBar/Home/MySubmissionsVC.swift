//
//  MySubmissionsVC.swift
//  Sway
//
//  Created by Admin on 20/05/21.
//

import UIKit
import ViewControllerDescribable

class MySubmissionsVC: BaseTabBarViewController {
    
    @IBOutlet weak var collectionViewSubmissions: UICollectionView!
    
    var viewModel:FeedsViewModel!
    var refreshControl:UIRefreshControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewSubmissions.dataSource = self
        collectionViewSubmissions.delegate = self
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .clear
        refreshControl.addTarget(self, action: #selector(self.refreshData(_:)), for: .valueChanged)
        self.collectionViewSubmissions.addSubview(refreshControl)
        if viewModel == nil {
            showLoader()
            viewModel = FeedsViewModel(delegate: self, mySubmissionsOnly: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        self.collectionViewSubmissions.reloadData()
    }
    
    @objc func refreshData(_ refreshControl:UIRefreshControl){
        refreshControl.endRefreshing()
        viewModel.refreshData()
    }
    
}

extension MySubmissionsVC: FeedsViewModelDelegate {
    func reloadData() {
        hideLoader()
        self.collectionViewSubmissions.reloadData()
    }
    
    func showAlert(with title: String?, message: String) {
        hideLoader()
        AlertView.showAlert(with: title, message: message)
    }
    
    func reloadRow(at indexPath: IndexPath) {
        hideLoader()
        self.collectionViewSubmissions.reloadItems(at: [indexPath])
    }
    
    func likeApi(isSuccess: Bool,indexPath:IndexPath) {}
    
    func deleteSuccessful() {
        self.collectionViewSubmissions.reloadData()
    }
    
}
extension MySubmissionsVC:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = viewModel.numberOfItems
        if numberOfItems <= 0 {
            collectionView.backgroundView = Helper.shared.addNoDataLabel(strMessage: "You haven't posted any newsfeed yet", to: collectionView)
        }else {
            collectionView.backgroundView = nil
        }
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MySubmissionCell", for: indexPath) as! MySubmissionCell
        //        cell.isApproved = false
        cell.setupData(viewModel: viewModel.getFeedViewModel(at: indexPath.row))
        cell.btnCrossThreeDots.tag = indexPath.row
        cell.btnSaveToDevice.tag = indexPath.row
        cell.btnDelete.tag = indexPath.row
        cell.btnEditPost.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(actionDelete(_:)), for: .touchUpInside)
        cell.btnSaveToDevice.addTarget(self, action: #selector(actionDownload(_:)), for: .touchUpInside)
        cell.btnEditPost.addTarget(self, action: #selector(actionEditPost(_:)), for: .touchUpInside)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width / 3 - 1
        return CGSize(width: width, height: width * 1.33)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.getNavController()?.push(ViewMyPostVC.self, animated: true, configuration: { (vc) in
            self.viewModel.selectedFeedIndex = indexPath.row
            vc.viewModel = self.viewModel
        })
//        if let cell = collectionView.cellForItem(at: indexPath) as? MySubmissionCell {
//            cell.isEditMode = true
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

extension MySubmissionsVC{
    @objc func actionDelete(_ sender:UIButton){
        AlertView.showAlert(with: Constants.Messages.kAlert, message: Constants.Messages.kAreYouSureToDeleteThePost, on: self, button1Title: "No", button2Title: "Yes") { (action) in
        } actionBtn2: {[weak self] (action) in
            if let feedId = self?.viewModel.getFeedViewModel(at: sender.tag).feedId {
                self?.viewModel.deleteFeed(with: feedId)
            }
        }
    }
    
    @objc func actionDownload(_ sender:UIButton){
        viewModel.downloadMedia(at: sender.tag)
    }
    
    @objc func actionEditPost(_ sender:UIButton){
        guard let cell = collectionViewSubmissions.cellForItem(at: IndexPath(row: sender.tag, section: 0)) as? MySubmissionCell else {return}
        let addVideoVM = AddVideoViewModel(feedViewModel: viewModel.getFeedViewModel(at: sender.tag), thumbnail: cell.imgThumbnail.image ?? UIImage())
        self.getNavController()?.push(AddVideoVC.self, animated: true, configuration: { (vc) in
            vc.viewModel = addVideoVM
        })
    }
}


extension MySubmissionsVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.home
    }
}

