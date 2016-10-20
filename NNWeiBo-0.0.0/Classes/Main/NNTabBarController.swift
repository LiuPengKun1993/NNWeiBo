//
//  NNTabBarController.swift
//  NNWeiBo-0.0.0
//
//  Created by iOS on 16/10/10.
//  Copyright © 2016年 YMWM. All rights reserved.
//

import UIKit

class NNTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 添加子控制器
        addChildViewControllers()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 添加加号按钮
        setupComposeBtn()
    }
    /**
     监听加号按钮点击
     */
    
    func composeBtnClick() {
        let composeVc = NNComposeViewController()
        let nav = UINavigationController(rootViewController: composeVc)
        presentViewController(nav, animated: true, completion: nil)
        
    }
    
    // MARK: - 内部控制方法
    private func setupComposeBtn() {
        
        // 1.添加加号按钮
        tabBar.addSubview(composeBtn)
        
        // 2.调整加号按钮的位置
        let width = UIScreen.mainScreen().bounds.size.width / CGFloat(viewControllers!.count)
        
        let rect = CGRect(x: 0, y: 0, width: width, height: 49)
        composeBtn.frame = CGRectOffset(rect, 2 * width, 0)
    }

    
    // MARK: - 添加子控制器
    private func addChildViewControllers() {
        
        addChildViewController(NNHomeTableViewController(), title: "首页", imageName: "tabbar_home", highImageName: "tabbar_home_highlighted")
        addChildViewController(NNMessageTableViewController(), title: "消息", imageName: "tabbar_message_center", highImageName: "tabbar_message_center_highlighted")
        
        addChildViewController(NNAddViewController(), title: "", imageName: "", highImageName: "")
        
        addChildViewController(NNDiscoverTableViewController(), title: "广场", imageName: "tabbar_discover", highImageName: "tabbar_discover_highlighted")
        addChildViewController(NNProfileTableViewController(), title: "我的", imageName: "tabbar_profile", highImageName: "tabbar_profile_highlighted")
    }

    
    private func addChildViewController(childController: UIViewController, title:String, imageName:String, highImageName:String) {
        
        // 1.设置首页对应的数据
        childController.tabBarItem.image = UIImage(named: imageName)
        childController.tabBarItem.selectedImage = UIImage(named: highImageName)
        childController.title = title
        
        // 2.给首页包装一个导航控制器
        let nav = UINavigationController()
        nav.addChildViewController(childController)
        
        // 3.将导航控制器添加到当前控制器上
        addChildViewController(nav)
    }
    
    // MARK: -懒加载
    private lazy var composeBtn:UIButton = {
    
        let btn = UIButton()
        
        // 2.设置前景图片
        btn.setImage(UIImage(named:"tabbar_compose_icon_add"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named:"tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        
        // 3.设置背景图片
        btn.setBackgroundImage(UIImage(named:"tabbar_compose_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named:"tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
       
        // 4.添加监听
        btn.addTarget(self, action: #selector(NNTabBarController.composeBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        
        return btn
    }()
}
  