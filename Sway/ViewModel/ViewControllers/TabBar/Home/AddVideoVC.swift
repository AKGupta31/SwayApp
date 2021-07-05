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
    @IBOutlet weak var otherContentDescription: GrowingTextView!
    
    @IBOutlet weak var otherContentInputView: CustomView!
    @IBOutlet weak var lblDescriptionOtherVideo: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    
    @IBOutlet weak var lblRemainingTextCount: UILabel!
    
    @IBOutlet weak var mediaView: UIView!
    @IBOutlet weak var textViewCaptions: GrowingTextView!
    @IBOutlet weak var btnSubmit: CustomButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnOtherContentWorkout: WorkoutButton!
    @IBOutlet weak var btnHiitWorkout: WorkoutButton!
    var viewModel:AddVideoViewModel!
    @IBOutlet weak var btnDanceWorkout: WorkoutButton!
    @IBOutlet weak var mediaThumbView: UIImageView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        mediaThumbView.image = viewModel.thumbnail
//        viewModel.delegate = self
        mediaThumbView.layer.cornerRadius = 10.0
        mediaThumbView.clipsToBounds = true
        
        viewDidLoadTasks()
        
//        if viewModel.mediaType == .kImage{
//            let tapOnMediaView = UITapGestureRecognizer(target: self, action: #selector(tapOnMediaView(_:)))
//            self.mediaView.addGestureRecognizer(tapOnMediaView)
//        }
//
//        setupUI()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionEdit(_ sender: UIButton) {
        showAlert()
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
        textViewCaptions.delegate = viewModel
        textViewCaptions.text = viewModel.caption
        lblRemainingTextCount.text = (50 - (viewModel.caption?.count ?? 0)).description + "/" +
        "50"
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
        btnSubmit.isEnabled = viewModel.caption?.isEmpty == false
        self.lblDescriptionOtherVideo.isHidden = !btnOtherContentWorkout.isSelected
        self.otherContentInputView.isHidden = !btnOtherContentWorkout.isSelected
        
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
        self.lblDescriptionOtherVideo.isHidden = !btnOtherContentWorkout.isSelected
        self.otherContentInputView.isHidden = !btnOtherContentWorkout.isSelected
    }
    
    
    @IBAction func actionSubmitForReview(_ sender: UIButton) {
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
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.tag == 1 {
            var remainingCount = textView.text.count
            if remainingCount > 50{
                remainingCount = 50
            }
            lblRemainingTextCount.text = remainingCount.description + "/" +
            "50"
        }
    }
    
    func videoPostedSuccessfully() {
        hideLoader()
        self.getNavController()?.push(PasswordChangeSuccessVC.self, animated: true, configuration: { (vc) in
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

extension AddVideoVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //MARK: Image Picker Controller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true)
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.viewModel.updateMedia(videoUrl: nil, thumbnail: image)
            viewDidLoadTasks()
//            self.viewModel = AddVideoViewModel(videoUrl: nil,thumbnail:image)
//            viewModel.workoutType = type
//            viewModel.caption = caption
//            viewDidLoadTasks()
//
        }
        else if  let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
           let thumbnail =  VideoUtility.shared.getImageFromUrl(url: videoURL) ?? UIImage()
           let asset = AVURLAsset(url: videoURL)
            if asset.duration.seconds < 10 {
                showAlert(with: "Error!", message: "Video must be minimum to 10 seconds")
            } else if asset.duration.seconds > 60 {
                showAlert(with: "Error!", message: "Video must be maximum to 60 seconds")
            }else {
                self.viewModel.updateMedia(videoUrl: videoURL, thumbnail: thumbnail)
                viewDidLoadTasks()
//                self.viewModel = AddVideoViewModel(videoUrl: videoURL,thumbnail:thumbnail)
//                viewModel.workoutType = type
//                viewModel.caption = caption
//                viewDidLoadTasks()
            }
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func viewDidLoadTasks(){
        viewModel.delegate = self
        textViewCaptions.delegate = viewModel
        otherContentDescription.delegate = viewModel
        mediaThumbView.image = viewModel.thumbnail
        if viewModel.mediaType == .kImage{
            let tapOnMediaView = UITapGestureRecognizer(target: self, action: #selector(tapOnMediaView(_:)))
            self.mediaView.gestureRecognizers?.removeAll()
            self.mediaView.addGestureRecognizer(tapOnMediaView)
        }
        setupUI()
    }
    
    @objc func showAlert() {
        let actionAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionAlert.addAction(UIAlertAction(title: Constants.Messages.kSelectVideo, style: .default, handler: { (action) in
            self.videoFileSelection()
        }))
        actionAlert.addAction(UIAlertAction(title: "Image", style: .default, handler: { (action) in
            self.imageFileSelection()
        }))
       
        actionAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionAlert, animated: true)
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
        imagePicker.videoMaximumDuration = 60
        self.present(imagePicker, animated: true)
    }
    
}


extension AddVideoVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.home
    }
}
