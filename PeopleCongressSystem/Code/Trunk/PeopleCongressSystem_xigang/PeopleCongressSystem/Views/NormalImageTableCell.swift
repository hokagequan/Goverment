//
//  NormalImageTableCell.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/1/19.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

@objc protocol NormalImageTableCellDelegate {

    @objc optional
    func didEditing(_ cell: NormalImageTableCell)
    func didEndEditing(_ cell: NormalImageTableCell)
    func didEditingTime(_ cell: NormalImageTableCell, datePicker: DatePickerView)
    func didEndEditingTime(_ cell: NormalImageTableCell)
    
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
            
            let bounds = headerText?.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: headerLabel.bounds.size.height), options: NSStringDrawingOptions.usesFontLeading, attributes: [NSFontAttributeName: headerLabel.font], context: nil)
            headerWidthLC.constant = bounds!.size.width + 8
            
            self.setNeedsLayout()
        }
    }
    
    var editable: Bool {
        get {
            return titleTextField.isEnabled
        }
        set {
            titleTextField.isEnabled = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - DatePicker
    
    func didPickDateCompletion(_ view: DatePickerView, date: Date, dateString: String) {
        titleTextField.text = dateString
    }
    
    func willDismiss() {
        delegate?.didEndEditingTime(self)
    }
    
    // MARK: - UITextField
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if timeEditable {
            let datePickerView = DatePickerView.view()
            datePickerView.delegate = self
            datePickerView.show()
            
            delegate?.didEditingTime(self, datePicker: datePickerView)
        }
        
        return !timeEditable
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.didEditing?(self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.didEndEditing(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }

}