//
//  Menu.swift
//  Delicious
//
//  Created by Rebecca Cheung on 5/6/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class Menu: NSObject, Codable {
    var id: String?
    var name: String = ""
    var recipes: [String]?
    var cookTime: Int?
    var servingSize: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case recipes
        case cookTime
        case servingSize
    }
}
