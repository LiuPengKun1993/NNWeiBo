//
//  NNStatusTopView.swift
//  NNWeiBo-0.0.0
//
//  Created by iOS on 16/10/14.
//  Copyright © 2016年 YMWM. All rights reserved.
//

import UIKit

class NNStatusTopView: UIView {
    
    var status: NNStatus? {
        didSet {
            // 设置昵称
            nameLabel.text = status?.user?.name
            
            // 设置用户头像
            if let url = status?.user?.imageURL {
                iconView.sd_setImageWithURL(url)
            }
            
            // 设置认证图标
            verifiedView.image = status?.user?.verifiedImage
            
            // 设置会员图标
            vipView.image = status?.user?.mbrankImage
            
            // 设置来源
            sourceLabel.text = status?.source
            
            // 设置时间
            timeLabel.text = status?.created_at
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 初始化UI
        setupUI()
    }
    
    
    private func setupUI() {
        
    // 1.添加子控件
        addSubview(iconView)
        addSubview(verifiedView)
        addSubview(nameLabel)
        addSubview(vipView)
        addSubview(timeLabel)
        addSubview(sourceLabel)
    
    // 2.布局子控件
    iconView.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: self, size: CGSize(width: 50, height: 50), offset: CGPoint(x: 10, y: 10))
    
    verifiedView.xmg_AlignInner(type: XMG_AlignType.BottomRight, referView: iconView, size: CGSize(width: 14, height: 14), offset: CGPoint(x: 5, y: 5))
    
    nameLabel.xmg_AlignHorizontal(type: XMG_AlignType.TopRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
    
    vipView.xmg_AlignHorizontal(type: XMG_AlignType.TopRight, referView: nameLabel, size: CGSize(width: 14, height: 14), offset: CGPoint(x: 10, y: 0))
    
    timeLabel.xmg_AlignHorizontal(type: XMG_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        
    sourceLabel.xmg_AlignHorizontal(type: XMG_AlignType.BottomRight, referView: timeLabel, size: nil, offset: CGPoint(x: 10, y: 0))
    }
    
    // MARK: - 懒加载
    /// 头像
    private lazy var iconView: UIImageView = {
        let iconV = UIImageView(image: UIImage(named: "avatar_default_big"))
        return iconV
    }()
    
    /// 认证图标
    private lazy var verifiedView: UIImageView = UIImageView(image: UIImage(named: "avatar_enterprise_vip"))
    
    /// 昵称
    private lazy var nameLabel: UILabel = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 14)
    
    /// 会员图标
    private lazy var vipView: UIImageView = UIImageView(image: UIImage(named: "common_icon_membership"))
    
    /// 时间
    private lazy var timeLabel: UILabel = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 14)
    
    /// 来源
    private lazy var sourceLabel: UILabel = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 14)
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
