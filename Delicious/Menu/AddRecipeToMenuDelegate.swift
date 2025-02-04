//
//  AddRecipeToMenuDelegate.swift
//  Delicious
//
//  Created by Rebecca Cheung on 26/6/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import Foundation

// Protocol for adding a recipe to a menu
protocol AddRecipeToMenuDelegate: AnyObject {
    func addRecipeToMenu(recipe: Recipe)
}

