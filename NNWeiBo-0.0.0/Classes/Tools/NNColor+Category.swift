//
//  NNColor+Category.swift
//  NNWeiBo-0.0.0
//
//  Created by iOS on 16/10/16.
//  Copyright © 2016年 YMWM. All rights reserved.
//

import UIKit


extension UIColor {
    
    class func randomColor() -> UIColor {
        return UIColor(red: randomNumber(), green: randomNumber(), blue: randomNumber(), alpha: 1.0)
    }
    
    class func randomNumber() -> CGFloat {
        return CGFloat(arc4random_uniform(256)) / CGFloat(255)
    }
}
