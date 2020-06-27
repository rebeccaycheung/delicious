//
//  EditSearchRecipeDelegate.swift
//  Delicious
//
//  Created by Rebecca Cheung on 19/6/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import Foundation

// Protocol for editting the searched recipe
protocol EditSearchRecipeDelegate: AnyObject {
    func editSearchRecipe(recipe: Recipe)
}
