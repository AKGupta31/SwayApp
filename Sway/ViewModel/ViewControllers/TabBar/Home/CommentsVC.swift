//
//  CommentsVC.swift
//  Sway
//
//  Created by Admin on 26/05/21.
//

import UIKit
import ViewControllerDescribable
import GrowingTextView

class CommentsVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var txtViewComments: GrowingTextView!
    @IBOutlet weak var lblCommentsCount: UILabel!
    @IBOutlet weak var predefinedCommentsCV: UICollectionView!
    
    var feedId:String!
    var viewModel:CommentsViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        predefinedCommentsCV.dataSource = self
        predefinedCommentsCV.delegate = self
        viewModel.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        txtViewComments.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapOnEmptySpace(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionCross(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionPost(_ sender: UIButton) {
        if let text = txtViewComments.text,text.count > 0 {
            viewModel.postComment(comment: text)
        }
    }
    
    func addNoDataLabel(strMessage: String,to view:UIView) -> UILabel {
        let noDataLabel = UILabel(frame:view.bounds)
        noDataLabel.text = strMessage
        noDataLabel.textColor = UIColor(named: "kThemeNavyBlue_50")
        noDataLabel.textAlignment = .center
        noDataLabel.numberOfLines = 1
        noDataLabel.font = UIFont(name: "CircularStd-Book", size: 14)
        return noDataLabel
    }
    
}

extension CommentsVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let char = text.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
               return true
            }
        }
        if textView.text.count > 200 {
            return false
        }
        return true
    }
}

extension CommentsVC:CommentsViewModelDelegate {
    func reloadData() {
        lblCommentsCount.text = viewModel.totalCommentsTitle
        tableView.reloadData()
    }
    func showAlert(with title: String?, message: String) {
        AlertView.showAlert(with: title, message: message)
    }
    
    func commentPostedSuccessfully() {
        txtViewComments.text = nil
        lblCommentsCount.text = viewModel.totalCommentsTitle
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}
extension CommentsVC:UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.commentsCount > 0 {
            tableView.backgroundView = nil
        }else {
            tableView.backgroundView = addNoDataLabel(strMessage: "Be the first to comment!", to: tableView)
        }
        return viewModel.commentsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
        cell.setupCell(viewModel: viewModel.getCommentViewModel(at: indexPath))
        if indexPath.row == viewModel.commentsCount - 1 {
            viewModel.loadMoreData()
        }
        return cell
    }
}

extension CommentsVC:UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PredefinedCommentsCell", for: indexPath) as! PredefinedCommentsCell
        cell.setupData(comment: viewModel.getPredefinedComment(at: indexPath))
        return cell
    }
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.predefinedCommentCount
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.postComment(comment: viewModel.getPredefinedComment(at: indexPath).name ?? "")
    }
    
    //MARK: Delegate flow layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let pdComment = viewModel.getPredefinedComment(at: indexPath)
        let size = NSAttributedString(string: pdComment.name ?? "", attributes: [NSAttributedString.Key.font:UIFont(name:
                                                                                                                                        "CircularStd-Medium", size: 12)!]).size()
        return CGSize(width: size.width + 32, height: 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

extension CommentsVC:ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.home
    }
}
