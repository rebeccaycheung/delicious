//
//  RecipeData.swift
//  Delicious
//
//  Created by Rebecca Cheung on 14/6/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

// Decodable for a recipe from the API
class RecipeData: NSObject, Decodable {
    var name: String
    var instructions: String
    var category: String?
    var area: String?
    var image: String?
    var source: String?
    
    var ingredients: [String] = []
    var measurements: [String] = []
    
    private enum RecipeKeys: String, CodingKey {
        // Map the keys from the ApI to own keys
        case name = "strMeal"
        case instructions = "strInstructions"
        case category = "strCategory"
        case area = "strArea"
        case image = "strMealThumb"
        case source = "strSource"
        
        case strIngredient1
        case strIngredient2
        case strIngredient3
        case strIngredient4
        case strIngredient5
        case strIngredient6
        case strIngredient7
        case strIngredient8
        case strIngredient9
        case strIngredient10
        case strIngredient11
        case strIngredient12
        case strIngredient13
        case strIngredient14
        case strIngredient15
        case strIngredient16
        case strIngredient17
        case strIngredient18
        case strIngredient19
        case strIngredient20
        
        case strMeasure1
        case strMeasure2
        case strMeasure3
        case strMeasure4
        case strMeasure5
        case strMeasure6
        case strMeasure7
        case strMeasure8
        case strMeasure9
        case strMeasure10
        case strMeasure11
        case strMeasure12
        case strMeasure13
        case strMeasure14
        case strMeasure15
        case strMeasure16
        case strMeasure17
        case strMeasure18
        case strMeasure19
        case strMeasure20
    }
    
    required init(from decoder: Decoder) throws {
        let recipeContainer = try decoder.container(keyedBy: RecipeKeys.self)
        
        name = try recipeContainer.decode(String.self, forKey: .name)
        instructions = try recipeContainer.decode(String.self, forKey: .instructions)
        category = try? recipeContainer.decode(String.self, forKey: .category)
        area = try? recipeContainer.decode(String.self, forKey: .area)
        image = try? recipeContainer.decode(String.self, forKey: .image)
        source = try? recipeContainer.decode(String.self, forKey: .source)
        
        if let ingredient1 = try? recipeContainer.decode(String.self, forKey: .strIngredient1) {
            ingredients.append(ingredient1)
        }
        if let ingredient2 = try? recipeContainer.decode(String.self, forKey: .strIngredient2) {
            ingredients.append(ingredient2)
        }
        if let ingredient3 = try? recipeContainer.decode(String.self, forKey: .strIngredient3) {
            ingredients.append(ingredient3)
        }
        if let ingredient4 = try? recipeContainer.decode(String.self, forKey: .strIngredient4) {
            ingredients.append(ingredient4)
        }
        if let ingredient5 = try? recipeContainer.decode(String.self, forKey: .strIngredient5) {
            ingredients.append(ingredient5)
        }
        if let ingredient6 = try? recipeContainer.decode(String.self, forKey: .strIngredient6) {
            ingredients.append(ingredient6)
        }
        if let ingredient7 = try? recipeContainer.decode(String.self, forKey: .strIngredient7) {
            ingredients.append(ingredient7)
        }
        if let ingredient8 = try? recipeContainer.decode(String.self, forKey: .strIngredient8) {
            ingredients.append(ingredient8)
        }
        if let ingredient9 = try? recipeContainer.decode(String.self, forKey: .strIngredient9) {
            ingredients.append(ingredient9)
        }
        if let ingredient10 = try? recipeContainer.decode(String.self, forKey: .strIngredient10) {
            ingredients.append(ingredient10)
        }
        if let ingredient11 = try? recipeContainer.decode(String.self, forKey: .strIngredient11) {
            ingredients.append(ingredient11)
        }
        if let ingredient12 = try? recipeContainer.decode(String.self, forKey: .strIngredient12) {
            ingredients.append(ingredient12)
        }
        if let ingredient13 = try? recipeContainer.decode(String.self, forKey: .strIngredient13) {
            ingredients.append(ingredient13)
        }
        if let ingredient14 = try? recipeContainer.decode(String.self, forKey: .strIngredient14) {
            ingredients.append(ingredient14)
        }
        if let ingredient15 = try? recipeContainer.decode(String.self, forKey: .strIngredient15) {
            ingredients.append(ingredient15)
        }
        if let ingredient16 = try? recipeContainer.decode(String.self, forKey: .strIngredient16) {
            ingredients.append(ingredient16)
        }
        if let ingredient17 = try? recipeContainer.decode(String.self, forKey: .strIngredient17) {
            ingredients.append(ingredient17)
        }
        if let ingredient18 = try? recipeContainer.decode(String.self, forKey: .strIngredient18) {
            ingredients.append(ingredient18)
        }
        if let ingredient19 = try? recipeContainer.decode(String.self, forKey: .strIngredient19) {
            ingredients.append(ingredient19)
        }
        if let ingredient20 = try? recipeContainer.decode(String.self, forKey: .strIngredient20) {
            ingredients.append(ingredient20)
        }
        
        if let measurement1 = try? recipeContainer.decode(String.self, forKey: .strMeasure1) {
            measurements.append(measurement1)
        }
        if let measurement2 = try? recipeContainer.decode(String.self, forKey: .strMeasure2) {
            measurements.append(measurement2)
        }
        if let measurement3 = try? recipeContainer.decode(String.self, forKey: .strMeasure3) {
            measurements.append(measurement3)
        }
        if let measurement4 = try? recipeContainer.decode(String.self, forKey: .strMeasure4) {
            measurements.append(measurement4)
        }
        if let measurement5 = try? recipeContainer.decode(String.self, forKey: .strMeasure5) {
            measurements.append(measurement5)
        }
        if let measurement6 = try? recipeContainer.decode(String.self, forKey: .strMeasure6) {
            measurements.append(measurement6)
        }
        if let measurement7 = try? recipeContainer.decode(String.self, forKey: .strMeasure7) {
            measurements.append(measurement7)
        }
        if let measurement8 = try? recipeContainer.decode(String.self, forKey: .strMeasure8) {
            measurements.append(measurement8)
        }
        if let measurement9 = try? recipeContainer.decode(String.self, forKey: .strMeasure9) {
            measurements.append(measurement9)
        }
        if let measurement10 = try? recipeContainer.decode(String.self, forKey: .strMeasure10) {
            measurements.append(measurement10)
        }
        if let measurement11 = try? recipeContainer.decode(String.self, forKey: .strMeasure11) {
            measurements.append(measurement11)
        }
        if let measurement12 = try? recipeContainer.decode(String.self, forKey: .strMeasure12) {
            measurements.append(measurement12)
        }
        if let measurement13 = try? recipeContainer.decode(String.self, forKey: .strMeasure13) {
            measurements.append(measurement13)
        }
        if let measurement14 = try? recipeContainer.decode(String.self, forKey: .strMeasure14) {
            measurements.append(measurement14)
        }
        if let measurement15 = try? recipeContainer.decode(String.self, forKey: .strMeasure15) {
            measurements.append(measurement15)
        }
        if let measurement16 = try? recipeContainer.decode(String.self, forKey: .strMeasure16) {
            measurements.append(measurement16)
        }
        if let measurement17 = try? recipeContainer.decode(String.self, forKey: .strMeasure17) {
            measurements.append(measurement17)
        }
        if let measurement18 = try? recipeContainer.decode(String.self, forKey: .strMeasure18) {
            measurements.append(measurement18)
        }
        if let measurement19 = try? recipeContainer.decode(String.self, forKey: .strMeasure19) {
            measurements.append(measurement19)
        }
        if let measurement20 = try? recipeContainer.decode(String.self, forKey: .strMeasure20) {
            measurements.append(measurement20)
        }
    }
}
