//
//  TimeService.swift
//  YourTake
//
//  Created by John Buonassisi on 2018-01-22.
//  Copyright © 2018 Enovi Inc. All rights reserved.
//

import Foundation

class TimeService: NSObject {
    
    static func getRoundedTimeRemaining(numSecondsRemaining: Int) -> String {
        if( numSecondsRemaining <= 0) {
            return "0 seconds"
        }
        
        let numDaysRemaining = numSecondsRemaining / ( 60 * 60 * 24)
        if(numDaysRemaining > 0) {
            if numDaysRemaining == 1 {
                return String(numDaysRemaining) + " day"
            }
            return String(numDaysRemaining) + " days"
        }
        
        let numHoursRemaining = numSecondsRemaining / ( 60 * 60 )
        if( numHoursRemaining > 0) {
            if numHoursRemaining == 1 {
                return String(numHoursRemaining) + " hour"
            }
            return String(numHoursRemaining) + " hours"
        }
        
        let numMinutesRemaining = numSecondsRemaining / 60
        if(numMinutesRemaining > 0){
            if numHoursRemaining == 1 {
                return String(numMinutesRemaining) + " minute"
            }
            return String(numMinutesRemaining) + " minutes"
        }
        if numSecondsRemaining == 1 {
            return String(numSecondsRemaining) + "second"
        }
        
        return String(numSecondsRemaining) + " seconds"
    }
}
