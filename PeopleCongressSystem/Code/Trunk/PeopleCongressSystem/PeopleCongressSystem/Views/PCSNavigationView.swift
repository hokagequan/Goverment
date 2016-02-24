//
//  PCSNavigationView.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/2/20.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

@IBDesignable class PCSNavigationView: UIView {
    
    @IBOutlet weak var viewController: UIViewController?
    
    @IBInspectable var title: String? = "Title"
    
    let backgroundView = UIView(frame: CGRectZero)
    let backButton = UIButton(type: UIButtonType.Custom)
    let titleLabel = UILabel(frame: CGRectZero)
    
    override var bounds: CGRect {
        didSet {
            self.setNeedsDisplay()
        }
    }

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        self.clipsToBounds = true
        
        if self.subviews.contains(backgroundView) == false {
            CustomObjectUtil.customObjectsLayout([backgroundView], backgroundColor: UIColor.yellowColor(), borderWidth: 0.0, borderColor: UIColor.clearColor(), corner: 3.0)
            self.addSubview(backgroundView)
        }
        
        var frame = backgroundView.frame
        frame.origin = CGPointMake(6.0, -0.5)
        frame.size = CGSizeMake(self.bounds.size.width - 12.0, self.bounds.size.height)
        backgroundView.frame = frame
        
        if self.subviews.contains(backButton) == false {
            backButton.setImage(UIImage(named: "navi_back"), forState: UIControlState.Normal)
            self.addSubview(backButton)
        }
        
        frame = backButton.frame
        frame.origin.x = 12.0
        frame.size = backButton.imageForState(UIControlState.Normal)!.size
        backButton.frame = frame
        backButton.center = CGPointMake(backButton.center.x, self.bounds.size.height / 2.0)
        backButton.addTarget(self, action: Selector("clickBack"), forControlEvents: UIControlEvents.TouchUpInside)
        
        if self.subviews.contains(titleLabel) == false {
            titleLabel.backgroundColor = UIColor.clearColor()
            titleLabel.textColor = UIColor.redColor()
            titleLabel.textAlignment = NSTextAlignment.Center
            titleLabel.font = UIFont.systemFontOfSize(15.0)
            self.addSubview(titleLabel)
        }
        
        frame = titleLabel.frame
        frame.size = self.bounds.size
        titleLabel.frame = frame
        titleLabel.text = title
    }
    
    // MARK: - Actions
    
    func clickBack() {
        self.viewController?.navigationController?.popViewControllerAnimated(true)
    }

}
