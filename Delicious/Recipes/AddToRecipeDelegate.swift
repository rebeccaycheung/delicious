//
//  AddToRecipeDelegate.swift
//  Delicious
//
//  Created by Rebecca Cheung on 30/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import Foundation

protocol AddToRecipeDelegate: AnyObject {
    func addToRecipe(type: String, value: String)
}

