//
//  PHLimitAccessViewController.swift
//  Swift-Photo
//
//  Created by k2hoon on 2023/07/08.
//

import Foundation

import UIKit
import SwiftUI
import Photos

class PHLimitAccessViewController: UIViewController {
    private var accessImages = [UIImage]()
    
    private let compositionalLayout: UICollectionViewCompositionalLayout = {
        let itemFractionalWidthFraction = 1.0 / 3.0
        let groupFractionalHeightFraction = 1.0 / 4.0
        let itemInset: CGFloat = 2.5
        
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(itemFractionalWidthFraction),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
        
        // Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(groupFractionalHeightFraction)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
        
        return UICollectionViewCompositionalLayout(section: section)
        
    }()
    
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = true
        //        collection.clipsToBounds = true
        view.contentInset = .zero
        view.delegate = self
        view.dataSource = self
        
        // Register cell classe
        view.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        return view
        
    }()
    
    
    private lazy var addButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.titlePadding  = 8
        let button = UIButton(configuration: configuration)
        
        // Set the background color of the button.
        button.backgroundColor = .white
        
        // Round the button frame.
        button.layer.masksToBounds = true
        
        // Set the radius of the corner.
        button.layer.cornerRadius = 8
        
        // Set the title (normal).
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        
        // Set the title (highlighted).
        button.setTitle("Add", for: .highlighted)
        button.setTitleColor(.black, for: .highlighted)
        
        // Add an event
        button.addTarget(self, action: #selector(onClickAddButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var headView: UIView = {
        let headView = UIView()
        headView.backgroundColor = .gray
        
        return headView
    }()
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PHPhotoLibrary.shared().register(self)
        
        let headView = UIView()
        
        self.view.addSubview(headView)
        self.view.addSubview(collectionView)
        
        headView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headView.topAnchor.constraint(equalTo: view.topAnchor),
            headView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            headView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            headView.heightAnchor.constraint(equalToConstant: 56),
        ])
        
        headView.addSubview(addButton)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            addButton.centerYAnchor.constraint(equalTo: headView.centerYAnchor),
            addButton.rightAnchor.constraint(equalTo: headView.safeAreaLayoutGuide.rightAnchor, constant: -16),
        ])

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: headView.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        self.getAccessPhoto()
    }
    
    @objc private func onClickAddButton(_ sender: Any) {
        PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self)
    }
    
    func getAccessPhoto() {
        self.accessImages.removeAll()
        
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        let fetchOptions = PHFetchOptions()
        let fetch = PHAsset.fetchAssets(with: fetchOptions)
        fetch.enumerateObjects { asset, _, _ in
            PHImageManager().requestImage(for: asset, targetSize: .init(width: 100, height: 100), contentMode: .aspectFill, options: options) { (image, info) in
                guard let image = image else {
                    return
                }
                self.accessImages.append(image)
            }
        }
    }
}

extension PHLimitAccessViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.accessImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
        cell.setImage(image: self.accessImages[indexPath.item])
        return cell
    }
}

extension PHLimitAccessViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async {
            self.getAccessPhoto()
            self.collectionView.reloadData()
        }
    }
}


struct PHLimitAccessViewController_Previews: PreviewProvider {
    static var previews: some View {
        PHLimitAccessViewController().toPreview()
    }
}

