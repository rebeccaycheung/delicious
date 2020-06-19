//
//  FirebaseController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 9/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebaseController: NSObject, DatabaseProtocol {
    
    var listeners = MulticastDelegate<DatabaseListener>()
    var authController: Auth
    var database: Firestore
    
    var menuRef: CollectionReference?
    var menuList: [Menu]
//    let DEFAULT_MENU_NAME = "Default Menu"
//    var defaultMenu: Menu
    
    var recipeRef: CollectionReference?
    var recipeList: [Recipe]
    
    var tagRef: CollectionReference?
    var tagList: [Tag]
    
    var bookmarksRef: CollectionReference?
    var bookmarksList: [Bookmarks]
    
    var shoppingListRef: CollectionReference?
    var shoppingItemList: [ShoppingList]
    
    var wishlistRef: CollectionReference?
    var wishlistList: [Wishlist]
    
    override init() {
        FirebaseApp.configure()
        authController = Auth.auth()
        database = Firestore.firestore()
        
//        defaultMenu = Menu()
        
        recipeList = [Recipe]()
        menuList = [Menu]()
        tagList = [Tag]()
        bookmarksList = [Bookmarks]()
        shoppingItemList = [ShoppingList]()
        wishlistList = [Wishlist]()
        
        super.init()
        
        self.setUpRecipeListener()
        self.setUpMenuListener()
        self.setUpTagListener()
        self.setUpBookmarksListener()
        self.setUpShoppingListListener()
        self.setUpWishlistListener()
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
    
    func setUpMenuListener() {
        menuRef = database.collection("menu")
        menuRef?.addSnapshotListener { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Error fetching documents: \(error!)")
                return
            }
            self.parseMenuSnapshot(snapshot: querySnapshot)
        }
//        menuRef?.whereField("name", isEqualTo: DEFAULT_MENU_NAME).addSnapshotListener {
//            (querySnapshot, error) in
//            guard let querySnapshot = querySnapshot, let menuSnapshot = querySnapshot.documents.first else {
//                print("Error fetching teams: \(error!)")
//                return
//            }
//            self.parseMenuSnapshot(snapshot: menuSnapshot)
//        }
    }
    
    func parseMenuSnapshot(snapshot: QuerySnapshot) {
        snapshot.documentChanges.forEach { (change) in
            let menuID = change.document.documentID
            print(menuID)
            
            var parsedMenu: Menu?
            
            do {
                parsedMenu = try change.document.data(as: Menu.self)
            } catch {
                print("Unable to decode menu. Is the menu malformed?")
                return
            }
            
            guard let menu = parsedMenu else {
                print("Document doesn't exist")
                return;
            }
            
            menu.id = menuID
            if change.type == .added {
                menuList.append(menu)
            } else if change.type == .modified {
                let index = getMenuIndexByID(menuID)!
                menuList[index] = menu
            } else if change.type == .removed {
                if let index = getMenuIndexByID(menuID) {
                    menuList.remove(at: index)
                }
            }
        }
        
        listeners.invoke{ (listener) in
            if listener.listenerType == ListenerType.menu || listener.listenerType == ListenerType.all {
                listener.onMenuChange(change: .update, menu: menuList)
            }
        }
//        defaultMenu = Menu()
//        defaultMenu.name = snapshot.data()["name"] as! String
//        defaultMenu.id = snapshot.documentID
//        if let recipeReferences = snapshot.data()["menu"] as? [DocumentReference] {
//            for reference in recipeReferences {
//                if let recipe = getRecipeByID(reference.documentID) {
//                    defaultMenu.recipes.append(recipe)
//                }
//            }
//        }
//
//        listeners.invoke{ (listener) in
//            if listener.listenerType == ListenerType.menu || listener.listenerType == ListenerType.all {
//                listener.onMenuChange(change: .update, menuRecipes: defaultMenu.recipes)
//            }
//        }
    }
    
    func getMenuIndexByID(_ id: String) -> Int? {
        if let menu = getMenuByID(id) {
            return menuList.firstIndex(of: menu)
        }
        return nil
    }
    
    func getMenuByID(_ id: String) -> Menu? {
        for menu in menuList {
            if menu.id == id {
                return menu
            }
        }
        return nil
    }
    
    func setUpTagListener() {
        tagRef = database.collection("tag")
        tagRef?.addSnapshotListener { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Error fetching documents: \(error!)")
                return
            }
            self.parseTagSnapshot(snapshot: querySnapshot)
        }
    }
    
    func parseTagSnapshot(snapshot: QuerySnapshot) {
        snapshot.documentChanges.forEach { (change) in
            let tagID = change.document.documentID
            print(tagID)
            
            var parsedTag: Tag?
            
            do {
                parsedTag = try change.document.data(as: Tag.self)
            } catch {
                print("Unable to decode tag. Is the tag malformed?")
                return
            }
            
            guard let tag = parsedTag else {
                print("Document doesn't exist")
                return;
            }
            
            tag.id = tagID
            if change.type == .added {
                tagList.append(tag)
            } else if change.type == .modified {
                let index = getTagIndexByID(tagID)!
                tagList[index] = tag
            } else if change.type == .removed {
                if let index = getTagIndexByID(tagID) {
                    tagList.remove(at: index)
                }
            }
        }
        
        listeners.invoke{ (listener) in
            if listener.listenerType == ListenerType.tag || listener.listenerType == ListenerType.all {
                listener.onTagListChange(change: .update, tag: tagList)
            }
        }
    }
    
    func getTagIndexByID(_ id: String) -> Int? {
        if let tag = getTagByID(id) {
            return tagList.firstIndex(of: tag)
        }
        return nil
    }
    
    func getTagByID(_ id: String) -> Tag? {
        for tag in tagList {
            if tag.id == id {
                return tag
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
    
    func addMenu(name: String) -> Menu {
        let menu = Menu()
        menu.name = name
        if let menuRef = menuRef?.addDocument(data: ["name" : name, "recipes": []]) {
            menu.id = menuRef.documentID
        }
        return menu
    }
    
    func updateMenu(menu: Menu) {
        if let menuRef = menuRef?.document(menu.id!) {
            menuRef.updateData(["name": menu.name, "cookTime": menu.cookTime, "servingSize": menu.servingSize])
        }
    }
    
    func addRecipeToMenu(recipe: Recipe, menu: Menu) -> Bool {
        guard let recipeID = recipe.id, let menuID = menu.id else {
            return false
        }
        if let newRecipeRef = recipeRef?.document(recipeID) {
            menuRef?.document(menuID).updateData(["recipes" : FieldValue.arrayUnion([newRecipeRef])] )
        }
        return true
    }
    
    func deleteMenu(menu: Menu) {
        if let menuID = menu.id {
            menuRef?.document(menuID).delete()
        }
    }
    
    func removeRecipeFromMenu(recipe: Recipe, menu: Menu) {
//        if menu.recipes?.contains(recipe), let menuID = menu.id, let recipeID = recipe.id {
//            if let removedRef = recipeRef?.document(recipeID) {
//                menuRef?.document(menuID).updateData(["recipes": FieldValue.arrayRemove([removedRef])] )
//            }
//        }
    }
    
    func addRecipe(recipe: Recipe) {
//        let recipe = Recipe()
//        recipe.name = name
//        recipe.source = source
//        recipe.cookTime = cookTime
//        recipe.servingSize = servingSize
//        recipe.ingredientNamesList = ingredientsList
//        recipe.ingredientMeasurementsList = measurementList
//        recipe.instructionsList = instructionsList
//        recipe.notesList = notesList
//        recipe.tagsList = tagsList
//        recipe.menuList = menuList
        
        do {
            if let recipeRef = try recipeRef?.addDocument(from: recipe) {
                recipe.id = recipeRef.documentID
            }
        } catch {
            print("Failed to serialize recipe")
        }
    }
    
    func updateRecipe(recipe: Recipe) {
        if let recipeRef = recipeRef?.document(recipe.id!) {
            recipeRef.updateData(["name": recipe.name, "source": recipe.source, "cookTime": recipe.cookTime, "servingSize": recipe.servingSize, "ingredientNamesList": recipe.ingredientNamesList, "ingredientMeasurementsList": recipe.ingredientMeasurementsList, "instructionsList": recipe.instructionsList, "notesList": recipe.notesList, "tagsList": recipe.tagsList])
        }
    }
    
    func deleteRecipe(recipe: Recipe) {
        recipeRef?.document(recipe.id!).delete() { (error) in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed")
            }
        }
    }
    
    func addTag(name: String) {
        let tag = Tag()
        tag.name = name
        
        if let tagRef = tagRef?.addDocument(data: ["name": name]) {
            tag.id = tagRef.documentID
        }
    }
    
    func updateTag(tag: Tag) {
        if let tagRef = tagRef?.document(tag.id!) {
            tagRef.updateData(["name": tag.name])
        }
    }
    
    func deleteTag(tag: Tag) {
        tagRef?.document(tag.id!).delete() { (error) in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed")
            }
        }
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
        } else if listener.listenerType == ListenerType.tag || listener.listenerType == ListenerType.all {
            listener.onTagListChange(change: .update, tag: tagList)
        } else if listener.listenerType == ListenerType.menu || listener.listenerType == ListenerType.all {
            listener.onMenuChange(change: .update, menu: menuList)
        }
    }

    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
}
