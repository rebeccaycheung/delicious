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
    case recipe
    case menu
    case tag
    case bookmarks
    case shoppingList
    case wishlist
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    
    func onRecipeListChange(change: DatabaseChange, recipe: [Recipe])
//    func onMenuChange(change: DatabaseChange, menuRecipes: [Recipe])
    func onMenuChange(change: DatabaseChange, menu: [Menu])
    func onTagListChange(change: DatabaseChange, tag: [Tag])
    func onBookmarksListChange(change: DatabaseChange, bookmarks: [Bookmarks])
    func onShoppingListChange(change: DatabaseChange, shoppingList: [ShoppingList])
    func onWishlistChange(change: DatabaseChange, wishlist: [Wishlist])
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
    
    func addRecipe(recipe: Recipe)
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
    
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
}

