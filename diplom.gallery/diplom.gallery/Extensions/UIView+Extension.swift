//
//  UIView+Extension.swift
//  diplom.gallery
//
//  Created by Rodion Trach on 16.03.2023.
//

import Foundation
import UIKit

extension UIView {
    
    func buttonSettings(
        radius: CGFloat = 12,
        backgroundColor: UIColor = .lightGray,
        borderWidth: CGFloat = 0.5) {
        self.layer.cornerRadius = radius
        self.layer.borderWidth = borderWidth
        self.backgroundColor = backgroundColor
    }
    
    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = Float(0.5)
        self.layer.shadowOffset = CGSize(width: 5.0,
                                         height: 8.0)
        self.layer.shadowRadius = 12
        self.layer.shadowPath = UIBezierPath(
            roundedRect: self.bounds,
            cornerRadius: self.layer.cornerRadius
        ).cgPath
    }
    
    func textFieldParameters(
        cornerRadius: CGFloat = 10,
        borderColor: CGColor = UIColor.black.cgColor,
        backgroundColor: UIColor = .systemGray.withAlphaComponent(0.2)) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = borderColor
        self.backgroundColor = backgroundColor
    }
    
}
