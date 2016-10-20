//
//  NNComposeViewController.swift
//  NNWeiBo-0.0.0
//
//  Created by iOS on 16/10/17.
//  Copyright © 2016年 YMWM. All rights reserved.
//

import UIKit
import SVProgressHUD

class NNComposeViewController: UIViewController {

    /// 表情键盘
    private lazy var emojiVc: EmojiViewController = EmojiViewController {
        [unowned self] (emoji) -> () in
        self.textView.insertEmoji(emoji)
    }
    
    /// 图片选择器
    private lazy var imageSelectorVc: ImageSelectorController = ImageSelectorController()
    
    /// 工具条底部约束
    var toolbarBottonCons: NSLayoutConstraint?
    
    /// 图片选择器高度约束
    var imageViewHeightCons: NSLayoutConstraint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        // 注册通知监听键盘弹出和消失
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NNComposeViewController.keyboardChange(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        // 将键盘控制器添加为当前控制器的子控制器
        addChildViewController(emojiVc)
        addChildViewController(imageSelectorVc)
        
        // 1.初始化导航条
        setupNav()
        // 2.初始化输入框
        setupInpuView()
        // 3.初始化图片选择器
        setupImageView()
        // 4.初始化工具条
        setupToolbar()
        
    }
    
    /**
     只要键盘改变就会调用
     */
    func keyboardChange(notify: NSNotification) {
        
        // 1.取出键盘最终的rect
        let value = notify.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let rect = value.CGRectValue()
        
        let height = UIScreen.mainScreen().bounds.height
        toolbarBottonCons?.constant = -(height - rect.origin.y)
        
        // 3.更新界面
        let duration = notify.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        
        // 1.取出键盘的动画节奏
        let curve = notify.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        
        UIView.animateWithDuration(duration.doubleValue){ () -> Void in
            // 2.设置动画节奏
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: curve.integerValue)!)
            
            self.view.layoutIfNeeded()
        }
        
        let anim = toolbar.layer.animationForKey("position")
        print("duration = \(anim?.duration)")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // 主动召唤键盘
        if imageViewHeightCons?.constant == 0 {
            textView.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // 主动隐藏键盘
        textView.resignFirstResponder()
    }
    
    // 初始化输入框
    private func setupInpuView() {
        
        // 1.添加子控件
        view.addSubview(textView)
        textView.addSubview(placeholderLabel)
        textView.alwaysBounceVertical = true
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        
        // 2.布局子控件
        textView.xmg_Fill(view)
        placeholderLabel.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: textView, size: nil, offset: CGPoint(x: 5, y: 8))
    }
    
    /**
     初始化导航条
     */
    private func setupNav() {
    
        // 1.添加左边按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(NNComposeViewController.close))
        // 2.添加右边按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(NNComposeViewController.sendStatus))
        navigationItem.rightBarButtonItem?.enabled = false
        
        // 3.添加中间视图
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 32))
        let label1 = UILabel()
        label1.text = "发微博"
        label1.font = UIFont.systemFontOfSize(15)
        label1.sizeToFit()
        titleView.addSubview(label1)
        
        let label2 = UILabel()
        label2.text = NNUserAccount.loadAccount()?.screen_name
        label2.font = UIFont.systemFontOfSize(13)
        label2.textColor = UIColor.darkGrayColor()
        label2.sizeToFit()
        titleView.addSubview(label2)
        
        label1.xmg_AlignInner(type: XMG_AlignType.TopCenter, referView: titleView, size: nil)
        label2.xmg_AlignInner(type: XMG_AlignType.BottomCenter, referView: titleView, size: nil)
        
        navigationItem.titleView = titleView
    }
    
    
    /**
     初始化图片选择器
     */
    func setupImageView() {
        
        view.insertSubview(imageSelectorVc.view, belowSubview: toolbar)
        
        let size = UIScreen.mainScreen().bounds.size
        let width = size.width
        let height: CGFloat = 0
        let cons = imageSelectorVc.view.xmg_AlignInner(type: XMG_AlignType.BottomLeft, referView: view, size: CGSize(width: width, height: height))
        imageViewHeightCons = imageSelectorVc.view.xmg_Constraint(cons, attribute: NSLayoutAttribute.Height)
        
    }
    
    func setupToolbar() {
        
        // 1.添加子控件
        view.addSubview(toolbar)
        // 2.添加按钮
        var items = [UIBarButtonItem]()
        let itemSettings = [["imageName": "compose_toolbar_picture", "action": "selectPicture"],
                            
                            ["imageName": "compose_mentionbutton_background"],
                            
                            ["imageName": "compose_trendbutton_background"],
                            
                            ["imageName": "compose_emoticonbutton_background", "action": "inputEmoticon"],
                            
                            ["imageName": "compose_addbutton_background"]]
        
        for dict in itemSettings {
            let item = UIBarButtonItem(imageName: dict["imageName"]!, target: self, action: dict["action"])
            items.append(item)
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        toolbar.items = items
        
         // 3布局toolbar
        let width = UIScreen.mainScreen().bounds.width
        let cons = toolbar.xmg_AlignInner(type: XMG_AlignType.BottomLeft, referView: view, size: CGSize(width: width, height: 44))
        
        toolbarBottonCons = toolbar.xmg_Constraint(cons, attribute: NSLayoutAttribute.Bottom)
    }
    
    /**
     选择相片
     */
    func selectPicture() {
        // 1.关闭键盘
        textView.resignFirstResponder()
        
        // 2.调整图片选择器的高度
        imageViewHeightCons?.constant = UIScreen.mainScreen().bounds.height * 0.6
    }
    
    /**
     切换表情键盘
     */
    func inputEmoticon() {
        
        // 1.关闭键盘
        textView.resignFirstResponder()
        
        // 2.设置inputView
        textView.inputView = (textView.inputView == nil) ? emojiVc.view : nil
        
        // 3.从新召唤出键盘
        textView.becomeFirstResponder()
    }
    
    /**
     关闭控制器
     */
    func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
     发送文本微博
     */
    func sendStatus() {
        
        

        let text = textView.emojiAttributedText()
        let image = imageSelectorVc.pictureImages.first
        
        NNNetworkTools.shareNetWorkTools().sendStatus(text , image: image, successCallback: { (status) -> () in
            // 1.提示用户发送成功
            SVProgressHUD.showSuccessWithStatus("发送成功")
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
            // 2.关闭发送界面
            self.close()
        }) {
            (error) -> () in
            // 3.提示用户发送失败
            SVProgressHUD.showErrorWithStatus("发送失败")
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
        }
    }
 
    
    // MARK:- 懒加载
    private lazy var textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFontOfSize(20)
        tv.delegate = self
        return tv
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(20)
        label.textColor = UIColor.darkGrayColor()
        label.text = "分享新鲜事..."
        return label
     }()
    
    private lazy var toolbar: UIToolbar = UIToolbar()
    
    private lazy var tipLabel: UILabel = {
        let label = UILabel()
        return label
    }()
}

private let maxTipLength = 10
extension NNComposeViewController: UITextViewDelegate {
    
    func textViewDidChange(textView: UITextView) {
        // 注意点: 输入图片表情的时候不会促发textViewDidChange
        placeholderLabel.hidden = textView.hasText()
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
        
        // 当前已经输入的内容长度
        let count = textView.emojiAttributedText().characters.count
        let res = maxTipLength - count
        tipLabel.textColor = (res > 0) ? UIColor.darkGrayColor() : UIColor.redColor()
        tipLabel.text = res == maxTipLength ? "" : "\(res)"
    }
}
