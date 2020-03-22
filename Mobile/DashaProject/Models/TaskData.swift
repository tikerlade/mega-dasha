//
//  TaskData.swift
//  DashaProject
//
//  Created by Георгий Кашин on 22.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import Foundation

class TaskData: Codable {
    var phoneNumber = Int()
    var name = String()
    var category = String()
    
    enum CodingKeys: String, CodingKey {
        case phoneNumber = "phone"
        case name = "description"
        case category = "category"
    }
}
