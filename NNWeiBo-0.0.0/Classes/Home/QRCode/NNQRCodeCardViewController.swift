//
//  NNQRCodeCardViewController.swift
//  NNWeiBo-0.0.0
//
//  Created by iOS on 16/10/12.
//  Copyright © 2016年 YMWM. All rights reserved.
//

import UIKit

class NNQRCodeCardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.设置标题
        navigationItem.title = "我的名片"
        
        // 2.添加图片容器
        view.addSubview(iconView)
        
        // 3.布局图片容器
        iconView.xmg_AlignInner(type: XMG_AlignType.Center, referView: view, size: CGSize(width: 200, height: 200))
        iconView.backgroundColor = UIColor.redColor()
        
        // 4.生成二维码
        let qrcodeImage = creatQRCodeImage()
        
        // 5.将生成好的二维码添加到图片容器上
        iconView.image = qrcodeImage
    }
    
    private func creatQRCodeImage()-> UIImage {
        // 1.创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        // 2.还原滤镜的默认属性
        filter?.setDefaults()
        
        // 3.设置需要生成二维码的数据
        filter?.setValue("柳钟宁".dataUsingEncoding(NSUTF8StringEncoding), forKey: "inputMessage")
        
        // 4.从滤镜中取出生成好的图片
        let ciImage = filter?.outputImage
        
        let bgImage = createNonInterpolatedUIImageFormCIImage(ciImage!, size: 200)
        
        // 5.创建一个头像
        let icon = UIImage(named: "avatar_default_big")
        
        // 6.合成图片(将二维码和头像进行合并)
        let newImage = createImage(bgImage, iconImage: icon!)
        
        // 7.返回生成好的二维码
        return newImage
    }
    
    
    /**
     合成图片
     */
    private func createImage(bgImage: UIImage, iconImage: UIImage) -> UIImage {
        
        // 1.开启图片上下文
        UIGraphicsBeginImageContext(bgImage.size)
        // 2.绘制背景图片
        bgImage.drawInRect(CGRect(origin: CGPointZero, size: bgImage.size))
        
         // 3.绘制头像
        let width:CGFloat = 30
        let height:CGFloat = width
        let x = (bgImage.size.width - width) * 0.5
        let y = (bgImage.size.height - height) * 0.5
        
        iconImage.drawInRect(CGRect(x: x, y: y, width: width, height: height))
        
        // 4.取出绘制号的图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        // 5.关闭上下文
        UIGraphicsEndImageContext()
        // 6.返回合成号的图片
        return newImage
    }
    
    
    /**
     根据CIImage生成指定大小的高清UIImage
     */
    private func createNonInterpolatedUIImageFormCIImage(image: CIImage, size: CGFloat) -> UIImage {
        
        let extent: CGRect = CGRectIntegral(image.extent)
        let scale: CGFloat = min(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent))
        
        // 1.创建bitmap;
        let width = CGRectGetWidth(extent) * scale
        let height = CGRectGetHeight(extent) * scale
        let cs: CGColorSpaceRef = CGColorSpaceCreateDeviceGray()!
        let bitmapRef = CGBitmapContextCreate(nil, Int(width), Int(height), 8, 0, cs, 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImageRef = context.createCGImage(image, fromRect: extent)
        
        CGContextSetInterpolationQuality(bitmapRef,  CGInterpolationQuality.None)
        CGContextScaleCTM(bitmapRef, scale, scale);
        CGContextDrawImage(bitmapRef, extent, bitmapImage);
        
        // 2.保存bitmap到图片
        let scaledImage: CGImageRef = CGBitmapContextCreateImage(bitmapRef)!
        
        return UIImage(CGImage: scaledImage)
    }
    
    // MARK: - 懒加载
    private lazy var iconView: UIImageView = UIImageView()
}
