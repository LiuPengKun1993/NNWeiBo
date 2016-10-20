//
//  NNBaseTableViewController.swift
//  NNWeiBo-0.0.0
//
//  Created by iOS on 16/10/11.
//  Copyright © 2016年 YMWM. All rights reserved.
//

import UIKit

class NNBaseTableViewController: UITableViewController, NNVisitorViewDelegate {
    
    // 定义一个变量保存用户当前是否登录
    var userLogin = NNUserAccount.userLogin()
    // 定义属性保存未登录界面
    var visitorView: NNVisitorView?
    
    override func loadView() {
        userLogin ? super.loadView() : setupVisitorView()
    }
    
    /**
     创建未登录界面
     */
    private func setupVisitorView() {
    
        // 1.初始化未登录界面
        let customView = NNVisitorView()
        customView.delegate = self
        view = customView
        visitorView = customView
        
        // 2.设置导航条未登录按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(NNBaseTableViewController.registerBtnWillClick))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(NNBaseTableViewController.loginBtnWillClick))
    }

// MARK: - VisitorViewDelegate
    func loginBtnWillClick() {
        let OAuthVc = NNOAuthViewController()
        let navigation = UINavigationController(rootViewController: OAuthVc)
        presentViewController(navigation, animated: true, completion: nil)
    }
    
    func registerBtnWillClick() {
    }

}
