//
//  Recipe.swift
//  Delicious
//
//  Created by Rebecca Cheung on 18/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import Foundation

// Recipe Object
class Recipe: NSObject, Codable {
    var id: String?
    var name: String = ""
    var imageReference: String?
    var source: String?
    var cookTime: Int = 0
    var servingSize: Int = 0
    var ingredientNamesList: [String]?
    var ingredientMeasurementsList: [String]?
    var instructionsList: [String]?
    var notesList: [String]?
    var tagsList: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageReference
        case source
        case cookTime
        case servingSize
        case ingredientNamesList
        case ingredientMeasurementsList
        case instructionsList
        case notesList
        case tagsList
    }
}

