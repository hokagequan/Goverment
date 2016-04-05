//
//  CollectionViewCell.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/12.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

@objc protocol CollectionViewCellDelegate {
    
    optional
    func didClickAdd(cell: CollectionViewCell)
    func didClickImage(cell: CollectionViewCell, image: UIImage)
    func didSelectIndex(cell: CollectionViewCell, index: Int)
    func didLongPressIndex(cell: CollectionViewCell, index: Int)
    
}

class CollectionViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var images = [String]()
    
    weak var delegate: CollectionViewCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(_:)))
        longPress.delaysTouchesBegan = true
        longPress.delegate = self
        collectionView.addGestureRecognizer(longPress)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addImages(imageNames: Array<String>) {
        if imageNames.count == 0 {
            return
        }
        
        let range = NSMakeRange(images.count, imageNames.count)
        images += imageNames
        
        let index = NSIndexSet(indexesInRange: range)
        var indexPaths = [NSIndexPath]()
        
        index.enumerateIndexesUsingBlock { (index, stop) -> Void in
            let indexPath = NSIndexPath(forRow: index + 1, inSection: 0)
            indexPaths.append(indexPath)
        }
        
        collectionView.insertItemsAtIndexPaths(indexPaths)
    }
    
    func deleteCollectionCell(index: Int) {
        if index >= images.count {
            return
        }
        
        let indexPath = NSIndexPath(forRow: index + 1, inSection: 0)
        images.removeAtIndex(index)
        
        collectionView.deleteItemsAtIndexPaths([indexPath])
    }
    
    func loadImages(sourceImages: Array<String>) {
        images = sourceImages
        collectionView.reloadData()
    }
    
    func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state != UIGestureRecognizerState.Began {
            return
        }
        
        let point = gesture.locationInView(collectionView)
        guard let indexPath = collectionView.indexPathForItemAtPoint(point) else {
            return
        }
        
        if indexPath.row == 0 {
            return
        }
        
        delegate?.didLongPressIndex(self, index: indexPath.row - 1)
    }
    
    // MARK: - UICollectionView
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SimpleImageCell", forIndexPath: indexPath) as! SimpleImageCell
        
        if indexPath.row == 0 {
            cell.iconImageView.image = UIImage(named: "add_white")
        }
        else {
            let photoName = images[indexPath.row - 1]
            let stringURL = "\(imageDownloadURL)\(photoName)"
            cell.iconImageView.loadImageURL(stringURL, name: photoName, placeholder: UIImageView.pathForTempImage().stringByAppendingString("/\(photoName)"))
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            delegate?.didClickAdd?(self)
            
            return
        }
        
        delegate?.didSelectIndex(self, index: indexPath.row - 1)
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! SimpleImageCell
        delegate?.didClickImage(self, image: cell.iconImageView.image!)
    }

}
