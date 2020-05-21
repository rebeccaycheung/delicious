//
//  Wishlist.swift
//  Delicious
//
//  Created by Rebecca Cheung on 16/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import Foundation

class Wishlist: NSObject, Decodable {
    var id: String?
    var name: String = ""
    var brand: String = ""
    var price: Float = 0
    var checked: Bool = false

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case brand
        case price
        case checked
    }
}
