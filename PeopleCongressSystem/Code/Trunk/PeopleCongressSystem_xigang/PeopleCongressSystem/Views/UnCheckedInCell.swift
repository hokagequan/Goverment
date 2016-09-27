//
//  UnCheckedInCell.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/4/26.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class UnCheckedInCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var notifyButton: UIButton!
    
    var clickNotifyBlock: ((UITableViewCell) -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        CustomObjectUtil.customObjectsLayout([containerView], backgroundColor: UIColor.white, borderWidth: 0, borderColor: nil, corner: 3.0)
        CustomObjectUtil.customObjectsLayout([notifyButton], backgroundColor: UIColor.clear, borderWidth: 1, borderColor: colorRed, corner: 3.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Actions

    @IBAction func clickNotify(_ sender: AnyObject) {
        clickNotifyBlock?(self)
    }
    
}
