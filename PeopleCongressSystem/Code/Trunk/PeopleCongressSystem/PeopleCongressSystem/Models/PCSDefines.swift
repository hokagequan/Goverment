//
//  PCSDefines.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/2/29.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation

/// @brief Server
let serverURL1 = "http://175.170.128.160:8099/"
let imageDownloadURL = "http://218.25.160.202:8099/lvzhiImage/"
let serverSoapAction = "http://tempuri.org/"
let photoDownloadURL = "http://175.170.128.160:8099/File/headimage/"
let qrCodeDownloadURL = "http://175.170.128.160:8099/File/QRCode/"

/// @brief HTML Page
let pageHTMLVariableManager = "/apph5/iphone/GZRY_lvzhiguanli.aspx?"
let pageHTMLVariableAnalyze = "/apph5/iphone/GZRY_lvzhitongji.aspx?"
let pageHTMLShareSpace = "/apph5/iphone/GZRY_gongxiangkongjianM.aspx?"
let pageHTMLCongressInfo = "/apph5/iphone/GZRY_daibaoxinxi.aspx?"
let pageHTMLNotify = "/apph5/iphone/GZRY_tongzhitongbao.aspx?"
let pageHTMLSituation = "/apph5/iphone/GZRY_zhiqingzhizhenglist.aspx?"
let pageHTMLHelp = "/apph5/iphone/GZRY_helper.aspx?"
let pageHTMLCongressNotify = "/apph5/iphone/RDDB_huodongtixing.aspx?"

let colorRed = GlobalUtil.colorRGBA(230, g: 27, b: 39, a: 1.0)

typealias SimpleCompletion = (Bool, String?) -> Void

enum PCSType: String {
    case Personal = "0102"
    case Congress = "0101"
    case Party = "0006"
}