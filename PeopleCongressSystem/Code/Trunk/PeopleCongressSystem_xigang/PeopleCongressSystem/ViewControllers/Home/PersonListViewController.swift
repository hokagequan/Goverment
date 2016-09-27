//
//  PersonListViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/4.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit
import EZLoadingActivity

class PersonListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PCSNavigationViewDelegate {

    @IBOutlet weak var personsTableView: UITableView!
    @IBOutlet weak var naviView: PCSNavigationView!
    
    var activity: Activity? = nil
    var group: Group? = nil
    var persons = [Person]()
    var backTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if backTitle.characters.count > 0 {
            naviView.backTitle = backTitle
        }
        
        naviView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationItem.hidesBackButton = true
        PCSCustomUtil.customNavigationController(self)
        
        if group == nil {
            return
        }
        
        var selectedNames = [String]()
        
        if (activity?.persons != nil) {
            selectedNames = activity!.persons!.map { (person) -> String in
                return person.name!
            }
        }
        
        EZLoadingActivity.show("", disableUI: true)
        PCSDataManager.defaultManager().getCongressList(group!.identifier!) { (info, errorCode) -> Void in
            EZLoadingActivity.hide()
            
            if info == nil {
                ResponseErrorManger.defaultManager().handleError(errorCode, message: nil)
                return
            }
            
            let personsTemp = info!
            var selectedIndexPaths = [IndexPath]()
            var index = 0
            self.persons = personsTemp.map({ (person) -> Person in
                person.organization = self.group?.title
                
                if selectedNames.contains(person.name!) {
                    selectedIndexPaths.append(IndexPath(row: index, section: 0))
                }
                
                index += 1
                
                return person
            })
            
            self.personsTableView.reloadData()
            
            if selectedIndexPaths.count > 0 {
                for indexPath in selectedIndexPaths {
                    self.personsTableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.none)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func markImageView() -> UIImageView {
        let mark = UIImageView(image: UIImage(named: "mark_nor"))
        mark.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        
        return mark
    }
    
    func mergePersons() {
        var memPersons = activity?.persons?.flatMap{return $0.organizationID != group?.identifier ? $0 : nil}
        let selection = personsTableView.indexPathsForSelectedRows
        
        if  selection == nil || selection?.count == 0 {
            activity?.persons = memPersons
            
            return
        }
        
        if memPersons == nil {
            memPersons = [Person]()
        }
        let selectedPersons = selection?.map{return persons[($0 as NSIndexPath).row]}
        memPersons! += selectedPersons!
        
        activity?.persons = memPersons
    }
    
    func updateSelection() {
        guard let selection = personsTableView.indexPathsForSelectedRows else {
            activity?.persons = nil
            
            return
        }
        
        for indexPath in selection {
            let person = persons[(indexPath as NSIndexPath).row]
            let memPerson = activity?.persons?.filter({ (objc) -> Bool in
                return objc.name == person.name
            })
            
            if memPerson?.count == 0 {
                activity?.persons?.append(person)
            }
        }
    }
    
    func updateSelectionState(_ cell: UITableViewCell, selected: Bool) {
        let imageName = selected ? "mark_sel" : "mark_nor"
        let markImage = UIImage(named: imageName)
        
        (cell.accessoryView as! UIImageView).image = markImage
    }
    
    // MARK: - Actions
    
    @IBAction func clickSelectAll(_ sender: AnyObject) {
        let button = sender as! UIButton
        
        button.isSelected = !button.isSelected
        
        activity?.persons = button.isSelected ? persons : nil
        
        for i in 0..<persons.count {
            let indexPath = IndexPath(row: i, section: 0)
            
            if button.isSelected {
                personsTableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.none)
            }
            else {
                personsTableView.deselectRow(at: indexPath, animated: false)
            }
            
            guard let cell = personsTableView.cellForRow(at: indexPath) else {
                continue
            }
            
            self.updateSelectionState(cell, selected: button.isSelected)
        }
    }
    
    // MARK: - UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if cell.accessoryView == nil {
            cell.accessoryView = self.markImageView()
        }
        
        self.updateSelectionState(cell, selected: cell.isSelected)
        
        let person = persons[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = person.name
        cell.detailTextLabel?.text = group?.title
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16.0)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15.0)
        cell.textLabel?.textColor = GlobalUtil.colorRGBA(51, g: 51, b: 51, a: 1)
        cell.detailTextLabel?.textColor = GlobalUtil.colorRGBA(60, g: 60, b: 60, a: 1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.contentView.viewWithTag(1000) != nil {
            return
        }
        
        let frame = CGRect(x: 5, y: 4, width: cell.bounds.size.width - 10, height: cell.bounds.size.height - 8)
        let view = UIView(frame: frame)
        view.tag = 1000
        CustomObjectUtil.customObjectsLayout([view], backgroundColor: UIColor.white, borderWidth: 1, borderColor: GlobalUtil.colorRGBA(240, g: 240, b: 240, a: 1.0), corner: 2)
        cell.contentView.addSubview(view)
        cell.contentView.sendSubview(toBack: view)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        self.updateSelectionState(cell, selected: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        self.updateSelectionState(cell, selected: false)
    }
    
    // MARK: - PCSNavigationViewDelegate
    
    func willDismiss() -> Bool {
        self.mergePersons()
        
        return false
        
//        self.performSegueWithIdentifier("ActivityDetailSegue", sender: nil)
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
