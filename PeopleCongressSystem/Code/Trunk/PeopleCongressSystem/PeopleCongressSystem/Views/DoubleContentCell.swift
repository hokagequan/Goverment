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
    @IBOutlet weak var headerUpLabel: UILabel!
    @IBOutlet weak var headerDownLabel: UILabel!
    @IBOutlet weak var headerUpWidthLC: NSLayoutConstraint!
    @IBOutlet weak var headerDownWidthLC: NSLayoutConstraint!
    
    var headerUpText: NSString? {
        didSet {
            headerUpLabel.text = headerUpText as? String
            
            if headerUpText == nil {
                headerUpWidthLC.constant = 0
                
                return
            }
            
            let bounds = headerUpText?.boundingRectWithSize(CGSizeMake(CGFloat.max, headerUpLabel.bounds.size.height), options: NSStringDrawingOptions.UsesFontLeading, attributes: [NSFontAttributeName: headerUpLabel.font], context: nil)
            headerUpWidthLC.constant = bounds!.size.width + 8
            
            self.setNeedsLayout()
        }
    }
    
    var headerDownText: NSString? {
        didSet {
            headerDownLabel.text = headerDownText as? String
            
            if headerDownText == nil {
                headerDownWidthLC.constant = 0
                
                return
            }
            
            let bounds = headerDownText?.boundingRectWithSize(CGSizeMake(CGFloat.max, headerDownLabel.bounds.size.height), options: NSStringDrawingOptions.UsesFontLeading, attributes: [NSFontAttributeName: headerDownLabel.font], context: nil)
            headerDownWidthLC.constant = bounds!.size.width + 8
            
            self.setNeedsLayout()
        }
    }

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
