//
//  PlannerEndPoint.swift
//  Sway
//
//  Created by Admin on 20/07/21.
//

import Foundation

class PlannerEndPoint {
    static func getSchedule(startDate:Int,dayOfWeek:Int,success: @escaping SuccessCompletionBlock<PlannerSchedulesDayWiseResponse>, failure: @escaping ErrorFailureCompletionBlock) {
        Api.requestNew(endpoint: .getPlannerWorkouts(startDateInMilis: startDate, dayOfWeek: dayOfWeek) , type: PlannerSchedulesDayWiseResponse.self, successHandler: success, failureHandler: failure)
    }
}
