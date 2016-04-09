//
//  VariableDetailViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/11.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit
import DKImagePickerController
import EZLoadingActivity

enum VariablePageType {
    
    case Detail
    case Add
    
}

class VariableDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CollectionViewCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TypeSelectViewDelegate, NormalImageTableCellDelegate, PCSNavigationViewDelegate, UIAlertViewDelegate {
    
    enum Sections: Int {
        
        case MainContent = 0
        case Detail
        case Photos
        case Max
        
        func rows() -> Array<Row> {
            let titles = [["标题:", "类型:", "人员:"],
                ["时间:", "内容:", "备注:"],
                ["履职现场:"]
            ]
            
            let icons = [["title", "type", "organization"],
                ["time2", "content", "content"],
                [""]
            ]
            
            let keys = [["title", "typeTitle", "persons"],
                ["time", "content", "remark"],
                ["photos"]
            ]
            
            if self.rawValue >= titles.count {
                return [Row]()
            }
            
            var rows = [Row]()
            let rowTitles = titles[self.rawValue]
            for i in 0..<rowTitles.count {
                var row = Row()
                row.title = rowTitles[i]
                row.icon = icons[self.rawValue][i]
                row.key = keys[self.rawValue][i]
                rows.append(row)
            }
            
            return rows
        }
        
        static func allKeys() -> [String] {
            return ["title", "typeTitle", "persons", "time", "content", "remark", "photos"]
        }
        
    }
    
    struct Row {
        
        var title: String? = nil
        var icon: String? = nil
        var key: String? = nil
        
    }

    @IBOutlet weak var naviView: PCSNavigationView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var footerView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var variable: Variable = Variable()
    var pageType = VariablePageType.Detail
    var selectedInfo: PCSTypeInfo? = nil
    var types = [PCSTypeInfo]()
    var addPhotoCount = 0
    var addPhotos = [String]()
    var oldPhotos = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        naviView.delegate = self
        oldPhotos = variable.photos
        
        tableView.registerNib(UINib(nibName: "NormalImageTableCell", bundle: nil), forCellReuseIdentifier: "NormalImageTableCell")
        CustomObjectUtil.customObjectsLayout([saveButton, submitButton], backgroundColor: colorRed, borderWidth: 0.0, borderColor: nil, corner: 3.0)
        
        self.customUI()
        
        if pageType == VariablePageType.Add {
            guard let localVariable = PCSDataManager.defaultManager().getLocalVariable() else {
                return
            }
            
            variable = localVariable
            tableView.reloadData()
            
            return
        }
        
        EZLoadingActivity.show("", disableUI: true)
        let req = GetVariableDetailReq()
        req.variable = variable
        req.requestSimpleCompletion { (success, errorCode) -> Void in
            EZLoadingActivity.hide()
            if success {
                self.oldPhotos = self.variable.photos
                self.tableView.reloadData()
            }
            else {
                ResponseErrorManger.defaultManager().handleError(errorCode, message: nil)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.hidesBackButton = true
        PCSCustomUtil.customNavigationController(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func customUI() {
        if pageType == VariablePageType.Add {
            deleteButton.hidden = true
            submitButton.hidden = true
        }
        else {
            if variable.submitted == true {
                deleteButton.hidden = true
                submitButton.hidden = true
                saveButton.hidden = true
            }
        }
    }
    
    func createVariable() -> Variable {
        let tempVariable = variable.copy() as! Variable
        
        for section in 0..<Sections.Max.rawValue {
            let sec = Sections(rawValue: section)
            let rowCount = sec?.rows().count
            
            for row in 0..<rowCount! {
                let cell = tableView!.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: section))
                if cell is NormalImageTableCell {
                    let row = sec!.rows()[row]
                    tempVariable.setValue((cell as! NormalImageTableCell).titleTextField.text, forKey: row.key!)
                }
            }
        }
        
        if selectedInfo != nil {
            tempVariable.type = selectedInfo?.code
        }
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        tempVariable.createTime = formatter.stringFromDate(NSDate())
        
        return tempVariable
    }
    
    func finishAddPhotos(cell: CollectionViewCell) {
        addPhotoCount -= 1
        
        if addPhotoCount == 0 {
            EZLoadingActivity.hide()
            cell.addImages(self.addPhotos)
            variable.photos += self.addPhotos
        }
    }
    
    func saveToLocal(completion: () -> Void) {
        let variable = self.createVariable()
        variable.token = GlobalUtil.randomImageName()
        PCSDataManager.defaultManager().saveVariableToLocal(variable, completion: completion)
    }
    
    func cancelSaveToLocal(completion: () -> Void) {
        PCSDataManager.defaultManager().deleteLocalVariable(completion)
    }
    
    func uploadAddedPhotos(completion: (() -> Void)?) {
        func filter(element: String) -> String? {
            if oldPhotos.contains(element) == false {
                return element
            }
            
            return nil
        }
        
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2)) as! CollectionViewCell
        let images = cell.images
        let toAddImages = images.flatMap{filter($0)}
        
        let semaphore = dispatch_semaphore_create(1)
        let queue = dispatch_queue_create("UploadPhotos", nil)
        let dispatchTimeout = dispatch_time(DISPATCH_TIME_NOW, Int64(5 * 60 * NSEC_PER_SEC))
        
        dispatch_async(queue, { () -> Void in
            for image in toAddImages {
                dispatch_semaphore_wait(semaphore, dispatchTimeout)
                autoreleasepool({ () -> () in
                    let imageData = NSData(contentsOfFile: UIImageView.pathForTempImage() + "/\(image)")
                    let req = UploadPhotoReq()
                    req.variableID = self.variable.token!
                    req.fileName = image
                    req.file = imageData
                    req.requestCompletion({ (response) -> Void in
                        dispatch_semaphore_signal(semaphore)
                    })
                })
            }
            
            dispatch_semaphore_wait(semaphore, dispatchTimeout)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion?()
            })
            dispatch_semaphore_signal(semaphore)
        })
    }
    
    // MARK: - Actions
    
    @IBAction func clickSave(sender: AnyObject) {
        if pageType == VariablePageType.Add {
            variable.token = GlobalUtil.randomImageName()
            EZLoadingActivity.show("", disableUI: true)
            
            PCSDataManager.defaultManager().addVariable(self.createVariable()) { (success, message, errorCode) -> Void in
                if success {
                    self.uploadAddedPhotos({ () -> Void in
                        EZLoadingActivity.hide()
                        self.showAlertWithDelegate(message ?? "添加成功")
                    })
                }
                else {
                    EZLoadingActivity.hide()
                    ResponseErrorManger.defaultManager().handleError(errorCode, message: message)
                }
            }
        }
        else {
            let toVariable = self.createVariable()
            
            let req = EditVariableReq()
            req.variable = toVariable
            
            EZLoadingActivity.show("", disableUI: true)
            req.requestSimpleCompletion { (success, message, errorCode) -> Void in
                if success {
                    self.uploadAddedPhotos({ () -> Void in
                        EZLoadingActivity.hide()
                        self.showAlertWithDelegate(message ?? "修改成功")
                    })
                }
                else {
                    EZLoadingActivity.hide()
                    ResponseErrorManger.defaultManager().handleError(errorCode, message: message)
                }
            }
        }
    }
    
    @IBAction func clickSubmit(sender: AnyObject) {
        let toVariable = self.createVariable()
        toVariable.submitted = true
        
        let req = EditVariableReq()
        req.variable = toVariable
        
        EZLoadingActivity.show("", disableUI: true)
        req.requestSimpleCompletion { (success, message, errorCode) -> Void in
            EZLoadingActivity.hide()
            
            let alertMessage = success ? "提交成功" : "提交失败，请检查您的网络状况"
            
            if success {
                self.showAlertWithDelegate(alertMessage)
            }
            else {
                ResponseErrorManger.defaultManager().handleError(errorCode, message: alertMessage)
            }
        }
    }
    
    @IBAction func clickDelete(sender: AnyObject) {
        EZLoadingActivity.show("", disableUI: true)
        
        let req = DeleteVariableReq()
        req.variable = variable
        req.requestSimpleCompletion { (success, message, errorCode) -> Void in
            EZLoadingActivity.hide()
            
            if success == true {
                self.showAlertWithDelegate("删除成功")
            }
            else {
                ResponseErrorManger.defaultManager().handleError(errorCode, message: "删除失败，请检查您的网络状况")
            }
        }
    }
    
    // MARK: - AlertView
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - CollectionViewCellDelegate
    
    func didClickAdd(cell: CollectionViewCell) {
        if variable.submitted == true {
            return
        }
        
        self.view.endEditing(true)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        let picker = DKImagePickerController()
        picker.maxSelectableCount = 6
        picker.assetType = DKImagePickerControllerAssetType.AllPhotos
        picker.didSelectAssets = {(assets: [DKAsset]) in
            self.addPhotoCount = assets.count
            self.addPhotos.removeAll()
            EZLoadingActivity.show("", disableUI: true)
            for asset in assets {
                asset.fetchFullScreenImageWithCompleteBlock({ (image, info) -> Void in
                    defer {
                        self.finishAddPhotos(cell)
                    }
                    
                    if image == nil {
                        return
                    }
                    
                    let imageData = UIImageJPEGRepresentation(image!, 0.5)
                    let imageName = GlobalUtil.randomImageName() + ".jpg"
                    imageData?.writeToFile(UIImageView.pathForTempImage().stringByAppendingString("/\(imageName)"), atomically: true)
                    self.addPhotos.append(imageName)
                })
            }
            
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
        
        picker.didCancel = { () in
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func didSelectIndex(cell: CollectionViewCell, index: Int) {
        if variable.submitted == true {
            return
        }
    }
    
    func didClickImage(cell: CollectionViewCell, image: UIImage) {
        let photoBrowser = PhotoBrowserView.view()
        photoBrowser.show(image)
    }
    
    func didLongPressIndex(cell: CollectionViewCell, index: Int) {
        let alert = UIAlertController(title: nil, message: "确定要删除照片吗？", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let sureAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default) { (action) -> Void in
            alert.dismissViewControllerAnimated(true, completion: nil)
            
            let photoName = cell.images[index]
            if self.variable.photos.contains(photoName) {
                EZLoadingActivity.show("", disableUI: true)
                let req = DeletePhotoReq()
                req.photoID = cell.images[index]
                req.requestSimpleCompletion({ (success, message, errorCode) -> Void in
                    EZLoadingActivity.hide()
                    
                    if success == true {
                        cell.deleteCollectionCell(index)
                        
                        if self.variable.photos.contains(req.photoID!) {
                            self.variable.photos.removeAtIndex(self.variable.photos.indexOf(req.photoID!)!)
                        }
                    }
                    else {
                        ResponseErrorManger.defaultManager().handleError(errorCode, message: message)
                    }
                })
            }
            else {
                cell.deleteCollectionCell(index)
            }
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Default) { (action) -> Void in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alert.addAction(sureAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - TypeSelectView
    
    func didSelectIndex(view: TypeSelectView, indexPath: NSIndexPath) {
        selectedInfo = types[indexPath.row]
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
    }
    
    // MARK: - NormalImageTableCellDelegate
    
    func didEditing(cell: NormalImageTableCell) {
        tableView?.scrollEnabled = false
        let keyboardHeight: CGFloat = 246.0
        let deltaY = cell.frame.origin.y + 50.0 - (tableView!.bounds.size.height - keyboardHeight) + tableView!.frame.origin.y
        
        if deltaY > 0 {
            tableView?.setContentOffset(CGPointMake(0, deltaY), animated: true)
        }
    }
    
    func didEndEditing(cell: NormalImageTableCell) {
        tableView?.setContentOffset(CGPointZero, animated: true)
        tableView?.scrollEnabled = true
        
        let indexPath = tableView.indexPathForCell(cell)
        let section = Sections(rawValue: indexPath!.section)!
        let row = section.rows()[indexPath!.row]
        variable.setValue(cell.titleTextField.text, forKey: row.key!)
    }
    
    func didEditingTime(cell: NormalImageTableCell, datePicker: DatePickerView) {
        self.view.endEditing(true)
        let keyboardHeight: CGFloat = datePicker.datePickerContainer.bounds.size.height
        let deltaY = cell.frame.origin.y + 50.0 - (tableView!.bounds.size.height - keyboardHeight) + tableView!.frame.origin.y
        
        if deltaY > 0 {
            tableView?.setContentOffset(CGPointMake(0, deltaY), animated: true)
        }
    }
    
    func didEndEditingTime(cell: NormalImageTableCell) {
        tableView?.setContentOffset(CGPointZero, animated: true)
        
        let indexPath = tableView.indexPathForCell(cell)
        let section = Sections(rawValue: indexPath!.section)!
        let row = section.rows()[indexPath!.row]
        variable.setValue(cell.titleTextField.text, forKey: row.key!)
    }
    
    // MARK: - UIImagePicker
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("")
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("")
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UITableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Sections.Max.rawValue
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let section = Sections(rawValue: indexPath.section)!
        
        if section == Sections.Photos {
            return 130.0
        }
        
        return 50.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sec = Sections(rawValue: section)!
        
        return sec.rows().count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1
        }
        
        return 18.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        
        return view
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sec = Sections(rawValue: section)!
        
        if sec == Sections.Photos {
            return 60.0
        }
        
        return 1.0
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sec = Sections(rawValue: section)!
        
        if sec == Sections.Photos {
            return footerView
        }
        
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        
        return view
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = Sections(rawValue: indexPath.section)!
        
        if section == Sections.Photos {
            let cell = tableView.dequeueReusableCellWithIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.delegate = self
            let row = section.rows()[indexPath.row]
            cell.titleLabel.text = row.title
            cell.loadImages(variable.photos)
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("NormalImageTableCell", forIndexPath: indexPath) as! NormalImageTableCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        let rows = section.rows()
        let row = rows[indexPath.row]
        cell.headerText = row.title
        cell.iconImageView.image = UIImage(named: row.icon!)
        cell.titleTextField.text = variable.valueForKey(row.key!) as? String
        cell.editable = !variable.submitted
        cell.delegate = self
        
        switch row.title! {
        case "类型:":
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.editable = false
            if selectedInfo != nil {
                cell.titleTextField.text = selectedInfo?.title
            }
            break
        case "时间:":
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.timeEditable = true
            break
        default:
            cell.accessoryType = UITableViewCellAccessoryType.None
            break
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if variable.submitted == true {
            return
        }
        
        let section = Sections(rawValue: indexPath.section)!
        let rows = section.rows()
        let row = rows[indexPath.row]
        
        switch row.title! {
        case "类型:":
            EZLoadingActivity.show("", disableUI: true)
            PCSDataManager.defaultManager().getTypeInfo(PCSType.Congress) { (infos, errorCode) -> Void in
                EZLoadingActivity.hide()
                if infos != nil {
                    self.types = infos!
                    let typeView = TypeSelectView.view()
                    typeView.dataSource = self.types.flatMap({return $0.title})
                    typeView.delegate = self
                    typeView.show()
                }
            }
            break
        default:
            break
        }
    }

    // MARK: - Navigation
    
    func willDismiss() -> Bool {
        self.view.endEditing(true)
        
        if pageType == VariablePageType.Add {
            var hasValue = false
            let tempVariable = self.createVariable()
            
            for key in Sections.allKeys() {
                hasValue = (tempVariable.valueForKey(key) as? String != "" && tempVariable.valueForKey(key) as? String != nil)
                
                if key == "photos" {
                    hasValue = tempVariable.photos.count > 0
                }
                
                if hasValue == true {
                    break
                }
            }
            
            if hasValue == false {
                return false
            }
            
            let alert = UIAlertController(title: nil, message: "是否保存？", preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel) { (action) in
                self.cancelSaveToLocal({ 
                    self.navigationController?.popViewControllerAnimated(true)
                })
            }
            let saveAction = UIAlertAction(title: "保存", style: UIAlertActionStyle.Default) { (action) in
                self.saveToLocal({ 
                    self.navigationController?.popViewControllerAnimated(true)
                })
            }
            
            alert.addAction(cancelAction)
            alert.addAction(saveAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            return true
        }
        
        return false
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
