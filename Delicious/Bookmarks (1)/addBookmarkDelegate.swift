//
//  addBookmarkDelegate.swift
//  Delicious
//
//  Created by Rebecca Cheung on 15/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import Foundation

protocol AddBookmarkDelegate: AnyObject {
    func addBookmark(name: String, url: String) -> Bool
}
