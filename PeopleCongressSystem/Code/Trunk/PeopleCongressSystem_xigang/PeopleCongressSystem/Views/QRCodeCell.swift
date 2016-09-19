//
//  QRCodeCell.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/4/26.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class QRCodeCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var qrCodeImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
