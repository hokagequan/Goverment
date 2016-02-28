//
//  WorkerContentInfo.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/2/24.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation

enum HomeElementContentWorker: Int {
    case ActivityManage = 0
    case VariableManage
    case Analyze
    case ShareSpace
    case CongressInfo
    case Notify
    case Situation
    case Max
    
    func title() -> String {
        let titles = ["活动管理", "履职管理", "履职统计", "共享空间", "代表信息", "通知通报", "知情知政", ""]
        
        return titles[self.rawValue]
    }
    
    func icon() -> String {
        let icons = ["huo_dong_guan_li", "lv_zhi_guan_li", "lv_zhi_tong_ji", "gong_xiang_kong_jian", "dai_biao_xin_xi", "tong_zhi_tong_bao", "zhi_qing_zhi_zheng", ""]
        
        return icons[self.rawValue]
    }
}

class WorderContentInfo: ContentInfo {
    
    override func homeElementCount() -> Int {
        return HomeElementContentWorker.Max.rawValue
    }
    
    override func homeElementTitle(index: Int) -> String? {
        guard let row = HomeElementContentWorker(rawValue: index) else {
            return nil
        }
        
        return row.title()
    }
    
    override func homeElementIcon(index: Int) -> String {
        guard let row = HomeElementContentWorker(rawValue: index) else {
            return ""
        }
        
        return row.icon()
    }
    
}