//
//  FeedbackViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/8.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit
import GrowingTextView

class FeedbackViewController: UIViewController {

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var feedbackTextView: GrowingTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        PCSCustomUtil.customNavigationController(self)
        
        CustomObjectUtil.customObjectsLayout([submitButton], backgroundColor: colorRed, borderWidth: 0, borderColor: nil, corner: 5.0)
        
        feedbackTextView.placeHolder = "请简要描述你的问题和建议"
        feedbackTextView.placeHolderColor = UIColor.lightGray
        feedbackTextView.maxHeight = 160.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions

    @IBAction func clickSubmit(_ sender: AnyObject) {
        let req = FeedbackReq()
        req.message = feedbackTextView.text
        req.requestCompletion { (response) -> Void in
            let result = response?.result
            var success: Bool = false
            var errorCode: String? = nil
            
            defer {
                if success == true {
                    self.feedbackTextView.text = nil
                    self.feedbackTextView.placeHolder = "请简要描述你的问题和建议"
                    self.showAlert("提交成功")
                }
                else {
                    self.showAlert("提交失败")
                    ResponseErrorManger.defaultManager().handleError(errorCode, message: "提交失败，请检查您的网络状况")
                }
            }
            
            if result?.isSuccess == true {
                guard let value = result?.value else {
                    success = false
                    
                    return
                }
                
                guard let responseString = HttpBaseReq.parseResponse(value) as? String else {
                    return
                }
                
                if ((responseString as NSString).intValue >= 1) {
                    success = true
                }
                else {
                    errorCode = responseString
                    success = false
                }
            }
            else {
                success = false
            }
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
