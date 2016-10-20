//
//  NNVisitorView.swift
//  NNWeiBo-0.0.0
//
//  Created by iOS on 16/10/11.
//  Copyright © 2016年 YMWM. All rights reserved.
//

import UIKit

// Swift中如何定义协议: 必须遵守NSObjectProtocol
protocol NNVisitorViewDelegate: NSObjectProtocol {
    // 登录回调
    func loginBtnWillClick()
    // 注册回调
    func registerBtnWillClick()
}

class NNVisitorView: UIView {
    
    // 定义一个属性保存代理对象
    // 一定要加上weak, 避免循环引用
    weak var delegate: NNVisitorViewDelegate?
    
    /**
     设置未登录界面
     */
    func setupVisitorInfo(isHome:Bool, imageName:String, message:String) {
        // 如果不是首页, 就隐藏转盘
        iconView.hidden = !isHome
        // 修改中间图标
        homeIcon.image = UIImage(named: imageName)
        // 修改文本
        messageLabel.text = message
        
        // 判断是否需要执行动画
        if isHome {
            startAnimation()
        }
    }
    
    // MARK: - startAnimation
    private func startAnimation(){
        
        // 1.创建动画
        let anim = CABasicAnimation(keyPath:"transform.rotation")
        
        // 2.设置动画属性
        anim.toValue = 2 * M_PI
        anim.duration = 20
        anim.repeatCount = MAXFLOAT
        
        // 该属性默认为YES, 代表动画只要执行完毕就移除
        anim.removedOnCompletion = false
        
        // 3.将动画添加到图层上
        iconView.layer.addAnimation(anim, forKey: nil)
    }
    
    func loginBtnClick() {
        delegate?.loginBtnWillClick()
    }
    
    func registerBtnClick() {
        delegate?.registerBtnWillClick()
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 1.添加子控件
        addSubview(iconView)
        addSubview(maskBGView)
        addSubview(homeIcon)
        addSubview(messageLabel)
        addSubview(loginButton)
        addSubview(registerButton)
        
        // 2.布局子控件
        // 2.1设置背景
        iconView.xmg_AlignInner(type: XMG_AlignType.Center, referView: self, size: nil)
        
        // 2.2设置小房子
        homeIcon.xmg_AlignInner(type: XMG_AlignType.Center, referView: self, size: nil)
        
        // 2.3设置文本
        messageLabel.xmg_AlignVertical(type: XMG_AlignType.BottomCenter, referView: iconView, size: nil)
        
        let widthCons = NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 224)
        addConstraint(widthCons)
     
        // 2.4设置按钮
        registerButton.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: messageLabel, size: CGSize(width: 100, height: 30), offset: CGPoint(x: 0, y: 20))
        
        loginButton.xmg_AlignVertical(type: XMG_AlignType.BottomRight, referView: messageLabel, size: CGSize(width: 100, height: 30), offset: CGPoint(x: 0, y: 20))
        
        // 2.5设置蒙版
        maskBGView.xmg_Fill(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

    // MARK:-懒加载控件
    /// 转盘
    private lazy var iconView:UIImageView = {
        let iv = UIImageView(image: UIImage(named:"visitordiscover_feed_image_smallicon"))
        return iv
    }()
    
    /// 图标
    private lazy var homeIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
        return iv
    }()
    
    /// 文本
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0;
        label.textColor = UIColor.darkGrayColor()
//        label.font = UIFont.systemFontOfSize(14)
        label.text = "欢迎来到 NNWeiBo"
        label.textAlignment = NSTextAlignment.Center
        return label
    }()
    
    /// 登陆按钮
    private lazy var loginButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        btn.setTitle("登录", forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named:"common_button_white_disable"), forState: UIControlState.Normal)
        btn.addTarget(self, action: #selector(NNVisitorView.loginBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    /// 注册按钮
    private lazy var registerButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        btn.setTitle("注册", forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named:"common_button_white_disable"), forState: UIControlState.Normal)
        btn.addTarget(self, action: #selector(NNVisitorView.registerBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    
    /// 蒙板
    private lazy var maskBGView: UIImageView = {
        let iv = UIImageView(image: UIImage(named:"visitordiscover_feed_mask_smallicon"))
        return iv
    }()
}
