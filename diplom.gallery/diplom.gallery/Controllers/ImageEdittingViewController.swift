//
//  ImageEdittingViewController.swift
//  diplom.gallery
//
//  Created by Rodion Trach on 17.03.2023.
//

import UIKit

private extension UIImage {
    static let filledHeart = UIImage(systemName: "heart.fill")
    static let heart = UIImage(systemName: "heart")
}

protocol ImageEdittingViewControllerDelegate: AnyObject {
    func reloadCollectionView()
    func imageEdittingVCDidDeleteImage(at index: Int)
}

class ImageEdittingViewController: UIViewController {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    weak var delegate : ImageEdittingViewControllerDelegate?
    var isLiked: Bool?
    var image: UIImage?
    var comment: String?
    var imageName: String?
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addToVC()
    }
    
    private func addToVC() {
        self.registerForKeyboardNotification()
        self.addTapGestureRecognizer()
        self.loadPreviousData()
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        self.deletePhoto()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        self.updateData()
    }
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        self.likePhoto()
    }
    
    private func registerForKeyboardNotification(){
        NotificationCenter
            .default
            .addObserver(
                self,
                selector: #selector(keyboardChanged(_:)),
                name: UIResponder.keyboardWillShowNotification,
                object: nil)
        NotificationCenter
            .default
            .addObserver(
                self,
                selector: #selector(keyboardChanged(_:)),
                name: UIResponder.keyboardWillHideNotification,
                object: nil)
    }
    
    @objc func keyboardChanged(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
              let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            self.bottomConstraint.constant = 10
        } else {
            self.bottomConstraint.constant = frame.height * 0.6
        }
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func addTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func loadPreviousData() {
        self.imageView.image = self.image
        self.commentTextField.text = self.comment
        if self.isLiked == true {
            self.likeButton.setImage(.filledHeart, for: .normal)
        } else {
            self.likeButton.setImage(.heart, for: .normal)
        }
    }
    
    private func deletePhoto() {
        self.delegate?.imageEdittingVCDidDeleteImage(at: self.index ?? .zero)
        presentAlertWithTitle(
            title: "Success",
            message: "Photo has been deleted",
            options: "OK") { (option) in
                switch (option) {
                case "OK":
                    self.navigationController?.popViewController(animated: true)
                    break
                default:
                    break
                }
            }
    }
    
    private func updateData() {
        guard let imageName = self.imageName,
              let comment = self.commentTextField.text,
              let isLiked = self.isLiked else { return }
        StorageManager.shared.updateImage(
            imageName: imageName,
            comment: comment,
            isLiked: isLiked)
        delegate?.reloadCollectionView()
        presentAlertWithTitle(
            title: "Success",
            message: "Information has been updated",
            options: "OK") { (option) in
                switch (option) {
                case "OK":
                    break
                default:
                    break
                }
            }
    }
    
    private func likePhoto() {
        self.isLiked?.toggle()
        if isLiked == true {
            self.likeButton.setImage(.filledHeart, for: .normal)
        } else {
            self.likeButton.setImage(.heart, for: .normal)
        }
    }
    
}

extension ImageEdittingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.commentTextField.resignFirstResponder()
        return true
    }
}
