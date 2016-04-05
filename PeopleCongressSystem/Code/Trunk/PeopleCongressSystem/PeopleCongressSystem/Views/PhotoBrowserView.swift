//
//  PhotoBrowserView.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/4/5.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class PhotoBrowserView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageHeightLC: NSLayoutConstraint!
    
    override func awakeFromNib() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    func show(image: UIImage) {
        guard let window = UIApplication.sharedApplication().keyWindow else {
            return
        }
        
        var size = image.size
        size.height = size.height * 280.0 / size.width
        imageHeightLC.constant = size.height
        imageView.image = image
        
        self.frame = window.bounds
        window.addSubview(self)
        self.alpha = 0.0
        
        UIView.animateWithDuration(0.3, animations: { 
            self.setNeedsLayout()
            self.alpha = 1.0
            }) { (finished) in
        }
    }
    
    func dismiss() {
        UIView.animateWithDuration(0.3, animations: { 
            self.alpha = 0.0
            }) { (finished) in
                self.removeFromSuperview()
        }
    }
    
    func handleTapGesture(gesture: UITapGestureRecognizer) {
        self.dismiss()
    }
    
    // MARK: - Class Function
    
    class func view() -> PhotoBrowserView {
        let views = NSBundle.mainBundle().loadNibNamed("PhotoBrowserView", owner: self, options: nil)
        for view in views {
            if view is PhotoBrowserView {
                return view as! PhotoBrowserView
            }
        }
        
        return PhotoBrowserView()
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
