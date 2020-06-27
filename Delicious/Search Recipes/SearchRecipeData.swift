//
//  SearchRecipeData.swift
//  Delicious
//
//  Created by Rebecca Cheung on 14/6/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

// Decodable for the recipes data from the API
class SearchRecipeData: NSObject, Decodable {
    var recipes: [RecipeData]?

    private enum CodingKeys: String, CodingKey {
        case recipes = "meals"
    }
}
