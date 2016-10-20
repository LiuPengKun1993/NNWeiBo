//
//  NNPhotoBrowserController.swift
//  NNWeiBo-0.0.0
//
//  Created by iOS on 16/10/16.
//  Copyright © 2016年 YMWM. All rights reserved.
//

import UIKit
import SVProgressHUD

private let NNPhotoBrowserCellReuseIdentifier = "pictureCell"

class NNPhotoBrowserController: UIViewController {

    var currentIndex: Int?
    var pictureURLS: [NSURL]?
    init(index: Int, urls: [NSURL]) {
        // Swift语法规定, 必须先初始化本类属性, 再初始化父类
        currentIndex = index
        pictureURLS = urls
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        // 初始化UI
        setupUI()
    }
    
    private func setupUI() {
        
        // 1.添加子控件
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        // 2.布局子控件
        closeBtn.xmg_AlignInner(type: XMG_AlignType.BottomLeft, referView: view, size: CGSize(width: 100, height: 35), offset: CGPoint(x: 10, y: -10))
        saveBtn.xmg_AlignInner(type: XMG_AlignType.BottomRight, referView: view, size: CGSize(width: 100, height: 35), offset: CGPoint(x: -10, y: -10))
        collectionView.frame = UIScreen.mainScreen().bounds
        
        // 3.设置数据源
        collectionView.dataSource = self
        
        collectionView.registerClass(NNPhotoBrowserCell.self, forCellWithReuseIdentifier: NNPhotoBrowserCellReuseIdentifier)
    }
    
    
    func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func save() {
        let index = collectionView.indexPathsForVisibleItems().last!
        let cell = collectionView.cellForItemAtIndexPath(index) as! NNPhotoBrowserCell
        
        let image = cell.iconView.image
        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(NNPhotoBrowserController.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        
        if error != nil {
            SVProgressHUD.showErrorWithStatus("保存失败")
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
        } else {
            SVProgressHUD.showSuccessWithStatus("保存成功")
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
        }
    }
    
    // MARK: - 懒加载
    private lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("关闭", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btn.backgroundColor = UIColor.darkGrayColor()
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 10
        btn.alpha = 0.9
        btn.addTarget(self, action: #selector(NNPhotoBrowserController.close), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    private lazy var saveBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("保存", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btn.backgroundColor = UIColor.darkGrayColor()
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 10
        btn.alpha = 0.9
        btn.addTarget(self, action: #selector(NNPhotoBrowserController.save), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    private lazy var collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: NNPhotoBrowserLayout())
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension NNPhotoBrowserController : UICollectionViewDataSource, NNPhotoBrowserCellDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureURLS?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NNPhotoBrowserCellReuseIdentifier, forIndexPath: indexPath) as! NNPhotoBrowserCell
        
        cell.backgroundColor = UIColor.randomColor()
        cell.imageURL = pictureURLS![indexPath.item]
        cell.photoBrowserCellDelegate = self
        return cell
    }
    
    func NNPhotoBrowserCellDidClose(cell: NNPhotoBrowserCell) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

class NNPhotoBrowserLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        itemSize = UIScreen.mainScreen().bounds.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.pagingEnabled = true
        collectionView?.bounces = false
    }
}
