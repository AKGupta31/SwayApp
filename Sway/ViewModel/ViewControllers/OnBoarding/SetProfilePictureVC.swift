//
//  SetProfilePictureVC.swift
//  Sway
//
//  Created by Admin on 05/05/21.
//

import UIKit
import ViewControllerDescribable
import KDCircularProgress

class SetProfilePictureVC: BaseViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var mainContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var btnUploadPhoto: UIButton!
    @IBOutlet weak var btnProfileImage: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressViewInnerCircle: CustomView!
    @IBOutlet weak var btnSkip: UIButton!
    
    var firstName = ""
    var lastName = ""
    var token = ""
    var password = ""
    var profilePicture = ""
    var progress:KDCircularProgress!
    var profileImage:UIImage? = nil {
        didSet {
            btnUploadPhoto.setTitle(profileImage == nil ? "Upload photo" : "Change Photo", for: .normal)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupProgress()
        scrollView.delegate = self
        btnProfileImage.imageView?.contentMode = .scaleAspectFill
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if mainContainerHeight.constant < scrollView.frame.height {
            mainContainerHeight.constant = scrollView.frame.height
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeUp(_:)))
            self.mainContainerView.isUserInteractionEnabled = true
            gesture.direction = .up
            self.mainContainerView.addGestureRecognizer(gesture)
        }
    }
    
    @objc func swipeUp(_ gesture:UISwipeGestureRecognizer){
        if gesture.direction == .up {
            signupApi()
        }
    }
    
    
    func setupViews(){
        let attributedString = NSMutableAttributedString(string: "Upload your\nprofile image", attributes: [
            .font: UIFont(name: "Poppins-Bold", size: 46.0)!,
            .foregroundColor: UIColor(red: 94.0 / 255.0, green: 0.0, blue: 1.0, alpha: 1.0)
        ])
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 5.0 / 255.0, green: 9.0 / 255.0, blue: 53.0 / 255.0, alpha: 1.0), range: NSRange(location: 0, length: 12))
        lblTitle.attributedText = attributedString
        lblTitle.minimumScaleFactor = 0.5
        lblTitle.numberOfLines = 2
    }
    
    @IBAction func actionProfilePicture(_ sender: UIButton) {
        showAlertForProfilePicture()
    }
    
    @IBAction func actionSkip(_ sender: UIButton) {
        signupApi()
    }
    
    func setupProgress(){
        progress = KDCircularProgress(frame:progressView.bounds)
        progress.startAngle = -90
        progress.progressThickness = 0.2
        progress.trackThickness = 0.1
        progress.clockwise = false
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = false
        progress.roundedCorners = true
        progress.glowMode = .noGlow
        progress.set(colors: UIColor(named: "k124123132")!)
        progress.trackColor = UIColor(red: 245/255, green: 246/255, blue: 250/255, alpha: 1.0)
        progress.progress = 1
        progressView.insertSubview(progress, at: 0)
        progressViewInnerCircle.backgroundColor = UIColor(named: "k245246250")
    }
    
    
}

extension SetProfilePictureVC:UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.profileImage != nil && profilePicture.isEmpty == false{
            print("call api")
            let height = scrollView.frame.size.height
            let contentYoffset = scrollView.contentOffset.y
            let distanceFromBottom = scrollView.contentSize.height - contentYoffset
            if distanceFromBottom <= height {
               signupApi()
            }
        }else{
            if profileImage != nil && profilePicture.isEmpty {
                AlertView.showAlert(with: "Alert!!!", message: "Please wait while we are uploading your profile picture")
            }
            print("do not call api")
        }
    }
    
    fileprivate func signupApi(){
        showLoader()
        LoginRegisterEndpoint.signup(token: token, fName: firstName, lName: lastName, password: password, imageUrl: profilePicture) {[weak self] (response) in
            self?.hideLoader()
            if response.statusCode == 200 {
                self?.view.makeToast("Signup Success", duration: 3.0, position: .center)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    guard var viewControllers = self?.navigationController?.viewControllers else {return}
                    viewControllers.removeLast()
                    viewControllers.removeLast()
                    viewControllers.removeLast()
                    viewControllers.removeLast()
                    let loginVC = LoginViaCredentialsVC.instantiated()
                    viewControllers.append(loginVC)
                    self?.navigationController?.setViewControllers(viewControllers, animated: true)
                }
            }else {
                AlertView.showAlert(with: "Error!!!", message: response.message ?? "")
            }
        } failure: { [weak self] (status) in
            self?.hideLoader()
            AlertView.showAlert(with: "Error!!!", message: status.msg)
        }
    }
}

extension SetProfilePictureVC {
    func showAlertForProfilePicture()  {
        let actionAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionAlert.addAction(UIAlertAction(title: "Take photo", style: .default, handler: { (action) in
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
    
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension SetProfilePictureVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.btnProfileImage.setImage(image, for: .normal)
            profileImage = image
            progressViewInnerCircle.backgroundColor = UIColor(named: "kThemeYellow")
            progress.set(colors: UIColor(named: "kThemeBlue")!)
            uploadImageOnAws(selectedImage: image)
        }
        self.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
    private func uploadImageOnAws(selectedImage: UIImage) {
        selectedImage.uploadImageToS3(uploadFolderName: "", success: { [weak self] (status, urlString, imageName) in
            print("url is ",urlString)
            self?.profilePicture = urlString
        }, progress: { (value) in
            print(value)
        }, failure: { (error) in
            DispatchQueue.main.async {
                AlertView.showAlert(with: "Error!!!", message: error.localizedDescription)
            }
        })
    }
}


extension SetProfilePictureVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.main
    }
}

