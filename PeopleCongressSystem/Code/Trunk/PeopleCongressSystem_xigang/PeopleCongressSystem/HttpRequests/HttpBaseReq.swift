//
//  HttpBaseReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/1/19.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation
import Alamofire

typealias HttpReqCompletion = (_ response: DataResponse<String>?) -> Void
typealias HttpReqJSONCompletion = (_ response: DataResponse<Any>?) -> Void

class HttpBaseReq: NSObject {
    
//    var httpReqURL = SettingsManager.getData(SettingKey.Server.rawValue) as! String
    var httpReqURL = serverURL1
    
    /// @brief SOAP
    func request(_ method: String, nameSpace: String, params: Dictionary<String, Any>, completion: HttpReqCompletion?) {
        let soapMessage = self.soapMessage(method, params: params)
        let mutableURLRequest = NSMutableURLRequest(url: URL(string: self.httpReqURL + "appjiekout/jiekou/\(nameSpace).asmx")!)
        mutableURLRequest.setValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.setValue(self.soapAction(method), forHTTPHeaderField: "SOAPAction")
        mutableURLRequest.setValue(String(soapMessage.characters.count), forHTTPHeaderField: "Content-Length")
        mutableURLRequest.httpMethod = "POST"
        mutableURLRequest.httpBody = soapMessage.data(using: String.Encoding.utf8)
        
        let request = Alamofire.request(mutableURLRequest as! URLRequestConvertible)
//        request.responseString { (rsp) -> Void in
//            completion?(response: rsp)
//        }
        let gbkEncoding = CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.GB_18030_2000.rawValue))
        request.responseString(encoding: String.Encoding(rawValue: gbkEncoding)) { (rsp) -> Void in
            completion?(rsp)
        }
    }
    
    func requestUpload(_ params: Dictionary<String, AnyObject>, data: Data, key: String, name: String, completion: HttpReqCompletion?) {
        let spaceName = "BatchUploaderImg2.ashx" // 正式
//        let spaceName = "BatchUploaderImg3.ashx" // 测试
        Alamofire.upload(multipartFormData: { (formData) in
            for key in params.keys {
                let object = params[key]
                
                if object is NSData {
                    formData.append(object as! Data, withName: key)
                }
                else {
                    let value = (object as! NSObject).description
                    let valueData = value.data(using: String.Encoding.utf8)
                    formData.append(valueData!, withName: key)
                }
            }
            
            formData.append(data, withName: key, fileName: name, mimeType: "application/octet-stream")
            }, to: URL(string: self.httpReqURL + spaceName)!) { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.responseString(completionHandler: { (response) -> Void in
                        completion?(response)
                    })
                    break
                default:
                    completion?(nil)
                    break
                }
        }
    }
    
    func requestCompletion(_ completion: HttpReqCompletion?) {}
    
    func soapMessage(_ method: String, params: Dictionary<String, Any>) -> String {
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
        
        message = message.replacingOccurrences(of: "\\", with: "")
        
        return message
    }
    
    func soapAction(_ method: String) -> String {
        return (serverSoapAction + method)
    }
    
    // MARK: - Class Function
    
    class func parseResponse(_ response: String?) -> AnyObject? {
        if response == nil {
            return nil
        }
        
        guard let index = response!.range(of: "<?xml version=")?.lowerBound else {
            return nil
        }
        
        let jsonString = response?.substring(to: index)
        
        guard let data = jsonString?.data(using: String.Encoding.utf8) else {
            return nil
        }
        do {
            let object = try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.mutableContainers])
            
            return object as AnyObject?? ?? jsonString as AnyObject?
        }
        catch {
            return jsonString as AnyObject?
        }
    }
    
}
