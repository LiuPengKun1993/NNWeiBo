//
//  UIImage+Category.swift
//  ImageSelector
//
//  Created by iOS on 16/10/18.
//  Copyright © 2016年 YMWM. All rights reserved.
//

import UIKit

extension UIImage {
    
    /**
     根据传入的宽度生成一张图片
     */
    func imageWithScale(width: CGFloat) -> UIImage {
        // 根据宽度计算高度
        let height = width *  size.height / size.width
        
        // 按照宽高比绘制一张新的图片
        
        let currentSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContext(currentSize)
        
        drawInRect(CGRect(origin: CGPointZero, size: currentSize))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
