//
//  DeleteBookmarkDelegate.swift
//  Delicious
//
//  Created by Rebecca Cheung on 16/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import Foundation

protocol DeleteBookmarkDelegate: AnyObject {
    func deleteBookmark(bookmark: Bookmarks)
}
