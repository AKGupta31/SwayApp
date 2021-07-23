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
    
    
    static func createChallenge(for challengeId:String,startDate:Int64,endDate:Int64,schedules:[Schedules],success: @escaping SuccessCompletionBlock<EmptyDataResponse>, failure: @escaping ErrorFailureCompletionBlock) {
        Api.requestNew(endpoint: .createChallenge(challengeId: challengeId, startDate: startDate, endDate: endDate, schedules: schedules) , type: EmptyDataResponse.self, successHandler: success, failureHandler: failure)
    }
    
    
    static func getWorkoutDetails(for workoutId:String,challengeId:String,success: @escaping SuccessCompletionBlock<WorkoutDetailsResponse>, failure: @escaping ErrorFailureCompletionBlock) {
        Api.requestNew(endpoint: .getWorkoutDetail(workoutId: workoutId, challengeId: challengeId), type: WorkoutDetailsResponse.self, successHandler: success, failureHandler: failure)
    }
    
    
    
    static func markWorkoutAsSeen(for workoutId:String,circuitId:String,challengeId:String,success: @escaping SuccessCompletionBlock<WorkoutHistoryResponse>, failure: @escaping ErrorFailureCompletionBlock){
        Api.requestNew(endpoint: .markCircuitAsSeen(workoutId: workoutId, circuitId: circuitId, challengeId: challengeId), type: WorkoutHistoryResponse.self, successHandler: success, failureHandler: failure)
    }
    
    
    
    static func rateWorkout(for workoutId:String,challengeId:String,rating:Ratings,success: @escaping SuccessCompletionBlock<EmptyDataResponse>, failure: @escaping ErrorFailureCompletionBlock){
        Api.requestNew(endpoint: .rateWorkout(workoutId: workoutId,challengeId:challengeId,ratings: rating), type: EmptyDataResponse.self, successHandler: success, failureHandler: failure)
    }
    
    static func getLibraryListing(page:Int,limit:Int,searchStr:String,filters:[FilterModel],success: @escaping SuccessCompletionBlock<WorkoutLibraryListingResponse>, failure: @escaping ErrorFailureCompletionBlock){
        Api.requestNew(endpoint: .getLibraryItems(page: page, limit: limit,searchStr:searchStr,filters:filters), type: WorkoutLibraryListingResponse.self, successHandler: success, failureHandler: failure)
    }
    
    static func getFilters(success: @escaping SuccessCompletionBlock<FiltersResponse>, failure: @escaping ErrorFailureCompletionBlock){
        Api.requestNew(endpoint: .getFilters, type: FiltersResponse.self, successHandler: success, failureHandler: failure)
    }
    
    static func addSchedule(model:WorkoutModel,isUpdate:Bool,success: @escaping SuccessCompletionBlock<EmptyDataResponse>, failure: @escaping ErrorFailureCompletionBlock){
        Api.requestNew(endpoint: .addWorkoutSchedule(workout: model, isUpdate: isUpdate), type: EmptyDataResponse.self, successHandler: success, failureHandler: failure)
    }
    
    static func getSchedules(success: @escaping SuccessCompletionBlock<SchedulesResponse>, failure: @escaping ErrorFailureCompletionBlock){
        Api.requestNew(endpoint: .getWorkoutSchedules, type: SchedulesResponse.self, successHandler: success, failureHandler: failure)
    }

    
    
}
