//
//  Task.swift
//  DashaProject
//
//  Created by Георгий Кашин on 21.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import Foundation

class Task: Codable {
    
    init(name: String, category: String) {
        self.name = name
        self.category = category
    }
    
    var name = String()
    var phone = Int()
    var category = String()
    
    enum CodingKeys: String, CodingKey {
        case name = "description"
        case category = "category"
    }
}

class Tasks: Codable {
    var tasks: [Task]
}
