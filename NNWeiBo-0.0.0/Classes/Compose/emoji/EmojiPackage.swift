//
//  EmojiPackage.swift
//  emoji
//
//  Created by iOS on 16/10/17.
//  Copyright © 2016年 YMWM. All rights reserved.
//

import UIKit

class EmojiPackage: NSObject {
    
    /// 当前组表情文件夹的名称
    var id: String?
    /// 组的名称
    var group_name_cn: String?
    /// 当前组所有的表情对象
    var emojis: [Emoji]?
    
    static let packageList: [EmojiPackage] = EmojiPackage.loadPackages()
    
    private class func loadPackages() -> [EmojiPackage] {
        var packages = [EmojiPackage]()
        // 0.创建最近组
        let pk = EmojiPackage(id: "")
        pk.group_name_cn = "最近"
        pk.emojis = [Emoji]()
        pk.appendEmtyEmojis()
        packages.append(pk)
        
        let path = NSBundle.mainBundle().pathForResource("emoticons.plist", ofType: nil, inDirectory: "Emoticons.bundle")
      
        let dict = NSDictionary(contentsOfFile: path!)!

        let dictArray = dict["packages"] as! [[String: AnyObject]]

        for d in dictArray {
            // 取出ID, 创建对应的组
            let package = EmojiPackage(id: d["id"]! as! String)
            packages.append(package)
            package.loadEmoji()
            package.appendEmtyEmojis()
        }
        
        return packages
    }
    
    /// 加载每一组中所有的表情
    func loadEmoji() {
        let emojiDict = NSDictionary(contentsOfFile: infoPath("info.plist"))!
        group_name_cn = emojiDict["group_name_cn"] as? String
        let dictArray = emojiDict["emoticons"] as! [[String: String]]
        emojis = [Emoji]()
        var index = 0
        for dict in dictArray { // 固定102
            if index == 20 {
                emojis?.append(Emoji(isRemoveButton: true))
                index = 0
            }
            emojis?.append(Emoji(dict: dict, id: id!))
            index++
        }
    }
    
    /**
     追加空白按钮
     */
    func appendEmtyEmojis() {
        let count = emojis!.count % 21
        for _ in count..<20
        {
            // 追加空白按钮
            emojis?.append(Emoji(isRemoveButton: false))
        }
        // 追加一个删除按钮
        emojis?.append(Emoji(isRemoveButton: true))
    }
    
    /**
     用于给最近添加表情
     */
    func appendEmojis(emoji: Emoji) {
        // 判断是否是删除按钮
        if emoji.isRemoveButton {
            return
        }
        
        // 判断当前点击的表情是否已经添加到最近数组中
        let contains = emojis!.contains(emoji)
        if !contains {
            // 删除删除按钮
            emojis?.removeLast()
            emojis?.append(emoji)
        }
        
        // 对数组进行排序
        var result = emojis?.sort({(e1, e2) -> Bool in
            return e1.times > e2.times
        })
        
        // 删除多余的表情
        if !contains {
            result?.removeLast()
            // 添加一个删除按钮
            result?.append(Emoji(isRemoveButton: true))
        }
        
        emojis = result
        
    }
    
    /**
     获取指定文件的全路径
     */
    func infoPath(fileName: String) -> String {
        return (EmojiPackage.emojiPath().stringByAppendingPathComponent(id!) as NSString).stringByAppendingPathComponent(fileName)
    }
    /// 获取微博表情的主路径
    class func emojiPath() -> NSString {
        return (NSBundle.mainBundle().bundlePath as NSString).stringByAppendingPathComponent("Emoticons.bundle")
    }
    
    init(id: String) {
        self.id = id
    }
}


class Emoji: NSObject {
    
     /// 表情对应的文字
    var chs: String?
    
     /// 表情对应的图片
    var png: String? {
        didSet {
            imagePath = (EmojiPackage.emojiPath().stringByAppendingPathComponent(id!) as NSString).stringByAppendingPathComponent(png!)
        }
    }
     /// emoji表情对应的十六进制字符串
    var code: String? {
        
        // 从字符串中取出十六进制的数
        didSet {
            let scanner = NSScanner(string: code!)
            // 将十六进制转换为字符串
            var result: UInt32 = 0
            
            scanner.scanHexInt(&result)
            
            // 将十六进制转换为emoji字符串
            emojiStr = "\(Character(UnicodeScalar(result)))"
        }
    }
    
    
    var emojiStr: String?
    
     /// 当前表情对应的文件夹
    var id: String?
    /// 表情图片的全路径
    var imagePath: String?
    /// 记录当前表情被使用的次数
    var times: Int = 0
    /// 标记是否是删除按钮
    var isRemoveButton: Bool = false
    
    init(isRemoveButton: Bool) {
        super.init()
        self.isRemoveButton = isRemoveButton
    }
    
    init(dict: [String: String], id: String) {
        super.init()
        self.id = id
        setValuesForKeysWithDictionary(dict)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
}
