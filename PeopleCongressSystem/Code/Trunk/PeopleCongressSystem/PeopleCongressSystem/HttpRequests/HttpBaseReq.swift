//
//  HttpBaseReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/1/19.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation
import Alamofire

typealias HttpReqCompletion = (response: Response<String, NSError>?) -> Void
typealias HttpReqJSONCompletion = (response: Response<AnyObject, NSError>?) -> Void

class HttpBaseReq {
    
//    var httpReqURL = SettingsManager.getData(SettingKey.Server.rawValue) as! String
    var httpReqURL = serverURL1
    
    /// @brief JSON
    func request(method: String, params: Dictionary<String, AnyObject>, completion: HttpReqJSONCompletion?) {
        Alamofire.request(.POST, httpReqURL + method, parameters: params, encoding: .JSON, headers: nil)
                 .responseJSON { (rsp) -> Void in
                    completion?(response: rsp)
                 }
    }
    
    /// @brief SOAP
    func request(method: String, nameSpace: String, params: Dictionary<String, AnyObject>, completion: HttpReqCompletion?) {
        let soapMessage = self.soapMessage(method, params: params)
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: self.httpReqURL + "appjiekout/jiekou/\(nameSpace).asmx")!)
        mutableURLRequest.setValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.setValue(self.soapAction(method), forHTTPHeaderField: "SOAPAction")
        mutableURLRequest.setValue(String(soapMessage.characters.count), forHTTPHeaderField: "Content-Length")
        mutableURLRequest.HTTPMethod = "POST"
        mutableURLRequest.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding)
        
        let request = Alamofire.request(mutableURLRequest)
//        request.responseString { (rsp) -> Void in
//            completion?(response: rsp)
//        }
        let gbkEncoding = CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.GB_18030_2000.rawValue))
        request.responseString(encoding: gbkEncoding) { (rsp) -> Void in
            completion?(response: rsp)
        }
    }
    
    func requestUpload(params: Dictionary<String, AnyObject>, data: NSData, key: String, name: String, completion: HttpReqCompletion?) {
//        let spaceName = "BatchUploaderImg2.ashx" // 正式
        let spaceName = "BatchUploaderImg3.ashx" // 测试
        Alamofire.upload(.POST, NSURL(string: self.httpReqURL + spaceName)!, multipartFormData: { (formData) -> Void in
            for key in params.keys {
                let object = params[key]
                
                if object is NSData {
                    formData.appendBodyPart(data: object as! NSData, name: key)
                }
                else {
                    let value = (object as! NSObject).description
                    let valueData = value.dataUsingEncoding(NSUTF8StringEncoding)
                    formData.appendBodyPart(data: valueData!, name: key)
                }
            }
            
            formData.appendBodyPart(data: data, name: key, fileName: name, mimeType: "application/octet-stream")
            }) { (result) -> Void in
                switch result {
                case .Success(let upload, _, _):
                    upload.responseString(completionHandler: { (response) -> Void in
                        completion?(response: response)
                    })
                    break
                default:
                    completion?(response: nil)
                    break
                }
        }
    }
    
    func requestCompletion(completion: HttpReqCompletion?) {}
    
    func soapMessage(method: String, params: Dictionary<String, AnyObject>) -> String {
        var message: String = String()
        message += "<?xml version='1.0' encoding='utf-8'?>"
        message += "<soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'>"
        message += "<soap:Body>"
        message += "<\(method) xmlns='\(serverSoapAction)'>"
        
        for key in params.keys {
            message += "<\(key)>\(params[key]!)</\(key)>"
        }
        message += "</\(method)>"
        message += "</soap:Body>"
        message += "</soap:Envelope>"
        
        message = message.stringByReplacingOccurrencesOfString("\\", withString: "")
        
        return message
    }
    
    func soapAction(method: String) -> String {
        return (serverSoapAction + method)
    }
    
    // MARK: - Class Function
    
    class func parseResponse(response: String?) -> AnyObject? {
        if response == nil {
            return nil
        }
        
        guard let index = response!.rangeOfString("<?xml version=")?.startIndex else {
            return nil
        }
        
        let jsonString = response?.substringToIndex(index)
        
        guard let data = jsonString?.dataUsingEncoding(NSUTF8StringEncoding) else {
            return nil
        }
        do {
            return try NSJSONSerialization.JSONObjectWithData(data, options: [NSJSONReadingOptions.MutableContainers, NSJSONReadingOptions.AllowFragments])
        }
        catch {
            return nil
        }
    }
    
}
