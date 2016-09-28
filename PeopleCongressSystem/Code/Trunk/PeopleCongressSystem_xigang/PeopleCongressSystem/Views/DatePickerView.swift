//
//  DatePickerView.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/5.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

@objc protocol DatePickerViewDelegate {
    
    @objc optional func didPickDateCompletion(_ view: DatePickerView, date: Date, dateString: String)
    @objc optional func willDismiss()
}

class DatePickerView: UIControl {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerContainer: UIView!
    
    weak var delegate: DatePickerViewDelegate?

    override func awakeFromNib() {
        self.addTarget(self, action: #selector(DatePickerView.dismiss), for: UIControlEvents.touchUpInside)
    }
    
    func dismiss() {
        delegate?.willDismiss?()
        
        self.removeFromSuperview()
    }
    
    func show() {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        self.frame = window.bounds
        window.addSubview(self)
    }
    
    // MARK: - Class Functions
    
    class func view() -> DatePickerView {
        let views = Bundle.main.loadNibNamed("DatePickerView", owner: self, options: nil)
        for view in views! {
            if view is DatePickerView {
                return view as! DatePickerView
            }
        }
        
        return DatePickerView()
    }
    
    // MARK: - Actions
    
    @IBAction func clickCompletion(_ sender: AnyObject) {
        let date = datePicker.date
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: date)
        
        delegate?.didPickDateCompletion?(self, date: date, dateString: dateString)
        
        self.dismiss()
    }
    
    @IBAction func clickCancel(_ sender: AnyObject) {
        self.dismiss()
    }
    
}