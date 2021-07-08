//
//  ChallengesEndPoint.swift
//  Sway
//
//  Created by Admin on 23/06/21.
//

import Foundation

class ChallengesEndPoint {
    static func getChallenges(page:Int,limit:Int,success: @escaping SuccessCompletionBlock<GetChallengesResponse>, failure: @escaping ErrorFailureCompletionBlock) {
        Api.requestNew(endpoint: .getChallenges(page: page, limit: limit) , type: GetChallengesResponse.self, successHandler: success, failureHandler: failure)
    }
    
    static func getChallengeDetail(for challengeId:String,success: @escaping SuccessCompletionBlock<ChallengeDetailResponse>, failure: @escaping ErrorFailureCompletionBlock) {
        Api.requestNew(endpoint: .getChallengeDetail(challengeId: challengeId) , type: ChallengeDetailResponse.self, successHandler: success, failureHandler: failure)
    }
    
    
    static func createChallenge(for challengeId:String,startDate:Int,endDate:Int,schedules:[Schedules],success: @escaping SuccessCompletionBlock<EmptyDataResponse>, failure: @escaping ErrorFailureCompletionBlock) {
        Api.requestNew(endpoint: .createChallenge(challengeId: challengeId, startDate: startDate, endDate: endDate, schedules: schedules) , type: EmptyDataResponse.self, successHandler: success, failureHandler: failure)
    }
    
    
    static func getWorkoutDetails(for workoutId:String,success: @escaping SuccessCompletionBlock<WorkoutDetailsResponse>, failure: @escaping ErrorFailureCompletionBlock) {
        Api.requestNew(endpoint: .getWorkoutDetail(workoutId: workoutId), type: WorkoutDetailsResponse.self, successHandler: success, failureHandler: failure)
    }
    
    
    
    static func markWorkoutAsSeen(for workoutId:String,circuitId:String,success: @escaping SuccessCompletionBlock<WorkoutHistoryResponse>, failure: @escaping ErrorFailureCompletionBlock){
        Api.requestNew(endpoint: .markCircuitAsSeen(workoutId: workoutId, circuitId: circuitId), type: WorkoutHistoryResponse.self, successHandler: success, failureHandler: failure)
    }
}
