//
//  Recipe.swift
//  Delicious
//
//  Created by Rebecca Cheung on 18/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class Recipe: NSObject, Decodable {
    var id: String?
    var name: String = ""
    var source: String?
    var cookTime: Int
    var servingSize: Int
    var ingredientNamesList: [String]?
    var ingredientMeasurementsList: [String]?
    var instructionsList: [String]?
    var notesList: [String]?
    var tagsList: [String]?
    var menuList: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case source
        case cookTime
        case servingSize
        case ingredientNamesList
        case ingredientMeasurementsList
        case instructionsList
        case notesList
        case tagsList
        case menuList
    }
}
