//
//  HomeVC.swift
//  Sway
//
//  Created by Admin on 06/05/21.
//

import UIKit
import ViewControllerDescribable
import Player
import AVFoundation
import SDWebImage
import ActiveLabel
class HomeVC: BaseViewController {
    @IBOutlet weak var lblPostUser: ActiveLabel!
    
    @IBOutlet weak var lblPostDescription: UILabel!
    
    @IBOutlet weak var imgPlay: UIImageView!
    @IBOutlet weak var btnComments: CustomTextLocationButton!
    @IBOutlet weak var btnLikes: CustomTextLocationButton!
    @IBOutlet weak var tableViewFeeds: UITableView!
    var player:Player!
    
    var refreshControl:UIRefreshControl!
    
    var viewModel:FeedsViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel == nil {
            viewModel = FeedsViewModel(delegate: self, mySubmissionsOnly: false)
        }
        tableViewFeeds.contentInsetAdjustmentBehavior  = .never
        self.imgPlay.isHidden = true
        
        //adding refresh control for pull to refresh
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refreshData(_:)), for: .valueChanged)
        self.tableViewFeeds.refreshControl = refreshControl
        
        DispatchQueue.global(qos: .background).async {
            self.viewModel.getPredefinedComments()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        if player != nil{
            player.playFromCurrentTime()
        }
    }
    
    @IBAction func actionMySubmission(_ sender: UIButton) {
        self.navigationController?.push(MySubmissionsVC.self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if tableViewFeeds != nil {
            tableViewFeeds.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if player != nil {
            player.pause()
        }
    }
    
    
    @IBAction func actionOut(_ sender: UIButton) {
        DataManager.shared.setLoggedInUser(user: nil)
        let navigationController = UINavigationController(rootViewController: LoginVC.instantiated())
        navigationController.setNavigationBarHidden(true, animated: false)
        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate{
            sceneDelegate.window?.rootViewController = navigationController
        }
    }
    
    @IBAction func actionLike(_ sender: UIButton) {
        if let indexPath = tableViewFeeds.indexPathsForVisibleRows?.first{
            viewModel.likeFeed(at: indexPath)
            let feedVM = viewModel.getFeedViewModel(at: indexPath.row)
            let isLiked = !feedVM.isLiked
            self.btnLikes.setImage(UIImage(named: isLiked ? "ic_liked" : "ic_like"), for: .normal)
            let likes = isLiked ? feedVM.likeCount + 1 : feedVM.likeCount - 1
            self.btnLikes.setTitle(likes.description, for: .normal)
        }
    }
    
    @IBAction func actionAdd(_ sender: UIButton) {
        showAlert()
    }
    
    @IBAction func actionComments(_ sender: UIButton) {
        if let indexPath = tableViewFeeds.indexPathsForVisibleRows?.first{
            self.tabBarController?.present(CommentsVC.self, navigationEnabled: false, animated: true, configuration: { (vc) in
                vc.modalPresentationStyle = .overCurrentContext
                vc.viewModel = self.viewModel.getCommentsViewModel(index: indexPath.row)
            }, completion: nil)
        }
        
    }
    
    @IBAction func actionSignou(_ sender: UIButton) {
        DataManager.shared.setLoggedInUser(user: nil)
        if var viewControllers = self.tabBarController?.navigationController?.viewControllers {
            self.tabBarController?.tabBar.isHidden = true
            viewControllers.removeAll()
            viewControllers.append(LoginVC.instantiated())
            self.navigationController?.setViewControllers(viewControllers, animated: true)
        }
    }
    
    
    @objc func refreshData(_ refreshControl:UIRefreshControl){
        refreshControl.endRefreshing()
        viewModel.refreshData()
    }
}

extension HomeVC:UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedsCell", for: indexPath) as! FeedsCell
        cell.setupData(viewModel: viewModel.getFeedViewModel(at: indexPath.row))
        if indexPath.row == viewModel.numberOfItems - 1 {
            viewModel.loadMoreData()
        }
        return cell
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        btnLikes.isEnabled = true
        if let indexPath = tableViewFeeds.indexPathsForVisibleRows?.first,let cell = tableViewFeeds.cellForRow(at: indexPath) as? FeedsCell{
            if cell.viewModel.mediaType == .kImage{
                if player != nil{
                    player.pause()
                    player.removeFromParent()
                    player.view.removeFromSuperview()
                }
            }else {
                self.setupPlayer(url: cell.viewModel.mediaUrl, cell: cell)
            }
            self.btnLikes.setImage(UIImage(named: cell.viewModel.isLiked ? "ic_liked" :
                                           "ic_like"), for: .normal)
            self.btnLikes.setTitle(cell.viewModel.likeCount.description, for: .normal)
            self.btnComments.setTitle(cell.viewModel.commentCount.description, for: .normal)
            lblPostUser.enabledTypes = [.mention]
            lblPostUser.mentionColor = UIColor.white
            lblPostDescription.text = cell.viewModel.caption
            lblPostUser.text = "@\(cell.viewModel.userName ?? "")"
        }
    }

    func setupPlayer(url:URL?,cell:FeedsCell){
        guard let videoUrl = url else {return}
        if player == nil {
            self.player = Player()
            self.player.playerDelegate = self
            self.player.playbackDelegate = self
        } else {
            player.pause()
            player.removeFromParent()
            player.view.removeFromSuperview()
        }
        self.player.url = videoUrl
        self.player.volume = 1.0
            //videoUrl
        self.player.view.frame = cell.bounds
        self.player.fillMode = .resizeAspectFill
        self.addChild(self.player)
        cell.addSubview(self.player.view)
        let tapOnPlayer = UITapGestureRecognizer(target: self, action: #selector(tapOnPlayerView(_:)))
        self.player.view.addGestureRecognizer(tapOnPlayer)
        self.player.didMove(toParent: self)
        self.player.playFromBeginning()
    }
    
    @objc func tapOnPlayerView(_ gesture:UITapGestureRecognizer){
        if player != nil {
            if player.playbackState == .playing {
                player.pause()
                self.imgPlay.image = UIImage(named: "ic_pause")
            }else {
                self.imgPlay.image = UIImage(named: "ic_play")
                player.playFromCurrentTime()
            }
            self.imgPlay.isHidden = false
            UIView.animate(withDuration: 0.35) {
                self.imgPlay.alpha = 1.0
            } completion: { (isSuccess) in
                self.imgPlay.alpha = 0.0
                self.imgPlay.isHidden = true
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height
    }
}

extension HomeVC:FeedsViewModelDelegate {
    func likeApi(isSuccess: Bool) {
        btnLikes.isEnabled = true
        if let indexPath = tableViewFeeds.indexPathsForVisibleRows?.first {
           let vm = viewModel.getFeedViewModel(at: indexPath.row)
            self.btnLikes.setImage(UIImage(named: vm.isLiked ? "ic_liked" :
                                           "ic_like"), for: .normal)
            self.btnLikes.setTitle(vm.likeCount.description, for: .normal)
        }
        
    }
    
    func showAlert(with title: String?, message: String) {
        hideLoader()
        btnLikes.isEnabled = true
        AlertView.showAlert(with: title, message: message,on: self)
    }
    
    func reloadRow(at indexPath: IndexPath) {
        self.tableViewFeeds.reloadRows(at: [indexPath], with: .automatic)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.scrollViewDidEndDecelerating(self.tableViewFeeds)
        }
    }
    
    func reloadData() {
        self.tableViewFeeds.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.scrollViewDidEndDecelerating(self.tableViewFeeds)
        }
    }
}

extension HomeVC:PlayerDelegate ,PlayerPlaybackDelegate{
    
    func playerReady(_ player: Player) {
//        self.imgVideoThumb.isHidden = true
    }
    
    func playerPlaybackStateDidChange(_ player: Player) {
        print("play back state",player.playbackState)
    }
    
    func playerBufferingStateDidChange(_ player: Player) {
        print("buffering state ",player.bufferingState)
    }
    
    func playerBufferTimeDidChange(_ bufferTime: Double) {
        
    }
    
    func player(_ player: Player, didFailWithError error: Error?) {
        
    }
    
    func playerCurrentTimeDidChange(_ player: Player) {
        
    }
    
    func playerPlaybackWillStartFromBeginning(_ player: Player) {
        
    }
    
    func playerPlaybackDidEnd(_ player: Player) {
        
    }
    
    func playerPlaybackWillLoop(_ player: Player) {
        
    }
    
    func playerPlaybackDidLoop(_ player: Player) {
        
    }
    
    
}


extension HomeVC{
    @objc func showAlert() {
        let actionAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionAlert.addAction(UIAlertAction(title: "Video", style: .default, handler: { (action) in
            self.videoFileSelection()
        }))
        actionAlert.addAction(UIAlertAction(title: "Image", style: .default, handler: { (action) in
            self.imageFileSelection()
        }))
       
        actionAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionAlert, animated: true)
    }
    
    func imageFileSelection()  {
        let actionAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionAlert.addAction(UIAlertAction(title: "Capture with camera", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.showImagePickerController(soucrType: .camera, MediaType: MediaTypes.kImage.rawValue)
            }
        }))
        actionAlert.addAction(UIAlertAction(title: "Pick from gallery", style: .default, handler: { (action) in
            self.showImagePickerController(soucrType: .photoLibrary, MediaType: MediaTypes.kImage.rawValue)
        }))
        actionAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionAlert, animated: true)
    }
    
    func showImagePickerController(soucrType: UIImagePickerController.SourceType , MediaType : String) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = soucrType
        imagePicker.mediaTypes = [MediaType]
        imagePicker.allowsEditing = true
        imagePicker.videoMaximumDuration = 30.0
        self.present(imagePicker, animated: true)
    }
    
    func videoFileSelection()  {
        let actionAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionAlert.addAction(UIAlertAction(title: "Capture Video", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.showImagePickerController(soucrType: .camera, MediaType: MediaTypes.kVideo.rawValue)
            }
        }))
        actionAlert.addAction(UIAlertAction(title: "Pick from gallery", style: .default, handler: { (action) in
            self.showImagePickerController(soucrType: .photoLibrary, MediaType: MediaTypes.kVideo.rawValue)
        }))
        actionAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionAlert, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension HomeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.navigationController?.push(AddVideoVC.self, animated: true, configuration: { (vc) in
                vc.viewModel = AddVideoViewModel(videoUrl: nil,thumbnail:image)
            })
            
        }
        else if  let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
           let thumbnail =  VideoUtility.shared.getImageFromUrl(url: videoURL) ?? UIImage()
            
            
            
//            let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".MP4")
            self.navigationController?.push(AddVideoVC.self, animated: true, configuration: { (vc) in
                vc.viewModel = AddVideoViewModel(videoUrl: videoURL,thumbnail:thumbnail)
            })

        }
        self.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
}


extension HomeVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.main
    }
}
