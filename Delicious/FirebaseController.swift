//
//  FirebaseController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 9/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebaseController: NSObject, DatabaseProtocol {
    var listeners = MulticastDelegate<DatabaseListener>()
    var database: Firestore
    
    var recipeRef: CollectionReference?
    var recipeList: [Recipe]
    
    var bookmarksRef: CollectionReference?
    var bookmarksList: [Bookmarks]
    
    var shoppingListRef: CollectionReference?
    var shoppingItemList: [ShoppingList]
    
    var wishlistRef: CollectionReference?
    var wishlistList: [Wishlist]
    
    override init() {
        FirebaseApp.configure()
        database = Firestore.firestore()
        
        bookmarksList = [Bookmarks]()
        shoppingItemList = [ShoppingList]()
        wishlistList = [Wishlist]()
        recipeList = [Recipe]()
        
        super.init()
        
        self.setUpBookmarksListener()
        self.setUpShoppingListListener()
        self.setUpWishlistListener()
        self.setUpRecipeListener()
    }
    
    func setUpRecipeListener() {
        recipeRef = database.collection("recipe")
        recipeRef?.addSnapshotListener { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Error fetching documents: \(error!)")
                return
            }
            self.parseRecipeSnapshot(snapshot: querySnapshot)
        }
    }
    
    func parseRecipeSnapshot(snapshot: QuerySnapshot) {
        snapshot.documentChanges.forEach { (change) in
            let recipeID = change.document.documentID
            print(recipeID)
            
            var parsedRecipe: Recipe?
            
            do {
                parsedRecipe = try change.document.data(as: Recipe.self)
            } catch {
                print("Unable to decode recipe. Is the recipe malformed?")
                return
            }
            
            guard let recipe = parsedRecipe else {
                print("Document doesn't exist")
                return;
            }
            
            recipe.id = recipeID
            if change.type == .added {
                recipeList.append(recipe)
            } else if change.type == .modified {
                let index = getRecipeIndexByID(recipeID)!
                recipeList[index] = recipe
            } else if change.type == .removed {
                if let index = getRecipeIndexByID(recipeID) {
                    recipeList.remove(at: index)
                }
            }
        }
        
        listeners.invoke{ (listener) in
            if listener.listenerType == ListenerType.recipe || listener.listenerType == ListenerType.all {
                listener.onRecipeListChange(change: .update, recipe: recipeList)
            }
        }
    }
    
    func getRecipeIndexByID(_ id: String) -> Int? {
        if let recipe = getRecipeByID(id) {
            return recipeList.firstIndex(of: recipe)
        }
        return nil
    }
    
    func getRecipeByID(_ id: String) -> Recipe? {
        for recipe in recipeList {
            if recipe.id == id {
                return recipe
            }
        }
        return nil
    }
    
    
    func setUpBookmarksListener() {
        bookmarksRef = database.collection("bookmarks")
        bookmarksRef?.addSnapshotListener { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Error fetching documents: \(error!)")
                return
            }
            self.parseBookmarksSnapshot(snapshot: querySnapshot)
        }
    }
    
    func parseBookmarksSnapshot(snapshot: QuerySnapshot) {
        snapshot.documentChanges.forEach { (change) in
            let bookmarksID = change.document.documentID
            print(bookmarksID)
            
            var parsedBookmarks: Bookmarks?
            
            do {
                parsedBookmarks = try change.document.data(as: Bookmarks.self)
            } catch {
                print("Unable to decode bookmarks. Is the bookmark malformed?")
                return
            }
            
            guard let bookmarks = parsedBookmarks else {
                print("Document doesn't exist")
                return;
            }
            
            bookmarks.id = bookmarksID
            if change.type == .added {
                bookmarksList.append(bookmarks)
            } else if change.type == .modified {
                let index = getBookmarksIndexByID(bookmarksID)!
                bookmarksList[index] = bookmarks
            } else if change.type == .removed {
                if let index = getBookmarksIndexByID(bookmarksID) {
                    bookmarksList.remove(at: index)
                }
            }
        }
        
        listeners.invoke{ (listener) in
            if listener.listenerType == ListenerType.bookmarks || listener.listenerType == ListenerType.all {
                listener.onBookmarksListChange(change: .update, bookmarks: bookmarksList)
            }
        }
    }
    
    func getBookmarksIndexByID(_ id: String) -> Int? {
        if let bookmarks = getBookmarksByID(id) {
            return bookmarksList.firstIndex(of: bookmarks)
        }
        return nil
    }
    
    func getBookmarksByID(_ id: String) -> Bookmarks? {
        for bookmarks in bookmarksList {
            if bookmarks.id == id {
                return bookmarks
            }
        }
        return nil
    }
    
    func setUpShoppingListListener() {
        shoppingListRef = database.collection("shoppingList")
        shoppingListRef?.addSnapshotListener { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Error fetching documents: \(error!)")
                return
            }
            self.parseShoppingListSnapshot(snapshot: querySnapshot)
        }
    }
    
    func parseShoppingListSnapshot(snapshot: QuerySnapshot) {
        snapshot.documentChanges.forEach { (change) in
            let shoppingListID = change.document.documentID
            print(shoppingListID)
            
            var parsedShoppingList: ShoppingList?
            
            do {
                parsedShoppingList = try change.document.data(as: ShoppingList.self)
            } catch {
                print("Unable to decode shopping list. Is the shopping list malformed?")
                return
            }
            
            guard let shoppingList = parsedShoppingList else {
                print("Document doesn't exist")
                return;
            }
            
            shoppingList.id = shoppingListID
            if change.type == .added {
                shoppingItemList.append(shoppingList)
            } else if change.type == .modified {
                let index = getShoppingListIndexByID(shoppingListID)!
                shoppingItemList[index] = shoppingList
            } else if change.type == .removed {
                if let index = getShoppingListIndexByID(shoppingListID) {
                    shoppingItemList.remove(at: index)
                }
            }
        }
        
        listeners.invoke{ (listener) in
            if listener.listenerType == ListenerType.shoppingList || listener.listenerType == ListenerType.all {
                listener.onShoppingListChange(change: .update, shoppingList: shoppingItemList)
            }
        }
    }
    
    func getShoppingListIndexByID(_ id: String) -> Int? {
        if let shoppingList = getShoppingListID(id) {
            return shoppingItemList.firstIndex(of: shoppingList)
        }
        return nil
    }
    
    func getShoppingListID(_ id: String) -> ShoppingList? {
        for shoppingList in shoppingItemList {
            if shoppingList.id == id {
                return shoppingList
            }
        }
        return nil
    }
    
    func setUpWishlistListener() {
        wishlistRef = database.collection("wishlist")
        wishlistRef?.addSnapshotListener { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Error fetching documents: \(error!)")
                return
            }
            self.parseWishlistSnapshot(snapshot: querySnapshot)
        }
    }
    
    func parseWishlistSnapshot(snapshot: QuerySnapshot) {
        snapshot.documentChanges.forEach { (change) in
            let wishlistID = change.document.documentID
            print(wishlistID)
            
            var parsedWishlist: Wishlist?
            
            do {
                parsedWishlist = try change.document.data(as: Wishlist.self)
            } catch {
                print("Unable to decode wishlist. Is the wishlist malformed?")
                return
            }
            
            guard let wishlist = parsedWishlist else {
                print("Document doesn't exist")
                return;
            }
            
            wishlist.id = wishlistID
            if change.type == .added {
                wishlistList.append(wishlist)
            } else if change.type == .modified {
                let index = getWishlistIndexByID(wishlistID)!
                wishlistList[index] = wishlist
            } else if change.type == .removed {
                if let index = getWishlistIndexByID(wishlistID) {
                    wishlistList.remove(at: index)
                }
            }
        }
        
        listeners.invoke{ (listener) in
            if listener.listenerType == ListenerType.bookmarks || listener.listenerType == ListenerType.all {
                listener.onBookmarksListChange(change: .update, bookmarks: bookmarksList)
            }
        }
    }
    
    func getWishlistIndexByID(_ id: String) -> Int? {
        if let wishlist = getWishlistByID(id) {
            return wishlistList.firstIndex(of: wishlist)
        }
        return nil
    }
    
    func getWishlistByID(_ id: String) -> Wishlist? {
        for wishlist in wishlistList {
            if wishlist.id == id {
                return wishlist
            }
        }
        return nil
    }
    
    func cleanup() {
    }
    
    func addBookmark(name: String, url: String) -> Bookmarks {
        let bookmarks = Bookmarks()
        bookmarks.name = name
        bookmarks.url = url
        if let bookmarksRef = bookmarksRef?.addDocument(data: ["name": name, "url": url]) {
            bookmarks.id = bookmarksRef.documentID
        }
        return bookmarks
    }
    
    func updateBookmark(bookmark: Bookmarks) {
        if let bookmarksRef = bookmarksRef?.document(bookmark.id!) {
            bookmarksRef.updateData(["name": bookmark.name, "url": bookmark.url])
        }
    }
    
    func deleteBookmark(bookmark: Bookmarks) {
        bookmarksRef?.document(bookmark.id!).delete() { (error) in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed")
            }
        }
    }
    
    func addShoppingItem(item: String, brand: String, price: Float) -> ShoppingList {
        let shoppingItem = ShoppingList()
        shoppingItem.item = item
        shoppingItem.brand = brand
        shoppingItem.price = price
        shoppingItem.checked = false
        if let shoppingListRef = shoppingListRef?.addDocument(data: ["item": item, "brand": brand, "price": price, "checked": false]) {
            shoppingItem.id = shoppingListRef.documentID
        }
        return shoppingItem
    }
    
    func updateShoppingItem(item: ShoppingList) {
        if let shoppingListRef = shoppingListRef?.document(item.id!) {
            shoppingListRef.updateData(["item": item.item, "brand": item.brand, "price": item.price])
        }
    }
    
    func checkShoppingItem(item: ShoppingList, checked: Bool) {
        if let shoppingListRef = shoppingListRef?.document(item.id!) {
            shoppingListRef.updateData(["checked": checked])
        }
    }
    
    func deleteShoppingItem(shoppingItem: ShoppingList) {
        shoppingListRef?.document(shoppingItem.id!).delete() { (error) in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed")
            }
        }
    }
    
    func addWishlistItem(name: String, brand: String, price: Float) {
        let wishlist = Wishlist()
        wishlist.name = name
        wishlist.brand = brand
        wishlist.price = price
        if let wishlistRef = wishlistRef?.addDocument(data: ["name": name, "brand": brand, "price": price, "checked": false]) {
            wishlist.id = wishlistRef.documentID
        }
    }
    
    func updateWishlistItem(item: Wishlist) {
        if let wishlistRef = wishlistRef?.document(item.id!) {
            wishlistRef.updateData(["name": item.name, "brand": item.brand, "price": item.price])
        }
    }
    
    func checkWishlistItem(item: Wishlist, checked: Bool) {
        if let wishlistRef = wishlistRef?.document(item.id!) {
            wishlistRef.updateData(["checked": checked])
        }
    }

    func deleteWishlistItem(wishlistItem: Wishlist) {
        wishlistRef?.document(wishlistItem.id!).delete() { (error) in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed")
            }
        }
    }
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        if listener.listenerType == ListenerType.bookmarks || listener.listenerType == ListenerType.all {
            listener.onBookmarksListChange (change: .update, bookmarks: bookmarksList)
        } else if listener.listenerType == ListenerType.shoppingList || listener.listenerType == ListenerType.all {
            listener.onShoppingListChange (change: .update, shoppingList: shoppingItemList)
        } else if listener.listenerType == ListenerType.wishlist || listener.listenerType == ListenerType.all {
            listener.onWishlistChange (change: .update, wishlist: wishlistList)
        } else if listener.listenerType == ListenerType.recipe || listener.listenerType == ListenerType.all {
            listener.onRecipeListChange(change: .update, recipe: recipeList)
        }
    }

    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
}
