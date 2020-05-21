//
//  Bookmarks.swift
//  Delicious
//
//  Created by Rebecca Cheung on 9/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import Foundation

class Bookmarks: NSObject, Decodable {
    var id: String?
    var name: String = ""
    var url: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case url
    }
}
