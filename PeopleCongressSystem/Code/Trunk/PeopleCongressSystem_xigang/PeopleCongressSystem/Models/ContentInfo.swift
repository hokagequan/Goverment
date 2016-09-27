//
//  ContentInfo.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/2/24.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation

class ContentInfo {
    
    /// @brief 处理事件
    var actionDelegate: ActionProtocol? = nil
    
    /// @brief 帮助页面地址
    var helpURL: String {
        return ""
    }
    
    /// @brief 主页元素个数
    func homeElementCount() -> Int {
        return 0
    }
    
    /// @brief 主页元素Title
    func homeElementTitle(_ index: Int) -> String? {
        return nil
    }
    
    /// @brief 主页元素Icon
    func homeElementIcon(_ index: Int) -> String {
        return ""
    }
    
}
