//
//  ImageAddingViewController.swift
//  diplom.gallery
//
//  Created by Rodion Trach on 17.03.2023.
//

import UIKit

private extension UIImage {
    static let filledHeart = UIImage(systemName: "heart.fill")
    static let heart = UIImage(systemName: "heart")
}

protocol ImageAddingViewControllerDelegate: AnyObject {
    func reloadCollectionView()
}

class ImageAddingViewController: UIViewController {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    weak var delegate: ImageAddingViewControllerDelegate?
    var imagesArray: [Image]? = User.shared.pictures
    let plusImage = UIImage(systemName: "plus")
    var isLiked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addToVC()
    }
    
    private func addToVC() {
        self.addTapGestureRecognizer()
        self.registerForKeyboardNotification()
        self.imageView.image = self.plusImage
        self.loadPreviousImages()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        self.saveImage()
    }
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        self.toLikePhoto()
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
            self.bottomConstraint.constant = 200
        } else {
            self.bottomConstraint.constant = frame.height + 15
        }
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func addTapGestureRecognizer() {
        let imageRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(imageTapDetected(_:)))
        self.imageView.addGestureRecognizer(imageRecognizer)
        
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        view.addGestureRecognizer(tap)
    }
    
    @objc private func imageTapDetected(_  recognizer: UITapGestureRecognizer) {
        self.pickImage()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func pickImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true)
        }
    }
    
    private func loadPreviousImages() {
        if StorageManager.shared.getImages()?.isEmpty == false {
            self.imagesArray = StorageManager.shared.getImages()
        } else {
            self.imagesArray = []
        }
    }
    
    private func addNewImage(){
        guard let image = self.imageView.image,
              let imageName = StorageManager.shared.saveImage(image) else {return}
        let current = Image(
            imageName: imageName,
            comment: self.commentTextField.text,
            isLiked: self.isLiked)
        self.imagesArray?.append(current)
        StorageManager.shared.saveImages(photo: self.imagesArray ?? [])
        self.delegate?.reloadCollectionView()
    }
    
    private func saveImage(){
        if self.imageView.image == self.plusImage {
            presentAlertWithTitle(
                title: "010Error101",
                message: "Please, choose a photo",
                options: "OK") { (option) in
                    switch(option) {
                    case "OK":
                        break
                    default:
                        break
                    }
                }
        } else {
            addNewImage()
            presentAlertWithTitle(
                title: "Success",
                message: "Photo is uploaded",
                options: "OK") { (option) in
                    switch(option) {
                    case "OK":
                        self.navigationController?.popViewController(animated: true)
                        break
                    default:
                        break
                    }
                }
        }
    }
    
    func toLikePhoto() {
        self.isLiked.toggle()
        if isLiked {
            self.likeButton.setImage(.filledHeart, for: .normal)
        } else {
            self.likeButton.setImage(.heart, for: .normal)
        }
    }
    
}

extension ImageAddingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.commentTextField.resignFirstResponder()
        return true
    }
}

extension ImageAddingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            self.imageView.image = pickedImage
        }
        picker.dismiss(animated: true)
    }
}
