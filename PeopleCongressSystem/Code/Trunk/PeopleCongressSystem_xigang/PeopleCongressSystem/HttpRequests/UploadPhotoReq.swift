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
    var file: NSData? = nil
    var fileName = ""

    override init() {
        super.init()
    }
    
    override func requestCompletion(completion: HttpReqCompletion?) {
        var params = [String: AnyObject]()
        params["lvzhiguid"] = variableID
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token
        
        self.requestUpload(params, data: file!, key: "Files", name: fileName, completion: completion)
    }
    
}
