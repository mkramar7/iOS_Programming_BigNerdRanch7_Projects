//
//  Photo.swift
//  Photorama
//
//  Created by Marko Kramar on 03/06/2020.
//  Copyright © 2020 Marko Kramar. All rights reserved.
//

import Foundation

class Photo: Codable {
    let title: String
    let remoteURL: URL?
    let photoID: String
    let dateTaken: Date
    
    enum CodingKeys: String, CodingKey {
        case title
        case remoteURL = "url_z"
        case photoID = "id"
        case dateTaken = "datetaken"
    }
}
