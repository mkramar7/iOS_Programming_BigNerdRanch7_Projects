//
//  PhotoStore.swift
//  Photorama
//
//  Created by Marko Kramar on 29/05/2020.
//  Copyright © 2020 Marko Kramar. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum PhotoError: Error {
    case imageCreationError
    case missingImageURL
}

class PhotoStore {
    let imageStore = ImageStore()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Photorama")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error setting up Core data (\(error).")
            }
        }
        
        return container
    }()
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func fetchImage(for photo: Photo, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let photoKey = photo.photoID else {
            preconditionFailure("Photo expected to have a photoID.")
        }
        
        if let image = imageStore.image(forKey: photoKey) {
            OperationQueue.main.addOperation {
                completion(.success(image))
            }
            
            return
        }
        
        guard let photoURL = photo.remoteURL else {
            completion(.failure(PhotoError.missingImageURL))
            return
        }
        
        let request = URLRequest(url: photoURL)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            let result = self.processImageRequest(data: data, error: error)
            if case let .success(image) = result {
                self.imageStore.setImage(image, forKey: photoKey)
            }
            
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        
        task.resume()
    }
    
    private func processImageRequest(data: Data?, error: Error?) -> Result<UIImage, Error> {
        guard let imageData = data, let image = UIImage(data: imageData) else {
            // Couldn't create an image
            if data == nil {
                return .failure(error!)
            } else {
                return .failure(PhotoError.imageCreationError)
            }
        }
        
        return .success(image)
    }
    
    func fetchInterestingPhotos(completion: @escaping (Result<[Photo], Error>) -> Void) {
        let url = FlickrAPI.interestingPhotosURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) in
            self.processPhotosRequest(data: data, error: error) { result in
                OperationQueue.main.addOperation {
                    completion(result)
                }
            }
        }
        
        task.resume()
    }
    
    private func processPhotosRequest(data: Data?, error: Error?, completion: @escaping (Result<[Photo], Error>) -> Void) {
        guard let jsonData = data else {
            completion(.failure(error!))
            return
        }
        
        persistentContainer.performBackgroundTask { context in
            switch FlickrAPI.photos(fromJSON: jsonData) {
            case let .success(flickrPhotos):
                let photos = flickrPhotos.map { flickrPhoto -> Photo in
                    // Check for duplicates
                    let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
                    let predicate = NSPredicate(format: "\(#keyPath(Photo.photoID)) == \(flickrPhoto.photoID)")
                    fetchRequest.predicate = predicate
                    
                    var fetchedPhotos: [Photo]?
                    context.performAndWait {
                        fetchedPhotos = try? fetchRequest.execute()
                    }
                    
                    if let existingPhoto = fetchedPhotos?.first {
                        return existingPhoto
                    }
                    
                    var photo: Photo!
                    context.performAndWait {
                        photo = Photo(context: context)
                        photo.title = flickrPhoto.title
                        photo.photoID = flickrPhoto.photoID
                        photo.remoteURL = flickrPhoto.remoteURL
                        photo.dateTaken = flickrPhoto.dateTaken
                    }
                    
                    return photo
                }
                
                do {
                    try context.save()
                } catch {
                    print("Error saving to Core Data: \(error)")
                    completion(.failure(error))
                    return
                }
                
                let photoIDs = photos.map { $0.objectID }
                let viewContext = self.persistentContainer.viewContext
                let viewContextPhotos = photoIDs.map { viewContext.object(with: $0) } as! [Photo]
                completion(.success(viewContextPhotos))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchAllPhotos(completion: @escaping (Result<[Photo], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let sortByDateTaken = NSSortDescriptor(key: #keyPath(Photo.dateTaken), ascending: true)
        fetchRequest.sortDescriptors = [sortByDateTaken]
        
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            do {
                let allPhotos = try viewContext.fetch(fetchRequest)
                completion(.success(allPhotos))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    //
    // Bronze challenge for chapter 22
    //
    func updateViewCount(photo: Photo) {
        photo.viewCount += 1
        persistentContainer.viewContext.performAndWait {
            do {
                try self.persistentContainer.viewContext.save()
            } catch {
                print("Error while trying to update view count for photo: \(error)")
            }
        }
    }
    //
    // End of bronze challenge for chapter 22
    //
    
    func fetchAllTags(completion: @escaping (Result<[Tag], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
        let sortByName = NSSortDescriptor(key: #keyPath(Tag.name), ascending: true)
        fetchRequest.sortDescriptors = [sortByName]
        
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            do {
                let allTags = try fetchRequest.execute()
                completion(.success(allTags))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    //
    // Silver challenge for chapter 23
    //
    func markOrUnmarkPhotoAsFavorite(photo: Photo, shouldSetAsFavorite: Bool) {
        photo.favorite = shouldSetAsFavorite
        persistentContainer.viewContext.performAndWait {
            do {
                try self.persistentContainer.viewContext.save()
            } catch {
                print("Error while trying to \(shouldSetAsFavorite ? "mark" : "unmark") photo as favorite: \(error)")
            }
        }
    }
    //
    // End of silver challenge for chapter 23
    //
}
