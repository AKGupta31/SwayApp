//
//  EndPoint.swift
//  Sway
//
//  Created by Admin on 12/04/21.
//

import Foundation
import Alamofire

enum Endpoint {
    
    case login(email:String,password:String)
    case socialRegister(socialId: String, email: String, firstName: String,lastName:String, type: SocialMediaType, profilePicture: String)
    case socialLogin(type:SocialMediaType,socialId:String)
    case verifyEmail(email:String,otp:String,type:VerifyOtpType)
    case getOtpOnEmail(email:String,type:VerifyOtpType)
    case signup(token: String,fName:String,lName:String,password:String,imageUrl:String)
    //    case forgotPassword(email:String)
    case resetPassword(email:String,password:String)
    case updateOnboardingStatus(key:String,value:Any)
    case getVideos(videoFor:Int)
    
    case getFeeds(page:Int,limit:Int,userId:String)
    case postFeed(feedId:String,caption:String,feedType:WorkoutType,url:String,thumbnailUrl:String,mediaType:MediaTypes,otherContentDescription:String?)
    case deleteFeed(feedId:String)
    case likeFeed(feedId:String)
    case getPredefinedComments
    case getComments(feedId:String,pageNumber:Int,limit:Int)
    case postComment(feedId:String,comment:String)
    //    case updateFeed(feedId:String,caption:String,feedType:WorkoutType,url:String,thumbnailUrl:String,mediaType:MediaTypes)
    
    case getChallenges(page:Int,limit:Int)
    case getChallengeDetail(challengeId:String)
    case createChallenge(challengeId:String,startDate:Int,endDate:Int,schedules:[Schedules])
    
    case getWorkoutDetail(workoutId:String,challengeId:String)
    case markCircuitAsSeen(workoutId:String,circuitId:String,challengeId:String)
    case rateWorkout(workoutId:String,ratings:Ratings)
    case getLibraryItems(page:Int,limit:Int,searchStr:String,filters:[FilterModel])
    case getFilters
    case getWorkoutSchedules //Schedules for current week
    case addWorkoutSchedule(workout:WorkoutModel,isUpdate:Bool)
    case getPlannerWorkouts(startDateInMilis:Int,endDateInMilis:Int,dayOfWeek:Int)
    
    /// GET, POST or PUT method for each request
    var method:Alamofire.HTTPMethod {
        switch self {
        case .addWorkoutSchedule(_,let isUpdate):
            return isUpdate ? .put : .post
        case .login,.socialRegister,.socialLogin,.getOtpOnEmail,.signup,.resetPassword,.likeFeed,.postComment,.createChallenge,.markCircuitAsSeen,.rateWorkout:
            return .post
        case .updateOnboardingStatus,.deleteFeed:
            return .put
        case .verifyEmail,.getVideos,.getFeeds,.getPredefinedComments,.getComments,.getChallenges,.getChallengeDetail,.getWorkoutDetail,.getLibraryItems,.getFilters,.getWorkoutSchedules,.getPlannerWorkouts:
            return .get
        case .postFeed(let feedId,_,_,_,_,_,_):
            return feedId.isEmpty ? .post : .patch
        }
    }
    
    /// URLEncoding used for GET requests and JSONEncoding for POST and PUT requests
    var encoding:Alamofire.ParameterEncoding {
        switch self {
        case .getLibraryItems:
            return URLEncoding(arrayEncoding: .noBrackets, boolEncoding: .literal)
        default:
            break
        }
        switch self.method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    /// URL string for each request
    var path: String {
        let interMediate = "/v1/user/"
        let interMediateChallenge = "/v1/"
        switch self {
        case .login:
            return Constants.Networking.kBaseUrl + interMediate + "login"
        case .socialRegister,.socialLogin:
            return Constants.Networking.kBaseUrl + interMediate + "social-signup"
        case .verifyEmail(_ ,_,let type):
            switch type {
            case .FORGOT_PASSWORD:
                return Constants.Networking.kBaseUrl + interMediate + "verify-forgot-otp"
            default:
                return Constants.Networking.kBaseUrl + interMediate + "verify-email"
            }
        case .getOtpOnEmail(_,let type):
            if type == .FORGOT_PASSWORD {
                return  Constants.Networking.kBaseUrl + interMediate + "forgot-password"
            }
            //else
            return  Constants.Networking.kBaseUrl + interMediate + "send-otp"
        case .signup:
            return  Constants.Networking.kBaseUrl + interMediate + "signup"
        case .resetPassword:
            return Constants.Networking.kBaseUrl + interMediate + "reset-password"
        case .updateOnboardingStatus:
            return Constants.Networking.kBaseUrl + interMediate + "profile"
        case .getVideos(let videoFor):
            return Constants.Networking.kBaseUrl + interMediate + "video/\(videoFor.description)"
        case .getFeeds(let page,let limit,let userId):
            let queryToAppend = userId.isEmpty ? "" : "&userId=\(userId)"
            return Constants.Networking.kBaseUrl + interMediate +  "feed?pageNo=\(page)&limit=\(limit)" + queryToAppend
        case .postFeed(let feedId,_,_,_,_,_,_):
            if feedId.isEmpty {
                return  Constants.Networking.kBaseUrl + interMediate +  "feed"
            }
            return Constants.Networking.kBaseUrl + interMediate + "feed/\(feedId)"
        case .deleteFeed:
            return  Constants.Networking.kBaseUrl + interMediate +  "update-feed-status"
        case .likeFeed:
            return Constants.Networking.kBaseUrl + interMediate + "like"
        case .getPredefinedComments:
            return Constants.Networking.kBaseUrl + interMediate + "pre-comment"
        case .getComments(let feedId,let pageNumber,let limit):
            return  Constants.Networking.kBaseUrl + interMediate + "comment?postId=\(feedId)&pageNo=\(pageNumber)&limit=\(limit)"
        case .postComment:
            return Constants.Networking.kBaseUrl + interMediate + "comment"
        case .getChallenges(let page,let limit):
            return Constants.Networking.kBaseUrl + interMediateChallenge + "challenges?pageNo=\(page)&limit=\(limit)"
        case .getChallengeDetail(let challengeId):
            return Constants.Networking.kBaseUrl + interMediateChallenge + "challenge-details/\(challengeId)"
        case .createChallenge:
            return Constants.Networking.kBaseUrl + interMediateChallenge + "challenge"
        case .getWorkoutDetail(let workoutId,let challengeId):
            return Constants.Networking.kBaseUrl + interMediate + "workout/\(workoutId)" + "?challengeId=\(challengeId)"
        case .markCircuitAsSeen:
            return Constants.Networking.kBaseUrl + interMediate + "workout-history"
        case .rateWorkout:
            return Constants.Networking.kBaseUrl + interMediate + "workoutRating"
        case .getLibraryItems:
            return Constants.Networking.kBaseUrl + interMediate + "library/workouts"
        case .getFilters:
            return Constants.Networking.kBaseUrl + interMediate + "library/filters"
        case .getWorkoutSchedules:
            return Constants.Networking.kBaseUrl + interMediate + "workout-schedules"
        case .addWorkoutSchedule(_,let isUpdate):
            if isUpdate {
                return  Constants.Networking.kBaseUrl + interMediate + "schedule"
            }
            //add
            return Constants.Networking.kBaseUrl + interMediate + "library/add-workout"
        case .getPlannerWorkouts:
        return Constants.Networking.kBaseUrl + interMediate + "planner/workouts"
        }
    }
    
    /// parameters Dictionary for each request
    var parameters:[String:Any] {
        switch self {
        case .login(let email,let password):
            return ["email":email,"password":password,"deviceId":DataManager.shared.deviceId,"deviceToken":DataManager.shared.deviceToken]
        case .socialRegister(let socialId,let email,let firstName, let lastName,let type,let profilePicture):
            var dictionary =  ["socialLoginType":type.rawValue,"socialId":socialId,"email":email,"firstName":firstName,"lastName":lastName,"deviceId":DataManager.shared.deviceId,"deviceToken":DataManager.shared.deviceToken]
            if profilePicture.isEmpty == false {
                dictionary["profilePicture"] = profilePicture
            }
            return dictionary
        case .socialLogin(let type,let socialId):
            return ["socialLoginType":type.rawValue,"socialId":socialId,"deviceId":DataManager.shared.deviceId,"deviceToken":DataManager.shared.deviceToken]
        case .verifyEmail(let email,let otp,_):
            return ["email":email,"otp":otp]
        case .getOtpOnEmail(let email,_):
            return  ["email":email]
        case .signup(let token,let fName,let lName,let password, let imageUrl):
            var dictionary = ["token":token,
                              "firstName": fName,
                              "lastName": lName,
                              "password": password]
            if imageUrl.isEmpty == false {
                dictionary["profilePicture"] = imageUrl
            }
            return dictionary
        case .resetPassword(let email,let password):
            return ["email":email,"password":password]
        case .updateOnboardingStatus(let key,let value):
            return [key:value]
        case .getVideos,.getFeeds,.getPredefinedComments,.getComments,.getChallenges,.getChallengeDetail,.getWorkoutDetail,.getFilters,.getWorkoutSchedules:
            return [:]
        case .postFeed(_,let caption,let feedType,let url,let thumbnailUrl,let mediaType,let otherContentDescription):
            var mediaDic = [String:Any]()
            mediaDic["url"] = url
            mediaDic["thumbnailImage"] = thumbnailUrl
            mediaDic["type"] = mediaType.intVal
            var mainDict = [String:Any]()
            mainDict["caption"] = caption
            mainDict["feedType"] = feedType.rawValue.description
            mainDict["media"] = mediaDic as Any
            if let description = otherContentDescription, feedType == WorkoutType.OTHER_CONTENT {
                mainDict["description"] = description
            }
            return mainDict
        case .deleteFeed(let feedId):
            return ["feedId":feedId,"status":"DELETED"]
        case .likeFeed(let feedId):
            return  ["postId":feedId]
        case .postComment(let feedId,let comment):
            return ["postId":feedId,"comment":comment]
        case .createChallenge(let challengeId,let startDate,let endDate,let schedules):
            var scheduleDictArray = [[String:Any]]()
            schedules.forEach({scheduleDictArray.append($0.toParamsForChallengeSchedule())})
            return [
                "challengeId":challengeId,
                "startDate":startDate,
                "endDate":endDate,
                "schedules":scheduleDictArray
            ]
        case .markCircuitAsSeen(let workoutId,let circuitId,let challengeId):
            return ["workOutId":workoutId,"circuitId":circuitId,"challengeId":challengeId]
        case .rateWorkout(let workoutId,let ratings):
            return ["workOutId":workoutId,"rating":ratings.rawValue]
        case .getLibraryItems(let page,let limit,let searchStr,let filters):
            var keyValue :[String:Any] = ["pageNo":page,"limit":limit]
            if searchStr.isEmpty == false {
                keyValue["searchKey"] = searchStr
            }
            var workoutTypes = [String]()
            var movementCategories = [Double]()
            for filterModel in filters {
                if filterModel.filterType == .movement ,let doubleVal = Double(filterModel.value ?? "1"){
                    movementCategories.append(doubleVal)
                }else if filterModel.filterType == .workoutType{
                    workoutTypes.append(filterModel.value ?? "1")
                }
            }
            if workoutTypes.count > 0 {
                keyValue["workOutType"] = workoutTypes.count == 1 ? workoutTypes + workoutTypes : workoutTypes
            }
            if movementCategories.count > 0 {
                keyValue["movementCategory"] = movementCategories.count == 1 ? movementCategories + movementCategories : movementCategories
            }
            return keyValue
        case .addWorkoutSchedule(let model,let isUpdate):
            return model.toParams(isUpdate: isUpdate)
        case .getPlannerWorkouts(let startDateInMilis,let endDate,_):
            return  ["startDate":startDateInMilis,"endDate":endDate]
        }
    }
    
    /// http header for each request (if needed)
    var header:HTTPHeaders? {
        var headers = ["platform":"2","timezone":"0","api_key":"1234","language":"en"]
        switch self {
        case .socialRegister,.socialLogin,.login,.getOtpOnEmail,.signup,.resetPassword:
            return HTTPHeaders(headers)
        case .verifyEmail:
            return HTTPHeaders(headers)
        case .updateOnboardingStatus,.getVideos,.getFeeds,.postFeed,.deleteFeed,.likeFeed,.getPredefinedComments,.getComments,.postComment,.getChallenges,.getChallengeDetail,.createChallenge,.getWorkoutDetail,.markCircuitAsSeen,.rateWorkout,.getLibraryItems,.getFilters,.getWorkoutSchedules,.addWorkoutSchedule,.getPlannerWorkouts:
            headers["authorization"] = "bearer " + (DataManager.shared.loggedInUser?.user?.accessToken ?? "")
            return HTTPHeaders(headers)
        }
    }
}



typealias JSONDictionary = [String : Any]

func asString(jsonDictionary: JSONDictionary) -> String {
  do {
    let data = try JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
    return String(data: data, encoding: String.Encoding.utf8) ?? ""
  } catch {
    return ""
  }
}

//let dict: JSONDictionary = ["foo": 1, "bar": 2, "baz": 3]
//let dictAsString = asString(jsonDictionary: dict)
