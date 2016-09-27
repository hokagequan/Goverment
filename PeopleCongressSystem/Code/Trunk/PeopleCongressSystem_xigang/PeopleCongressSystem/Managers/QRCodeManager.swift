//
//  QRCodeManager.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/5/3.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation

enum QRCodeType: String {
    case ActivityID = "大连人大履职系统活动ID"
}

class QRCodeManager {
    
    func handleCode(_ code: String, personID: String, completion: @escaping (Bool, PCSError?) -> Void) {
        if code == "Non" {
            completion(false, PCSError.qrCodeError("未识别的二维码"))
            
            return
        }
        
        let array = code.components(separatedBy: ":")
        
        if array.count != 2 {
            completion(false, PCSError.qrCodeError("未识别的二维码"))
            
            return
        }
        
        guard let qrCodeType = QRCodeType(rawValue: array.last!) else {
            completion(false, PCSError.qrCodeError("未识别的二维码"))
            
            return
        }

        switch qrCodeType {
        case .ActivityID:
            self.checkInActivity(array.first!, personID: personID, completion: completion)
            break
//        default:
//            break
        }
    }
    
    // Private
    
    fileprivate func checkInActivity(_ activityID: String, personID: String, completion: @escaping (Bool, PCSError?) -> Void) {
        let req = CheckInReq()
        req.activityID = activityID
        req.qrCodes = [personID]
        req.requestCompletion { (response) -> Void in
            let result = response?.result
            var success: Bool = false
            var errorCode: String? = nil
            
            defer {
                var error: PCSError? = nil
                
                if success == false {
                    if errorCode != "-1" {
                        error = PCSError.qrCodeError("签到失败")
                    }
                    else {
                        ResponseErrorManger.defaultManager().handleError(errorCode, message: nil)
                    }
                }
                
                completion(success, error)
            }
            
            if result?.isSuccess == true {
                guard let responseString = HttpBaseReq.parseResponse(result?.value) as? String else {
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
