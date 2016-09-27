//
//  UIWebView+HtmlInteract.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/9.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation
import UIKit

@objc protocol UIWebViewHtmlDelegate {
    
}

extension UIWebView {
    
    fileprivate struct AssociatedKeys {
        static var htmlDelegate = "htmlDelegate"
    }
    
    var htmlDelegate: UIWebViewHtmlDelegate? {
        get {
            let delegate = objc_getAssociatedObject(self, &AssociatedKeys.htmlDelegate)
            
            return delegate as? UIWebViewHtmlDelegate
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.htmlDelegate, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    func analysisHtmlCall(_ request: URLRequest) {
        let requestURLString = request.url?.absoluteString
        
        guard let components = requestURLString?.components(separatedBy: ":") else {
            return
        }
        
        let commandName = components[1]
        var args = [String: String]()
        
        if components.count > 2 {
            let argsString = components[2].removingPercentEncoding
            
            guard let argsData = argsString?.data(using: String.Encoding.utf8) else {
                return
            }
            
            do {
                args = try JSONSerialization.jsonObject(with: argsData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : String]
                self.callback(commandName, args: args)
            }
            catch {}
        }
    }
    
    func htmlRequest(_ method: String?, params: AnyObject?) {
        var jsCommand: String = ""
        var jsParams = ""
        
        defer {
            if method != nil {
                jsCommand = "\(method)(\(jsParams))"
            }
            else {
                jsCommand = jsParams
            }
            
            self.stringByEvaluatingJavaScript(from: jsCommand)
        }
        
        if (params != nil) {
            if params is Dictionary<String, AnyObject> {
                do {
                    let paramsData = try JSONSerialization.data(withJSONObject: params!, options: JSONSerialization.WritingOptions.prettyPrinted)
                    jsParams = String(data: paramsData, encoding: String.Encoding.utf8)!
                }
                catch {}
            }
            else if params is String {
                jsParams = params as! String
            }
        }
    }
    
    func hasHtmlCall(_ request: URLRequest) -> Bool {
        guard let requestURLString = request.url?.absoluteString else {
            return false
        }
        
        return requestURLString.hasPrefix("js-call:")
    }
    
    fileprivate func callback(_ method: String, args:Dictionary<String, String>) {}
    
}
