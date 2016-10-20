//
//  UITextView+Category.swift
//  emoji
//
//  Created by iOS on 16/10/17.
//  Copyright © 2016年 YMWM. All rights reserved.
//

import UIKit

extension UITextView {
    
    func insertEmoji(emoji: Emoji) {
        
        // 处理删除按钮
        if emoji.isRemoveButton {
            deleteBackward()
        }
        
        // 判断当前点击的是否是emoji表情
        if emoji.emojiStr != nil {
            self.replaceRange(self.selectedTextRange!, withText: emoji.emojiStr!)
        }
        
        // 判断当前点击的是否是表情图片
        if emoji.png != nil {
            
            // 创建表情字符串
            let imageText = EmojiTextAttachment.imageText(emoji, font: font ?? UIFont.systemFontOfSize(17))
            
            // 拿到当前所有的内容
            let strM = NSMutableAttributedString(attributedString: self.attributedText)
            
             // 插入表情到当前光标所在的位置
            let range = self.selectedRange
            strM.replaceCharactersInRange(range, withAttributedString: imageText)
            
            // 属性字符串有自己默认的尺寸
            strM.addAttribute(NSFontAttributeName, value: font!, range: NSMakeRange(range.location, 1))
            
            // 将替换后的字符串赋值给UITextView
            self.attributedText = strM
            // 恢复光标所在的位置
            self.selectedRange = NSMakeRange(range.location + 1, 0)
            
        }
    }
    
    /**
     获取需要发送给服务器的字符串
     */
    func emojiAttributedText() -> String {
        var strM = String()
        attributedText.enumerateAttributesInRange(NSMakeRange(0, attributedText.length), options: NSAttributedStringEnumerationOptions(rawValue: 0)) {
            (objc, range, _) -> Void in
            if objc["NSAttachment"] != nil {
                // 图片
                let attachment = objc["NSAttachment"] as! EmojiTextAttachment
                strM += attachment.chs!
            } else {
                // 文字
                strM += (self.text as NSString).substringWithRange(range)
            }
        }
        return strM
    }
}
