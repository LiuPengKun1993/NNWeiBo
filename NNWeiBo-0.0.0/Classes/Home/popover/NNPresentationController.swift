//
//  NNPresentationController.swift
//  NNWeiBo-0.0.0
//
//  Created by iOS on 16/10/11.
//  Copyright © 2016年 YMWM. All rights reserved.
//

import UIKit

class NNPresentationController: UIPresentationController {
    
    /// 定义属性保存菜单的大小
    var presentFrame = CGRectZero
    
    
    /**
     初始化方法, 用于创建负责转场动画的对象
     */
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
    }
    
    /**
     即将布局转场子视图时调用
     */
    override func containerViewWillLayoutSubviews() {
        
        // 1.修改弹出视图的大小
        presentedView()?.frame = CGRect(x: 100, y: 56, width: 200, height: 200)
        
        // 2.在容器视图上添加一个蒙版, 插入到展现视图的下面
        containerView?.insertSubview(coverView, atIndex: 0)
    }

    // MARK: - 懒加载
    private lazy var coverView: UIView = {
    
        // 1.创建view
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        view.frame = UIScreen.mainScreen().bounds
        
        // 2.添加监听
        let tap = UITapGestureRecognizer(target: self, action: #selector(NSStream.close))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    func close() {
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
