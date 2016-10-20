//
//  EmojiTextAttachment.swift
//  emoji
//
//  Created by iOS on 16/10/17.
//  Copyright © 2016年 YMWM. All rights reserved.
//

import UIKit

class EmojiTextAttachment: NSTextAttachment {
    // 保存对应表情的文字
    var chs: String?
    
    /// 根据表情模型, 创建表情字符串
    class func imageText(emoji: Emoji, font: UIFont) -> NSAttributedString {
        // 创建附件
        let attachment = EmojiTextAttachment()
        attachment.chs = emoji.chs
        attachment.image = UIImage(contentsOfFile: emoji.imagePath!)
        // 设置了附件的大小
        attachment.bounds = CGRectMake(0, -4, font.lineHeight, font.lineHeight)
        
        // 根据附件创建属性字符串
        return NSAttributedString(attachment: attachment)
    }
}
