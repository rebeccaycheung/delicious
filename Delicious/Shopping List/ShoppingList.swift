//
//  ShoppingList.swift
//  Delicious
//
//  Created by Rebecca Cheung on 16/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class ShoppingList: NSObject, Decodable {
    var id: String = ""
    var brand: String = ""
    var item: String = ""
    var price: Float
    
    enum CodingKeys: String, CodingKey {
        case brand
        case item
        case price
    }
}
