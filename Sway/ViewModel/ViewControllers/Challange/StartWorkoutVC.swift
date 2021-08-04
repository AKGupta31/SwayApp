//
//  StartWorkoutVC.swift
//  Sway
//
//  Created by Admin on 07/07/21.
//

import UIKit
import ViewControllerDescribable
import KDCircularProgress
import GSPlayer
import AVFoundation


protocol StartWorkoutVCDelegate:class {
    func markWorkoutAsViewed(workoutId:String,circuitId:String)
}

class StartWorkoutVC: BaseViewController {
    @IBOutlet weak var btnCrossTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableViewWorkouts: UITableView!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var countdownProgressLabel: UILabel!
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var lblStartIn: UILabel!
    @IBOutlet weak var countDownTimerProgressView: UIView!
    @IBOutlet weak var countdownProgressInnerCircle: CustomView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var lblNextVideoName: UILabel!
    var viewModel:WorkoutContentsVM!
    var progress:KDCircularProgress!
    var timer:Timer!
    var i = 10
    var progressCount:Double = 0
    var timeObserverToken: Any?
    var playerView:VideoPlayerView!
//    var player:AVPlayer!
//    var playerLayer:AVPlayerLayer!
    
    var videoProgress:KDCircularProgress!
    weak var delegate:StartWorkoutVCDelegate?

//    var playerItemContext = 0
    
    lazy var imgPlay:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ic_pause"))
        imageView.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
        self.view.addSubview(imageView)
        return imageView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.controller = .StartWorkoutVC
        viewModel.delegate = self
        edgesForExtendedLayout = [.bottom]
        extendedLayoutIncludesOpaqueBars = true
        tableViewWorkouts.contentInsetAdjustmentBehavior  = .never
        tableViewWorkouts.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        blurView.isHidden = true
        checkPreload()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapOnPlayer(_:)))
        self.view.addGestureRecognizer(tap)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            self.btnCross.isEnabled = false
            self.setupProgressView()
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.actionTimer(_:)), userInfo: nil, repeats: true)
            self.showNextVideoName(currentCellIndex: 0)
        }
        
//        NotificationCenter.default.addObserver(self, selector: #selector(playerDidEndPlaying(_:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(videoStalled(_:)),
//                                                      name: NSNotification.Name.AVPlayerItemPlaybackStalled, object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func videoStalled(_ notification:Notification){
        print("video stalled")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.btnCrossTopConstraint.constant = view.safeAreaInsets.top + 16
    }
    
    deinit {
        print("deinit ",self.description)
    }
    
    


    @IBAction func actionCross(_ sender: UIButton) {
        if self.timer != nil ,timer.isValid{
            timer.invalidate()
            self.navigationController?.popViewController(animated: true)
            return
        }
        if let cell = tableViewWorkouts.visibleCells.first as? StartWorkoutVideoWithTimerCell{
            let wasPlayingBefore = playerView != nil ? (playerView.state == .playing ? true : false) : false //vm.player.timeControlStatus == .playing
            pause(reason: .userInteraction)
            self.getNavController()?.present(WorkoutEndAlertVC.self, navigationEnabled: false, animated: false, configuration: { (vc) in
                vc.modalPresentationStyle = .overCurrentContext
                vc.videoThumbnail = cell.imgVideoThumb.image
                vc.wasPlayingBeforeComingToTheScreen = wasPlayingBefore
                vc.actionQuit = {[weak self](wasPlayingBefore,workoutEndVC) in
//                    guard let nav = self?.navigationController else {return}
                    
                    //remove start workout vc from nativationcontroller i.e self instance
                 /*
                    var vcs = nav.viewControllers
                    vcs.removeLast()
                    let rateChallenge = RateChallengeVC.instantiated()
                    rateChallenge.workoutId = self!.viewModel.workoutId
                    rateChallenge.challengeId = self!.viewModel.challengeId
                    vcs.append(rateChallenge)
                    self?.navigationController?.setViewControllers(vcs, animated: true)
 
                    */
                    self?.pause(reason: .hidden)
                    if self?.playerView != nil && self?.playerView.superview != nil {
                        self?.playerView.removeFromSuperview()
                        self?.playerView = nil
                    }
                    if var vcs = self?.navigationController?.viewControllers {
                        vcs.removeLast()
                        vcs.removeLast()
                        self?.navigationController?.setViewControllers(vcs, animated: true)
                    }
                    workoutEndVC.dismiss(animated: true, completion: nil)
                
                }
                vc.actionResume = {[weak self](wasPlayingBefore,workoutEndVC) in
                    if wasPlayingBefore {
                        if self?.playerView != nil {
                            self?.playerView.resume()
                        }
                    }
                    workoutEndVC.dismiss(animated: true, completion: nil)
                }
            }, completion: nil)
        }
        //        pause(reason: .hidden)
        //        if playerView != nil && playerView.superview != nil{
        //            playerView.removeFromSuperview()
        //            playerView = nil
        //        }
        //        self.navigationController?.popViewController(animated: true)
    }
    
    func removePlayer(){
        if playerView != nil && playerView.superview != nil{
            playerView.removeFromSuperview()
            playerView = nil
        }
    }
    
    @objc func actionTimer(_ timer:Timer){
        i -= 1
        progressCount += 1
        if i <= 0{
//            btnCross.isEnabled = true
            hideBlurOverlayView()
            timer.invalidate()
            self.timer = nil
            play()
//            if let cell = tableViewWorkouts.visibleCells.first as? StartWorkoutVideoWithTimerCell {
//
//            }
//            if let url = URL(string: urlStr) {
//                setupProgressView(for: url)
//            }
        }
        countdownProgressLabel.text = i.description
        progress.animate(toAngle: 36 * progressCount, duration: 1, completion: nil)
    }
    
    @objc func tapOnPlayer(_ gesture:UITapGestureRecognizer){
        if let cell = tableViewWorkouts.visibleCells.first as? StartWorkoutVideoWithTimerCell,let vm = cell.viewModel , let player = playerView{
            if player.state == .playing {
                pause(reason: .userInteraction)
                self.imgPlay.image = UIImage(named: "ic_pause")
            }else {
                self.imgPlay.image = UIImage(named: "ic_play")
                player.resume()
//                vm.player.play()
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
    
    
    func removeObservers(){
        removePeriodicTimeObserver()
//        NotificationCenter.default.removeObserver(self)
    }

}

extension StartWorkoutVC:WorkoutContentsVMDelegate {
    func reloadData() {
    }
    
    func workoutMarkedAsViewed(contentId: String, workoutId: String) {
        hideLoader()
        self.delegate?.markWorkoutAsViewed(workoutId: workoutId, circuitId: contentId)
        pause(reason: .userInteraction)
        removeObservers()
        if var vcs = self.navigationController?.viewControllers {
            vcs.removeLast()
            vcs.removeLast()
            self.navigationController?.setViewControllers(vcs, animated: true)
        }
    }
    
    func showAlert(with title: String?, message: String) {
        hideLoader()
        AlertView.showAlert(with: title, message: message, on: self)
    }
}

//MARK: Private Functions

extension StartWorkoutVC {
    fileprivate func setupProgressView(){
        if progress != nil ,progress.superview != nil {
            progress.removeFromSuperview()
        }
        progress = KDCircularProgress(frame:countDownTimerProgressView.bounds)
        progress.startAngle = -90
        progress.progressThickness = 0.2
        progress.trackThickness = 0.05
        progress.clockwise = true
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = false
        progress.roundedCorners = true
        progress.glowMode = .noGlow
        progress.set(colors: UIColor(named: "kThemeBlue")!)
        progress.trackColor = UIColor(named: "k124123132")!
        progress.progress = 0
        countDownTimerProgressView.addSubview(progress)
        countdownProgressInnerCircle.backgroundColor = UIColor(named: "kThemeYellow")
    }
    
    func hideBlurOverlayView(){
        blurView.isHidden = true
        countDownTimerProgressView.isHidden = true
        lblStartIn.isHidden = true
    }
    
    func checkPreload() {
//        guard let lastRow = tableViewWorkouts.indexPathsForVisibleRows?.last?.row else { return }
        VideoPreloadManager.shared.preloadByteCount = 1024 * 1024 * 4
        VideoPreloadManager.shared.set(waiting: viewModel.getVideoUrlsInMovements())
    }
    
}
extension StartWorkoutVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.challenge
    }
}


extension StartWorkoutVC:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfMovements
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StartWorkoutVideoWithTimerCell", for: indexPath) as! StartWorkoutVideoWithTimerCell
        cell.progressViewBottomConstraint.constant = 76 + self.view.safeAreaInsets.bottom
        cell.lblTitleTopConstraint.constant = self.btnCrossTopConstraint.constant - 16
        cell.setupData(viewModel: viewModel.getMovementVM(at: indexPath.row), indexPath: indexPath)
        cell.btnInfo.tag = indexPath.row
        cell.btnInfo.addTarget(self, action: #selector(actionInfo(_:)), for: .touchUpInside)
        cell.backgroundColor = .black
//        cell.videoDidEnd = {[weak self](indexPath) in
//            if tableView.numberOfRows(inSection: 0) > indexPath.row + 1 {
//                tableView.scrollToRow(at: IndexPath(row: indexPath.row + 1, section: indexPath.section), at: .top, animated: true)
////                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
////                    if let cell = tableView.visibleCells.first as? StartWorkoutVideoWithTimerCell{
////                        cell.play()
////                    }
////                }
//            }
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height
    }


//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        play()
//    }
    
//    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        play()
//    }
    
    @objc func actionInfo(_ sender:UIButton){
//        pause(reason: .userInteraction)
        if let cell = tableViewWorkouts.visibleCells.first as? StartWorkoutVideoWithTimerCell,let infoVM = cell.viewModel ,let player = playerView{
//            let infoVm = viewModel.getMovementVM(at: sender.tag)
            let wasPlaying = player.state == .playing//infoVM.player.timeControlStatus == .playing
            pause(reason: .userInteraction)
            self.getNavController()?.present(WorkoutInfoVC.self, navigationEnabled: false, animated: true, configuration: { (vc) in
                vc.infoVM = infoVM
                vc.modalPresentationStyle = .fullScreen
                vc.wasPlayingVideoWhenComingToThisScreen = wasPlaying
                vc.actionClose = {(wasPlayingBefore) in
                    if wasPlayingBefore {
                        player.resume()
                    }
                }
            }, completion: {Void in
                
            })
        }
        
        
    }
}

extension StartWorkoutVC {
    func play() {
        
        guard let cell = self.tableViewWorkouts.visibleCells.first as? StartWorkoutVideoWithTimerCell else {return}
        guard let indexPath = self.tableViewWorkouts.indexPath(for: cell) else {return}
        startActivityIndicator(style: .medium, inSelf: true, touchEnabled: true, tintColor: .white)
        /***********PLAY WITH PLAYER LAYER AND AVPLAYER ******/
        /*
         
         cell.imgVideoThumb.isHidden = true
         if let viewModel = cell.viewModel{
         if playerLayer != nil {
         playerLayer.removeFromSuperlayer()
         playerLayer = nil
         }
         if viewModel.playerItem.status != .readyToPlay {
         startActivityIndicator()
         }
         addPeriodicTimeObserver(cell: cell)
         viewModel.playerItem.addObserver(self,
         forKeyPath: #keyPath(AVPlayerItem.status),
         options: [.old, .new],
         context: &playerItemContext)
         playerLayer = AVPlayerLayer(player: viewModel.player)
         playerLayer.frame = cell.bounds
         viewModel.player.volume = 1.0
         cell.contentView.layer.insertSublayer(playerLayer, above: cell.imgVideoThumb.layer)
         viewModel.player.seek(to: .zero, toleranceBefore: .zero, toleranceAfter: .zero)
         self.setupCellProgressView(for: cell)
         cell.lblProgressCounter.text = cell.viewModel.duration.description
         viewModel.player.play()
         showNextVideoName(currentCellIndex: indexPath.row)
         }
         */
        /***********END OF PLAY WITH PLAYER LAYER AND AVPLAYER ******/
        
        guard let videoUrl = cell.viewModel.mainVideoUrl else {
            return
        }
        
        if self.playerView != nil ,self.playerView.superview != nil{
            self.playerView.removeFromSuperview()
            self.playerView = nil
        }
        /*Setup Player View*/
        self.playerView = VideoPlayerView()
        self.playerView.contentMode = .scaleAspectFill
        self.playerView.frame = cell.bounds
        cell.contentView.insertSubview(self.playerView, at: 0)
        /* End of setup player view */
        cell.progressView.isHidden = false
        cell.imgVideoThumb.isHidden = true
        self.playerView.play(for: videoUrl)
        self.playerView.isHidden = false
        self.playerView.contentMode = .scaleAspectFill
        showNextVideoName(currentCellIndex: indexPath.row)
        self.playerView.stateDidChanged = {[weak self](state) in
            switch state {
            case .playing:
                self?.stopActivityIndicator()
                cell.lblProgressCounter.text = Int(self!.playerView.totalDuration).description
                self?.setupCellProgressView(for: cell)
                break
            case .error(let error1):
                print("error ",error1.localizedDescription)
            default:
                break
            }
        }
        self.playerView.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: 30), queue: .main) { (time) in
            if self.videoProgress != nil && self.playerView != nil {
                var newProgress = time.seconds / self.playerView.totalDuration
                print("new progress ",newProgress)
                if newProgress.isNaN || newProgress > 1{
                    newProgress = 1.0
                }
                self.videoProgress.progress = newProgress
                var durationLeft = self.playerView.totalDuration - time.seconds
                if durationLeft < 0 {
                    durationLeft = 0
                }
                cell.lblProgressCounter.text = Int(durationLeft).description
            }
        }
        self.playerView.playToEndTime = {[weak self] in
            self?.playerDidEndPlaying()
//            self?.pause(reason: .hidden)
//            if self?.tableViewWorkouts.numberOfRows(inSection: 0) ?? 0 > indexPath.row + 1 {
//                self?.tableViewWorkouts.scrollToRow(at: IndexPath(row: indexPath.row + 1, section: indexPath.section), at: .top, animated: false)
//            }else {
//                DispatchQueue.main.async {
//                    self?.showLoader()
//                    self?.viewModel.markAsCompleted()
//                }
//
//            }
        }
    }
    
    func showNextVideoName(currentCellIndex:Int){
        if self.tableViewWorkouts.numberOfRows(inSection: 0) > currentCellIndex + 1 {
            let vm = viewModel.getMovementVM(at: currentCellIndex + 1)
            lblNextVideoName.text = vm.videoName
        }else {
            lblNextVideoName.text = ""
        }
    }
    
    
    func pause(reason:VideoPlayerView.PausedReason) {
        if playerView != nil {
            playerView.pause(reason:reason)
        }
        
        //        if let cell = tableViewWorkouts.visibleCells.first as? StartWorkoutVideoWithTimerCell,let viewModel = cell.viewModel {
        //            viewModel.player.pause()
        //        }
        
    }
    
    func setupCellProgressView(for cell:StartWorkoutVideoWithTimerCell){
        if videoProgress != nil,videoProgress.superview != nil {
            videoProgress.removeFromSuperview()
            videoProgress = nil
        }
        videoProgress = KDCircularProgress(frame:cell.progressView.bounds)
        videoProgress.startAngle = -90
        videoProgress.progressThickness = 0.2
        videoProgress.trackThickness = 0.05
        videoProgress.clockwise = true
        videoProgress.gradientRotateSpeed = 2
        videoProgress.roundedCorners = false
        videoProgress.roundedCorners = true
        videoProgress.glowMode = .noGlow
        videoProgress.set(colors: UIColor(named: "kThemeBlue")!)
        videoProgress.trackColor = UIColor(named: "k124123132")!
        videoProgress.progress = 0
        cell.progressView.isHidden = false
        cell.progressView.insertSubview(videoProgress, at: 0)
        cell.progressViewInnerCircle.backgroundColor = UIColor(named: "kThemeYellow")
    }

}

extension StartWorkoutVC {
    @objc func playerDidEndPlaying(){
        guard let cell = self.tableViewWorkouts.visibleCells.first as? StartWorkoutVideoWithTimerCell else {return}
        guard let indexPath = self.tableViewWorkouts.indexPath(for: cell) else {return}
        pause(reason: .hidden)
//        cell.viewModel.player.pause()
//        cell.viewModel.player.volume = 0
//        removePeriodicTimeObserver()
        if self.tableViewWorkouts.numberOfRows(inSection: 0) > indexPath.row + 1 {
            self.tableViewWorkouts.scrollToRow(at: IndexPath(row: indexPath.row + 1, section: indexPath.section), at: .top, animated: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.play()
            }
        }else {
            DispatchQueue.main.async {
                self.showLoader()
                self.viewModel.markAsCompleted()
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        
//        // Only handle observations for the playerItemContext
//        guard context == &playerItemContext else {
//            super.observeValue(forKeyPath: keyPath,
//                               of: object,
//                               change: change,
//                               context: context)
//            return
//        }
//
//        if keyPath == #keyPath(AVPlayerItem.status) {
//            let status: AVPlayerItem.Status
//            if let statusNumber = change?[.newKey] as? NSNumber {
//                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
//            } else {
//                status = .unknown
//            }
//
//            // Switch over status value
//            switch status {
//            case .readyToPlay:
//                stopActivityIndicator()
//                if let cell = tableViewWorkouts.visibleCells.first as? StartWorkoutVideoWithTimerCell {
//                    cell.lblProgressCounter.text =  Int(cell.viewModel.playerItem.duration.seconds).description
//
//                }
//            // Player item is ready to play.
//            case .failed:
//                // Player item failed. See error.
//                showAlert(with: "Error!", message: "Failed to play the video")
//            case .unknown:
//                // Player item is not yet ready.
//                startActivityIndicator()
//            default:
//                break
//            }
//        }
    }
    
    //MARK:- AV Player Delegates
    func addPeriodicTimeObserver(cell:StartWorkoutVideoWithTimerCell) {
//        if let viewModel = cell.viewModel{
//            viewModel.player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: 60), queue: .main) { (time) in
//                if self.videoProgress != nil{
//                    var newProgress = time.seconds / viewModel.playerItem.totalDuration
//                    print("new progress ",newProgress)
//                    if newProgress.isNaN || newProgress > 1{
//                        newProgress = 1.0
//                    }
//                    self.videoProgress.progress = newProgress
//                }
//            }
//        }
    }
    
    func removePeriodicTimeObserver() {
//        if let cell = tableViewWorkouts.visibleCells.first as? StartWorkoutVideoWithTimerCell,let viewModel = cell.viewModel{
//            if let timeObserverToken = timeObserverToken {
//                viewModel.player.removeTimeObserver(timeObserverToken)
//                self.timeObserverToken = nil
//            }
//        }
    }
}
