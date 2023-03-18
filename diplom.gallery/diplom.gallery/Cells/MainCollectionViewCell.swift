//
//  MainCollectionViewCell.swift
//  diplom.gallery
//
//  Created by Rodion Trach on 16.03.2023.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    static let identifier = "MainCollectionViewCell"
    
    func configure(image: UIImage?) {
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.image = image
    }
    
}
