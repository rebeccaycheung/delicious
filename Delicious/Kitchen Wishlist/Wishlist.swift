//
//  Wishlist.swift
//  Delicious
//
//  Created by Rebecca Cheung on 16/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import Foundation

class Wishlist: NSObject, Decodable {
    var id: String = ""
    var name: String = ""
    var brand: String = ""
    var price: Float

    enum CodingKeys: String, CodingKey {
        case name
        case brand
        case price
    }
}
