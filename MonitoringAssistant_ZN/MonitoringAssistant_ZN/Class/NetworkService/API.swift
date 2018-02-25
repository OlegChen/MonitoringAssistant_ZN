//
//  API.swift
//  swift_test
//
//  Created by apple on 2017/10/19.
//  Copyright © 2017年 chenxianghong. All rights reserved.
//

import Foundation



//public struct API {

private let baseURL = "http://plat.znxk.net:6803"


//MARK:- ---  接口
//登录
public let LoginUrl = baseURL + "/user/login"
//修改密码
public let ChangePwUrl = baseURL + "/user/modifyPwd"
//收费
public let FeeUrl = baseURL + "/charge/overview"
//用能概况
public let profilesDataUrl = baseURL + "/useenergy/profilesData"
//黄金对标
public let goldStandardDataUrl = baseURL + "/useenergy/goldStandardAllData"
//用能监测
public let moniterDataUrl = baseURL + "/useenergy/moniterData"
//工单管理
public let workOrderAllDataUrl = baseURL + "/repair/workOrderAllData"
//转派工单
public let workSendPageUrl = baseURL + "/repair/workSendPage"
//选择派单（派单员工列表）
public let sendEmpListUrl = baseURL + "/repair/sendEmpList"
//派单/改派
public let workSendUrl = baseURL + "/repair/workSend"


//}

//private static let baseURL = "https://www.designernews.co"
