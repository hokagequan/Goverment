//
//  PCSDefines.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/2/29.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation

/// @brief Server
let serverURL1 = "http://175.170.128.160:8099"
let serverURL2 = ""
let serverSoapAction = "http://tempuri.org/"

/// @brief HTML Page
let pageHTMLVariableManager = "/apph5/GZRY_lvzhiguanli.aspx?"
let pageHTMLVariableAnalyze = "/apph5/GZRY_lvzhitongji.aspx?"
let pageHTMLShareSpace = "/apph5/GZRY_gongxiangkongjianM.aspx?"

let colorRed = GlobalUtil.colorRGBA(230, g: 27, b: 39, a: 1.0)

typealias SimpleCompletion = (Bool, String?) -> Void

enum PCSType: String {
    case Personal = "0102"
    case Congress = "0101"
    case Party = "0006"
}