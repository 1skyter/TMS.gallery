//
//  StorageManager.swift
//  diplom.gallery
//
//  Created by Rodion Trach on 16.03.2023.
//

import Foundation
import UIKit

private extension String {
    static let usernameKey = "usernameKey"
}

class StorageManager {
    static let shared = StorageManager()
    private let userDefault = UserDefaults.standard
    private var loggedInUser = ""
    
    private init() {}
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func saveImage(_ image: UIImage) -> String? {
        guard let directory = FileManager
            .default
            .urls(
                for: .documentDirectory,
                in: .userDomainMask
            )
                .first else {return nil}
        let fileName = UUID().uuidString
        let fileURL = directory.appendingPathComponent(fileName)
        
        guard let data = image.jpegData(compressionQuality: 1.0) else { return nil }
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch let error {
                print(error)
                return nil
            }
        }
        do {
            try data.write(to: fileURL)
            return fileName
        } catch let error {
            print(error)
            return nil
        }
    }
    
    func loadImage(fileName: String) -> UIImage? {
        guard let directory = FileManager
            .default
            .urls(
                for: .documentDirectory,
                in: .userDomainMask
            )
                .first else {return nil}
        let fileURL = directory.appendingPathComponent(fileName)
        let image = UIImage(contentsOfFile: fileURL.path)
        return image
    }
    
    func saveImages(photo: [Image]) {
        userDefault.set(encodable: photo, forKey: self.loggedInUser)
    }
    
    func getImages() -> [Image]? {
        let image = userDefault.value([Image].self, forKey: self.loggedInUser)
        return image
    }
    
    func updateImage(
        imageName: String,
        comment: String,
        isLiked: Bool) {
        var images = getImages() ?? []
        
        if let index = images.firstIndex(where: { $0.imageName == imageName }) {
            images[index].comment = comment
            images[index].isLiked = isLiked
        }
        userDefault.set(encodable: images, forKey: self.loggedInUser)
    }
    
    func signUp(username: String, password: String) {
        if username.isEmpty || password.isEmpty {
            self.showAlert(title: "Error", message: "Username or password cannot be empty")
            return
        }
        var existingUsers: [User] = userDefault.value([User].self, forKey: .usernameKey) ?? []
        if existingUsers.contains(where: { $0.username == username }) {
            self.showAlert(title: "Error", message: "User with this username already exists")
            return
        }
        let newUser = User(username: username, password: password)
        existingUsers.append(newUser)
        userDefault.set(encodable: existingUsers, forKey: .usernameKey)
        self.showAlert(title: "Success", message: "User has been registered")
    }

    func signIn(username: String, password: String) -> Bool {
        if let savedUsers = userDefault.value([User].self, forKey: .usernameKey){
            if savedUsers.first(where: {$0.username == username && $0.password == password }) != nil {
                loggedInUser = username
                return true
            } else {
                self.showAlert(title: "Error", message: "Incorrect username or password")
            }
        } else {
            self.showAlert(title: "Error", message: "User not found")
        }
        return false
    }
    
}
