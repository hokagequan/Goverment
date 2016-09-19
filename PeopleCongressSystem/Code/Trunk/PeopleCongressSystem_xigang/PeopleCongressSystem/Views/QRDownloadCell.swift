//
//  QRDownloadCell.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/8.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class QRDownloadCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        CustomObjectUtil.customObjectsLayout([containerView], backgroundColor: UIColor.whiteColor(), borderWidth: 0, borderColor: UIColor.clearColor(), corner: 3)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
