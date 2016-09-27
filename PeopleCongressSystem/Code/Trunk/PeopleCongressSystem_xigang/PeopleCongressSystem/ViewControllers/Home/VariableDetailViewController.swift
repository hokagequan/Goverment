//
//  VariableDetailViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/11.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit
import EZLoadingActivity
import DKImagePickerController

enum VariablePageType {
    
    case detail
    case add
    
}

class VariableDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CollectionViewCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TypeSelectViewDelegate, NormalImageTableCellDelegate, PCSNavigationViewDelegate, UIAlertViewDelegate {
    
    enum Sections: Int {
        
        case mainContent = 0
        case detail
        case photos
        case max
        
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
    var pageType = VariablePageType.detail
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
        
        tableView.register(UINib(nibName: "NormalImageTableCell", bundle: nil), forCellReuseIdentifier: "NormalImageTableCell")
        CustomObjectUtil.customObjectsLayout([saveButton, submitButton], backgroundColor: colorRed, borderWidth: 0.0, borderColor: nil, corner: 3.0)
        
        self.customUI()
        
        if pageType == VariablePageType.add {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.hidesBackButton = true
        PCSCustomUtil.customNavigationController(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func customUI() {
        if pageType == VariablePageType.add {
            deleteButton.isHidden = true
            submitButton.isHidden = false
        }
        else {
            if variable.submitted == true {
                deleteButton.isHidden = true
                submitButton.isHidden = true
                saveButton.isHidden = true
            }
        }
    }
    
    func createVariable() -> Variable {
        let tempVariable = variable.copy() as! Variable
        
        for section in 0..<Sections.max.rawValue {
            let sec = Sections(rawValue: section)
            let rowCount = sec?.rows().count
            
            for row in 0..<rowCount! {
                let cell = tableView!.cellForRow(at: IndexPath(row: row, section: section))
                if cell is NormalImageTableCell {
                    let row = sec!.rows()[row]
                    tempVariable.setValue((cell as! NormalImageTableCell).titleTextField.text, forKey: row.key!)
                }
            }
        }
        
        if selectedInfo != nil {
            tempVariable.type = selectedInfo?.code
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        tempVariable.createTime = formatter.string(from: Date())
        
        return tempVariable
    }
    
    func finishAddPhotos(_ cell: CollectionViewCell) {
        addPhotoCount -= 1
        
        if addPhotoCount == 0 {
            EZLoadingActivity.hide()
            cell.addImages(self.addPhotos)
            variable.photos += self.addPhotos
        }
    }
    
    func saveToLocal(_ completion: @escaping () -> Void) {
        let variable = self.createVariable()
        variable.token = GlobalUtil.randomImageName()
        PCSDataManager.defaultManager().saveVariableToLocal(variable, completion: completion)
    }
    
    func cancelSaveToLocal(_ completion: @escaping () -> Void) {
        PCSDataManager.defaultManager().deleteLocalVariable(completion)
    }
    
    func uploadAddedPhotos(_ completion: (() -> Void)?) {
        func filter(_ element: String) -> String? {
            if oldPhotos.contains(element) == false {
                return element
            }
            
            return nil
        }
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! CollectionViewCell
        let images = cell.images
        let toAddImages = images.flatMap{filter($0)}
        
        let semaphore = DispatchSemaphore(value: 1)
        let queue = DispatchQueue(label: "UploadPhotos", attributes: [])
        let dispatchTimeout = DispatchTime.now() + Double(Int64(5 * 60 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
        
        queue.async(execute: { () -> Void in
            for image in toAddImages {
                semaphore.wait(timeout: dispatchTimeout)
                autoreleasepool(invoking: { () -> () in
                    let imageData = try? Data(contentsOf: URL(fileURLWithPath: UIImageView.pathForTempImage() + "/\(image)"))
                    let req = UploadPhotoReq()
                    req.variableID = self.variable.token!
                    req.fileName = image
                    req.file = imageData
                    req.requestCompletion({ (response) -> Void in
                        semaphore.signal()
                    })
                })
            }
            
            semaphore.wait(timeout: dispatchTimeout)
            DispatchQueue.main.async(execute: { () -> Void in
                completion?()
            })
            semaphore.signal()
        })
    }
    
    // MARK: - Actions
    
    @IBAction func clickSave(_ sender: AnyObject) {
        if pageType == VariablePageType.add {
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
    
    @IBAction func clickSubmit(_ sender: AnyObject) {
        if pageType == VariablePageType.add {
            variable.token = GlobalUtil.randomImageName()
            variable.submitted = true
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
    }
    
    @IBAction func clickDelete(_ sender: AnyObject) {
        let alert = UIAlertController(title: nil, message: "是否删除此履职记录", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.default) { (action) in
            
        }
        let sureAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default) { (action) in
            EZLoadingActivity.show("", disableUI: true)
            
            let req = DeleteVariableReq()
            req.variable = self.variable
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
        
        alert.addAction(cancelAction)
        alert.addAction(sureAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - AlertView
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - CollectionViewCellDelegate
    
    func didClickAdd(_ cell: CollectionViewCell) {
        if variable.submitted == true {
            return
        }
        
        self.view.endEditing(true)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        let picker = DKImagePickerController()
        picker.maxSelectableCount = 6
        picker.assetType = DKImagePickerControllerAssetType.allPhotos
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
                    let url = URL(string: UIImageView.pathForTempImage().appending("/\(imageName)"))
                    
                    do {
                        try imageData?.write(to: url!, options: .atomic)
                        self.addPhotos.append(imageName)
                    }
                    catch {}
                })
            }
            
            picker.dismiss(animated: true, completion: nil)
        }
        
        picker.didCancel = { () in
            picker.dismiss(animated: true, completion: nil)
        }
        
        self.present(picker, animated: true, completion: nil)
    }
    
    func didSelectIndex(_ cell: CollectionViewCell, index: Int) {
        if variable.submitted == true {
            return
        }
    }
    
    func didClickImage(_ cell: CollectionViewCell, image: UIImage) {
        let photoBrowser = PhotoBrowserView.view()
        photoBrowser.show(image)
    }
    
    func didLongPressIndex(_ cell: CollectionViewCell, index: Int) {
        let alert = UIAlertController(title: nil, message: "确定要删除照片吗？", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let sureAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default) { (action) -> Void in
            alert.dismiss(animated: true, completion: nil)
            
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
                            self.variable.photos.remove(at: self.variable.photos.index(of: req.photoID!)!)
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
        
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.default) { (action) -> Void in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(sureAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - TypeSelectView
    
    func didSelectIndex(_ view: TypeSelectView, indexPath: IndexPath) {
        selectedInfo = types[(indexPath as NSIndexPath).row]
        tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: UITableViewRowAnimation.none)
    }
    
    // MARK: - NormalImageTableCellDelegate
    
    func didEditing(_ cell: NormalImageTableCell) {
        tableView?.isScrollEnabled = false
        let keyboardHeight: CGFloat = 246.0
        let deltaY = cell.frame.origin.y + 50.0 - (tableView!.bounds.size.height - keyboardHeight) + tableView!.frame.origin.y
        
        if deltaY > 0 {
            tableView?.setContentOffset(CGPoint(x: 0, y: deltaY), animated: true)
        }
    }
    
    func didEndEditing(_ cell: NormalImageTableCell) {
        tableView?.setContentOffset(CGPoint.zero, animated: true)
        tableView?.isScrollEnabled = true
        
        let indexPath = tableView.indexPath(for: cell)
        let section = Sections(rawValue: (indexPath! as NSIndexPath).section)!
        let row = section.rows()[(indexPath! as NSIndexPath).row]
        variable.setValue(cell.titleTextField.text, forKey: row.key!)
    }
    
    func didEditingTime(_ cell: NormalImageTableCell, datePicker: DatePickerView) {
        self.view.endEditing(true)
        let keyboardHeight: CGFloat = datePicker.datePickerContainer.bounds.size.height
        let deltaY = cell.frame.origin.y + 50.0 - (tableView!.bounds.size.height - keyboardHeight) + tableView!.frame.origin.y
        
        if deltaY > 0 {
            tableView?.setContentOffset(CGPoint(x: 0, y: deltaY), animated: true)
        }
    }
    
    func didEndEditingTime(_ cell: NormalImageTableCell) {
        tableView?.setContentOffset(CGPoint.zero, animated: true)
        
        let indexPath = tableView.indexPath(for: cell)
        let section = Sections(rawValue: (indexPath! as NSIndexPath).section)!
        let row = section.rows()[(indexPath! as NSIndexPath).row]
        variable.setValue(cell.titleTextField.text, forKey: row.key!)
    }
    
    // MARK: - UIImagePicker
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("")
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.max.rawValue
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = Sections(rawValue: (indexPath as NSIndexPath).section)!
        
        if section == Sections.photos {
            return 130.0
        }
        
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sec = Sections(rawValue: section)!
        
        return sec.rows().count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1
        }
        
        return 18.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sec = Sections(rawValue: section)!
        
        if sec == Sections.photos {
            return 60.0
        }
        
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sec = Sections(rawValue: section)!
        
        if sec == Sections.photos {
            return footerView
        }
        
        let view = UIView()
        view.backgroundColor = UIColor.clear
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = Sections(rawValue: (indexPath as NSIndexPath).section)!
        
        if section == Sections.photos {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.delegate = self
            let row = section.rows()[(indexPath as NSIndexPath).row]
            cell.titleLabel.text = row.title
            cell.loadImages(variable.photos)
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NormalImageTableCell", for: indexPath) as! NormalImageTableCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let rows = section.rows()
        let row = rows[(indexPath as NSIndexPath).row]
        cell.headerText = row.title as NSString?
        cell.iconImageView.image = UIImage(named: row.icon!)
        cell.titleTextField.text = variable.value(forKey: row.key!) as? String
        cell.editable = !variable.submitted
        cell.delegate = self
        
        switch row.title! {
        case "类型:":
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.editable = false
            if selectedInfo != nil {
                cell.titleTextField.text = selectedInfo?.title
            }
            break
        case "时间:":
            cell.accessoryType = UITableViewCellAccessoryType.none
            cell.timeEditable = true
            break
        default:
            cell.accessoryType = UITableViewCellAccessoryType.none
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if variable.submitted == true {
            return
        }
        
        let section = Sections(rawValue: (indexPath as NSIndexPath).section)!
        let rows = section.rows()
        let row = rows[(indexPath as NSIndexPath).row]
        
        switch row.title! {
        case "类型:":
            EZLoadingActivity.show("", disableUI: true)
            PCSDataManager.defaultManager().getTypeInfo(PCSType.Personal) { (infos, errorCode) -> Void in
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
        
        if pageType == VariablePageType.add {
            var hasValue = false
            let tempVariable = self.createVariable()
            
            for key in Sections.allKeys() {
                hasValue = (tempVariable.value(forKey: key) as? String != "" && tempVariable.value(forKey: key) as? String != nil)
                
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
            
            let alert = UIAlertController(title: nil, message: "是否保存？", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (action) in
                self.cancelSaveToLocal({ 
                    self.navigationController?.popViewController(animated: true)
                })
            }
            let saveAction = UIAlertAction(title: "保存", style: UIAlertActionStyle.default) { (action) in
                self.saveToLocal({ 
                    self.navigationController?.popViewController(animated: true)
                })
            }
            
            alert.addAction(cancelAction)
            alert.addAction(saveAction)
            
            self.present(alert, animated: true, completion: nil)
            
            return true
        }
        
        return false
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
