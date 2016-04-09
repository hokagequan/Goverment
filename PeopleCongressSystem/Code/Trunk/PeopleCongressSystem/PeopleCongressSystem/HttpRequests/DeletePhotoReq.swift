//
//  DeletePhotoReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/17.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class DeletePhotoReq: HttpBaseReq {
    
    var photoID: String? = nil
    
    override init() {
        super.init()
    }
    
    func requestSimpleCompletion(completion: SimpleCompletion?) {
        var params = [String: AnyObject]()
        params["imgid"] = photoID
//        params["AddUser"] = PCSDataManager.defaultManager().accountManager.user!.identifier
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field
        params["thecharset"] = "gb2312"
        
        self.request("LvZhiImgDel", nameSpace: "rendadaibiao", params: params) { (response) -> Void in
            let result = response?.result
            
            var success: Bool = false
            var errorCode: String? = nil
            
            defer {
                if success == true {
                    completion?(true, "删除成功", errorCode)
                }
                else {
                    completion?(false, "删除失败，请检查您的网络状况", errorCode)
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
    
}
