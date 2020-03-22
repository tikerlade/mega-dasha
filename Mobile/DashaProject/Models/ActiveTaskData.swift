//
//  ActiveTaskData.swift
//  DashaProject
//
//  Created by Георгий Кашин on 22.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import Foundation

class ActiveTaskData: Codable {
    var radius = Int()
    var location = String()
    var phoneNumber = Int()
    var friendPhoneNumbers: [Int]? = [Int]()
    
    enum CodingKeys: String, CodingKey {
        case phoneNumber = "me"
        case radius = "radius"
        case location = "location"
        case friendPhoneNumbers = "users"
    }
}
