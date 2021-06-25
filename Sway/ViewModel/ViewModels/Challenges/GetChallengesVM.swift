//
//  GetChallengesVM.swift
//  Sway
//
//  Created by Admin on 23/06/21.
//

import UIKit

protocol ChallengeSelectionVMDelegate:BaseVMDelegate {
    
}

class ChallengeSelectionVM:NSObject {
    
    let PAGE_SIZE = 10
    var currentPage = 1
    var canFetchMoreData = true
    weak var delegate:ChallengeSelectionVMDelegate?
    var isFetchedAgainIfAuthFailed = false
    var challenges:[ChallengeModel]!
    
    var numberOfItems:Int {
        return challenges.count
    }
    
    override init() {
        super.init()
        initialize()
    }
    
    init(with delegate:ChallengeSelectionVMDelegate) {
        super.init()
        self.delegate = delegate
        initialize()
    }

    private func initialize(){
        challenges = [ChallengeModel]()
        getChallenges(isRefreshData: false)
    }
    
    func getChallengeVM(at index:Int) -> ChallengeViewModel {
        return ChallengeViewModel(challenge: challenges[index])
    }


}

extension ChallengeSelectionVM {
    private func getChallenges(isRefreshData:Bool){
        ChallengesEndPoint.getChallenges(page: currentPage, limit: PAGE_SIZE) { [weak self] (response) in
            if response.statusCode == 401 && response.message == "Missing authentication" && !self!.isFetchedAgainIfAuthFailed {
                self!.isFetchedAgainIfAuthFailed = true
                self?.getChallenges(isRefreshData: isRefreshData)
            }
            if isRefreshData {
                self?.challenges.removeAll()
            }
            if let newChallenges = response.data?.challenges {
                self?.challenges.append(contentsOf: newChallenges)
            }
            if let nextHit = response.data?.next_hit{
                if nextHit >= 1 {
                    self?.canFetchMoreData = true
                }else {
                    self?.canFetchMoreData = false
                }
            }
            self?.delegate?.reloadData()
        } failure: {[weak self] (status) in
            self?.delegate?.showAlert(with: "Error!", message: status.msg)
        }

    }
}

protocol ChallengeViewModelDelegate:BaseVMDelegate {
    func challengeCreatedSuccessfully(challenge:ChallengeSchedulesModel)
}
class ChallengeViewModel {
    
    private var challenge:ChallengeModel
    weak var delegate:ChallengeViewModelDelegate?
    
    var title:String? {
        return challenge.title
    }
    
    init(challenge:ChallengeModel) {
        self.challenge = challenge
    }
    
    var bannerUrl:URL? {
        if let urlStr = challenge.coverPicture?.url {
            return URL(string: urlStr)
        }
        return nil
    }
    
    var participants:Int? {
        return challenge.activeUsersCount
    }
    
    var weeksCount:Int? {
        return challenge.numberOfWeeks
    }
    
    var description:String? {
        return challenge.description
    }
    
    var average:Int? {
        return challenge.average
    }
    
    var bannerThumbnail:URL? {
        if let urlStr = challenge.coverPicture?.thumbnailImage {
            return URL(string: urlStr)
        }
        return nil
    }
    
    var videoUrl:URL? {
        if let urlStr = challenge.video?.url {
            return URL(string: urlStr)
        }
        return nil
    }
    
    func getDetails(){
        if let id = challenge._id {
            ChallengesEndPoint.getChallengeDetail(for: id) { [weak self](response) in
                if let details = response.data {
                    self?.challenge = details
                }
                self?.delegate?.reloadData()
            } failure: { [weak self] (status) in
                self?.delegate?.showAlert(with: "Error!", message: status.msg)
            }
            
        }
       
    }
    
    func getWorkoutDetailsVMs() -> [WorkoutDetailsViewModel]{
        let models = self.challenge.workoutDetails?.filter({$0.workouts != nil})
        var viewModels = [WorkoutDetailsViewModel]()
        models?.forEach({ (details) in
            viewModels.append(WorkoutDetailsViewModel(details: details))
        })
        return viewModels
    }

    func createChallenge(schedules:[Schedules]){
        let startDate = Date().millisecondsSinceNow
        let endDate = Calendar.current.date(byAdding: .weekOfYear, value: challenge.workoutDetails!.count, to: Date())?.millisecondsSinceNow ?? startDate
        
        ChallengesEndPoint.createChallenge(for: challenge._id!, startDate: startDate, endDate: endDate, schedules: schedules) { [weak self](response) in
            if response.type == "CHALLENGE_CREATED" && response.statusCode == 201 {
                let model = ChallengeSchedulesModel(challengeId: self!.challenge._id!, startDate: startDate, endDate: endDate, schedules: schedules)
                self?.delegate?.challengeCreatedSuccessfully(challenge: model)
            }else {
                self?.delegate?.showAlert(with: "Error!", message: response.message)
            }
            print("response",response)
        } failure: { (status) in
            self.delegate?.showAlert(with: "Error!", message: status.msg)
        }

//        ChallengesEndPoint.createChallenge(for: challenge._id!, startDate: startDate, endDate: endDate, schedules: schedules) { (response) in
//            print(response)
//        } failure: { [weak self] (status) in
//            self?.delegate?.showAlert(with: "Error!", message: status.msg)
//        }


    }
    
}




extension Date {
    var millisecondsSinceNow:Int {
        return Int((self.timeIntervalSinceNow * 1000.0).rounded())
    }

    init(milliseconds:Int) {
        self = Date(timeIntervalSinceNow: TimeInterval(milliseconds) / 1000)
    }
}


class WorkoutDetailsViewModel {
    
    private let workoutDetails:WorkoutDetails
    
    var numberOfItems: Int {
        return workoutDetails.workouts?.count ?? 0
    }
    
    var weekTitle:String {
        return "Week " + (workoutDetails.week?.description ?? "0")
    }
    
    init(details:WorkoutDetails) {
        self.workoutDetails = details
    }
    
    func getWorkoutVM(at index:Int) -> WorkoutViewModel?{
        if let workouts = workoutDetails.workouts{
            return WorkoutViewModel(workout: workouts[index])
        }
        return nil
    }
    
    
    func getWorkoutModels() -> [WorkoutModel]{
//        let strings = ["HIIT","DANCE","HIIT","DANCE"]
        var workouts = [WorkoutModel]()
        for item in workoutDetails.workouts! {
            let model = WorkoutModel(title: item.name ?? "")
            model.color = UIColor(named:"kThemeBlue")!
            model.isSelected = true
            model.workoutId = item.workoutId
            workouts.append(model)
        }
        return workouts
    }
    
    func createChallenge(schedules:[[String:Any]]){
//        ChallengesEndPoint.createChallenge(for: <#T##String#>, startDate: <#T##Int#>, endDate: <#T##Int#>, schedules: <#T##[[String : Any]]#>, success: <#T##SuccessCompletionBlock<EmptyDataResponse>##SuccessCompletionBlock<EmptyDataResponse>##(EmptyDataResponse) -> Void#>, failure: <#T##ErrorFailureCompletionBlock##ErrorFailureCompletionBlock##(ResponseStatus) -> Void#>)
    }
    
}


class WorkoutViewModel {
    
    private let workout:Workout
    
    var thumbnailUrl:URL? {
        if let urlStr = workout.imageUrl {
            return URL(string: urlStr)
        }
        return nil
    }
    
    var name:String? {
        return workout.name
    }
    
    var durationInMinutes:String {
        let durationInSeconds = workout.duration ?? 0
        let minutesOfDuration =  Int(floor(Double(durationInSeconds / 60)))
        let pendingSeconds =  durationInSeconds % 60
        
        return String(format: "%02d", minutesOfDuration) + ":" + String(format: "%02d", pendingSeconds)
    }

    
    init(workout:Workout) {
        self.workout = workout
    }
}
