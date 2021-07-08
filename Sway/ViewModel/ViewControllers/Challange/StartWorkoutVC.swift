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
    var playerView:VideoPlayerView!
    var videoProgress:KDCircularProgress!
    weak var delegate:StartWorkoutVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.controller = .StartWorkoutVC
        viewModel.delegate = self
        edgesForExtendedLayout = [.bottom]
        extendedLayoutIncludesOpaqueBars = true
        tableViewWorkouts.contentInsetAdjustmentBehavior  = .never
        tableViewWorkouts.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        checkPreload()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.btnCrossTopConstraint.constant = view.safeAreaInsets.top + 16
    }
    
    deinit {
        print("deinit ",self.description)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnCross.isEnabled = false
        setupProgressView()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(actionTimer(_:)), userInfo: nil, repeats: true)
    }

    @IBAction func actionCross(_ sender: UIButton) {
        pause(reason: .hidden)
        if playerView != nil && playerView.superview != nil{
            playerView.removeFromSuperview()
            playerView = nil
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func actionTimer(_ timer:Timer){
        i -= 1
        progressCount += 1
        if i <= 0{
            btnCross.isEnabled = true
            hideBlurOverlayView()
            timer.invalidate()
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
    

}

extension StartWorkoutVC:WorkoutContentsVMDelegate {
    func reloadData() {
    }
    
    func workoutMarkedAsViewed(contentId: String, workoutId: String) {
        hideLoader()
        self.delegate?.markWorkoutAsViewed(workoutId: workoutId, circuitId: contentId)
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
        cell.lblTitleTopConstraint.constant = self.btnCrossTopConstraint.constant
        cell.setupData(viewModel: viewModel.getMovementVM(at: indexPath.row), indexPath: indexPath)
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
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if let cell = tableViewWorkouts.visibleCells.first as? StartWorkoutVideoWithTimerCell{
//            play()
//        }
        play()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        play()
//        if let cell = tableViewWorkouts.visibleCells.first as? StartWorkoutVideoWithTimerCell{
//            play()
//        }
    }
}

extension StartWorkoutVC {
    func play() {
        guard let cell = tableViewWorkouts.visibleCells.first as? StartWorkoutVideoWithTimerCell else {return}
        guard let indexPath = tableViewWorkouts.indexPath(for: cell) else {return}
        if let videoUrl = cell.viewModel.mainVideoUrl {
            if playerView != nil ,playerView.superview != nil{
                playerView.removeFromSuperview()
                playerView = nil
            }
            /*Setup Player View*/
            playerView = VideoPlayerView()
            playerView.contentMode = .scaleAspectFill
            playerView.frame = cell.bounds
            cell.contentView.insertSubview(playerView, at: 0)
            /* End of setup player view */
            cell.progressView.isHidden = false
            cell.imgVideoThumb.isHidden = true
            
//            print("play at indexPath ,",indexPath.row)
//            print("play with url ,",videoUrl)
            playerView.play(for: videoUrl)
            playerView.isHidden = false
            playerView.contentMode = .scaleAspectFill
            playerView.stateDidChanged = {[weak self](state) in
                switch state {
                case .playing:
                    cell.lblProgressCounter.text = Int(self!.playerView.totalDuration).description
                    self?.setupCellProgressView(for: cell)
                    break
                default:
                    break
                }
            }
            playerView.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: 30), queue: .main) { (time) in
                if self.videoProgress != nil && self.playerView != nil {
                    var newProgress = time.seconds / self.playerView.totalDuration
                    print("new progress ",newProgress)
                    if newProgress.isNaN || newProgress > 1{
                        newProgress = 1.0
                    }
                    self.videoProgress.progress = newProgress
                }
            }
            playerView.playToEndTime = {[weak self] in
                self?.pause(reason: .hidden)
                if self?.tableViewWorkouts.numberOfRows(inSection: 0) ?? 0 > indexPath.row + 1 {
                    self?.tableViewWorkouts.scrollToRow(at: IndexPath(row: indexPath.row + 1, section: indexPath.section), at: .top, animated: true)
                }else {
                    DispatchQueue.main.async {
                        self?.showLoader()
                        self?.viewModel.markAsCompleted()
                    }
                    
                }
            }
        }
    }
    
    func pause(reason:VideoPlayerView.PausedReason) {
        playerView.pause(reason:reason)
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
        cell.progressView.insertSubview(videoProgress, at: 0)
        cell.progressViewInnerCircle.backgroundColor = UIColor(named: "kThemeYellow")
    }

}
