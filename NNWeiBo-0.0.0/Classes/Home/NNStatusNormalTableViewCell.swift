//
//  NNStatusNormalTableViewCell.swift
//  NNWeiBo-0.0.0
//
//  Created by iOS on 16/10/15.
//  Copyright © 2016年 YMWM. All rights reserved.
//

import UIKit

class NNStatusNormalTableViewCell: NNHomeTableViewCell {
    
    override func setupUI() {
        super.setupUI()
        
        let cons = pictureView.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: contentLabel, size: CGSizeZero, offset: CGPoint(x: 0, y: 10))
        
        pictureWidthCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureHeightCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Height)
    }

}
