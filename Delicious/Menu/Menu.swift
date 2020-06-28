//
//  Menu.swift
//  Delicious
//
//  Created by Rebecca Cheung on 5/6/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

// Menu Object
class Menu: NSObject, Codable {
    var id: String?
    var name: String = ""
    var imageReference: String?
    var recipes: [Recipe]?
    var cookTime: Int?
    var servingSize: Int?
    var extraIngredientsName: [String]?
    var extraIngredientsMeasurement: [String]?
    var extraInstructions: [String]?
    var notesList: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageReference
        case recipes
        case cookTime
        case servingSize
        case extraIngredientsName
        case extraIngredientsMeasurement
        case extraInstructions
        case notesList
    }
}
