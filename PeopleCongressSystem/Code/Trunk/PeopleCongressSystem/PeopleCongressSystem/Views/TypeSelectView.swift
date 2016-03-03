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

    optional
    func didSelectType(view: TypeSelectView, type: PCSTypeInfo)
    
}

class TypeSelectView: UIControl, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var typeTableView: UITableView!
    
    var type: PCSType = PCSType.Congress
    var types = [PCSTypeInfo]()
    
    weak var delegate: TypeSelectViewDelegate?

    override func awakeFromNib() {
        self.addTarget(self, action: Selector("dismiss"), forControlEvents: UIControlEvents.TouchUpInside)
        
        typeTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        CustomObjectUtil.customObjectsLayout([containerView], backgroundColor: UIColor.whiteColor(), borderWidth: 0.0, borderColor: nil, corner: 8.0)
        
        EZLoadingActivity.show("", disableUI: true)
        PCSDataManager.defaultManager().getTypeInfo(type) { (infos) -> Void in
            if infos != nil {
                self.types = infos!
                self.typeTableView.reloadData()
            }
        }
    }
    
    func dismiss() {
        self.removeFromSuperview()
    }
    
    func show(pcsType: PCSType) {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        self.frame = app.window!.bounds
        
        type = pcsType
        
        app.window?.addSubview(self)
    }
    
    // MARK: - Class Functions
    
    class func view() -> TypeSelectView {
        let views = NSBundle.mainBundle().loadNibNamed("TypeSelectView", owner: self, options: nil)
        for view in views {
            if view is TypeSelectView {
                return view as! TypeSelectView
            }
        }
        
        return TypeSelectView()
    }
    
    // MARK: - UITableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return types.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        
        return view
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        
        return view
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let typeInfo = types[indexPath.row]
        
        cell.textLabel?.text = typeInfo.title
        cell.textLabel?.textColor = GlobalUtil.colorRGBA(38, g: 38, b: 38, a: 1)
        cell.textLabel?.font = UIFont.systemFontOfSize(17.0)
        cell.textLabel?.textAlignment = NSTextAlignment.Center
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.didSelectType?(self, type: types[indexPath.row])
    }
    
}
