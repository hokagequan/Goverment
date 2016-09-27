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
    
    func loadImageURL(_ url: String?, name: String, placeholder: String) {
        self.image = UIImage(named: placeholder)
        
        if url == nil {
            return
        }
        
        let imageName = name
        let localPath = UIImageView.pathForTempImage() + "/\(imageName)"
        
        if FileManager.default.fileExists(atPath: localPath, isDirectory: nil) == true {
            self.image = UIImage(contentsOfFile: localPath)
            
            return
        }
        
        Alamofire.request(url!).responseImage { (response) in
            if let image = response.result.value {
                self.image = image
                
                let imageData = UIImageJPEGRepresentation(image, 1.0)
                let toURL = URL(string: localPath)
                do {
                    try imageData?.write(to: toURL!, options: .atomic)
                }
                catch {}
            }
        }
    }
    
    class func pathForTempImage() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentationDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        var path = paths.first
        
        path = path! + "/PCSCacheImage"
        
        if FileManager.default.fileExists(atPath: path!, isDirectory: nil) == false {
            do {
                try FileManager.default.createDirectory(atPath: path!, withIntermediateDirectories: true, attributes: nil)
            }
            catch {}
        }
        
        return path!
    }
    
}
