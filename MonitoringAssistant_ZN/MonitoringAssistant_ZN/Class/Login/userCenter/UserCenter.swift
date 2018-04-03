//
//  UserCenter.swift
//  MonitoringAssistant_ZN
//
//  Created by Chen on 2018/2/11.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

final class UserCenter: NSObject {
    
    static let isLogin       = "isLogin"
    static let companyCode   = "companyCode"
    static let orgCode       = "orgCode"
    static let empNo         = "empNo"
    static let empName       = "empName"
    static let loginName     = "loginName"
    static let mobile        = "mobile"
    
    static let loginMobile   = "loginMobile"
    static let loginPw       = "loginPw"


    
    static let shared = UserCenter()
    private override init() {}
    
//    typealias userCenterInfoBlock = () -> Void
    
    
}

extension UserCenter {
    
    
    func logIn( userModel : LoginModel) {
        
        //1、 保存
        UserDefaults .standard.set(true, forKey:UserCenter.isLogin)
        
        UserDefaults .standard.set(userModel.returnObj?.companyCode, forKey:UserCenter.companyCode)
        UserDefaults .standard.set(userModel.returnObj?.orgCode, forKey:UserCenter.orgCode)
        UserDefaults .standard.set(userModel.returnObj?.empNo, forKey:UserCenter.empNo)
        UserDefaults .standard.set(userModel.returnObj?.empName, forKey:UserCenter.empName)
        UserDefaults .standard.set(userModel.returnObj?.loginName, forKey:UserCenter.loginName)
        UserDefaults .standard.set(userModel.returnObj?.mobile, forKey:UserCenter.mobile)

        //2、同步
        UserDefaults .standard.synchronize()
        
    }
    
    func logOut() {
    
        //1、 保存
        UserDefaults .standard.set(false, forKey:UserCenter.isLogin)
        UserDefaults .standard.set("", forKey:UserCenter.loginPw)
        UserDefaults .standard.set("", forKey:UserCenter.loginMobile)

        
        UserDefaults .standard.set("", forKey:UserCenter.companyCode)
        UserDefaults .standard.set("", forKey:UserCenter.orgCode)
        UserDefaults .standard.set("", forKey:UserCenter.empNo)
        UserDefaults .standard.set("", forKey:UserCenter.empName)
        UserDefaults .standard.set("", forKey:UserCenter.loginName)
        UserDefaults .standard.set("", forKey:UserCenter.mobile)
        
        //2、同步
        UserDefaults .standard.synchronize()

        
    }
    
    func userInfo(Infor:@escaping (_ isLogin : Bool , _ userReturnModel : LoginReturnObjModel) -> ()) {
        
        let objModel = LoginReturnObjModel.init()
        
        objModel.companyCode = UserDefaults.standard.object(forKey: UserCenter.companyCode) as? String
        objModel.empName = UserDefaults.standard.object(forKey: UserCenter.empName) as? String
        objModel.empNo = UserDefaults.standard.object(forKey: UserCenter.empNo) as? String
        objModel.loginName = UserDefaults.standard.object(forKey: UserCenter.loginName) as? String
        objModel.mobile = UserDefaults.standard.object(forKey: UserCenter.mobile) as? String
        objModel.orgCode = UserDefaults.standard.object(forKey: UserCenter.orgCode) as? String
        
        Infor(UserDefaults.standard.bool(forKey: UserCenter.isLogin) , objModel)
        
//        return ( UserDefaults.standard.bool(forKey: UserCenter.isLogin), objModel)
    }
    
    func rememberPw(Pw:String) -> () {
        
        UserDefaults.standard.set(Pw, forKey:UserCenter.loginPw)
    }
    func rememberLoginMobile(mobile:String) -> () {
        
        UserDefaults.standard.set(mobile, forKey:UserCenter.loginMobile)
    }
    
    
    func loginMobile(mobile:@escaping ( _ mobile : String) -> ()) {
        
        let str = (UserDefaults.standard.object(forKey: UserCenter.loginMobile) as? String)
        
        mobile( str == nil ? "" : str!)
    }

    func loginPw(Pw:@escaping ( _ Pw : String) -> ()) {
        
        let str = (UserDefaults.standard.object(forKey: UserCenter.loginPw) as? String)
        Pw(str == nil ? "" : str!)
    }

}
