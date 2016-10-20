//
//  NNHomeTableViewCell.swift
//  NNWeiBo-0.0.0
//
//  Created by iOS on 16/10/14.
//  Copyright © 2016年 YMWM. All rights reserved.
//

import UIKit
import SDWebImage

let NNPictureViewCellIdentifier = "NNPictureViewCellIdentifier"

/**
 保存cell的重用标示
 */
enum NNStatusTableViewCellIdentifier: String {
    case NormalCell = "NormalCell"
    case ForwardCell = "ForwardCell"
    
    // 如果在枚举中利用static修饰一个方法 , 相当于类中的class修饰方法
    static func cellID(status: NNStatus) -> String {
        return status.retweeted_status != nil ? ForwardCell.rawValue : NormalCell.rawValue
    }
}

class NNHomeTableViewCell: UITableViewCell {
    
    /// 保存配图的宽度约束
    var pictureWidthCons: NSLayoutConstraint?
    /// 保存配图的高度约束
    var pictureHeightCons: NSLayoutConstraint?
    /// 保存配图的顶部约束
    var pictureTopCons: NSLayoutConstraint?
    
    
    var status = NNStatus?() {
        didSet {
            // 设置顶部视图
            topView.status = status
            
            // 设置正文
            contentLabel.text = status?.text
            
            // 设置配图的尺寸
            pictureView.status = status?.retweeted_status != nil ? status?.retweeted_status : status
            
            // 1.1根据模型计算配图的尺寸
            let size = pictureView.calculateImageSize()
            // 1.2设置配图的尺寸
            
            pictureWidthCons?.constant = size.width
            
            pictureHeightCons?.constant = size.height
            
            pictureTopCons?.constant = size.height == 0 ? 0 : 10
        }
    }
    
    
    
    // 自定义一个类需要重写的init方法是 designated
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 初始化UI
        setupUI()
    }

    
    func setupUI() {
    
        // 1.添加子控件
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(pictureView)
        contentView.addSubview(footView)
        
        let width = UIScreen.mainScreen().bounds.width

         // 2.布局子控件
        
        topView.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: contentView, size: CGSize(width: width, height: 60))
        
        contentLabel.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: topView, size: nil, offset: CGPoint(x: 10, y: 10))
        
        footView.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: pictureView, size: CGSize(width: width, height: 30), offset: CGPoint(x: -10, y: 10))
        
    }
    
    /**
     用于获取行号
     */
    func rowHeight(status: NNStatus) -> CGFloat
    {
        // 1.为了能够调用didSet, 计算配图的高度
        self.status = status
        
        // 2.强制更新界面
        self.layoutIfNeeded()
        
        // 3.返回底部视图最大的Y值
        
        return CGRectGetMaxY(footView.frame)
    }
    
    
    // MARK: - 懒加载
    /// 顶部视图
    private lazy var topView: NNStatusTopView = NNStatusTopView()
    
    /// 正文
    lazy var contentLabel: UILabel = {
        let label = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 15)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
        return label
    }()
    
    /// 配图
    lazy var pictureView: NNStatusPictureView = NNStatusPictureView()
    
    /// 底部工具条
    lazy var footView: NNStatusBottomView = NNStatusBottomView()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

