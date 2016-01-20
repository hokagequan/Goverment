//
//  DoubleContentCell.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/1/20.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class DoubleContentCell: UITableViewCell {
    
    @IBOutlet weak var iconUpImageView: UIImageView!
    @IBOutlet weak var iconDownImageView: UIImageView!
    @IBOutlet weak var titleUpLabel: UITextField!
    @IBOutlet weak var titleDownLabel: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var editable: Bool {
        get {
            return titleUpLabel.enabled
        }
        set {
            titleUpLabel.enabled = newValue
            titleDownLabel.enabled = newValue
        }
    }

}
