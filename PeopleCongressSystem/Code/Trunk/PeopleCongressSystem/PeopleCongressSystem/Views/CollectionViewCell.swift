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
    func didSelectIndex(cell: CollectionViewCell, index: Int)
    
}

class CollectionViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var images = [String]()
    
    weak var delegate: CollectionViewCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadImages(sourceImages: Array<String>) {
        images = sourceImages
        collectionView.reloadData()
    }
    
    // MARK: - UICollectionView
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SimpleImageCell", forIndexPath: indexPath) as! SimpleImageCell
        
        if indexPath.row == 0 {
            // TODO: 加号
            cell.iconImageView.image = UIImage(named: "")
        }
        else {
            let photoName = images[indexPath.row]
            let stringURL = "\(imageDownloadURL)\(photoName)"
            cell.iconImageView.loadImageURL(stringURL, name: photoName, placeholder: "")
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            delegate?.didClickAdd?(self)
            
            return
        }
        
        delegate?.didSelectIndex(self, index: indexPath.row - 1)
    }

}
