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
    var source: String = ""
    var cookTime: Int
    var servingSize: Int
    var ingredientName: [String] = []
    var ingredientMeasurement: [String] = []
    var instruction: [String] = []
    var note: [String] = []
    var tag: [String] = []
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case source
        case cookTime
        case servingSize
        case ingredientName
        case ingredientMeasurement
        case instruction
        case note
        case tag
    }
}
