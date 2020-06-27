//
//  EditImageViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 26/6/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit
import FirebaseStorage

class EditImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    
    var recipe: Recipe?
    
    var storageReference = Storage.storage()
    
    // Initialise the indicator for the loading
    var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uploadButton.layer.cornerRadius = 23
        uploadButton.layer.borderWidth = 1
        uploadButton.layer.borderColor = UIColor.white.cgColor
        
        // Create a loading animation
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = self.image.center
        self.view.addSubview(indicator)
        
        if let imageRef = recipe?.imageReference {
            indicator.startAnimating()
            indicator.backgroundColor = UIColor.clear
            
            if imageRef.hasPrefix("gs://") {
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
                let url = URL(string: imageRef)
                let data = try? Data(contentsOf: url!)
                self.image.image = UIImage(data: data!)
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
            }
        }
    }
    
    @IBAction func uploadButton(_ sender: Any) {
        let controller = UIImagePickerController()
        controller.allowsEditing = false
        controller.delegate = self
        
        let actionSheet = UIAlertController(title: nil, message: "Select Option:", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
            controller.sourceType = .camera
            self.present(controller, animated: true, completion: nil)
        }
        
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { action in
            controller.sourceType = .photoLibrary
            self.present(controller, animated: true, completion: nil)
        }
        
        let albumAction = UIAlertAction(title: "Photo Album", style: .default) { action in
            controller.sourceType = .savedPhotosAlbum
            self.present(controller, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(cameraAction)
            
        }
        actionSheet.addAction(libraryAction)
        actionSheet.addAction(albumAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        guard let image = image.image else {
            displayMessage("Cannot save until a photo has been uploaded!", "Error")
            return
        }
        
        let date = UInt(Date().timeIntervalSince1970)
        let filename = "\(date).jpg"
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            displayMessage("Image data could not be compressed.", "Error")
            return
        }
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        
        do {
            try data.write(to: fileURL)
            
            let storageRef = storageReference.reference()
            let imageRef = storageRef.child("test.jpg")
            
            
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
                        //self.recipe!.imageReference = "\(downloadURL)"
                        //print(self.recipe!.imageReference)
                        //let userImageRef = self.usersReference.document("\(userID)")
                        //userImageRef.collection("images").document("\(date)").setData(["url": "\(downloadURL)"])
                        //self.displayMessage("Image uploaded to Firebase", "Success")
                    }
                }
            }
            
            //self.navigationController?.popViewController(animated: true)
        } catch {
            displayMessage(error.localizedDescription, "Error")
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
    
    func displayMessage(_ message: String,_ title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
