//
//  PhotoInfoViewController.swift
//  Photorama
//
//  Created by Marko Kramar on 07/06/2020.
//  Copyright © 2020 Marko Kramar. All rights reserved.
//

import UIKit

class PhotoInfoViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var viewCountLabel: UILabel!
    @IBOutlet var favoriteButton: UIBarButtonItem!
    
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        // Bronze challenge for chapter 22
        //
        // Update view count for photo
        store.updateViewCount(photo: photo)
        //
        // End of bronze challenge for chapter 22
        //
        
        store.fetchImage(for: photo) { (result) -> Void in
            switch result {
            case let .success(image):
                self.imageView.image = image
                self.viewCountLabel.text = "\(self.photo.viewCount) times viewed"
                self.updateFavoriteButton()
            case let .failure(error):
                print("Error fetching image for photo: \(error)")
            }
        }
        
        imageView.accessibilityLabel = photo.title
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showTags":
            let navController = segue.destination as! UINavigationController
            let tagController = navController.topViewController as! TagsViewController
            
            tagController.store = store
            tagController.photo = photo
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
    //
    // Silver challenge for chapter 23
    //
    func updateFavoriteButton() {
        self.favoriteButton.image = UIImage(systemName: self.photo.favorite ? "star.fill" : "star")
    }
    
    @IBAction func markOrUnmarkAsFavorite(_ sender: UIBarButtonItem) {
        store.markOrUnmarkPhotoAsFavorite(photo: photo, shouldSetAsFavorite: !photo.favorite)
        updateFavoriteButton()
    }
    //
    // End of silver challenge for chapter 23
    //
    
}
