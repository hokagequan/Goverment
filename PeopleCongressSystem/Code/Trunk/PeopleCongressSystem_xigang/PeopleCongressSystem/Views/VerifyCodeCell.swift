//
//  VerifyCodeCell.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/4/11.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

@objc protocol VerifyCodeDelegate {
    optional func didClickDetail(cell: VerifyCodeCell)
}

class VerifyCodeCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var headerWidthLC: NSLayoutConstraint!
    @IBOutlet weak var borderView: UIView!
    
    weak var delegate: VerifyCodeDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func clickDetail(sender: AnyObject) {
        delegate?.didClickDetail?(self)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
