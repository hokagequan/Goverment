//
//  CongressContentInfo.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/1.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation

enum HomeElementContentCongress: Int {
    case ActivityNotify = 0
    case VariableRecords
    case Analyze
    case ShareSpace
    case CongressInfo
    case Notify
    case Situation
    case Max
    
    func title() -> String {
        let titles = ["活动提醒", "履职记录", "履职统计", "共享空间", "代表风采", "通知通报", "知情知政", ""]
        
        return titles[self.rawValue]
    }
    
    func icon() -> String {
        let icons = ["huo_dong_ti_xing", "lv_zhi_ji_lu", "lv_zhi_tong_ji", "gong_xiang_kong_jian", "dai_biao_xin_xi", "tong_zhi_tong_bao", "zhi_qing_zhi_zheng", ""]
        
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
        return HomeElementContentCongress.Max.rawValue
    }
    
    override func homeElementTitle(index: Int) -> String? {
        guard let row = HomeElementContentCongress(rawValue: index) else {
            return nil
        }
        
        return row.title()
    }
    
    override func homeElementIcon(index: Int) -> String {
        guard let row = HomeElementContentCongress(rawValue: index) else {
            return ""
        }
        
        return row.icon()
    }
    
}