//
//  PCSNavigationView.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/2/20.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

@objc protocol PCSNavigationViewDelegate {
    @objc optional func willDismiss() -> Bool
}

@IBDesignable class PCSNavigationView: UIView {
    
    @IBOutlet weak var viewController: UIViewController?
    @IBOutlet weak var delegate: PCSNavigationViewDelegate?
    
    @IBInspectable var title: String?
    @IBInspectable var backHidden: Bool = false {
        didSet {
            backButton.isHidden = backHidden
        }
    }

    let backgroundView = UIView(frame: CGRect.zero)
    let backButton = UIButton(type: UIButtonType.custom)
    let titleLabel = UILabel(frame: CGRect.zero)
    
    var backTitle: String = ""
    
    override var bounds: CGRect {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForInterfaceBuilder() {
        backButton.sizeToFit()
    }

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.clipsToBounds = true
        
        if self.subviews.contains(backgroundView) == false {
            CustomObjectUtil.customObjectsLayout([backgroundView], backgroundColor: GlobalUtil.colorRGBA(242, g: 203, b: 94, a: 1.0), borderWidth: 0.0, borderColor: UIColor.clear, corner: 3.0)
            self.addSubview(backgroundView)
            self.sendSubview(toBack: backgroundView)
        }
        
        var frame = backgroundView.frame
        frame.origin = CGPoint(x: 6.0, y: -0.5)
        frame.size = CGSize(width: self.bounds.size.width - 12.0, height: self.bounds.size.height)
        backgroundView.frame = frame
        
        if self.subviews.contains(backButton) == false {
            if backTitle.characters.count > 0 {
                backButton.setTitle(backTitle, for: UIControlState())
                backButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
            }
            else {
                backButton.setImage(UIImage(named: "navi_back"), for: UIControlState())
            }
            backButton.setTitleColor(colorRed, for: UIControlState())
            backButton.addTarget(self, action: #selector(PCSNavigationView.clickBack), for: UIControlEvents.touchUpInside)
            self.addSubview(backButton)
        }
        
        frame = backButton.frame
        frame.origin.x = 12.0
        frame.size = CGSize(width: 44, height: 15)
        backButton.frame = frame
        backButton.center = CGPoint(x: backButton.center.x, y: self.bounds.size.height / 2.0)
        
        if self.subviews.contains(titleLabel) == false {
            titleLabel.backgroundColor = UIColor.clear
            titleLabel.textColor = UIColor.red
            titleLabel.textAlignment = NSTextAlignment.center
            titleLabel.font = UIFont.systemFont(ofSize: 15.0)
            self.addSubview(titleLabel)
        }
        
        frame = titleLabel.frame
        frame.size = self.bounds.size
        titleLabel.frame = frame
        titleLabel.text = title
    }
    
    // MARK: - Actions
    
    func clickBack() {
        if delegate?.willDismiss?() == true {
            return
        }
        
        self.viewController?.navigationController?.popViewController(animated: true)
    }

}
