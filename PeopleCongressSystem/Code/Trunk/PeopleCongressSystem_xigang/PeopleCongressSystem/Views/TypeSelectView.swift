//
//  TypeSelectView.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/3.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit
import EZLoadingActivity

@objc protocol TypeSelectViewDelegate {

    @objc optional
    func didSelectIndex(_ view: TypeSelectView, indexPath: IndexPath)
    
}

class TypeSelectView: UIControl, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var typeTableView: UITableView!
    
    var dataSource = [String]()
    
    weak var delegate: TypeSelectViewDelegate?

    override func awakeFromNib() {
        self.addTarget(self, action: #selector(self.dismiss), for: UIControlEvents.touchUpInside)
        
        typeTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        typeTableView.layoutMargins = UIEdgeInsets.zero
        
        CustomObjectUtil.customObjectsLayout([containerView], backgroundColor: UIColor.white, borderWidth: 0.0, borderColor: nil, corner: 8.0)
    }
    
    func dismiss() {
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
    
    class func view() -> TypeSelectView {
        let views = Bundle.main.loadNibNamed("TypeSelectView", owner: self, options: nil)
        for view in views! {
            if view is TypeSelectView {
                return view as! TypeSelectView
            }
        }
        
        return TypeSelectView()
    }
    
    // MARK: - UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let string = dataSource[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = string
        cell.textLabel?.textColor = GlobalUtil.colorRGBA(38, g: 38, b: 38, a: 1)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17.0)
        cell.textLabel?.textAlignment = NSTextAlignment.center
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectIndex?(self, indexPath: indexPath)
        self.dismiss()
    }
    
}
