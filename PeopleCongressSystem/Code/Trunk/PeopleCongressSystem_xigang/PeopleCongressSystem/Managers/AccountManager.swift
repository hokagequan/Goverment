//
//  AccountManager.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/1/19.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class AccountManager: NSObject {
    
    //证书id
    let certID = "Vh2Ayp+qlaEYsgRUtv8XE4NlKhI="
    
    //签名值
    let strSignData = "123456"
    
    var user: UserEntity? = nil
    
    override init() {
        super.init()
        
        self.getDefaultUser()
        self.loadCA()
    }
    
    func getDefaultUser() {
        let context = CoreDataManager.defalutManager().managedObjectContext
        let fetchReq: NSFetchRequest<UserEntity> = NSFetchRequest(entityName: "UserEntity")
        fetchReq.predicate = NSPredicate(format: "isDefault == %@", NSNumber(value: true))
        
        do {
            let fetchObjects = try context.fetch(fetchReq)
            user = fetchObjects.first
        }
        catch {
            user = nil
        }
    }
    
    func loadCA() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        let path = (paths.first)! + "/lnca.db"
        
        if FileManager.default.fileExists(atPath: path) == false {
            let dbPath = Bundle.main.path(forResource: "lnca", ofType: "db")!
            do {
                try FileManager.default.copyItem(atPath: dbPath, toPath: path)
            }
            catch {}
        }
        
        return path
    }
    
    // MARK: - Server
    
    func changePassword(_ theOld: String, theNew: String, completion: SimpleCompletion?) {
        let req = ChangePasswordReq()
        req.theNew = theNew
        req.theOld = theOld
        
        req.requestCompletion { (response) -> Void in
            let result = response?.result
            var success: Bool = false
            var errorCode: String? = nil
            
            defer {
                if success == true {
                    completion?(true, nil, errorCode)
                }
                else {
                    completion?(false, "保存失败", errorCode)
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
                    
                    let context = CoreDataManager.defalutManager().managedObjectContext
                    let fetchReq: NSFetchRequest<UserEntity> = NSFetchRequest(entityName: "UserEntity")
                    fetchReq.predicate = NSPredicate(format: "account == %@", self.user!.account!)
                    
                    do {
                        let users = try context.fetch(fetchReq)
                        let storeUser = users.first
                        
                        if storeUser == nil {
                            return
                        }
                        
                        storeUser?.password = theNew
                        
                        CoreDataManager.defalutManager().saveContext(nil)
                    }
                    catch {
                        success = true
                    }
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
    
    func getInfo(_ completion: SimpleCompletion?) {
        let req = GetCongressInfoReq()
        req.requestCompletion { (response) -> Void in
            let result = response?.result
            
            var success = false
            var message = ""
            var errorCode: String? = nil
            
            defer {
                completion?(success, message, errorCode)
            }
            
            if result?.isFailure == true {
                message = "获取失败，请检查您的网络状况"
                
                return
            }
            
            guard let infos = HttpBaseReq.parseResponse(result?.value) else {
                message = "获取失败，请检查您的网络状况"
                
                return
            }
            
            if infos is String {
                errorCode = infos as? String
                return
            }
            
            if infos.count == 0 {
                return
            }
            
            success = true
            let info = (infos as! Array<AnyObject>).first as! Dictionary<String, AnyObject>
            
//            self.user?.identifier = info["RDDB_ID"] as? String
//            self.user?.congressID = info["RDDB_Guid"] as? String
            self.user?.photoName = info["RDDB_HeadPic"] as? String
            self.user?.qrCode = info["RDDB_QRCode"] as? String
            self.user?.organizationID = info["RDDB_Org"] as? String
            self.user?.congressCode = info["RDDB_Code"] as? String
            self.user?.name = info["RDDB_Name"] as? String
            self.user?.gender = info["RDDB_Sex"] as? String
            self.user?.birthday = info["RDDB_Birthday"] as? String
            self.user?.nation = info["RDDB_Nation"] as? String
            self.user?.job = info["RDDB_Job"] as? String
            self.user?.address = info["RDDB_Address"] as? String
            self.user?.zip = info["RDDB_Zip"] as? String
            self.user?.party = info["RDDB_Party"] as? String
            self.user?.education = info["RDDB_Education_QRZ"] as? String
            self.user?.educationWork = info["RDDB_Education_ZZ"] as? String
            self.user?.workTime = info["RDDB_Work_Time"] as? String
            self.user?.tel = info["RDDB_Tel"] as? String
            self.user?.place = info["RDDB_Place"] as? String
            self.user?.state = info["RDDB_State"] as? Int
            self.user?.remark = info["RDDB_Remark"] as? String
            self.user?.sort = info["RDDB_Sort"] as? Int
            self.user?.addTime = info["RDDB_AddTime"] as? String
            self.user?.addUser = info["RDDB_AddUser"] as? String
            self.user?.hasDeleted = info["RDDB_IsDel"] as? Bool
            self.user?.organization = info["DBT_NAME"] as? String
        }
    }
    
    func signIn(_ account: String, password: String, completion: SimpleCompletion?) {
        let semaphore = DispatchSemaphore(value: 0)
        let queue = DispatchQueue(label: "PCSSignInQueue", attributes: [])
        var error = false
        let errorCode: String? = nil
        
        queue.async {
            // 登录
            var isUseCA = false
            
            let appReq = GetAppInfoReq()
            appReq.requestSimpleCompletion({ (response) in
                isUseCA = response
            })
            
            let req = SignInReq()
            req.account = account
            req.password = password
            req.requestCompletion { (response) -> Void in
                let result = response?.result
                if result?.isFailure == true {
                    semaphore.signal()
                    
                    return
                }
                
                guard let _ = result?.value else {
                    semaphore.signal()
                    
                    return
                }
                
                guard let info = HttpBaseReq.parseResponse(result?.value) as? [String: Any] else {
                    semaphore.signal()
                    
                    return
                }
                
                guard let _ = info["user_ID"] as? String else {
                    semaphore.signal()
                    
                    return
                }
                
                let context = CoreDataManager.defalutManager().managedObjectContext
                let fetchReq: NSFetchRequest<UserEntity> = NSFetchRequest(entityName: "UserEntity")
                
                do {
                    self.user = nil
                    let users = try context.fetch(fetchReq)
                    
                    for storeUser in users {
                        storeUser.isDefault = false
                        
                        if storeUser.account == req.account {
                            self.user = storeUser
                        }
                    }
                    
                    if self.user == nil {
                        self.user = NSEntityDescription.insertNewObject(forEntityName: "UserEntity", into: context) as? UserEntity
                    }
                    
                    self.user?.account = account
                    self.user?.password = password
                    self.user?.isDefault = true
                    
                    self.user?.identifier = info["user_ID"] as? String
                    self.user?.congressID = info["user_GUID"] as? String
                    self.user?.name = info["User_FirstName"] as? String
                    self.user?.token = info["CheckTicket"] as? String
                    self.user?.memberType = info["MemberType"] as? String
                    self.user?.field = info["STAFF_FieldID"] as? String
                    self.user?.huanxinAccount = info["hunxinID"] as? String
                    
                    CoreDataManager.defalutManager().saveContext(nil)
                    
                    if self.user?.memberType == "301" {
                        PCSDataManager.defaultManager().content = CongressContentInfo()
                    }
                    else {
                        PCSDataManager.defaultManager().content = WorderContentInfo()
                    }
                    
                    let req = SubmitDeviceTokenReq()
                    req.deviceToken = PCSDataManager.defaultManager().deviceToken
                    req.requestSimpleCompletion()
                    
                    error = true
                    semaphore.signal()
                }
                catch {
                    semaphore.signal()
                }
            }
            
            semaphore.wait(timeout: DispatchTime.distantFuture)
            if error == false {
                semaphore.signal()
                DispatchQueue.main.async(execute: {
                    completion?(false, "用户名或密码错误", errorCode)
                })
                
                return
            }
            
            if isUseCA == true {
                // CA
                var randString: String? = nil
                let caReq = GetCARandReq()
                caReq.requestSimple({ (rand) in
                    randString = rand
                    semaphore.signal()
                })
                
                semaphore.wait(timeout: DispatchTime.distantFuture)
                if randString == nil {
                    semaphore.signal()
                    DispatchQueue.main.async(execute: {
                        completion?(false, "用户名或密码错误", errorCode)
                    })
                    
                    return
                }
                //证书base64
                let certBase64 = MiddlewareAPI.instance().getCertByID(self.certID, 1)
                
                //签名结果转成base64
                let signedBase64 = MiddlewareAPI.instance().sign(byID: self.certID, randString)
                
                let signedCAReq = SignCAReq()
                signedCAReq.rand = randString!
                signedCAReq.cert = (certBase64?.addingPercentEscapes(using: String.Encoding.utf8)!)!
                signedCAReq.signed = (signedBase64?.addingPercentEscapes(using: String.Encoding.utf8)!)!
                signedCAReq.requestSimple({ (success) in
                    semaphore.signal()
                    DispatchQueue.main.async(execute: {
                        completion?(true, nil, errorCode)
                    })
                })
            }
            else {
                semaphore.signal()
                DispatchQueue.main.async(execute: {
                    completion?(true, nil, errorCode)
                })
            }
            
            semaphore.wait(timeout: DispatchTime.distantFuture)
            if self.user?.huanxinAccount == nil {
                semaphore.signal()
                
                return
            }
            
            EMClient.shared().login(withUsername: self.user?.huanxinAccount, password: "123456")
            EMClient.shared().setApnsNickname(self.user?.name)
            semaphore.signal()
        }
    }
    
}
