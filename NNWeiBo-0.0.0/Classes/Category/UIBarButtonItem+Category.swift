//
//  UIBarButtonItem+Category.swift
//  NNWeiBo-0.0.0
//
//  Created by iOS on 16/10/11.
//  Copyright © 2016年 YMWM. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    // 如果在func前面加上class, 就相当于OC中的+
    class func creatBarButtonItem(imageNamed:String, target:AnyObject, action:Selector) -> UIBarButtonItem {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageNamed), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: imageNamed + "_highlighted"), forState: UIControlState.Highlighted)
        btn.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        btn.sizeToFit()
        return UIBarButtonItem(customView:btn)
    }
    
    convenience init(imageName: String, target: AnyObject?, action: String?) {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
        if action != nil {
            btn.addTarget(target, action: Selector(action!), forControlEvents: UIControlEvents.TouchUpInside)
        }
        btn.sizeToFit()
        self.init(customView: btn)
    }
    
}
