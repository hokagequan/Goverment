//
//  CollectionViewCell.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/12.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

@objc protocol CollectionViewCellDelegate {
    
    @objc optional
    func didClickAdd(_ cell: CollectionViewCell)
    func didClickImage(_ cell: CollectionViewCell, image: UIImage)
    func didSelectIndex(_ cell: CollectionViewCell, index: Int)
    func didLongPressIndex(_ cell: CollectionViewCell, index: Int)
    
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addImages(_ imageNames: Array<String>) {
        if imageNames.count == 0 {
            return
        }
        
        let range = NSMakeRange(images.count, imageNames.count)
        images += imageNames
        
        let index = IndexSet(integersIn: range.toRange() ?? 0..<0)
        var indexPaths = [IndexPath]()
        
        for theIndex in index {
            let indexPath = IndexPath(row: theIndex + 1, section: 0)
            indexPaths.append(indexPath)
        }
        
        collectionView.insertItems(at: indexPaths)
    }
    
    func deleteCollectionCell(_ index: Int) {
        if index >= images.count {
            return
        }
        
        let indexPath = IndexPath(row: index + 1, section: 0)
        images.remove(at: index)
        
        collectionView.deleteItems(at: [indexPath])
    }
    
    func loadImages(_ sourceImages: Array<String>) {
        images = sourceImages
        collectionView.reloadData()
    }
    
    func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state != UIGestureRecognizerState.began {
            return
        }
        
        let point = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: point) else {
            return
        }
        
        if (indexPath as NSIndexPath).row == 0 {
            return
        }
        
        delegate?.didLongPressIndex(self, index: (indexPath as NSIndexPath).row - 1)
    }
    
    // MARK: - UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimpleImageCell", for: indexPath) as! SimpleImageCell
        
        if (indexPath as NSIndexPath).row == 0 {
            cell.iconImageView.image = UIImage(named: "add_white")
        }
        else {
            let photoName = images[(indexPath as NSIndexPath).row - 1]
            let stringURL = "\(imageDownloadURL)\(photoName)"
            cell.iconImageView.loadImageURL(stringURL, name: photoName, placeholder: UIImageView.pathForTempImage() + "/\(photoName)")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).row == 0 {
            delegate?.didClickAdd?(self)
            
            return
        }
        
        delegate?.didSelectIndex(self, index: (indexPath as NSIndexPath).row - 1)
        
        let cell = collectionView.cellForItem(at: indexPath) as! SimpleImageCell
        
        guard let image = cell.iconImageView.image else {
            return
        }
        
        delegate?.didClickImage(self, image: image)
    }

}
