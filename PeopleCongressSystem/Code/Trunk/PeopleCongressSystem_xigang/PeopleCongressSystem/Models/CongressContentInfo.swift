//
//  CongressContentInfo.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/1.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation

enum HomeElementContentCongress: Int {
    case activityNotify = 0
    case variableRecords
    case analyze
    case shareSpace
    case congressInfo
    case notify
    case situation
    case review
    case suggestion
    case vote
    case max
    
    func title() -> String {
        let titles = ["活动提醒", "履职记录", "履职统计", "共享空间", "代表风采", "通知通报", "知情知政", "调查问卷", "建议意见", "投票表决", ""]
        
        return titles[self.rawValue]
    }
    
    func icon() -> String {
        let icons = ["huo_dong_ti_xing", "lv_zhi_ji_lu", "lv_zhi_tong_ji", "gong_xiang_kong_jian", "dai_biao_xin_xi", "tong_zhi_tong_bao", "zhi_qing_zhi_zheng", "diao_cha_wen_juan", "suggestion", "表决权", ""]
        
        return icons[self.rawValue]
    }
}

class CongressContentInfo: ContentInfo {
    
    override init() {
        super.init()
        
        actionDelegate = CongressHomeActionDelegate()
    }
    
    override var helpURL: String {
        return pageHTMLHelpCongress
    }
    
    override func homeElementCount() -> Int {
        return HomeElementContentCongress.max.rawValue
    }
    
    override func homeElementTitle(_ index: Int) -> String? {
        guard let row = HomeElementContentCongress(rawValue: index) else {
            return nil
        }
        
        return row.title()
    }
    
    override func homeElementIcon(_ index: Int) -> String {
        guard let row = HomeElementContentCongress(rawValue: index) else {
            return ""
        }
        
        return row.icon()
    }
    
}
