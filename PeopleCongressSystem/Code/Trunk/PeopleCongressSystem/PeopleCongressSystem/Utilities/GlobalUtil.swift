//
//  GlobalUtil.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/2/24.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation
import UIKit

class GlobalUtil {
    
    class func colorRGBA(r:CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    class func rateForHeight() -> CGFloat {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        
        return app.window!.bounds.size.height / CGFloat(667.0)
    }
    
    class func rateForWidth() -> CGFloat {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        
        return app.window!.bounds.size.height / CGFloat(667.0)
    }
    
}