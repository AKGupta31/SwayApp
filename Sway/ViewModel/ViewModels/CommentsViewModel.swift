//
//  CommentsViewModel.swift
//  Sway
//
//  Created by Admin on 27/05/21.
//

import UIKit

protocol CommentsViewModelDelegate:BaseVMDelegate {
    func commentPostedSuccessfully()
}

class CommentsViewModel:NSObject {
    var pdComments = [PredefinedComment]()
    let feedId:String
    var currentPage = 1
    let PAGE_LIMIT = 10
    weak var delegate:CommentsViewModelDelegate?
    var comments = [CommentModel]()
    var canFetchMoreComments = true
    var totalCommentsCount = 0

    init(feedId:String,totalCommentsCount:Int) {
        self.feedId = feedId
        pdComments = DataManager.shared.predefinedComments
        self.totalCommentsCount = totalCommentsCount
        super.init()
        getComments(isRefreshData: false)
    }

    var commentsCount:Int{
        return comments.count
    }
    
    var predefinedCommentCount:Int {
        return pdComments.count
    }
    
    var totalCommentsTitle:String {
        return totalCommentsCount.description + " comments"
    }
    
    func getPredefinedComment(at indexPath:IndexPath) -> PredefinedComment{
        return pdComments[indexPath.row]
    }
    
    func getCommentViewModel(at indexPath:IndexPath) -> CommentViewModel{
        return CommentViewModel(model: self.comments[indexPath.row])
    }
    
    
    
    func getComments(isRefreshData:Bool){
        FeedsEndPoint.getComments(feedId: feedId, pageNumber: currentPage, limit: PAGE_LIMIT) { [weak self](response) in
            if isRefreshData {
                self?.comments.removeAll()
            }
            if response.statusCode == 200,let newComments = response.commentData?.comments {
                self?.comments.append(contentsOf: newComments)
                self?.delegate?.reloadData()
            }else {
                self?.delegate?.showAlert(with: "Error!!!", message: response.message ?? "Unknown error")
            }
            if let nextHit = response.commentData?.nextHit{
                if nextHit >= 1 {
                    self?.canFetchMoreComments = true
                }else {
                    self?.canFetchMoreComments = false
                }
            }
        } failure: { [weak self](status) in
            self?.delegate?.showAlert(with: "Error!!!", message: status.msg)
        }

    }
    
    func postComment(comment:String){
        (self.delegate as? BaseViewController)?.showLoader()
        FeedsEndPoint.postComment(feedId: feedId, comment: comment) { [weak self](response) in
            (self?.delegate as? BaseViewController)?.hideLoader()
            if response.statusCode == 200,let newComment = response.comment {
                self?.comments.insert(newComment, at: 0)
                self?.totalCommentsCount += 1
                self?.delegate?.commentPostedSuccessfully()
            }else {
                self?.delegate?.showAlert(with: "Error!!!", message: response.message ?? "Unknown error")
            }
           
        } failure: { [weak self](status) in
            (self?.delegate as? BaseViewController)?.hideLoader()
            self?.delegate?.showAlert(with: "Error!!!", message: status.msg)
        }

    }
    
    func loadMoreData(){
        if canFetchMoreComments {
            currentPage += 1
            getComments(isRefreshData: false)
        }
    }
    
}

class CommentViewModel:NSObject{
    let model:CommentModel
    
    init(model:CommentModel) {
        self.model = model
        super.init()
    }
    
    var comment:String? {
        return model.comment
    }
    
    var profileImageUrl:URL? {
        if let urlStr = model.userData?.profilePicture{
            return URL(string:urlStr)
        }
        return nil
    }
    
    var timeString:String? {
        if let createdAt = model.createdAt{
            let date = Date.getDate(from: createdAt)
            return date.timeAgoSince
        }
        return Date().timeAgoSince
    }
    
    var commentWithUserName:NSAttributedString {
        let name = model.userData!.firstName! + " " + model.userData!.lastName!
        let comment = model.comment ?? ""
        let mixComment = name + " " + comment
        let attr1 = NSMutableAttributedString(string: mixComment)
        let rangeOfName  = NSRange(location: 0, length: name.count)
        let rangeOfComment = NSRange(location: name.count, length: comment.count)
        attr1.addAttribute(.font, value: UIFont(name: "CircularStd-Bold", size: 14)!, range: rangeOfName)
        attr1.addAttribute(.font, value: UIFont(name: "CircularStd-Book", size: 14)!, range: rangeOfComment)
        return attr1
    }
}

