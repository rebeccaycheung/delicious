//
//  ShoppingList.swift
//  Delicious
//
//  Created by Rebecca Cheung on 16/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import Foundation

class ShoppingList: NSObject, Decodable {
    var id: String?
    var brand: String = ""
    var item: String = ""
    var price: Float = 0
    var checked: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case brand
        case item
        case price
        case checked
    }
}
