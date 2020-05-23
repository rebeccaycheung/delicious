//
//  ShowRecipeDelegate.swift
//  Delicious
//
//  Created by Rebecca Cheung on 24/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import Foundation

protocol ShowRecipeDelegate: AnyObject {
    func showRecipe(recipe: Recipe)
}

