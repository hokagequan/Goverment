//
//  UploadPhotoReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/14.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class UploadPhotoReq: HttpBaseReq {
    
    var variableID: String = ""
    var files = [AnyObject]()

    override init() {
        super.init()
    }
    
    override func requestCompletion(completion: HttpReqCompletion?) {
        var params = [String: AnyObject]()
        params["lvzhiguid"] = variableID
        params["Files"] = files
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token
        params["thecharset"] = "gb2312"
        
        self.requestUpload(params, completion: completion)
    }
    
}
