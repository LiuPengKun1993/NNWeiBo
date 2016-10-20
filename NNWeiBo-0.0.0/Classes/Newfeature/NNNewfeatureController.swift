//
//  NNNewfeatureController.swift
//  NNWeiBo-0.0.0
//
//  Created by iOS on 16/10/13.
//  Copyright © 2016年 YMWM. All rights reserved.
//

import UIKit

private let reuseIdentifier = "reuseIdentifier"

class NNNewfeatureController: UICollectionViewController {

    /// 页面个数
    private let pageCount = 4
    /// 布局对象
    private var layout: UICollectionViewFlowLayout = NewfeatureLayout()
    init() {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1.注册一个cell
        //      OC :  [UICollectionViewCell class]
        collectionView?.registerClass(NewfeatureCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - UICollectionViewDataSource
    // 1.返回一个有多少个cell
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageCount
    }
    
    // 2.返回对应indexPath的cell
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // 1.获取cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as!NewfeatureCell
        
        // 2.设置cell的数据
        //        cell.backgroundColor = UIColor.redColor()
        cell.imageIndex = indexPath.item
        
        // 3.返回cell
        return cell
    }
    
    // 完全显示一个cell之后调用
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        // 传递给我们的是上一页的索引
        
        // 1.拿到当前显示的cell对应的索引
        let path = collectionView.indexPathsForVisibleItems().last!
        if path.item == (pageCount - 1) {
            
            // 2.拿到当前索引对应的cell
            let cell = collectionView.cellForItemAtIndexPath(path) as! NewfeatureCell
            // 3.让cell执行按钮动画
            cell.startBtnAnimation()
        }
    }
}

// Swift中一个文件中是可以定义多个类的
private class NewfeatureCell: UICollectionViewCell {
    
    /// 保存图片的索引
    private var imageIndex: Int? {
        didSet {
            iconView.image = UIImage(named: "new_feature_\(imageIndex! + 1)")
        }
    }
    
    /**
     让按钮做动画
     */
    func startBtnAnimation() {
    startBtn.hidden = false
        
        // 执行动画
        startBtn.transform = CGAffineTransformMakeScale(0.0, 0.0)
        startBtn.userInteractionEnabled = false
        
        UIView.animateWithDuration(2.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            
            // 清空形变
            self.startBtn.transform = CGAffineTransformIdentity
            
            }, completion: { (_) -> Void in
                self.startBtn.userInteractionEnabled = true
        })
    }
    
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        
        // 1.初始化UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func customBtnClick() {

        NSNotificationCenter.defaultCenter().postNotificationName(NNSwitchRootViewControllerKey, object: true)
    }
    
    private func setupUI() {
        // 1.添加子控件到contentView上
        contentView.addSubview(iconView)
        contentView.addSubview(startBtn)
        // 2.布局子控件的位置
        iconView.xmg_Fill(contentView)
        startBtn.xmg_AlignInner(type: XMG_AlignType.BottomCenter, referView: contentView, size: nil, offset: CGPoint(x: 0, y: -160))
        
    }
    
    // MARK: - 懒加载
    private lazy var iconView = UIImageView()
    
    private lazy var startBtn: UIButton = {
        let btn = UIButton()
    btn.setBackgroundImage(UIImage(named:"new_feature_button"), forState: UIControlState.Normal)
        
        btn.setBackgroundImage(UIImage(named:"new_feature_button_highlighted"), forState: UIControlState.Highlighted)
        
        btn.hidden = true
        btn.addTarget(self, action: #selector(NewfeatureCell.customBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
}

private class NewfeatureLayout: UICollectionViewFlowLayout {
    // 准备布局
    override func prepareLayout() {
        
        // 1.设置layout布局
        itemSize = UIScreen.mainScreen().bounds.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        // 2.设置collectionView的属性
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.bounces = false
        collectionView?.pagingEnabled = true
    }
}
