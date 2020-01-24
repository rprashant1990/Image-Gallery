//
//  CustomCollectionViewCell.swift
//  CollectionViewLayout
//
//  Created by Prashant on 22/01/20.
//  Copyright © 2020 Prashant. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    static let identifer = "collectionViewCellIdentifier"
    
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.autoresizesSubviews = true
        
        imageView.frame = self.bounds
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(imageView)
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
