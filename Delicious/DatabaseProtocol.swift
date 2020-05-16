//
//  DatabaseProtocol.swift
//  Delicious
//
//  Created by Rebecca Cheung on 9/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import Foundation

enum DatabaseChange {
    case add
    case remove
    case update
}

enum ListenerType {
    case bookmarks
    case shoppingList
    case wishlist
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}

    func onBookmarksListChange(change: DatabaseChange, bookmarks: [Bookmarks])
    func onShoppingListChange(change: DatabaseChange, shoppingList: [ShoppingList])
    func onWishlistChange(change: DatabaseChange, wishlist: [Wishlist])
}

protocol DatabaseProtocol: AnyObject {
    func cleanup()
    
    func addBookmark(name: String, url: String) -> Bookmarks
    func updateBookmark(name: String, url: String) -> Bookmarks
    func deleteBookmark(bookmark: Bookmarks)
    
    //func addShoppingItem(brand: String, item: String, price: Float) -> ShoppingList
    func deleteShoppingItem(shoppingItem: ShoppingList)
    
    //func addWishlistItem(brand: String, item: String, price: Float) -> ShoppingList
    func deleteWishlistItem(wishlistItem: Wishlist)
    
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
}
