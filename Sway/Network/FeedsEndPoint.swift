//
//  FeedsEndPoint.swift
//  Sway
//
//  Created by Admin on 21/05/21.
//

import Foundation

class FeedsEndPoint {
    static func getFeeds(page:Int,limit:Int,userId:String,success: @escaping SuccessCompletionBlock<FeedsResponse>, failure: @escaping ErrorFailureCompletionBlock) {
        Api.requestNew(endpoint: .getFeeds(page: page, limit: limit,userId:userId) , type: FeedsResponse.self, successHandler: success, failureHandler: failure)
    }
    
    static func postFeed(feedId:String,caption:String,feedType:WorkoutType,url:String,thumbnailUrl:String,mediaType:MediaTypes,otherContentDescription:String?,success: @escaping SuccessCompletionBlock<FeedsResponse>, failure: @escaping ErrorFailureCompletionBlock) {
        Api.requestNew(endpoint: .postFeed(feedId: feedId, caption: caption, feedType: feedType, url: url, thumbnailUrl: thumbnailUrl, mediaType: mediaType, otherContentDescription: otherContentDescription) , type: FeedsResponse.self, successHandler: success, failureHandler: failure)
    }
    
    static func deleteFeed(feedId:String,success: @escaping SuccessCompletionBlock<EmptyDataResponse>, failure: @escaping ErrorFailureCompletionBlock) {
        Api.requestNew(endpoint: .deleteFeed(feedId:feedId) , type: EmptyDataResponse.self, successHandler: success, failureHandler: failure)
    }
    
    static func likeFeed(feedId:String,success: @escaping SuccessCompletionBlock<EmptyDataResponse>, failure: @escaping ErrorFailureCompletionBlock) {
        Api.requestNew(endpoint: .likeFeed(feedId: feedId) , type: EmptyDataResponse.self, successHandler: success, failureHandler: failure)
    }
    
    static func getPredefinedComments(success: @escaping SuccessCompletionBlock<PredefinedCommentsResponse>, failure: @escaping ErrorFailureCompletionBlock) {
        Api.requestNew(endpoint: .getPredefinedComments, type: PredefinedCommentsResponse.self, successHandler: success, failureHandler: failure)
    }
    
    static func getComments(feedId:String,pageNumber:Int,limit:Int,success: @escaping SuccessCompletionBlock<CommentsResponse>, failure: @escaping ErrorFailureCompletionBlock) {
        Api.requestNew(endpoint: .getComments(feedId: feedId, pageNumber: pageNumber, limit: limit), type: CommentsResponse.self, successHandler: success, failureHandler: failure)
    }
    
    static func postComment(feedId:String,comment:String,success: @escaping SuccessCompletionBlock<PostCommentResponse>, failure: @escaping ErrorFailureCompletionBlock) {
        Api.requestNew(endpoint: .postComment(feedId: feedId, comment: comment), type: PostCommentResponse.self, successHandler: success, failureHandler: failure)
    }
}
