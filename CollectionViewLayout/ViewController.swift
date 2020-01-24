//
//  ViewController.swift
//  CollectionViewLayout
//
//  Created by Prashant on 22/01/20.
//  Copyright © 2020 Prashant. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    
    let images = [UIImage(named: "1")!, UIImage(named: "3")!, UIImage(named: "2")!,  UIImage(named: "4")!, UIImage(named: "5")!, UIImage(named: "6")!, UIImage(named: "9")!, UIImage(named: "7")!, UIImage(named: "8")!, UIImage(named: "10")! ,UIImage(named: "11")! ,UIImage(named: "12")!, UIImage(named: "13")!]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let colletionViewLayout = GalleryLayout(images: images)
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: colletionViewLayout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.alwaysBounceVertical = true
        collectionView.indicatorStyle = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifer)
        
        self.view.addSubview(collectionView)

    }


    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Always show 50K cells so scrolling performance can be tested.
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifer, for: indexPath) as? CustomCollectionViewCell
            else { preconditionFailure("Failed to load collection view cell") }

        cell.imageView.image = images[indexPath.row]
        return cell
    }

}


