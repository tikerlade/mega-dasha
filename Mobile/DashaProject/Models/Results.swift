//
//  Results.swift
//  DashaProject
//
//  Created by Георгий Кашин on 22.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import Foundation

class Results: Codable {
    
    var results = Items()
}

class Items: Codable {
    
    var items = [Item]()
}

class Item: Codable {
    
    var position = [Double]()
    var icon = String()
}
