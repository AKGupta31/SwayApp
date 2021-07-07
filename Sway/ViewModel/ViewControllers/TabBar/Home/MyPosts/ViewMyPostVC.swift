//
//  ViewMyPostVC.swift
//  Sway
//
//  Created by Admin on 02/07/21.
//

import UIKit
import ViewControllerDescribable
import GSPlayer
import ActiveLabel

class ViewMyPostVC: BaseViewController {

    @IBOutlet weak var imgPlay: UIImageView!
    @IBOutlet weak var btnComments: CustomTextLocationButton!
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var btnLike: CustomTextLocationButton!
    
    @IBOutlet weak var lblUser: ActiveLabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    var viewModel:FeedsViewModel!
    
    lazy var playerView:VideoPlayerView = {
        let playerView = VideoPlayerView()
        playerView.contentMode = .scaleAspectFill
        return playerView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tabBarController?.tabBar.isHidden = true
        viewModel.delegate = self
        let feedVM = viewModel.getFeedViewModel(at: viewModel.selectedFeedIndex)
        btnLike.isHidden = feedVM.status != .APPROVED
        btnComments.isHidden = feedVM.status != .APPROVED
        
        if feedVM.mediaType == .kVideo {
            playerView.frame = self.view.bounds
            self.view.insertSubview(playerView, aboveSubview: imgBackground)
            playerView.stateDidChanged = { [weak self] state in
                guard let `self` = self else { return }
                switch state {
                case .loading:
                    self.startActivityIndicator(style: .medium, inSelf: true, touchEnabled: true)
                
                case .playing:
                    self.stopActivityIndicator()
                    self.imgPlay.image = UIImage(named: "ic_pause")
                case .paused:
                    self.stopActivityIndicator()
                    self.imgPlay.image = UIImage(named: "ic_play")
                default:
                   break
                }
                self.imgPlay.isHidden = false
                UIView.animate(withDuration: 0.35) {
                    self.imgPlay.alpha = 1.0
                } completion: { (isSuccess) in
                    self.imgPlay.alpha = 0.0
                    self.imgPlay.isHidden = true
                }
            }
            playerView.play(for: feedVM.mediaUrl!)
            self.imgBackground.sd_setImage(with: feedVM.thumbUrl, completed: nil)
        }else {
            self.imgBackground.sd_setImage(with: feedVM.mediaUrl, completed: nil)
        }
        setupData(viewModel: feedVM)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.playerView.pause(reason: .hidden)
    }
    
    func setupData(viewModel:FeedViewModel){
        self.btnLike.setImage(UIImage(named: viewModel.isLiked ? "ic_liked" :
                                       "ic_like"), for: .normal)
        self.btnLike.setTitle(viewModel.likeCount.description, for: .normal)
        self.btnComments.setTitle(viewModel.commentCount.description, for: .normal)
        
        lblUser.enabledTypes = [.mention]
        lblUser.mentionColor = UIColor.white
        lblDescription.text = viewModel.caption
        lblUser.text = "@\(viewModel.userName ?? "")"
        
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        playerView.pause()
        self.navigationController?.popViewController(animated: true)
    }
    

    @objc func tapOnPlayerView(_ gesture:UITapGestureRecognizer){
        if playerView.state == .playing {
            playerView.pause(reason: .userInteraction)
            self.imgPlay.image = UIImage(named: "ic_pause")
        }else {
            self.imgPlay.image = UIImage(named: "ic_play")
            playerView.resume()
        }
        self.imgPlay.isHidden = false
        UIView.animate(withDuration: 0.35) {
            self.imgPlay.alpha = 1.0
        } completion: { (isSuccess) in
            self.imgPlay.alpha = 0.0
            self.imgPlay.isHidden = true
        }
        
    }

    @IBAction func actionLike(_ sender: UIButton) {
        let indexPath = IndexPath(row: viewModel.selectedFeedIndex, section: 0)
        viewModel.likeFeed(at: indexPath)
        let feedVM = viewModel.getFeedViewModel(at: indexPath.row)
        let isLiked = !feedVM.isLiked
        btnLike.setImage(UIImage(named: isLiked ? "ic_liked" : "ic_like"), for: .normal)
        let likes = isLiked ? feedVM.likeCount + 1 : feedVM.likeCount - 1
        btnLike.setTitle(likes.description, for: .normal)
        sender.rotate()
    }
  
    @IBAction func actionComments(_ sender: UIButton) {
        playerView.pause()
        let selectedIndex = viewModel.selectedFeedIndex
        self.tabBarController?.present(CommentsVC.self, navigationEnabled: false, animated: true, configuration: { (vc) in
            vc.modalPresentationStyle = .overCurrentContext
            vc.viewModel = self.viewModel.getCommentsViewModel(index: selectedIndex)
        }, completion: nil)
    }
    
    
    @IBAction func actionMenu(_ sender: UIButton) {
        showMenuPopover(sender)
    }
}

extension ViewMyPostVC {
    @objc func showMenuPopover(_ sender:UIView) {
        let actionAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let actionDelete = UIAlertAction(title: "Delete", style: .default, handler: { (action) in
            self.actionDeletePost()
        })
        actionDelete.setValue(UIImage(named: "ic_trash"), forKey: "image")
        actionAlert.addAction(actionDelete)
        let actionEdit = UIAlertAction(title: "Edit", style: .default, handler: { (action) in
            self.actionEditPost()
        })
        actionEdit.setValue(UIImage(named: "ic_edit"), forKey: "image")
        actionAlert.addAction(actionEdit)
        
        let actionSaveDevice = UIAlertAction(title: "Save to device", style: .default, handler: { (action) in
            self.viewModel.downloadMedia(at: self.viewModel.selectedFeedIndex)
        })
        actionSaveDevice.setValue(UIImage(named: "ic_save"), forKey: "image")
        actionAlert.addAction(actionSaveDevice)
        
        actionAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionAlert, animated: true)
    }
    
    private func actionDeletePost(){
        AlertView.showAlert(with: Constants.Messages.kAlert, message: Constants.Messages.kAreYouSureToDeleteThePost, on: self, button1Title: "No", button2Title: "Yes") { (action) in
        } actionBtn2: {[weak self] (action) in
            if let viewModel = self?.viewModel {
                let feedId = viewModel.getFeedViewModel(at: viewModel.selectedFeedIndex).feedId
                self?.viewModel.deleteFeed(with: feedId)
            }
        }
    }
    
    private func actionEditPost(){
//        guard let cell = collectionViewSubmissions.cellForItem(at: IndexPath(row: sender.tag, section: 0)) as? MySubmissionCell else {return}
        let addVideoVM = AddVideoViewModel(feedViewModel: viewModel.getFeedViewModel(at: viewModel.selectedFeedIndex), thumbnail: imgBackground.image ?? UIImage())
        self.getNavController()?.push(AddVideoVC.self, animated: true, configuration: { (vc) in
            vc.viewModel = addVideoVM
        })
    }
    
    
}


extension ViewMyPostVC:FeedsViewModelDelegate {
    func likeApi(isSuccess: Bool,indexPath:IndexPath) {
        let vm = viewModel.getFeedViewModel(at: indexPath.row)
        btnLike.setImage(UIImage(named: vm.isLiked ? "ic_liked" :
                                        "ic_like"), for: .normal)
        btnLike.setTitle(vm.likeCount.description, for: .normal)
    }
    
    func showAlert(with title: String?, message: String) {
        hideLoader()
        stopActivityIndicator()
        AlertView.showAlert(with: title, message: message,on: self)
    }
    
    func reloadRow(at indexPath: IndexPath) {
        self.setupData(viewModel: viewModel.getFeedViewModel(at:viewModel.selectedFeedIndex))
    }
    
    func reloadData() {
        self.setupData(viewModel: viewModel.getFeedViewModel(at:viewModel.selectedFeedIndex))
    }
    
    func deleteSuccessful() {
        self.navigationController?.popViewController(animated: true)
    }
}
extension ViewMyPostVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.home
    }
}
