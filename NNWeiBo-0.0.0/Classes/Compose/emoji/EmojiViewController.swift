//
//  EmojiViewController.swift
//  emoji
//
//  Created by iOS on 16/10/17.
//  Copyright © 2016年 YMWM. All rights reserved.
//

import UIKit

private let NNEmojiCellReuseIdentifier = "NNEmojiCellReuseIdentifier"
class EmojiViewController: UIViewController {
    /// 定义一个闭包属性, 用于传递选中的表情模型
    var emojiDidSelectedCallBack:(emoji: Emoji) -> ()
    
    init(callBack: (emoji: Emoji) ->()) {
        self.emojiDidSelectedCallBack = callBack
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.redColor()
        
        // 1.初始化UI
        setupUI()
    }
    /**
     初始化UI
     */
    private func setupUI() {
        // 添加子控件
        view.addSubview(collectionView)
        view.addSubview(toolbar)
        
        // 布局子控件
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        var cons = [NSLayoutConstraint]()
        let dict = ["collectionView": collectionView, "toolbar": toolbar]
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[toolbar]-0-|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collectionView]-[toolbar(44)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        view.addConstraints(cons)
    }
    
    
    func itemClick(item: UIBarButtonItem) {
        collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: item.tag), atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
    }
    
    
    // MARK: - 懒加载
    private lazy var collectionView: UICollectionView = {
        let clv = UICollectionView(frame: CGRectZero, collectionViewLayout: EmojiLayout())
        // 注册cell
        clv.registerClass(EmojiCell.self, forCellWithReuseIdentifier: NNEmojiCellReuseIdentifier)
        clv.delegate = self
        clv.dataSource = self
        return clv
    }()
    
    private lazy var toolbar: UIToolbar = {
        let bar = UIToolbar()
        bar.tintColor = UIColor.darkGrayColor()
        var items = [UIBarButtonItem]()
        
        var index = 0
        for title in ["最近", "默认", "emoji", "浪小花"] {
            let item = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EmojiViewController.itemClick(_:)))
            
            item.tag = index++
            items.append(item)
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        }
        
        items.removeLast()
        bar.items = items
        return bar
    }()
    
    private lazy var packages: [EmojiPackage] = EmojiPackage.packageList
}

extension EmojiViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // 告诉系统每组有多少行
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packages[section].emojis?.count ?? 0
    }
     // 告诉系统有多少组
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return packages.count
    }
    
    // 告诉系统每行显示什么内容
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NNEmojiCellReuseIdentifier, forIndexPath: indexPath) as! EmojiCell
        
        cell.backgroundColor = (indexPath.item % 2 == 0) ? UIColor.redColor() : UIColor.greenColor()
        
        // 取出对应的组
        let package = packages[indexPath.section]
        // 取出对应组对应行的模型
        let emoji = package.emojis![indexPath.item]
        // 赋值给cell
        cell.emoji = emoji
        
        return cell
    }
    
    // 选中某一个cell时调用
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // 处理最近表情, 将当前使用的表情添加到最近表情的数组中
        let emoji = packages[indexPath.section].emojis![indexPath.item]
        emoji.times++
        packages[0].appendEmojis(emoji)
        
        // 回调通知使用者当前点击了那个表情
        emojiDidSelectedCallBack(emoji: emoji)
    }
}


// MARK: - UICollectionViewCell
class EmojiCell: UICollectionViewCell {
    var emoji: Emoji? {
        didSet {
            // 判断是否是图片表情
            if emoji!.chs != nil {
                iconButton.setImage(UIImage(contentsOfFile: emoji!.imagePath!), forState: UIControlState.Normal)
            } else {
                // 防止重用
                iconButton.setImage(nil, forState: UIControlState.Normal)
            }
            
            // 设置emoji表情
            iconButton.setTitle(emoji?.emojiStr ?? "", forState: UIControlState.Normal)
            
            // 判断是否是删除按钮
            if emoji!.isRemoveButton {
                iconButton.setTitle("删除", forState: UIControlState.Normal)
            iconButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
                iconButton.titleLabel?.font = UIFont.systemFontOfSize(14)
            }
        }
    }
    
    
     override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
   
    /**
     初始化UI
     */
    private func setupUI() {
        contentView.addSubview(iconButton)
        iconButton.backgroundColor = UIColor.whiteColor()
        iconButton.frame = CGRectInset(contentView.bounds, 4, 4)
        iconButton.userInteractionEnabled = false
    }
    
    // MARK: - 懒加载
    private lazy var iconButton: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFontOfSize(32)
        return btn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - 自定义布局
class EmojiLayout: UICollectionViewFlowLayout {
    
    override func prepareLayout() {
        super.prepareLayout()
        
         // 设置cell相关属性
        let width = collectionView!.bounds.width / 7
        itemSize = CGSize(width: width, height: width)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        // 设置collectionview相关属性
        collectionView?.pagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
        
        let y = (collectionView!.bounds.height - 3 * width) * 0.4
        collectionView?.contentInset = UIEdgeInsets(top: y, left: 0, bottom: y, right: 0)
        
    }
}
