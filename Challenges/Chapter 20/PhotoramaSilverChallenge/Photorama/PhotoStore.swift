//
//  PhotoStore.swift
//  Photorama
//
//  Created by Marko Kramar on 29/05/2020.
//  Copyright © 2020 Marko Kramar. All rights reserved.
//

import Foundation
import UIKit

enum PhotoError: Error {
    case imageCreationError
    case missingImageURL
}

class PhotoStore {
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func fetchInterestingPhotos(completion: @escaping (Result<[Photo], Error>) -> Void) {
        fetchPhotos(FlickrAPI.interestingPhotosURL, completion: completion)
    }
    
    func fetchRecentPhotos(completion: @escaping (Result<[Photo], Error>) -> Void) {
        fetchPhotos(FlickrAPI.recentPhotosURL, completion: completion)
    }
    
    private func fetchPhotos(_ url: URL, completion: @escaping (Result<[Photo], Error>) -> Void) {
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) in
            self.printResponseInformation(response)
            let result = self.processPhotosRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        
        task.resume()
    }
    
    func fetchImage(for photo: Photo, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let photoURL = photo.remoteURL else {
            completion(.failure(PhotoError.missingImageURL))
            return
        }
        
        let request = URLRequest(url: photoURL)
        let task = session.dataTask(with: request) { (data, response, error) in
            self.printResponseInformation(response)
            let result = self.processImageRequest(data: data, error: error)
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
    
    private func processPhotosRequest(data: Data?, error: Error?) -> Result<[Photo], Error> {
        guard let jsonData = data else {
            return .failure(error!)
        }
        
        return FlickrAPI.photos(fromJSON: jsonData)
    }
    
    private func printResponseInformation(_ response: URLResponse?) {
        if let httpResponse = response as? HTTPURLResponse {
            print("Status code: \(httpResponse.statusCode)")
            print("All header fields: \(httpResponse.allHeaderFields)")
        }
    }
    
}
