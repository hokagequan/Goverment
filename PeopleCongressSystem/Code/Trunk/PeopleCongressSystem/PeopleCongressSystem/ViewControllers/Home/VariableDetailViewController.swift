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

class VariableDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CollectionViewCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TypeSelectViewDelegate {
    
    enum Sections: Int {
        
        case MainContent = 0
        case Detail
        case Photos
        case Max
        
        func rows() -> Array<Row> {
            let titles = [["标题:", "类型:", "人员:"],
                ["内容:", "备注:"],
                ["履职现场:"]
            ]
            
            let icons = [["title", "type", "organization"],
                ["content", "content"],
                [""]
            ]
            
            let keys = [["title", "typeTitle", "persons"],
                ["content", "remark"],
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
    
    var variable: Variable = Variable()
    var pageType = VariablePageType.Detail
    var selectedInfo: PCSTypeInfo? = nil
    var types = [PCSTypeInfo]()
    var addPhotoCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        PCSCustomUtil.customNavigationController(self)
        
        tableView.registerNib(UINib(nibName: "NormalImageTableCell", bundle: nil), forCellReuseIdentifier: "NormalImageTableCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        return tempVariable
    }
    
    func finishAddPhotos() {
        addPhotoCount--
        
        if addPhotoCount == 0 {
            EZLoadingActivity.hide()
            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 2)], withRowAnimation: UITableViewRowAnimation.None)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func clickSave(sender: AnyObject) {
        variable.identifier = GlobalUtil.randomImageName()
        EZLoadingActivity.show("", disableUI: true)
        
        PCSDataManager.defaultManager().addVariable(self.createVariable()) { (success, message) -> Void in
            if success {
                // TODO: 上传照片
                EZLoadingActivity.hide()
            }
            else {
                EZLoadingActivity.hide()
                self.showAlert(message!)
            }
        }
    }
    
    // MARK: - CollectionViewCellDelegate
    
    func didClickAdd(cell: CollectionViewCell) {
        let picker = DKImagePickerController()
        picker.maxSelectableCount = 6
        picker.assetType = DKImagePickerControllerAssetType.AllPhotos
        picker.didSelectAssets = {(assets: [DKAsset]) in
            self.addPhotoCount = assets.count
            EZLoadingActivity.show("", disableUI: true)
            for asset in assets {
                asset.fetchFullScreenImageWithCompleteBlock({ (image, info) -> Void in
                    if image == nil {
                        return
                    }
                    
                    let imageData = UIImageJPEGRepresentation(image!, 1.0)
                    let imageName = GlobalUtil.randomImageName()
                    imageData?.writeToFile(UIImageView.pathForTempImage().stringByAppendingString("/\(imageName)"), atomically: true)
                    self.variable.photos.append(imageName)
                    self.finishAddPhotos()
                    
                    let req = UploadPhotoReq()
                    req.variableID = "111"
                    req.files = [imageData!]
                    req.requestCompletion({ (response) -> Void in
                        let result = response?.result
                        print("\(result)")
                    })
                })
            }
            
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
        
        picker.didCancel = { () in
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
        
        self.presentViewController(picker, animated: true, completion: nil)
//        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
//        
//        let albumAction = UIAlertAction(title: "相册", style: UIAlertActionStyle.Default) { (action) -> Void in
//            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
//                let pickerViewController = UIImagePickerController()
//                pickerViewController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
//                pickerViewController.mediaTypes = [kUTTypeImage as String]
//                pickerViewController.delegate = self
//                pickerViewController.allowsEditing = false
//                
//                self.presentViewController(pickerViewController, animated: true, completion: nil)
//            }
//        }
//        
//        let cameraAction = UIAlertAction(title: "拍照", style: UIAlertActionStyle.Default) { (action) -> Void in
//            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
//                let pickerViewController = UIImagePickerController()
//                pickerViewController.sourceType = UIImagePickerControllerSourceType.Camera
//                pickerViewController.mediaTypes = [kUTTypeMovie as String]
//                pickerViewController.delegate = self
//                pickerViewController.allowsEditing = false
//                
//                self.presentViewController(pickerViewController, animated: true, completion: nil)
//            }
//        }
//        
//        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Default) { (action) -> Void in
//            alert.dismissViewControllerAnimated(true, completion: nil)
//        }
//        
//        alert.addAction(albumAction)
//        alert.addAction(cameraAction)
//        alert.addAction(cancelAction)
//        
//        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func didSelectIndex(cell: CollectionViewCell, index: Int) {
        // TODO: 点击照片
    }
    
    // MARK: - TypeSelectView
    
    func didSelectIndex(view: TypeSelectView, indexPath: NSIndexPath) {
        selectedInfo = types[indexPath.row]
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
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
            return 100.0
        }
        
        return 50.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sec = Sections(rawValue: section)!
        
        return sec.rows().count
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
        
        switch row.title! {
        case "类型:":
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.editable = false
            if selectedInfo != nil {
                cell.titleTextField.text = selectedInfo?.title
            }
            break
        default:
            cell.accessoryType = UITableViewCellAccessoryType.None
            break
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = Sections(rawValue: indexPath.section)!
        let rows = section.rows()
        let row = rows[indexPath.row]
        
        switch row.title! {
        case "类型:":
            EZLoadingActivity.show("", disableUI: true)
            PCSDataManager.defaultManager().getTypeInfo(PCSType.Congress) { (infos) -> Void in
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
