//
//  CollectionViewCell.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/12.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class CollectionViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var images = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
            
        }
        
        return cell
    }

}