//
//  AccountManager.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/1/19.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation
import CoreData

class AccountManager {
    
    var user: UserEntity? = nil
    
    init() {
        self.getDefaultUser()
    }
    
    func getDefaultUser() {
        let context = CoreDataManager.defalutManager().managedObjectContext
        let fetchReq = NSFetchRequest(entityName: "UserEntity")
        fetchReq.predicate = NSPredicate(format: "isDefault == %@", true)
        
        do {
            let fetchObjects = try context.executeFetchRequest(fetchReq)
            user = fetchObjects.first as? UserEntity
        }
        catch {
            user = nil
        }
    }
    
    func changePassword(theOld: String, theNew: String, completion: SimpleCompletion?) {
        let req = ChangePasswordReq()
        req.theNew = theNew
        req.theOld = theOld
        
        req.requestCompletion { (response) -> Void in
            let result = response?.result
            var success: Bool = false
            
            defer {
                if success == true {
                    completion?(true, nil)
                }
                else {
                    completion?(false, "保存失败")
                }
            }
            
            if result?.isSuccess == true {
                guard let value = result?.value else {
                    success = false
                    
                    return
                }
                
                if ((value as NSString).intValue >= 1) {
                    success = true
                    
                    let context = CoreDataManager.defalutManager().managedObjectContext
                    let fetchReq = NSFetchRequest(entityName: "UserEntity")
                    fetchReq.predicate = NSPredicate(format: "account == %@", self.user!.account!)
                    
                    do {
                        let users = try context.executeFetchRequest(fetchReq) as! Array<UserEntity>
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
                    success = false
                }
            }
            else {
                success = false
            }
        }
    }
    
    func getInfo(completion: SimpleCompletion?) {
        let req = GetCongressInfoReq()
        req.requestCompletion { (response) -> Void in
            let result = response?.result
            
            var success = false
            var message = ""
            
            defer {
                completion?(success, message)
            }
            
            if result?.isFailure == true {
                message = "获取失败"
                
                return
            }
            
            guard let infos = HttpBaseReq.parseResponse(result?.value) else {
                message = "获取失败"
                
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
    
    func signIn(account: String, password: String, completion: SimpleCompletion?) {
        let req = SignInReq()
        req.account = account
        req.password = password
        req.requestCompletion { (response) -> Void in
            let result = response?.result
            if result?.isFailure == true {
                completion?(false, "登录失败")
                
                return
            }
            
            guard let _ = result?.value else {
                completion?(false, "登录失败")
                
                return
            }
            
            guard let info = HttpBaseReq.parseResponse(result?.value) else {
                completion?(false, "登录失败")
                
                return
            }
            
            guard let _ = info["user_ID"] as? String else {
                completion?(false, "登录失败")
                
                return
            }
            
            let context = CoreDataManager.defalutManager().managedObjectContext
            let fetchReq = NSFetchRequest(entityName: "UserEntity")
            
            do {
                self.user = nil
                let users = try context.executeFetchRequest(fetchReq) as! Array<UserEntity>
                
                for storeUser in users {
                    storeUser.isDefault = false
                    
                    if storeUser.account == req.account {
                        self.user = storeUser
                    }
                }
                
                if self.user == nil {
                    self.user = NSEntityDescription.insertNewObjectForEntityForName("UserEntity", inManagedObjectContext: context) as? UserEntity
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
                
                CoreDataManager.defalutManager().saveContext(nil)
                
                if self.user?.memberType == "301" {
                    PCSDataManager.defaultManager().content = CongressContentInfo()
                }
                else {
                    PCSDataManager.defaultManager().content = WorderContentInfo()
                }
                
                if PCSDataManager.defaultManager().deviceToken != nil {
                    let req = SubmitDeviceTokenReq()
                    req.deviceToken = PCSDataManager.defaultManager().deviceToken!
                    req.requestSimpleCompletion()
                }
                
                completion?(true, nil)
            }
            catch {
                completion?(false, "数据库错误")
            }
        }
    }
    
}
