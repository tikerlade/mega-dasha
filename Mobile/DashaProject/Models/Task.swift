//
//  Task.swift
//  DashaProject
//
//  Created by Георгий Кашин on 21.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import Foundation

class Task: Codable {
    
    init(name: String, phoneNumber: Int, category: String) {
        self.name = name
        self.category = category
        self.phone = phoneNumber
//        self.engCategory = engCategories[categories.firstIndex(of: category)!]
    }
    
    var name = String()
    var phone = Int()
    var category = String()
//    var engCategory = String()
    
    enum CodingKeys: String, CodingKey {
        case name = "description"
        case category = "category"
        case phone = "phone"
    }
}

class Tasks: Codable {
    var tasks: [Task]
}
