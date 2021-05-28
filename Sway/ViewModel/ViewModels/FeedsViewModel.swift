//
//  FeedsViewModel.swift
//  Sway
//
//  Created by Admin on 20/05/21.
//

import Foundation

protocol BaseVMDelegate:class{
    func reloadData()
    func showAlert(with title:String?,message:String)
}

protocol FeedsViewModelDelegate: BaseVMDelegate{
    func reloadRow(at indexPath:IndexPath)
    func likeApi(isSuccess:Bool)
}

class FeedsViewModel {
    var currentPage = 1
    let PAGE_SIZE = 10
    var canFetchMoreData = true
    let mySubmissionsOnly:Bool
    var feeds = [FeedModel]()
    
    weak var delegate:FeedsViewModelDelegate? = nil
    
    init(delegate:FeedsViewModelDelegate?,mySubmissionsOnly:Bool) {
        self.delegate = delegate
        self.mySubmissionsOnly = mySubmissionsOnly
        fetchMoreData(isRefreshData: true)
    }

    var isFetchedAgainIfAuthFailed = false
    private func fetchMoreData(isRefreshData:Bool){
        (delegate as? BaseViewController)?.showLoader()
        guard let userId = DataManager.shared.loggedInUser?.user?._id else {return}
        FeedsEndPoint.getFeeds(page: currentPage, limit: PAGE_SIZE, userId: mySubmissionsOnly ? userId : "") { [weak self](response) in
            if response.statusCode == 401 && response.message == "Missing authentication" && !self!.isFetchedAgainIfAuthFailed {
                self!.isFetchedAgainIfAuthFailed = true
                self?.fetchMoreData(isRefreshData: isRefreshData)
            }
            if isRefreshData {
                self?.feeds.removeAll()
            }
            (self?.delegate as? BaseViewController)?.hideLoader()
            if let feeds = response.data?.feeds {
                let feedsWithMedia = feeds.filter({$0.media != nil})
                self?.feeds.append(contentsOf: feedsWithMedia)
            }
            if let nextHit = response.data?.nextHit{
                if nextHit >= 1 {
                    self?.canFetchMoreData = true
                }else {
                    self?.canFetchMoreData = false
                }
            }
            self?.delegate?.reloadData()
        } failure: { (status) in
            self.delegate?.showAlert(with: "Error!!!", message: status.msg)
        }

    }
    
    func getCommentsViewModel(index:Int) -> CommentsViewModel {
        return CommentsViewModel(feedId: self.feeds[index]._id!,totalCommentsCount:feeds[index].commentCount ?? 0)
    }
    
    func getFeedViewModel(at index:Int) ->FeedViewModel{
        return FeedViewModel(model: feeds[index])
    }
    
    var isAlreadyCallingLikeAPI = false
    func likeFeed(at indexPath:IndexPath){
        guard let feedId = self.feeds[indexPath.row]._id else {return}
        let isLike = !feeds[indexPath.row].isLike
        let oldCount = feeds[indexPath.row].likeCount
        let newCount = isLike ? oldCount + 1 : oldCount - 1
        (self.delegate as? BaseViewController)?.showLoader()
        FeedsEndPoint.likeFeed(feedId: feedId) {[weak self] (response) in
            (self?.delegate as? BaseViewController)?.hideLoader()
            if response.statusCode == 200 {
                self?.feeds[indexPath.row].isLike = isLike
                self?.feeds[indexPath.row].likeCount = newCount
                self?.delegate?.likeApi(isSuccess: true)
            }else{
                self?.delegate?.showAlert(with: "Error!!!", message: response.message)
                self?.delegate?.likeApi(isSuccess: false)
            }
           
        } failure: { [weak self](status) in
            (self?.delegate as? BaseViewController)?.hideLoader()
            self?.delegate?.showAlert(with: "Error!!!", message: status.msg)
            self?.delegate?.likeApi(isSuccess: false)
        }

    }
    
    func deleteFeed(with id:String){
        (self.delegate as? BaseViewController)?.showLoader()
        FeedsEndPoint.deleteFeed(feedId: id) { [weak self](response) in
            (self?.delegate as? BaseViewController)?.hideLoader()
            if response.statusCode == 200 {
                self?.feeds.removeAll(where: {$0._id == id})
                self?.delegate?.reloadData()
            }else{
                self?.delegate?.showAlert(with: "Error!!!", message: response.message)
            }
        } failure: { [weak self](status) in
            self?.delegate?.showAlert(with: "Error!!!", message: status.msg)
        }
    }
    
    func downloadMedia(at index:Int){
        let viewModel = getFeedViewModel(at: index)
        guard let url = viewModel.mediaUrl else {return}
        (self.delegate as? BaseViewController)?.showProgress(progress: 0.0)
        Api.downloadFile(with: url) { (progress) in
            (self.delegate as? BaseViewController)?.showProgress(progress: Float(progress))
        } completion: { [weak self](url, error) in
            (self?.delegate as? BaseViewController)?.hideLoader()
            if let err = error {
                DispatchQueue.main.async {
                    self?.delegate?.showAlert(with: "Error!!!", message: err.localizedDescription)
                }
            }else if let fileUrl = url {
                VideoUtility.shared.saveVideoToLibrary(url: fileUrl, mediaType: viewModel.mediaType) { [weak self](isSuccess, error) in
                    DispatchQueue.main.async {
                        if let err = error {
                            self?.delegate?.showAlert(with: "Error!!!", message: err.localizedDescription)
                        }else {
                            self?.delegate?.showAlert(with: "Congratulations!!!", message: "Your media has been successfully saved to photos")
                        }
                    }
                    
                }
            }
            
        }
        
    }
    
    var numberOfItems:Int {
        return feeds.count
    }
    
    func loadMoreData(){
        if canFetchMoreData {
            currentPage += 1
            fetchMoreData(isRefreshData: false)
        }
    }
    
    func refreshData(){
        currentPage = 1
        fetchMoreData(isRefreshData: true)
    }
    
    
    func getPredefinedComments(){
        FeedsEndPoint.getPredefinedComments { (response) in
            DataManager.shared.predefinedComments = response.comments?.comments ?? [PredefinedComment]()
        } failure: { (status) in
            print("Predefined comments")
        }

    }
    

}

class FeedViewModel{
    
    private let model:FeedModel
    
    init(model:FeedModel) {
        self.model = model
    }
    
    var userName:String? {
        if model.isAdmin ?? false {
            return "sarahmagusara"
        }
        return (model.user?.firstName ?? "") + (model.user?.lastName ?? "")
    }
    
    var caption:String? {
        return model.caption
    }
    
    var feedId:String{
        return self.model._id ?? ""
    }
    
    var mediaUrl:URL? {
        if let urlStr = model.media?.url {
            return URL(string: urlStr)
        }
        return nil
    }
    
    var thumbUrl:URL? {
        if let urlStr = model.media?.thumbnailImage{
            return URL(string:urlStr)
        }
        return nil
    }
    
    var mediaType:MediaTypes {
        if model.media?.type == MediaTypes.kImage.intVal {
            return .kImage
        }
        return .kVideo
    }
    var isApproved:Bool {
        return model.adminApproved == 2
    }
    
    var likeCount:Int {
        return model.likeCount ?? 0
    }
    
    var commentCount:Int {
        return model.commentCount ?? 0
    }
    
    var isLiked:Bool{
        get {
            return model.isLike
        }
    }
  
    
    var workoutType:WorkoutType{
        get {
            guard let feedTypeStr = model.feedType,let feedType = Int(feedTypeStr) else {return .DANCE_WORKOUT}
            return WorkoutType(rawValue: feedType) ?? .DANCE_WORKOUT
        }
    }
}
