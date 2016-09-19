//
//  NormalImageCell.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/1/19.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class NormalImageCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var markLabel: UILabel!
    
    override func awakeFromNib() {
        CustomObjectUtil.customObjectsLayout([markLabel], backgroundColor: colorRed, borderWidth: 0, borderColor: nil, corner: 10)
    }
    
}
