//
//  NNHomeTableViewController.swift
//  NNWeiBo-0.0.0
//
//  Created by iOS on 16/10/10.
//  Copyright © 2016年 YMWM. All rights reserved.
//

import UIKit
import SVProgressHUD

let NNHomeReuseIdentifier = "NNHomeReuseIdentifier"


class NNHomeTableViewController: NNBaseTableViewController {
    
    /// 保存微博数组
    var statuses: [NNStatus]? {
        didSet {
            // 当别人设置完毕数据, 就刷新表格
            tableView.reloadData()
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 如果没有登录, 就设置未登录界面的信息
        if !userLogin
        {
            visitorView?.setupVisitorInfo(true, imageName: "visitordiscover_feed_image_house", message: "关注一些人，回这里看看有什么惊喜")
            return
        }
        // 初始化导航条
        setupNav()
        
        // 注册通知, 监听菜单
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NNHomeTableViewController.change), name: NNPopoverAnimatorWillShow, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NNHomeTableViewController.change), name: NNPopoverAnimatorWillDismiss, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NNHomeTableViewController.showPhotoBrowser(_:)), name: NNStatusPictureViewSelected, object: nil)
        
        // 注册两个cell
        tableView.registerClass(NNStatusNormalTableViewCell.self, forCellReuseIdentifier: NNStatusTableViewCellIdentifier.NormalCell.rawValue)
        tableView.registerClass(NNStatusForwardTableViewCell.self, forCellReuseIdentifier: NNStatusTableViewCellIdentifier.ForwardCell.rawValue)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // 4.添加下拉刷新控件
        refreshControl = NNHomeRefreshControl()
        refreshControl?.addTarget(self, action: #selector(NNHomeTableViewController.loadData), forControlEvents: UIControlEvents.ValueChanged)
        
        // 4.加载微博数据
        loadData()
    }
    
    /**
     显示图片浏览器
     */
    func showPhotoBrowser(notify: NSNotification) {
        // 注意: 如果通过通知传递数据, 一定要判断数据是否存在
        guard let indexPath = notify.userInfo![NNStatusPictureViewIndexKey] as? NSIndexPath
         else {
            return
        }
        
        guard let urls = notify.userInfo![NNStatusPictureViewURLsKey] as? [NSURL] else {
            print("没有配图")
            return
        }
        // 1.创建图片浏览器
        let vc = NNPhotoBrowserController(index: indexPath.item, urls: urls)
        // 2.显示图片浏览器
        presentViewController(vc, animated: true, completion: nil)
        

    }
    
    deinit {
    // 移除通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /// 定义变量记录当前是上拉还是下拉
    var pullupRefreshFlag = false
    
    /**
     获取微博数据
     */
    @objc private func loadData() {
        // 1.默认当做下拉处理
        var since_id = statuses?.first?.id ?? 0
        
        var max_id = 0
        // 2.判断是否是上拉
        if pullupRefreshFlag {
            since_id = 0
            max_id = statuses?.last?.id ?? 0
        }
        
        NNStatus.loadStatuses(since_id, max_id: max_id) { (models, error) -> () in
            
            // 接收刷新
            self.refreshControl?.endRefreshing()
            
            if error != nil {
                return
            }
            
            // 下拉刷新
            if since_id > 0 {
                
                // 如果是下拉刷新, 就将获取到的数据, 拼接在原有数据的前面
                self.statuses = models! + self.statuses!
                
                // 显示刷新提醒
                self.showNewStatusCount(models?.count ?? 0)
            } else if max_id > 0 {
                // 如果是上拉加载更多, 就将获取到的数据, 拼接在原有数据的后面
                self.statuses = self.statuses! + models!
            } else {
                self.statuses = models
            }
        }
    }
    
    /**
     显示刷新提醒
     */
    private func showNewStatusCount(count: Int) {
        newStatusLabel.hidden = false
        newStatusLabel.text = (count == 0) ? "没有刷新到新的微博数据" : "刷新到\(count)条微博数据"
        
        UIView.animateWithDuration(2, animations: { () -> Void in
        self.newStatusLabel.transform = CGAffineTransformMakeTranslation(0, self.newStatusLabel.frame.height)
        }) { (_) -> Void in
            UIView.animateWithDuration(2, animations: { () -> Void in
                self.newStatusLabel.transform = CGAffineTransformIdentity
                }, completion: { (_) -> Void in
                    self.newStatusLabel.hidden = true
            })
        }
    }
    
    /**
     修改标题按钮的状态
     */
    func change() {
        
        // 修改标题按钮的状态
        let titleBtn = navigationItem.titleView as! NNTitleButton
        titleBtn.selected = !titleBtn.selected
    }
    
    // 2.初始化导航条
    private func setupNav() {
        // 1.初始化左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem.creatBarButtonItem("navigationbar_friendattention", target: self, action: #selector(NNHomeTableViewController.leftItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.creatBarButtonItem("navigationbar_pop", target: self, action: #selector(NNHomeTableViewController.rightItemClick))
        
        // 2.初始化标题按钮
        let titleBtn = NNTitleButton()
        titleBtn.setTitle("柳钟宁 ", forState: UIControlState.Normal)
        titleBtn.addTarget(self, action: #selector(NNHomeTableViewController.titleBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.titleView = titleBtn
    }
    
    func titleBtnClick(btn: NNTitleButton) {
        
        // 弹出菜单
        let sb = UIStoryboard(name: "NNPopoverViewController", bundle: nil)
        
        let vc = sb.instantiateInitialViewController()
        
        // 设置转场代理
        vc?.transitioningDelegate = popverAnimator
        
        // 设置转场的样式
        vc?.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        presentViewController(vc!, animated: true, completion: nil)
    }
    
    func leftItemClick() {
    }
    func rightItemClick() {
        let qrcode = UIStoryboard(name: "NNQRCodeViewController", bundle: nil)
        
        let qrcodeVc = qrcode.instantiateInitialViewController()
        presentViewController(qrcodeVc!, animated: true, completion: nil)
    }
    
    // MARK: - 懒加载
    private lazy var popverAnimator: NNPopoverAnimator = {
        let popover = NNPopoverAnimator()
        popover.presentFrame = CGRect(x: 100, y: 56, width: 200, height: 250)
        return popover
    }()
    
    /// 刷新提醒控件
    private lazy var newStatusLabel: UILabel = {
        let label = UILabel()
        let height: CGFloat = 44
        label.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: height)
        label.backgroundColor = UIColor.orangeColor()
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        
        // 加载 navBar 上面，不会随着 tableView 一起滚动
        self.navigationController?.navigationBar.insertSubview(label, atIndex: 0)
        
        label.hidden = true
        return label
    }()
    
    
    /// 微博行高的缓存, 利用字典作为容器. key就是微博的id, 值就是对应微博的行高
    var rowCache: [Int: CGFloat] = [Int: CGFloat]()
    
    override func didReceiveMemoryWarning() {
        // 清空缓存
        rowCache.removeAll()
    }
    
}

extension NNHomeTableViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let status = statuses![indexPath.row]
        
        // 获取cell
        let cell = tableView.dequeueReusableCellWithIdentifier(NNStatusTableViewCellIdentifier.cellID(status), forIndexPath: indexPath) as! NNHomeTableViewCell
        cell.status = status
        
        // 判断是否滚动到了最后一个cell
        let count = statuses?.count ?? 0
        if indexPath.row == (count - 1) {
            pullupRefreshFlag = true
            loadData()
        }
        // 返回cell
        return cell
    }
    
    // 返回行高
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // 1.取出对应行的模型
        let status = statuses![indexPath.row]
        
        // 2.判断缓存中有没有
        if let height = rowCache[status.id] {
            print("从缓存中获取")
            return height
        }
        
        // 3.拿到cell
        let cell = tableView.dequeueReusableCellWithIdentifier(NNStatusTableViewCellIdentifier.cellID(status)) as! NNHomeTableViewCell
        
        // 4.拿到对应行的行高
        let rowHeight = cell.rowHeight(status)
        
        // 5.缓存行高
        rowCache[status.id] = rowHeight
                
        // 6.返回行高
        return rowHeight
        
    }
}