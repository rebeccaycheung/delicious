//
//  DatabaseProtocol.swift
//  Delicious
//
//  Created by Rebecca Cheung on 9/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import Foundation

// Inform of what kind of change has occurred to the database
enum DatabaseChange {
    case add
    case remove
    case update
}

// Determine what changes the listener cares about
enum ListenerType {
    case recipe
    case menu
    case tag
    case bookmarks
    case shoppingList
    case wishlist
    case all
}

// Delegates to be used for receiving and updating from the database
protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    
    func onRecipeListChange(change: DatabaseChange, recipe: [Recipe])
    func onMenuChange(change: DatabaseChange, menu: [Menu])
    func onTagListChange(change: DatabaseChange, tag: [Tag])
    func onBookmarksListChange(change: DatabaseChange, bookmarks: [Bookmarks])
    func onShoppingListChange(change: DatabaseChange, shoppingList: [ShoppingList])
    func onWishlistChange(change: DatabaseChange, wishlist: [Wishlist])
}

// Protocols that the database must implement
protocol DatabaseProtocol: AnyObject {
    func cleanup()
    
    func addBookmark(name: String, url: String) -> Bookmarks
    func updateBookmark(bookmark: Bookmarks)
    func deleteBookmark(bookmark: Bookmarks)
    
    func addShoppingItem(item: String, brand: String, price: Float) -> ShoppingList
    func updateShoppingItem(item: ShoppingList)
    func checkShoppingItem(item: ShoppingList, checked: Bool)
    func deleteShoppingItem(shoppingItem: ShoppingList)
    
    func addWishlistItem(name: String, brand: String, price: Float) -> Wishlist
    func updateWishlistItem(item: Wishlist)
    func checkWishlistItem(item: Wishlist, checked: Bool)
    func deleteWishlistItem(wishlistItem: Wishlist)
    
    func addRecipe(recipe: Recipe)
    func addImageToRecipe(recipe: Recipe, image: String)
    func updateRecipe(recipe: Recipe)
    func deleteRecipe(recipe: Recipe)
    
    func addTag(name: String)
    func updateTag(tag: Tag)
    func deleteTag(tag: Tag)
    
    func addMenu(name: String) -> Menu
    func updateMenu(menu: Menu)
    func addRecipeToMenu(recipe: Recipe, menu: Menu) -> Bool
    func deleteMenu(menu: Menu)
    func removeRecipeFromMenu(recipe: Recipe, menu: Menu)
    func addImageToMenu(menu: Menu, image: String)
    
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
}
