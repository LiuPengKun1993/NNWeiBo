//
//  NNDiscoverTableViewController.swift
//  NNWeiBo-0.0.0
//
//  Created by iOS on 16/10/10.
//  Copyright © 2016年 YMWM. All rights reserved.
//

import UIKit

class NNDiscoverTableViewController: NNBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.如果没有登录, 就设置未登录界面的信息
        if !userLogin
        {
            visitorView?.setupVisitorInfo(false, imageName: "visitordiscover_image_message", message: "登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过")
        }
    }

}
