//
//  NNLabel+Category.swift
//  NNWeiBo-0.0.0
//
//  Created by iOS on 16/10/14.
//  Copyright © 2016年 YMWM. All rights reserved.
//

import UIKit

extension UILabel {
    /// 快速创建一个UILabel
    class func createLabel(color: UIColor, fontSize: CGFloat) -> UILabel {
        let label = UILabel()
        label.textColor = color
        label.font = UIFont.systemFontOfSize(fontSize)
        return label
    }

}
