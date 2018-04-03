//
//  AppDelegate.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/1/12.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,BMKGeneralDelegate {

    var window: UIWindow?
    
    var blockRotation: Bool = false
    
    var _mapManager: BMKMapManager?
    
//    SJNavigationPopGesture.install()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        
        UITextField.appearance().tintColor = RGBCOLOR(r: 74, 144, 181)
        
        _mapManager = BMKMapManager()
        // 如果要关注网络及授权验证事件，请设定generalDelegate参数
        let ret = _mapManager?.start("T861GXQXTnAYjvF1MxfGlGpXGgFg4yhY", generalDelegate: self)
        if ret == false {
            NSLog("manager start failed!")
        }
        
        //登录 ？
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        
        UserCenter.shared.userInfo{ (islogin, userReturnModel) in
            
            if (islogin){
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let initViewController: NavigationController = storyBoard.instantiateViewController(withIdentifier: "rootNav") as! NavigationController
                self.window?.rootViewController = initViewController
                
            }else{
                //未登录
                let vc = LoginVC.getLoginVC()
                self.window?.rootViewController = vc
            }
        }
        

        
        self.window?.makeKeyAndVisible()
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        if self.blockRotation{
            return UIInterfaceOrientationMask.landscapeRight
            
        } else {
            
            return UIInterfaceOrientationMask.portrait
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

