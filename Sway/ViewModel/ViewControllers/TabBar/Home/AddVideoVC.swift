//
//  AddVideoVC.swift
//  Sway
//
//  Created by Admin on 18/05/21.
//

import UIKit
import AVKit
import ViewControllerDescribable
import GrowingTextView
class AddVideoVC: BaseViewController {

    @IBOutlet weak var mediaView: UIView!
    @IBOutlet weak var textViewCaptions: GrowingTextView!
    @IBOutlet weak var btnSubmit: CustomButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnOtherContentWorkout: WorkoutButton!
    @IBOutlet weak var btnHiitWorkout: WorkoutButton!
    var viewModel:AddVideoViewModel!
    @IBOutlet weak var btnDanceWorkout: WorkoutButton!
    @IBOutlet weak var mediaThumbView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mediaThumbView.image = viewModel.thumbnail
        viewModel.delegate = self
        mediaThumbView.layer.cornerRadius = 10.0
        mediaThumbView.clipsToBounds = true
        
        if viewModel.mediaType == .kImage{
            let tapOnMediaView = UITapGestureRecognizer(target: self, action: #selector(tapOnMediaView(_:)))
            self.mediaView.addGestureRecognizer(tapOnMediaView)
        }
        
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    @objc func tapOnMediaView(_ gesture:UITapGestureRecognizer){
        self.present(ViewImageVC.self, navigationEnabled: false, animated: true) { (vc) in
            vc.image = self.viewModel.thumbnail
            vc.modalPresentationStyle = .fullScreen
//            vc.image = self.viewModel.videoUrl
        } completion: { (vc) in
            
        }

    }
    
    fileprivate func setupUI(){
        if viewModel.mediaType == .kVideo {
            btnPlay.isHidden = false
        }else {
            btnPlay.isHidden = true
        }
        btnDanceWorkout.isSelected = true
        btnSubmit.isEnabled = false
        textViewCaptions.delegate = viewModel
        textViewCaptions.text = viewModel.caption
        
        btnDanceWorkout.isSelected = false
        btnHiitWorkout.isSelected = false
        btnOtherContentWorkout.isSelected = false
        switch viewModel.workoutType {
        case .DANCE_WORKOUT:
            btnDanceWorkout.isSelected = true
        case .HIIT_WORKOUT:
            btnHiitWorkout.isSelected = true
        case .OTHER_CONTENT:
            btnOtherContentWorkout.isSelected = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionSelectCategory(_ sender: WorkoutButton) {
        btnDanceWorkout.isSelected = false
        btnHiitWorkout.isSelected = false
        btnOtherContentWorkout.isSelected = false
        sender.isSelected = true//!sender.isSelected
        viewModel.workoutType = WorkoutType(rawValue: sender.tag) ?? .DANCE_WORKOUT
        reloadData()
    }
    
    
    @IBAction func actionSubmitForReview(_ sender: UIButton) {
        showLoader()
        viewModel.actionSubmit()
    }
    
    @IBAction func actionPlay(_ sender: UIButton) {
        guard let url = viewModel.videoUrl else {return}
        let player = AVPlayerViewController()
        let avPlayer = AVPlayer(url: url)
        player.player = avPlayer
        self.navigationController?.present(player, animated: true, completion: {
            player.player?.play()
        })
    }
 
}
extension AddVideoVC:AddVideoViewModelDelegate {
    func videoPostedSuccessfully() {
        hideLoader()
        self.navigationController?.push(PasswordChangeSuccessVC.self, animated: true, configuration: { (vc) in
            vc.type = .postSubmitted
        })
    }
    
    func reloadData() {
        let (isValid,_) = viewModel.areFieldsValid()
        btnSubmit.isEnabled = isValid
    }
    
    func showAlert(with title: String?, message: String) {
        hideLoader()
        AlertView.showAlert(with: title, message: message)
    }
}

extension AddVideoVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.home
    }
}
