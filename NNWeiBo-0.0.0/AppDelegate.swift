//
//  AppDelegate.swift
//  NNWeiBo-0.0.0
//
//  Created by iOS on 16/10/10.
//  Copyright © 2016年 YMWM. All rights reserved.
//

import UIKit

// 切换控制器通知
let NNSwitchRootViewControllerKey = "NNSwitchRootViewControllerKey"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func applicationDidEnterBackground(application: UIApplication) {
        
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // 注册一个通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.switchRootViewController(_:)), name: NNSwitchRootViewControllerKey, object: nil)
        
        // 设置导航条和工具条的外观
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        
        // 创建window
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        // 创建根控制器
        window?.rootViewController = defaultController()
        window?.makeKeyAndVisible()
        
        return true
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func switchRootViewController(notify: NSNotification) {
        if notify.object as! Bool {
            window?.rootViewController = NNTabBarController()
        } else {
            window?.rootViewController = NNWelcomeController()
        }
    }
    
    /**
     用于获取默认界面
     */
    private func defaultController() -> UIViewController {
        // 检测用户是否登录
        if NNUserAccount.userLogin() {
            return isNewUpdate() ? NNNewfeatureController() : NNWelcomeController()
        }
        return NNTabBarController()
    }
    
    private func isNewUpdate() -> Bool {
        //  获取当前软件的版本号
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        
        //  获取以前的软件版本号
        let sandboxVersion = NSUserDefaults.standardUserDefaults().objectForKey("CFBundleShortVersionString") as? String ?? ""
        
        //  比较当前版本号和以前版本号
        if currentVersion.compare(sandboxVersion) == NSComparisonResult.OrderedDescending {
            
             // 存储当前最新的版本号
            NSUserDefaults.standardUserDefaults().setObject(currentVersion, forKey: "CFBundleShortVersionString")
            return true
        }
        return false
    }
}

