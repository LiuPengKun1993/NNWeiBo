//
//  NNMessageTableViewController.swift
//  NNWeiBo-0.0.0
//
//  Created by iOS on 16/10/10.
//  Copyright © 2016年 YMWM. All rights reserved.
//

import UIKit

class NNMessageTableViewController: NNBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if !userLogin
        {
            visitorView?.setupVisitorInfo(false, imageName: "visitordiscover_image_message", message: "登录后，别人评论你的微博，发给你的消息，都会在这里收到通知")
        }

    }

}
