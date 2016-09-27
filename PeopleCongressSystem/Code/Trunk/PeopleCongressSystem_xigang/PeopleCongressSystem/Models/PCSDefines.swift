//
//  PCSDefines.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/2/29.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation

#if Debug
/// @brief Server 测试
let serverURL1 = "http://218.61.34.40:8301/"
let imageDownloadURL = "http://218.61.34.40:8301/lvzhiImage/"
let serverSoapAction = "http://tempuri.org/"
let photoDownloadURL = "http://218.61.34.40:8301/File/headimage/"
let qrCodeDownloadURL = "http://218.61.34.40:8301/download/appdownload.aspx/"
#else

/// @brief Server 正式
let serverURL1 = "http://rdlz.xigang.gov.cn:8099/"
let imageDownloadURL = "http://rdlz.xigang.gov.cn:8099/lvzhiImage/"
let serverSoapAction = "http://tempuri.org/"
let photoDownloadURL = "http://rdlz.xigang.gov.cn:8099/File/headimage/"
let qrCodeDownloadURL = "http://rdlz.xigang.gov.cn:8099/download/appdownload.aspx/"
#endif

/// @brief HTML Page
let pageHTMLVariableManagerWorker = "apph5/iphone/GZRY_lvzhiguanli.aspx?"
let pageHTMLVariableAnalyzeWorker = "apph5/iphone/GZRY_lvzhitongji.aspx?"
let pageHTMLShareSpaceWorker = "apph5/iphone/GZRY_gongxiangkongjianM.aspx?"
let pageHTMLCongressInfoWorker = "apph5/iphone/GZRY_daibaoxinxi.aspx?"
let pageHTMLNotifyWorker = "apph5/iphone/GZRY_tongzhitongbao.aspx?"
let pageHTMLSituationWorker = "apph5/iphone/GZRY_zhiqingzhizhenglist.aspx?"
let pageHTMLHelpWorker = "apph5/iphone/GZRY_helper.aspx?"
let pageHTMLCongressNotify = "apph5/iphone/RDDB_huodongtixing.aspx?"
let pageHTMLAnalyzeDetailCongress = "apph5/iphone/RDDB_lvzhitongjitouxi.aspx?"
let pageHTMLShareSpaceCongress = "apph5/iphone/RDDB_gongxiangkongjianM.aspx?"
let pageHTMLVariableAnalyzeCongress = "apph5/iphone/RDDB_lvzhitongjixq.aspx?"
let pageHTMLCongressInfoCongress = "apph5/iphone/RDDB_daibiaofengcai.aspx?"
let pageHTMLNotifyCongress = "apph5/iphone/RDDB_tongzhitongbao.aspx?"
let pageHtMLSituationCongress = "apph5/iphone/RDDB_zhiqingzhizhenglist.aspx?"
let pageHTMLHelpCongress = "apph5/iphone/RDDB_helper.aspx?"
let pageHTMLPolicy = "/apph5/iphone/pub_affiche.aspx?"
let pageHTMLQuestionnaire = "/apph5/iphone/RDDB_wenjuandati.aspx?"
let pageHTMLSuggestion = "/apph5/iphone/RDDB_jianyi_list.aspx?"
let pageHTMLAddSuggestion = "/apph5/iphone/RDDB_jianyi_add.aspx?typ=add&"
let pageHTMLVote = "/apph5/iphone/RDDB_biaojuelist.aspx?"

/// @brief Notification Keys
let kNotificationPresentLogin = "kNotificationPresentLogin"

let colorRed = GlobalUtil.colorRGBA(230, g: 27, b: 39, a: 1.0)

typealias SimpleCompletion = (Bool, String?, String?) -> Void

enum PCSType: String {
    case Personal = "0102"
    case Congress = "0101"
    case Party = "0006"
}
