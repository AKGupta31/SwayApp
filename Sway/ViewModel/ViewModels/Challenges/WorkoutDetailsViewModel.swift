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
    }
    
    func getContentVM(at index:Int) -> WorkoutContentsVM? {
        guard let content = workout.contents?[index] else {return nil}
        return WorkoutContentsVM(content: content)
    }
    

}

extension WorkoutDetailsViewModel{
    func getDetails(){
        ChallengesEndPoint.getWorkoutDetails(for: self.workoutId) { [weak self](response) in
            if let statusCode = response.statusCode,statusCode >= 200 && statusCode <= 300,let workoutData = response.data {
                self?.workout = workoutData
                self?.delegate?.reloadData()
            }else {
                self?.delegate?.showAlert(with: "Error!", message: response.message ?? "Unknown error")
            }
        } failure: { [weak self](status) in
            self?.delegate?.showAlert(with: "Error!", message: status.msg)
        }

    }
}


class WorkoutContentsVM {
    
    let content:Content
    
    var numberOfSections:Int {
        return 2
    }
    
    func numberOfItems(in section:Int) -> Int {
        section == 0 ? 1 : (content.movement?.count ?? 0)
    }
    var numberOfMovements:Int {
        return content.movement?.count ?? 0
    }
    
    init(content:Content) {
        self.content = content
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
        if let urlStr = movement.media?.thumbnailImage{
            cell.imgVideoThumb.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgVideoThumb.sd_setImage(with: URL(string: urlStr), completed: nil)
        }
        cell.lblName.text = movement.name
        cell.lblRepetetion.text = (movement.repetationDuration?.count ?? 0).description + " Reps"
        
    }
}
