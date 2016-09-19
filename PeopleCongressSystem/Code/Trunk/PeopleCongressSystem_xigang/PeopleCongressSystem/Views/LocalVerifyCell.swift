//
//  LocalVerifyCell.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/4/11.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class LocalVerifyCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var verifyCodeView: RandomCodeView!
    @IBOutlet weak var headerLabelWidthLC: NSLayoutConstraint!
    
    var code: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        verifyCodeView.didChangeCode { (code) in
            self.code = code
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Actions
    
    @IBAction func clickRefresh(sender: AnyObject) {
        verifyCodeView.changeCode()
        verifyCodeView.didChangeCode { (code) in
            self.code = code
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
