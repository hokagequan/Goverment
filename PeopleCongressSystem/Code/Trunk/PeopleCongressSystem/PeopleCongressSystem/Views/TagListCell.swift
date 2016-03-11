//
//  TagListCell.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/1/20.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit
import TagListView

class TagListCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagList: TagListView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadPersons(persons: Array<Person>?) {
        if persons == nil {
            tagList.removeAllTags()
            
            return
        }
        
        for i in 0..<persons!.count {
            let person = persons![i]
            if person.organization == nil {
                self.tagList.addTag("\(person.name!)")
                
                continue
            }
            
            self.tagList.addTag("\(person.organization!):\n\(person.name!)")
        }
    }
    
    class func cellHeight(persons: Array<Person>?) -> CGFloat {
        if persons != nil {
            let tempTagList = TagListView()
            tempTagList.paddingY = 5.0
            tempTagList.marginY = 5.0
            tempTagList.frame = CGRectMake(0, 0, GlobalUtil.rateForWidth() * 320.0, 0)
            
            for i in 0..<persons!.count {
                let person = persons![i]
                
                if person.organization == nil {
                    tempTagList.addTag("\(person.name!)")
                    
                    continue
                }
                tempTagList.addTag("\(person.organization!):\n\(person.name!)")
            }
            
            return tempTagList.intrinsicContentSize().height + 44.0 + 5.0
        }
        
        return 44.0
    }

}
