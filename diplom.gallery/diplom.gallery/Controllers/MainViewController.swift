//
//  MainViewController.swift
//  diplom.gallery
//
//  Created by Rodion Trach on 16.03.2023.
//

import UIKit

private extension CGFloat {
    static let space = 5.0
    static let cornerRadius = 20.0
}

private extension Int {
    static let horisontalCount = 3
}

class MainViewController: UIViewController, ImageAddingViewControllerDelegate, ImageEdittingViewControllerDelegate {
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var greetingsLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    var username: String?
    let storageManager = StorageManager.shared
    let collectionViewBackground = UIImageView(image: UIImage(named: "matrix_background"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modifyCollectionView()
        self.loadUsername()
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        self.goToImageAddingVC()
    }
    
    private func goToImageAddingVC() {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "ImageAddingViewController") as? ImageAddingViewController else { return }
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func goToImageEdittingVC(
        image: UIImage?,
        comment: String?,
        isLiked: Bool?,
        imageName: String?,
        index: Int) {
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "ImageEdittingViewController")
                    as? ImageEdittingViewController else { return }
            controller.delegate = self
            controller.image = image
            controller.comment = comment
            controller.isLiked = isLiked
            controller.imageName = imageName
            controller.index = index
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
    
    func reloadCollectionView() {
        self.imagesCollectionView.reloadData()
    }
    
    private func modifyCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = .space / 2
        layout.minimumInteritemSpacing = .zero
        let count = CGFloat(Int.horisontalCount)
        let width = self.imagesCollectionView.frame.size.width
        let side = (width / count) - .space
        layout.itemSize = CGSize(
            width: side,
            height: side)
        self.imagesCollectionView.layer.cornerRadius = .cornerRadius
        self.imagesCollectionView.setCollectionViewLayout(layout, animated: true)
        self.imagesCollectionView.contentInset = UIEdgeInsets(
            top: .zero,
            left: .space,
            bottom: .space,
            right: .space)
        self.imagesCollectionView.isOpaque = false
        self.imagesCollectionView.backgroundColor = .black
        self.imagesCollectionView.backgroundView = self.collectionViewBackground
    }
    
    private func loadUsername() {
        if let unwrappedUsername = self.username {
            self.greetingsLabel.text = "Welcome, \(unwrappedUsername)"
        } else {
            self.greetingsLabel.text = "Welcome 0101001010101100100"
        }
    }
    
    func imageEdittingVCDidDeleteImage(at index: Int) {
        var images = self.storageManager.getImages() ?? []
        guard index < images.count else { return }
        let imageNameToDelete = images[index].imageName
        images.remove(at: index)
        self.storageManager.saveImages(photo: images)
        self.imagesCollectionView.reloadData()
    }
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            let allData = self.storageManager.getImages()
            let cellCount = allData?.count
            return cellCount ?? .zero
        }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView
                .dequeueReusableCell(
                    withReuseIdentifier: MainCollectionViewCell.identifier,
                    for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
            
            guard let images = self.storageManager.getImages(),
                  indexPath.item < images.count else { return UICollectionViewCell() }
            let image = self.storageManager.loadImage(fileName: images[indexPath.item].imageName)
            cell.configure(image: image)
            return cell
        }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath) {
            guard let images = self.storageManager.getImages(),
                  indexPath.item < images.count else { return }
            
            let image = self.storageManager.loadImage(fileName: images[indexPath.item].imageName)
            let imageName = images[indexPath.item].imageName
            let savedData = self.storageManager.getImages()
            let comment = savedData?[indexPath.item].comment
            let isLiked = savedData?[indexPath.item].isLiked
            let index = indexPath.item
            self.goToImageEdittingVC(
                image: image,
                comment: comment,
                isLiked: isLiked,
                imageName: imageName,
                index: index)
        }
}
