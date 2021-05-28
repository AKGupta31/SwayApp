//
//  MySubmissionsVC.swift
//  Sway
//
//  Created by Admin on 20/05/21.
//

import UIKit
import ViewControllerDescribable

class MySubmissionsVC: BaseViewController {
    
    @IBOutlet weak var collectionViewSubmissions: UICollectionView!
    
    var viewModel:FeedsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewSubmissions.dataSource = self
        collectionViewSubmissions.delegate = self
        if viewModel == nil {
            viewModel = FeedsViewModel(delegate: self, mySubmissionsOnly: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
}

extension MySubmissionsVC: FeedsViewModelDelegate {
    func reloadData() {
        self.collectionViewSubmissions.reloadData()
    }
    
    func showAlert(with title: String?, message: String) {
        AlertView.showAlert(with: title, message: message)
    }
    
    func reloadRow(at indexPath: IndexPath) {
        self.collectionViewSubmissions.reloadItems(at: [indexPath])
    }
    
    func likeApi(isSuccess: Bool) {}
    
    
}
extension MySubmissionsVC:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
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
        if let cell = collectionView.cellForItem(at: indexPath) as? MySubmissionCell {
            cell.isEditMode = true
        }
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
        let feedId = viewModel.getFeedViewModel(at: sender.tag).feedId
        viewModel.deleteFeed(with: feedId)
    }
    
    @objc func actionDownload(_ sender:UIButton){
        viewModel.downloadMedia(at: sender.tag)
    }
    
    @objc func actionEditPost(_ sender:UIButton){
        guard let cell = collectionViewSubmissions.cellForItem(at: IndexPath(row: sender.tag, section: 0)) as? MySubmissionCell else {return}
        let addVideoVM = AddVideoViewModel(feedViewModel: viewModel.getFeedViewModel(at: sender.tag), thumbnail: cell.imgThumbnail.image ?? UIImage())
        self.navigationController?.push(AddVideoVC.self, animated: true, configuration: { (vc) in
            vc.viewModel = addVideoVM
        })
    }
}


extension MySubmissionsVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.home
    }
}

