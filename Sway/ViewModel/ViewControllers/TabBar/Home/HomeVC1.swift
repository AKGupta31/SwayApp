////
////  HomeVC.swift
////  Sway
////
////  Created by Admin on 06/05/21.
////
//
//import UIKit
//import ViewControllerDescribable
//import Player
//import AVFoundation
//import SDWebImage
//import ActiveLabel
//
//class HomeVC: BaseTabBarViewController {
//    @IBOutlet weak var lblPostUser: ActiveLabel!
//    
//    @IBOutlet weak var lblPostDescription: UILabel!
//    
//    @IBOutlet weak var imgPlay: UIImageView!
////    @IBOutlet weak var btnComments: CustomTextLocationButton!
////    @IBOutlet weak var btnLikes: CustomTextLocationButton!
//    @IBOutlet weak var tableViewFeeds: UITableView!
////    var player:Player!
//    
//    var refreshControl:UIRefreshControl!
//    var viewModel:FeedsViewModel!
//    
//    
//    var player:AVPlayer?
//    var playerLayer:AVPlayerLayer?
//    var playerItem:AVPlayerItem?
//    var tapOnPlayer:UITapGestureRecognizer!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        if viewModel == nil {
//            viewModel = FeedsViewModel(delegate: self, mySubmissionsOnly: false)
//        }
//        tableViewFeeds.contentInsetAdjustmentBehavior  = .never
//        self.imgPlay.isHidden = true
//        //adding refresh control for pull to refresh
//        refreshControl = UIRefreshControl()
//        refreshControl.tintColor = .clear
//        refreshControl.addTarget(self, action: #selector(self.refreshData(_:)), for: .valueChanged)
//        self.tableViewFeeds.refreshControl = refreshControl
//        self.tableViewFeeds.tableFooterView = nil
//        DispatchQueue.global(qos: .background).async {
//            self.viewModel.getPredefinedComments()
//        }
//        // Do any additional setup after loading the view.
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        self.tabBarController?.tabBar.isHidden = false
//        if player != nil{
//            player?.play()
//        }
//    }
//    
//    @IBAction func actionMySubmission(_ sender: UIButton) {
//        self.navigationController?.push(MySubmissionsVC.self)
//    }
//    
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//        if player != nil {
//            player?.pause()
//        }
//    }
//    
//    
//    @IBAction func actionOut(_ sender: UIButton) {
//        DataManager.shared.setLoggedInUser(user: nil)
//        let navigationController = UINavigationController(rootViewController: LoginVC.instantiated())
//        navigationController.setNavigationBarHidden(true, animated: false)
//        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate{
//            sceneDelegate.window?.rootViewController = navigationController
//        }
//    }
//    
//    @objc func actionLike(_ sender: UIButton) {
//        let indexPath = IndexPath(row: sender.tag, section: 0)
//        if let cell = tableViewFeeds.cellForRow(at: indexPath) as? FeedsCell {
//            viewModel.likeFeed(at: indexPath)
//            let feedVM = viewModel.getFeedViewModel(at: indexPath.row)
//            let isLiked = !feedVM.isLiked
//            
//            cell.btnLikes.setImage(UIImage(named: isLiked ? "ic_liked" : "ic_like"), for: .normal)
//            let likes = isLiked ? feedVM.likeCount + 1 : feedVM.likeCount - 1
//            cell.btnLikes.setTitle(likes.description, for: .normal)
//            sender.rotate()
//        }
////        if let indexPath = tableViewFeeds.indexPathsForVisibleRows?.first{
//           
////        }
//        
//    }
//    
//    @IBAction func actionAdd(_ sender: UIButton) {
//        if player != nil {
//            player?.pause()
//        }
//        showAlert()
//    }
//    
//    @IBAction func actionComments(_ sender: UIButton) {
//        
//        /*Testing */
////        self.navigationController?.push(SubscriptionVC.self)
//        if player != nil {
//            player?.pause()
//        }
//        
//         let indexPath = IndexPath(row: sender.tag, section: 0)
//         self.tabBarController?.present(CommentsVC.self, navigationEnabled: false, animated: true, configuration: { (vc) in
//         vc.modalPresentationStyle = .overCurrentContext
//         vc.viewModel = self.viewModel.getCommentsViewModel(index: indexPath.row)
//         }, completion: nil)
//         
//        
//        
//        //        if let indexPath = tableViewFeeds.indexPathsForVisibleRows?.first{
//        //
//        //        }
//        
//    }
//    
//    @IBAction func actionSignou(_ sender: UIButton) {
//        player?.pause()
////        if player != nil && player.playbackState == .playing {
////            player.pause()
////            player.playbackDelegate = nil
////        }
//        DataManager.shared.setLoggedInUser(user: nil)
//        if var vcs = self.tabBarController?.navigationController?.viewControllers {
//            vcs.removeAll()
//            vcs.append(GuestNewsFeed.instantiated())
//            self.tabBarController?.navigationController?.setViewControllers(vcs, animated: true)
//        }
//    }
//    
//    
//    @objc func refreshData(_ refreshControl:UIRefreshControl){
//        refreshControl.endRefreshing()
//        viewModel.refreshData()
//    }
//}
//
//extension HomeVC:UITableViewDataSource, UITableViewDelegate {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let numberOfItems = viewModel.numberOfItems
//        if numberOfItems <= 0 {
//            tableView.backgroundView = Helper.shared.addNoDataLabel(strMessage: "No News feed is available, please click on the \u{0002B} option to upload the news feed", to: tableView,offSet: CGPoint(x: 0, y: -150))
//        }else {
//            tableView.backgroundView = nil
//        }
//        return numberOfItems
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedsCell", for: indexPath) as! FeedsCell
//        cell.setupData(viewModel: viewModel.getFeedViewModel(at: indexPath.row))
//        if indexPath.row == viewModel.numberOfItems - 1 {
//            viewModel.loadMoreData()
//        }
//        cell.btnLikes.tag = indexPath.row
//        cell.btnComments.tag = indexPath.row
//        cell.btnLikes.addTarget(self, action: #selector(actionLike(_:)), for: .touchUpInside)
//        cell.btnComments.addTarget(self, action: #selector(actionComments(_:)), for: .touchUpInside)
//        return cell
//    }
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
////        btnLikes.isEnabled = true
//        if let indexPath = tableViewFeeds.indexPathsForVisibleRows?.first,let cell = tableViewFeeds.cellForRow(at: indexPath) as? FeedsCell{
//            if cell.viewModel.mediaType == .kImage{
//                if tapOnPlayer != nil && cell.gestureRecognizers?.contains(tapOnPlayer) ?? false{
//                    cell.removeGestureRecognizer(tapOnPlayer)
//                }
//                if player != nil{
//                    player?.pause()
//                    playerLayer?.removeFromSuperlayer()
//                }
//            }else {
//                self.setupPlayer(url: cell.viewModel.mediaUrl, cell: cell)
//            }
////            self.btnLikes.setImage(UIImage(named: cell.viewModel.isLiked ? "ic_liked" :
////                                           "ic_like"), for: .normal)
////            self.btnLikes.setTitle(cell.viewModel.likeCount.description, for: .normal)
////            self.btnComments.setTitle(cell.viewModel.commentCount.description, for: .normal)
//            lblPostUser.enabledTypes = [.mention]
//            lblPostUser.mentionColor = UIColor.white
//            lblPostDescription.text = cell.viewModel.caption
//            lblPostUser.text = "@\(cell.viewModel.userName ?? "")"
//        }
//    }
//    
////    override class func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
////        if (object == player && keyPath == "status") {
////            if
////               if (player.status == AVPlayerStatusReadyToPlay) {
////                   playButton.enabled = YES;
////               } else if (player.status == AVPlayerStatusFailed) {
////                   // something went wrong. player.error should contain some information
////               }
////           }
////    }
//
//    func setupPlayer(url:URL?,cell:FeedsCell){
//        guard let videoUrl = url else {return}
//        playerItem = AVPlayerItem(url:videoUrl)
//        if player == nil {
//             player = AVPlayer(playerItem: playerItem!)
//        } else {
//            player?.pause()
//            playerLayer?.removeFromSuperlayer()
//            playerLayer = nil
//            player?.replaceCurrentItem(with: playerItem!)
//        }
//        playerLayer = AVPlayerLayer(player: player!)
//        playerLayer?.frame = cell.bounds
//        player?.volume = 1.0
//        playerLayer?.videoGravity = .resizeAspectFill
//        NotificationCenter.default.addObserver(self,
//                      selector: #selector(playerItemDidReadyToPlay(notification:)),
//                      name: .AVPlayerItemNewAccessLogEntry,
//                      object: player?.currentItem)
//        cell.contentView.layer.insertSublayer(playerLayer!, at: 1)
//        self.player?.play()
//        
//       
//    
//        
////        self.player?.currentItem = playerItem
////        self.player?.url = videoUrl
////        self.player.volume = 1.0
//            //videoUrl
////        self.player.view.frame = cell.bounds
////        self.player.fillMode = .resizeAspectFill
////        self.addChild(self.player)
////        cell.contentView.insertSubview(self.player.view, at: 1)
//        
//        
////        if player == nil {
////            self.player = Player()
////            self.player.playerDelegate = self
////            self.player.playbackDelegate = self
////        } else {
////            player.pause()
////            player.removeFromParent()
////            player.view.removeFromSuperview()
////        }
////        self.player.url = videoUrl
////        self.player.volume = 1.0
////            //videoUrl
////        self.player.view.frame = cell.bounds
////        self.player.fillMode = .resizeAspectFill
////        self.addChild(self.player)
////        cell.contentView.insertSubview(self.player.view, at: 1)
////        cell.addSubview(self.player.view)
//        
////        cell.bringSubviewToFront(cell.btnComments)
////        cell.bringSubviewToFront(cell.btnLikes)
//        tapOnPlayer = UITapGestureRecognizer(target: self, action: #selector(tapOnPlayerView(_:)))
//        cell.addGestureRecognizer(tapOnPlayer)
////        self.player.view.addGestureRecognizer(tapOnPlayer)
////        self.player.didMove(toParent: self)
////        self.player.playFromBeginning()
//    }
//    
//    @objc func playerItemDidReadyToPlay(notification: Notification) {
//            if let _ = notification.object as? AVPlayerItem {
//                // player is ready to play now!!
//                self.player?.play()
//            }
//    }
//    
//    
//    
//    @objc func tapOnPlayerView(_ gesture:UITapGestureRecognizer){
//        if player != nil {
//            if player?.timeControlStatus == .playing {
//                player?.pause()
//                self.imgPlay.image = UIImage(named: "ic_pause")
//            }else {
//                self.imgPlay.image = UIImage(named: "ic_play")
//                player?.play()
//            }
//            self.imgPlay.isHidden = false
//            UIView.animate(withDuration: 0.35) {
//                self.imgPlay.alpha = 1.0
//            } completion: { (isSuccess) in
//                self.imgPlay.alpha = 0.0
//                self.imgPlay.isHidden = true
//            }
//        }
//    }
//    
//    
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return tableView.frame.height
//    }
//    
//    func deinitPlayer(){
//        self.player?.pause()
//        playerLayer?.removeFromSuperlayer()
//        player = nil
//    }
//}
//
//extension HomeVC:FeedsViewModelDelegate {
//    func likeApi(isSuccess: Bool,indexPath:IndexPath) {
//        if let cell = tableViewFeeds.cellForRow(at: indexPath) as? FeedsCell {
//            let vm = viewModel.getFeedViewModel(at: indexPath.row)
//             cell.btnLikes.setImage(UIImage(named: vm.isLiked ? "ic_liked" :
//                                            "ic_like"), for: .normal)
//             cell.btnLikes.setTitle(vm.likeCount.description, for: .normal)
//        }
////        btnLikes.isEnabled = true
////        if let indexPath = tableViewFeeds.indexPathsForVisibleRows?.first {
////           let vm = viewModel.getFeedViewModel(at: indexPath.row)
////            self.btnLikes.setImage(UIImage(named: vm.isLiked ? "ic_liked" :
////                                           "ic_like"), for: .normal)
////            self.btnLikes.setTitle(vm.likeCount.description, for: .normal)
////        }
////
//    }
//    
//    func showAlert(with title: String?, message: String) {
//        hideLoader()
////        btnLikes.isEnabled = true
//        AlertView.showAlert(with: title, message: message,on: self)
//    }
//    
//    func reloadRow(at indexPath: IndexPath) {
//        self.tableViewFeeds.reloadRows(at: [indexPath], with: .automatic)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            self.scrollViewDidEndDecelerating(self.tableViewFeeds)
//        }
//    }
//    
//    func reloadData() {
//        self.tableViewFeeds.reloadData()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            self.scrollViewDidEndDecelerating(self.tableViewFeeds)
//        }
//    }
//}
//
//extension HomeVC:PlayerDelegate ,PlayerPlaybackDelegate{
//    
//    func playerReady(_ player: Player) {
////        self.imgVideoThumb.isHidden = true
//    }
//    
//    func playerPlaybackStateDidChange(_ player: Player) {
//        print("play back state",player.playbackState)
//    }
//    
//    func playerBufferingStateDidChange(_ player: Player) {
//        print("buffering state ",player.bufferingState)
//    }
//    
//    func playerBufferTimeDidChange(_ bufferTime: Double) {
//        
//    }
//    
//    func player(_ player: Player, didFailWithError error: Error?) {
//        
//    }
//    
//    func playerCurrentTimeDidChange(_ player: Player) {
//        
//    }
//    
//    func playerPlaybackWillStartFromBeginning(_ player: Player) {
//        
//    }
//    
//    func playerPlaybackDidEnd(_ player: Player) {
//        
//    }
//    
//    func playerPlaybackWillLoop(_ player: Player) {
//        
//    }
//    
//    func playerPlaybackDidLoop(_ player: Player) {
//        
//    }
//    
//    
//}
//
//
//extension HomeVC{
//    @objc func showAlert() {
//        let actionAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        actionAlert.addAction(UIAlertAction(title: "Video", style: .default, handler: { (action) in
//            self.videoFileSelection()
//        }))
//        actionAlert.addAction(UIAlertAction(title: "Image", style: .default, handler: { (action) in
//            self.imageFileSelection()
//        }))
//       
//        actionAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        self.present(actionAlert, animated: true)
//    }
//    
//    func imageFileSelection()  {
//        let actionAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        actionAlert.addAction(UIAlertAction(title: "Capture with camera", style: .default, handler: { (action) in
//            if UIImagePickerController.isSourceTypeAvailable(.camera) {
//                self.showImagePickerController(soucrType: .camera, MediaType: MediaTypes.kImage.rawValue)
//            }
//        }))
//        actionAlert.addAction(UIAlertAction(title: "Pick from gallery", style: .default, handler: { (action) in
//            self.showImagePickerController(soucrType: .photoLibrary, MediaType: MediaTypes.kImage.rawValue)
//        }))
//        actionAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        
//        self.present(actionAlert, animated: true)
//    }
//    
//    func showImagePickerController(soucrType: UIImagePickerController.SourceType , MediaType : String) {
//        let imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
//        imagePicker.sourceType = soucrType
//        imagePicker.mediaTypes = [MediaType]
//        imagePicker.allowsEditing = true
//        imagePicker.videoMaximumDuration = 60
//        self.present(imagePicker, animated: true)
//    }
//    
//    func videoFileSelection()  {
//        let actionAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        actionAlert.addAction(UIAlertAction(title: "Capture Video", style: .default, handler: { (action) in
//            if UIImagePickerController.isSourceTypeAvailable(.camera) {
//                self.showImagePickerController(soucrType: .camera, MediaType: MediaTypes.kVideo.rawValue)
//            }
//        }))
//        actionAlert.addAction(UIAlertAction(title: "Pick from gallery", style: .default, handler: { (action) in
//            self.showImagePickerController(soucrType: .photoLibrary, MediaType: MediaTypes.kVideo.rawValue)
//        }))
//        actionAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        
//        self.present(actionAlert, animated: true)
//    }
//}
//
//// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
//extension HomeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        self.dismiss(animated: true)
//        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
//            self.navigationController?.push(AddVideoVC.self, animated: true, configuration: { (vc) in
//                vc.viewModel = AddVideoViewModel(videoUrl: nil,thumbnail:image)
//            })
//            
//        }
//        else if  let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
//           let thumbnail =  VideoUtility.shared.getImageFromUrl(url: videoURL) ?? UIImage()
//           let asset = AVURLAsset(url: videoURL)
//            if asset.duration.seconds < 10 {
//                showAlert(with: "Error!", message: "Video must be minimum to 10 seconds")
//            } else if asset.duration.seconds > 60 {
//                showAlert(with: "Error!", message: "Video must be maximum to 60 seconds")
//            }else {
//                self.navigationController?.push(AddVideoVC.self, animated: true, configuration: { (vc) in
//                    vc.viewModel = AddVideoViewModel(videoUrl: videoURL,thumbnail:thumbnail)
//                })
//            }
//            
//            
////            let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".MP4")
//         
//
//        }
//        
//    }
//    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        self.dismiss(animated: true)
//    }
//}
//
//
//extension HomeVC:ViewControllerDescribable {
//    static var storyboardName: StoryboardNameDescribable {
//        return UIStoryboard.Name.main
//    }
//}
//
//
//extension UIView{
//    func rotate() {
//        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
//        rotation.toValue = NSNumber(value: Double.pi * 2)
//        rotation.duration = 0.35
//        rotation.isCumulative = true
//        rotation.repeatCount = 1
//        rotation.isRemovedOnCompletion = true
//        self.layer.add(rotation, forKey: "rotationAnimation")
//    }
//}
