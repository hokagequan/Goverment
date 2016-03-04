//
//  PersonListViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/4.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit
import EZLoadingActivity

class PersonListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var personsTableView: UITableView!
    
    var activity: Activity? = nil
    var group: Group? = nil
    var persons = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if group == nil {
            return
        }
        
        EZLoadingActivity.show("", disableUI: true)
        PCSDataManager.defaultManager().GetCongressList(group!.identifier!) { (info) -> Void in
            if info == nil {
                return
            }
            
            self.persons = info!
            
            self.personsTableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func markImageView() -> UIImageView {
        let mark = UIImageView(image: UIImage(named: "mark_nor"))
        mark.frame = CGRectMake(0, 0, 22, 22)
        
        return mark
    }
    
    func updateSelection() {
        guard let selection = personsTableView.indexPathsForSelectedRows else {
            activity?.persons = nil
            
            return
        }
        
        activity?.persons = selection.map({return persons[$0.row]})
    }
    
    func updateSelectionState(cell: UITableViewCell, selected: Bool) {
        let imageName = selected ? "mark_sel" : "mark_nor"
        let markImage = UIImage(named: imageName)
        
        (cell.accessoryView as! UIImageView).image = markImage
    }
    
    // MARK: - Actions
    
    @IBAction func clickSelectAll(sender: AnyObject) {
        let button = sender as! UIButton
        
        button.selected = !button.selected
        
        activity?.persons = button.selected ? persons : nil
        
        for i in 0..<50 {
            let indexPath = NSIndexPath(forRow: i, inSection: 0)
            
            if button.selected {
                personsTableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
            }
            else {
                personsTableView.deselectRowAtIndexPath(indexPath, animated: false)
            }
            
            guard let cell = personsTableView.cellForRowAtIndexPath(indexPath) else {
                continue
            }
            
            self.updateSelectionState(cell, selected: button.selected)
        }
    }
    
    // MARK: - UITableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        if cell.accessoryView == nil {
            cell.accessoryView = self.markImageView()
        }
        
        self.updateSelectionState(cell, selected: cell.selected)
        
        let person = persons[indexPath.row]
        cell.textLabel?.text = person.name
        cell.detailTextLabel?.text = group?.title
        cell.textLabel?.font = UIFont.systemFontOfSize(16.0)
        cell.detailTextLabel?.font = UIFont.systemFontOfSize(16.0)
        cell.textLabel?.textColor = GlobalUtil.colorRGBA(59, g: 59, b: 59, a: 1)
        cell.textLabel?.textColor = UIColor.grayColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.contentView.viewWithTag(1000) != nil {
            return
        }
        
        let frame = CGRectMake(5, 4, cell.bounds.size.width - 10, cell.bounds.size.height - 8)
        let view = UIView(frame: frame)
        CustomObjectUtil.customObjectsLayout([view], backgroundColor: UIColor.whiteColor(), borderWidth: 1, borderColor: GlobalUtil.colorRGBA(240, g: 240, b: 240, a: 1.0), corner: 2)
        cell.contentView.addSubview(view)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        self.updateSelectionState(cell, selected: true)
        self.updateSelection()
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        self.updateSelectionState(cell, selected: false)
        self.updateSelection()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
