//
//  NormalImageTableCell.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/1/19.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

@objc protocol NormalImageTableCellDelegate {

    optional
    func didEditing(cell: NormalImageTableCell)
    func didEndEditing(cell: NormalImageTableCell)
    func didEditingTime(cell: NormalImageTableCell, datePicker: DatePickerView)
    func didEndEditingTime(cell: NormalImageTableCell)
    
}

class NormalImageTableCell: UITableViewCell, UITextFieldDelegate, DatePickerViewDelegate {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerWidthLC: NSLayoutConstraint!
    @IBOutlet weak var iconWidthLC: NSLayoutConstraint!
    
    var timeEditable: Bool = false
    
    weak var delegate: NormalImageTableCellDelegate?
    
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
    
    // MARK: - DatePicker
    
    func didPickDateCompletion(view: DatePickerView, date: NSDate, dateString: String) {
        titleTextField.text = dateString
        
        delegate?.didEndEditingTime(self)
    }
    
    // MARK: - UITextField
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if timeEditable {
            let datePickerView = DatePickerView.view()
            datePickerView.delegate = self
            datePickerView.show()
            
            delegate?.didEditingTime(self, datePicker: datePickerView)
        }
        
        return !timeEditable
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        delegate?.didEditing?(self)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        delegate?.didEndEditing(self)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }

}
