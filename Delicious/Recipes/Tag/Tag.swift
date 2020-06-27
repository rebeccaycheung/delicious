//
//  Tag.swift
//  Delicious
//
//  Created by Rebecca Cheung on 25/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import Foundation

// Tag Object
class Tag: NSObject, Decodable {
    var id: String?
    var name: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}

