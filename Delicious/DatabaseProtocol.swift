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
    case recipe
    case tag
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}

    func onBookmarksListChange(change: DatabaseChange, bookmarks: [Bookmarks])
    func onShoppingListChange(change: DatabaseChange, shoppingList: [ShoppingList])
    func onWishlistChange(change: DatabaseChange, wishlist: [Wishlist])
    func onRecipeListChange(change: DatabaseChange, recipe: [Recipe])
    func onTagListChange(change: DatabaseChange, tag: [Tag])
}

protocol DatabaseProtocol: AnyObject {
    func cleanup()
    
    func addBookmark(name: String, url: String) -> Bookmarks
    func updateBookmark(bookmark: Bookmarks)
    func deleteBookmark(bookmark: Bookmarks)
    
    func addShoppingItem(item: String, brand: String, price: Float) -> ShoppingList
    func updateShoppingItem(item: ShoppingList)
    func checkShoppingItem(item: ShoppingList, checked: Bool)
    func deleteShoppingItem(shoppingItem: ShoppingList)
    
    func addWishlistItem(name: String, brand: String, price: Float)
    func updateWishlistItem(item: Wishlist)
    func checkWishlistItem(item: Wishlist, checked: Bool)
    func deleteWishlistItem(wishlistItem: Wishlist)
    
    func addRecipe(name: String, source: String, cookTime: Int, servingSize: Int, ingredientsList: [String], measurementList: [String], instructionsList: [String], notesList: [String], tagsList: [String])
    func updateRecipe(recipe: Recipe)
    func deleteRecipe(recipe: Recipe)
    
    func addTag(name: String)
    func updateTag(tag: Tag)
    func deleteTag(tag: Tag)
    
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
}

