//
//  User.swift
//  diplom.gallery
//
//  Created by Rodion Trach on 16.03.2023.
//

import Foundation

final class User: Codable {
    
    static let shared = User(username: "", password: "")
    let username: String?
    let password: String?
    var pictures: [Image]?
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
        pictures = []
    }
}
