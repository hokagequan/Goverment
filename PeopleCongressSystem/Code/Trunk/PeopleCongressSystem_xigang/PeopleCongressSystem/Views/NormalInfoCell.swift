//
//  NormalInfoCell.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/6.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class NormalInfoCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
