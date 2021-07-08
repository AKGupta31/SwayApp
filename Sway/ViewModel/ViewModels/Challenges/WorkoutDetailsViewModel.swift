//
//  WorkoutDetailsVm.swift
//  Sway
//
//  Created by Admin on 28/06/21.
//

import UIKit
import SDWebImage

protocol WorkoutDetailsViewModelDelegate:BaseVMDelegate {
    
}


enum IntensityLevel:Int {
    case low = 1,medium = 2,high = 3
    var name:String {
        switch self {
        case .low:
            return "LOW"
        case .medium:
            return "MEDIUM"
        case .high:
            return "HIGH"
        }
    }
}

class WorkoutDetailsViewModel {
    
    var workout:WorkoutResponseData!
    var workoutId:String = ""
    
    weak var delegate:WorkoutDetailsViewModelDelegate?
    
    var numberOfSections:Int {
        return workout == nil ? 0 : 2
    }
    
    func getNumberOfRows(in section:Int) -> Int {
        if workout == nil {
            return 0
        }
        return section == 0 ? 2 : (workout.contents?.count ?? 0)
    }
    
    init(workoutId:String){
        self.workoutId = workoutId
        getDetails()
    }
    
    var bannerImageUrl:URL? {
        if let imageModel = workout.imageUrl,let imageUrl = imageModel.url {
            return URL(string: imageUrl)
        }
        return nil
    }
    
    var title:String? {
        return workout.name
    }
    
    var lastSeenItemIndex:Int = -1
    
    var workoutType:WorkoutType {
        if let type = workout.workOutType ,let workoutIntVal = Int(type){
            let workout = WorkoutType(rawValue: workoutIntVal) ?? .OTHER_CONTENT
            return workout
        }
        return .OTHER_CONTENT
    }
    
    var intensity:IntensityLevel{
        if let intensity = workout.intensityLevel,let intVal = Int(intensity) {
            return IntensityLevel(rawValue: intVal) ?? .medium
        }
        return .medium
    }
    
    func setupCell(cell:HIITDescriptionCell){
        cell.lblEquipmentYesNo.text = workout.equipmentRequired == true ? "YES" : "NO"
        cell.lblSpaceValue.text = workout.spaceRecommendation
        cell.lblDurationUnit.text = (workout.contents?.count ?? 0).description
        cell.lblDescription.text = workout.description
    }
    
    func setupCell(cell:HIITItemCell,indexPath:IndexPath){
        if let content = workout.contents?[indexPath.row]{
            cell.lblName.text = content.name
        }
        cell.lblNumber.text = (indexPath.row + 1).description
       
        if lastSeenItemIndex >= 0 {
            if indexPath.row <= lastSeenItemIndex {
                cell.cellType = .completed
            }else if indexPath.row == lastSeenItemIndex + 1 {
                cell.cellType = .next
            }else {
                cell.cellType = .normal
            }
        } else {
            if indexPath.row == 0 {
                cell.cellType = .next
            }else {
                cell.cellType = .normal
            }
            
        }
    }
    
    func getContentVM(at index:Int) -> WorkoutContentsVM? {
        guard let content = workout.contents?[index] else {return nil}
        return WorkoutContentsVM(content: content, workoutId: self.workoutId)
    }
    
    func markWorkoutAsViewed(workoutId: String, circuitId: String) {
        guard let contents = workout.contents else {return}
        guard let indexOfContent = contents.firstIndex(where: {$0.id == circuitId}) else {return}
        workout.contents?[indexOfContent].isSeen = true
        lastSeenItemIndex = indexOfContent
        self.delegate?.reloadData()
    }
    
    

}

extension WorkoutDetailsViewModel{
    func getDetails(){
        ChallengesEndPoint.getWorkoutDetails(for: self.workoutId) { [weak self](response) in
            if let statusCode = response.statusCode,statusCode >= 200 && statusCode <= 300,let workoutData = response.data {
                self?.workout = workoutData
                if let lastSeenIndex = self?.workout.contents?.lastIndex(where: {$0.isSeen}) {
                    self?.lastSeenItemIndex = lastSeenIndex
                }
                self?.delegate?.reloadData()
            }else {
                self?.delegate?.showAlert(with: "Error!", message: response.message ?? "Unknown error")
            }
        } failure: { [weak self](status) in
            self?.delegate?.showAlert(with: "Error!", message: status.msg)
        }

    }
}

protocol WorkoutContentsVMDelegate:BaseVMDelegate {
    func workoutMarkedAsViewed(contentId:String,workoutId:String)
}

class WorkoutContentsVM {
    
    private let content:Content
    private let workoutId:String
    var controller:ViewController = .HIITDetailsPendingStartVC
    weak var delegate:WorkoutContentsVMDelegate?
    var numberOfSections:Int {
        if controller == .HIITDetailsPendingStartVC {
            return 2
        }
        return 1
    }
    
    func numberOfItems(in section:Int) -> Int {
        if controller == .HIITDetailsPendingStartVC {
            return section == 0 ? 1 : (content.movement?.count ?? 0)
        }
        return content.movement?.count ?? 0
    }
    
    var numberOfMovements:Int {
        return content.movement?.count ?? 0
    }
    
    init(content:Content,workoutId:String) {
        self.content = content
        self.workoutId = workoutId
    }
    

    var intensity:IntensityLevel{
        if let intensity = content.intensityLevel,let intVal = Int(intensity) {
            return IntensityLevel(rawValue: intVal) ?? .medium
        }
        return .medium
    }
    
    func setupHeaderCell(cell:HIITDescriptionCell){
        cell.lblTitle.text = content.name
        cell.lblDescription.text = content.description
        cell.lblEquipmentYesNo.text = content.equipmentRequired == true ? "YES" : "NO"
        cell.lblIntensityLevel.text = intensity.name
        cell.lblDuration.text = 0.description
    }
    
    func setupCell(cell:HIITVideoItemCell,for indexPath:IndexPath){
        guard let movement = content.movement?[indexPath.row] else {
            return
        }
        if let urlStr = movement.media?.imageUrl{
            cell.imgVideoThumb.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgVideoThumb.sd_setImage(with: URL(string: urlStr), completed: nil)
        }
        cell.lblName.text = movement.name
        cell.lblRepetetion.text = (movement.repetationDuration?.count ?? 0).description + " Reps"
        
    }
    
    func getMovementVM(at index:Int) -> MovementViewModel{
        return MovementViewModel(movement: content.movement![index])
    }
    
    func getVideoUrlsInMovements() -> [URL]{
        var urls = [URL]()
        if let movements = self.content.movement {
            for movement in movements {
                if let url = URL(string: "https://www.rmp-streaming.com/media/big-buck-bunny-360p.mp4") {
                    urls.append(url)
                }
//                if let urlStr = movement.media?.mainVideoUrl,let url = URL(string: urlStr) {
//                    
//                    urls.append(url)
//                }
            }
        }
        return urls
    }
    
    func markAsCompleted(){
        if let circuitId = content.id {
            ChallengesEndPoint.markWorkoutAsSeen(for: self.workoutId, circuitId: circuitId) { [weak self](response) in
                if response.statusCode == 200 {
                    self?.delegate?.workoutMarkedAsViewed(contentId: circuitId, workoutId: self!.workoutId)
                }else {
                    self?.delegate?.showAlert(with: Constants.Messages.kError, message: response.message ?? Constants.Messages.kUnknownError)
                }
            } failure: { [weak self](status) in
                self?.delegate?.showAlert(with: Constants.Messages.kError, message: status.msg)
            }
            
        }
        //        ChallengesEndPoint.markWorkoutAsSeen(workoutId: workoutId, circuitId: content.)
        //        ChallengesEndPoint.markWorkoutAsSeen(workoutId: <#T##String#>, circuitId: <#T##String#>)
    }
}

class MovementViewModel {
    let movement:Movement
    
    init(movement:Movement) {
        self.movement = movement
    }
    
    var videoThumb:URL? {
        if let urlStr = movement.media?.imageUrl {
            return URL(string: urlStr)
        }
        return nil
    }
    
    var mainVideoUrl:URL? {
        if let urlStr = movement.media?.mainVideoUrl {
            return URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4")
//            return URL(string: urlStr)
        }
        return nil
    }

}
