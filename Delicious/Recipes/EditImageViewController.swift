//
//  EditImageViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 26/6/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit
import FirebaseStorage

// Edit image common class
class EditImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DatabaseListener {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    
    // Optional data to pass
    var recipe: Recipe?
    var menu: Menu?
    var type = String()
    
    // Reference to storage
    var storageReference = Storage.storage()
    
    // Initialise the indicator for the loading
    var indicator = UIActivityIndicatorView()
    
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .recipe
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        // Button style
        uploadButton.layer.cornerRadius = 23
        uploadButton.layer.borderWidth = 1
        uploadButton.layer.borderColor = UIColor.white.cgColor
        
        // Create a loading animation
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        
        // Load image, passing the image reference
        if let imageRef = recipe?.imageReference {
            loadImage(imageRef)
        } else if let imageRef = menu?.imageReference {
            loadImage(imageRef)
        }
    }
    
    // Load image function
    func loadImage(_ imageRef: String) {
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.clear
        
        // Check what the prefix is for the image reference
        if imageRef.hasPrefix("gs://") || imageRef.hasPrefix("https://firebasestorage") {
            // Get the image from cloud storage
            let ref = self.storageReference.reference(forURL: imageRef)
            let _ = ref.getData(maxSize: 5 * 1024 * 1024) { data, error in
                do {
                    if let error = error {
                        print(error)
                    } else {
                        let image = UIImage(data: data!)
                        self.image.image = image
                        self.indicator.stopAnimating()
                        self.indicator.hidesWhenStopped = true
                    }
                }
            }
        } else if imageRef.hasPrefix("https://") {
            // Download the image
            let url = URL(string: imageRef)
            let data = try? Data(contentsOf: url!)
            self.image.image = UIImage(data: data!)
            self.indicator.stopAnimating()
            self.indicator.hidesWhenStopped = true
        }
    }
    
    // On upload
    @IBAction func uploadButton(_ sender: Any) {
        // Initialise the image picker controller
        let controller = UIImagePickerController()
        controller.allowsEditing = false
        controller.delegate = self
        
        // Create an action sheet
        let actionSheet = UIAlertController(title: nil, message: "Select Option:", preferredStyle: .actionSheet)
        
        // Present the camera
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
            controller.sourceType = .camera
            self.present(controller, animated: true, completion: nil)
        }
        
        // Present photo library
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { action in
            controller.sourceType = .photoLibrary
            self.present(controller, animated: true, completion: nil)
        }
        
        // Present photo album
        let albumAction = UIAlertAction(title: "Photo Album", style: .default) { action in
            controller.sourceType = .savedPhotosAlbum
            self.present(controller, animated: true, completion: nil)
        }
        
        // Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Check if camera is available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(cameraAction)
            
        }
        
        // Add the actions to the action sheet
        actionSheet.addAction(libraryAction)
        actionSheet.addAction(albumAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    // On save
    @IBAction func save(_ sender: Any) {
        // Ensure there is an image uploaded
        guard let image = image.image else {
            displayMessage("Cannot save until a photo has been uploaded!", "Error")
            return
        }
        
        // Get image data that was uploaded
        let date = UInt(Date().timeIntervalSince1970)
        let filename = "\(date).jpg"
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            displayMessage("Image data could not be compressed.", "Error")
            return
        }
        
        // Save data to file manager locally
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        
        do {
            self.indicator.startAnimating()
            self.indicator.backgroundColor = UIColor.clear
            
            // Attempt to write the image to the file manager
            try data.write(to: fileURL)
            
            // Storage reference
            let storageRef = storageReference.reference()
            
            if type == "recipe" {
                // Store the image with the recipe's id
                let imageRef = storageRef.child("\(self.recipe!.id!).jpg")
                uploadImage(imageRef: imageRef, data: data)
            } else {
                // Store the image with the menu's id
                let imageRef = storageRef.child("\(self.menu!.id!).jpg")
                uploadImage(imageRef: imageRef, data: data)
            }
        } catch {
            displayMessage(error.localizedDescription, "Error")
        }
    }
    
    // Upload image function
    func uploadImage(imageRef: StorageReference, data: Data) {
        // Metadata of the image
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        imageRef.putData(data, metadata: metadata) { (meta, error) in
            if error != nil {
                self.displayMessage("Could not upload image to firebase", "Error")
            } else {
                imageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        print("Download URL not found")
                        return
                    }
                    // Add downloaded image to database
                    if self.type == "recipe" {
                        let _ = self.databaseController?.addImageToRecipe(recipe: self.recipe!, image: "\(downloadURL)")
                    } else {
                        let _ = self.databaseController?.addImageToMenu(menu: self.menu!, image: "\(downloadURL)")
                    }
                    self.indicator.stopAnimating()
                    self.indicator.hidesWhenStopped = true
                    self.displayMessage("Image uploaded", "Success")
                }
            }
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            image.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Display alert message function
    func displayMessage(_ message: String,_ title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func onRecipeListChange(change: DatabaseChange, recipe: [Recipe]) {
        //
    }
    
    func onMenuChange(change: DatabaseChange, menu: [Menu]) {
        //
    }
    
    func onTagListChange(change: DatabaseChange, tag: [Tag]) {
        //
    }
    
    func onBookmarksListChange(change: DatabaseChange, bookmarks: [Bookmarks]) {
        //
    }
    
    func onShoppingListChange(change: DatabaseChange, shoppingList: [ShoppingList]) {
        //
    }
    
    func onWishlistChange(change: DatabaseChange, wishlist: [Wishlist]) {
        //
    }
}
