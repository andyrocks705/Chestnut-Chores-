//
//  Job.swift
//  Chestnut Chores Revamp
//
//  Created by Andy Lau on 3/22/21.
//  Copyright © 2021 SCH Academy. All rights reserved.
//

import Foundation
import UIKit

struct Job {
    var location: Location!
    var customer: Customer?
    var worker: Worker?
    var address = String()
    var jobType = String()
    var price = Double()
    
    struct Location {
        var latitude: Double
        var longitude: Double
    }
    
    struct Customer {
        var firstName = String()
        var lastName = String()
        var phoneNumber: String?
        var email: String?
    }
    
    struct Worker {
        var firstName = String()
        var lastName = String()
        var phoneNumber: String?
        var email: String?
    }
}
