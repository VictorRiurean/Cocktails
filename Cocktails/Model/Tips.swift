//
//  Tips.swift
//  Cocktails
//
//  Created by Victor on 11/06/2021.
//

import UIKit

class Tips {
    let image: UIImage?
    let shortDescription: String
    let longDescription: String
    
    init(image: UIImage, shortDescription: String, longDescription: String) {
        self.image = image
        self.shortDescription = shortDescription
        self.longDescription = longDescription
    }
}
