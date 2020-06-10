//
//  UIImage+Mandala.swift
//  Mandala
//
//  Created by Marko Kramar on 20/05/2020.
//  Copyright © 2020 Marko Kramar. All rights reserved.
//

import UIKit

enum ImageResource: String {
    case angry
    case confused
    case crying
    case goofy
    case happy
    case meh
    case sad
    case sleepy
}

extension UIImage {
    convenience init(resource: ImageResource) {
        self.init(named: resource.rawValue)!
    }
}
