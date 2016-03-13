//
//  UIImageView+webImage.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/12.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

extension UIImageView {
    
    func loadImageURL(url: String?, name: String, placeholder: String) {
        self.image = UIImage(named: placeholder)
        
        if url == nil {
            return
        }
        
        let imageName = name
        let localPath = UIImageView.pathForTempImage().stringByAppendingString("/\(imageName)")
        
        if NSFileManager.defaultManager().fileExistsAtPath(localPath, isDirectory: nil) == true {
            self.image = UIImage(contentsOfFile: localPath)
            
            return
        }
        
        Alamofire.request(.GET, url!)
            .responseImage { response in
                if let image = response.result.value {
                    self.image = image
                    
                    let imageData = UIImageJPEGRepresentation(image, 1.0)
                    imageData?.writeToFile(localPath, atomically: true)
                }
        }
    }
    
    class func pathForTempImage() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentationDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        var path = paths.first
        
        path = path?.stringByAppendingString("/PCSCacheImage")
        
        if NSFileManager.defaultManager().fileExistsAtPath(path!, isDirectory: nil) == false {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(path!, withIntermediateDirectories: true, attributes: nil)
            }
            catch {}
        }
        
        return path!
    }
    
}