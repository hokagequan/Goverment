//
//  NormalImageTableCell.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/1/19.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class NormalImageTableCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var border: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerWidthLC: NSLayoutConstraint!
    
    var headerText: NSString? {
        didSet {
            headerLabel.text = headerText as? String
            
            if headerText == nil {
                headerWidthLC.constant = 0
                
                return
            }
            
            let bounds = headerText?.boundingRectWithSize(CGSizeMake(CGFloat.max, headerLabel.bounds.size.height), options: NSStringDrawingOptions.UsesFontLeading, attributes: [NSFontAttributeName: headerLabel.font], context: nil)
            headerWidthLC.constant = bounds!.size.width + 8
            
            self.setNeedsLayout()
        }
    }
    
    var editable: Bool {
        get {
            return titleTextField.enabled
        }
        set {
            titleTextField.enabled = newValue
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

}
