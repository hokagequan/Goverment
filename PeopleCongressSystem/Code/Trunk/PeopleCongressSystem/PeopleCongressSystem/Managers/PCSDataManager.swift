//
//  PCSDataManager.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/1/19.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation

class PCSDataManager {
    
    static let _pcsDataManager = PCSDataManager()
    
    var accountManager = AccountManager()
    var content: ContentInfo = ContentInfo()
    
    // MARK: - Class Functions
    
    class func defaultManager() -> PCSDataManager {
        return _pcsDataManager;
    }
    
    init() {
    }
    
    /// @brief 添加活动
    func addActivity(activity: Activity, completion: SimpleCompletion?) {
        let req = AddActivityReq()
        req.activity = activity
        
        req.requestCompletion { (response) -> Void in
            let result = response?.result
            var success: Bool = false
            
            defer {
                if success == true {
                    completion?(true, nil)
                }
                else {
                    completion?(false, "添加失败")
                }
            }
            
            if result?.isSuccess == true {
                guard let value = result?.value else {
                    success = false
                    
                    return
                }
                
                if ((value as NSString).intValue >= 1) {
                    success = true
                }
                else {
                    success = false
                }
            }
            else {
                success = false
            }
        }
    }
    
    func getTypeInfo(type: PCSType, completion: ((Array<PCSTypeInfo>?) -> Void)?) {
        let req = GetActivityTypesReq()
        req.type = type
        
        req.requestCompletion { (response) -> Void in
            var relArray: Array<PCSTypeInfo>? = nil
            
            defer {
                completion?(relArray)
            }
            
            let result = response?.result
            
            if result?.isSuccess == true {
                guard let value = result?.value else {
                    return
                }
                
                let info = HttpBaseReq.parseResponse(value) as! NSArray
                relArray = [PCSTypeInfo]()
                for i in 0..<info.count {
                    let dict = info[i] as! Dictionary<String, AnyObject>
                    let typeInfo = PCSTypeInfo()
                    typeInfo.title = dict["Name"] as? String
                    typeInfo.code = dict["GUID"] as? String
                    typeInfo.sort = dict["shuzi"] as? String
                    typeInfo.type = dict["DmlbID"] as? String
                    relArray?.append(typeInfo)
                }
            }
        }
    }
    
}
