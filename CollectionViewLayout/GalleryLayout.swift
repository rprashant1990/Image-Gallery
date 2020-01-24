//
//  AppDelegate.swift
//  GalleryLayout
//
//  Created by Prashant on 09/01/20.
//  Copyright © 2020 Prashant. All rights reserved.
//
import UIKit

class GalleryLayout: UICollectionViewLayout {
    
    var itemAttributes =  [UICollectionViewLayoutAttributes]()
    var images: [UIImage]
    private var contentSize: CGSize!
    
    init(images: [UIImage]) {
        self.images = images
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var contentBounds = CGRect.zero
    
    var contentInsets: UIEdgeInsets {
        return collectionView!.contentInset
    }
    
    override func prepare() {
        super.prepare()
        itemAttributes.removeAll()
        guard let collectionView = collectionView else { return }
        
        contentBounds = CGRect(origin: .zero, size: collectionView.bounds.size)

        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0

        let imageRows = calculateRowDimensions(images: images)
        var currentIndex = 0
        for imageRow in imageRows {
            for imageDimension in imageRow {
                let indexPath = IndexPath(item: currentIndex, section: 0)
                let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                currentIndex += 1
                attribute.frame = CGRect(x: xOffset, y: yOffset, width: imageDimension.width, height: imageDimension.height)
                itemAttributes.append(attribute)
                
                xOffset +=  imageDimension.width
            }
            yOffset +=  imageRow.last!.height
            xOffset = 0
        }
        contentSize = CGSize(width: collectionView.bounds.width, height: yOffset)
        
    }
    
    
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        return !newBounds.size.equalTo(collectionView.bounds.size)
    }
    
    /// - Tag: LayoutAttributesForItem
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemAttributes[indexPath.row]
    }
    
    /// - Tag: LayoutAttributesForElements
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        if self.itemAttributes.count > 0 {
            
            let filteredArray  =  self.itemAttributes.filter({ (object) -> Bool in
                return rect.intersects(object.frame)
            })
            
            attributes.append(contentsOf: filteredArray)
            
        }
        
        return attributes
    }
    
    func calculateRowDimensions(images:[UIImage]) -> [[ImageDimension]] {
        let maxHeight: CGFloat = 200
        let maxWidth = self.collectionView!.frame.width
        var rowWidth: CGFloat = 0
        var naiveLayoutRows : [[ImageDimension]] = []
        var currentNaiveRow: [ImageDimension] = []
        
        func resetCurrentRow() {
            currentNaiveRow.removeAll()
            rowWidth = 0
        }
        
        for (index, image) in images.enumerated() {
            let imageWidth = (image.size.width/image.size.height)*maxHeight
            rowWidth += imageWidth
            let currentImageLayout = ImageDimension(height: maxHeight, width: imageWidth)
            currentNaiveRow.append(currentImageLayout)
            if rowWidth >= maxWidth + maxWidth/4 {
                let newHeight = (maxWidth/(rowWidth-imageWidth))*maxHeight
                var newImageLayout: [ImageDimension] = []
                for (index,imageDimension) in currentNaiveRow.enumerated() {
                    if index == currentNaiveRow.count - 1 {
                        naiveLayoutRows.append(newImageLayout)
                        resetCurrentRow()
                        rowWidth += imageWidth
                        currentNaiveRow.append(currentImageLayout)
                    }
                    else {
                        let scaledImageDimension = getNewImageDimension(from: imageDimension, for: newHeight)
                        newImageLayout.append(scaledImageDimension)
                    }
                }
            }
            else if rowWidth > maxWidth {
                let newHeight = (maxWidth/rowWidth)*maxHeight
                var newImageLayout: [ImageDimension] = []
                for imageDimension in currentNaiveRow {
                   let scaledImageDimension = getNewImageDimension(from: imageDimension, for: newHeight)
                    newImageLayout.append(scaledImageDimension)
                }
                naiveLayoutRows.append(newImageLayout)
                resetCurrentRow()
            }
            else if rowWidth == maxWidth {
                naiveLayoutRows.append(currentNaiveRow)
                resetCurrentRow()
            }
            else {
                if index == images.count-1 {
                    naiveLayoutRows.append(currentNaiveRow)
                }
            }
        }
        return naiveLayoutRows
    }
    
    func getNewImageDimension(from imageDimension: ImageDimension, for newHeight: CGFloat) -> ImageDimension {
        let newImageWidth = (imageDimension.width/imageDimension.height)*newHeight
        return ImageDimension(height: newHeight, width: newImageWidth)
    }
    
    
}

struct ImageDimension {
    var height: CGFloat
    var width: CGFloat
    
    init(height: CGFloat, width: CGFloat) {
        self.height = height
        self.width = width
    }
}
