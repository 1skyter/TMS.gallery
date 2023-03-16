//
//  Image.swift
//  diplom.gallery
//
//  Created by Rodion Trach on 16.03.2023.
//

import Foundation

final class Image: Codable {
    
    let imageName: String
    var comment: String?
    var isLiked = false
    
    init(imageName: String, comment: String?, isLiked: Bool) {
        self.imageName = imageName
        self.comment = comment
        self.isLiked = isLiked
    }
}

