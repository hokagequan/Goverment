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

class HttpBaseReq {
    
//    var httpReqURL = SettingsManager.getData(SettingKey.Server.rawValue) as! String
    var httpReqURL = serverURL1
    
    /// @brief JSON
//    func request(params: Dictionary<String, AnyObject>, completion: HttpReqCompletion?) {
//        Alamofire.request(.POST, httpReqURL, parameters: params, encoding: .JSON, headers: nil)
//                 .responseJSON { (rsp) -> Void in
//                    completion?(response: rsp)
//                 }
//    }
    
    /// @brief SOAP
    func request(method: String, params: Dictionary<String, AnyObject>, completion: HttpReqCompletion?) {
        let soapMessage = self.soapMessage(method, params: params)
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: self.httpReqURL + "/appjiekout/jiekou/gonggong.asmx")!)
        mutableURLRequest.setValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.setValue(self.soapAction(method), forHTTPHeaderField: "SOAPAction")
        mutableURLRequest.setValue(String(soapMessage.characters.count), forHTTPHeaderField: "Content-Length")
        mutableURLRequest.HTTPMethod = "POST"
        mutableURLRequest.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding)
        
        let request = Alamofire.request(mutableURLRequest)
        request.responseString { (rsp) -> Void in
            completion?(response: rsp)
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
    
    class func parseResponse(response: String?) -> Dictionary<String, AnyObject>? {
        if response == nil {
            return nil
        }
        
        guard let index = response!.rangeOfString("}")?.endIndex else {
            return nil
        }
        
        let jsonString = response?.substringToIndex(index)
        
        guard let data = jsonString?.dataUsingEncoding(NSUTF8StringEncoding) else {
            return nil
        }
        do {
            return try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? Dictionary<String, AnyObject>
        }
        catch {
            return nil
        }
    }
    
}
