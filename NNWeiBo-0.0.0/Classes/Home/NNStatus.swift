//
//  NNStatus.swift
//  NNWeiBo-0.0.0
//
//  Created by iOS on 16/10/13.
//  Copyright © 2016年 YMWM. All rights reserved.
//

import UIKit
import SDWebImage

class NNStatus: NSObject {
    /// 微博创建时间
    var created_at: String? {
        didSet {
            // 1.将字符串转换为时间
            let createdDate = NSDate.dateWithStr(created_at!)
            // 2.获取格式化之后的时间字符串
            created_at = createdDate.descDate
        }
    }
    /// 微博ID
    var id: Int = 0
    /// 微博信息内容
    var text: String?
    /// 微博来源
    var source: String? {
        didSet {
                // 1.截取字符串
                if let str = source {
                    if str == "" {
                        return
                    }
                
                // 1.1获取开始截取的位置
                let startLocation = (str as NSString).rangeOfString(">").location + 1
                
                // 1.2获取截取的长度
                let length = (str as NSString).rangeOfString("<", options: NSStringCompareOptions.BackwardsSearch).location - startLocation
                // 1.3截取字符串
                source = "来自:" + (str as NSString).substringWithRange(NSMakeRange(startLocation, length))
            }
        }
    }
    /// 配图数组
    var pic_urls: [[String: AnyObject]]? {
        didSet {
            // 1.初始化数组
            storedPicURLS = [NSURL]()
            storedLargePicURLS = [NSURL]()
            
            // 2遍历取出所有的图片路径字符串
            for dict in pic_urls! {
                if let urlStr = dict["thumbnail_pic"] as? String {
                    // 将字符串转换为URL保存到数组中
                    storedPicURLS?.append(NSURL(string: urlStr)!)
                    
                    // 2.处理大图
                    let largeURLStr = urlStr.stringByReplacingOccurrencesOfString("thumbnail", withString: "large")
                    storedLargePicURLS?.append(NSURL(string: largeURLStr)!)
                    
                }
            }
        }
    }
    
    /// 保存当前微博所有配图的URL
    var storedPicURLS: [NSURL]?
    /// 保存当前微博所有配图"大图"的URL
    var storedLargePicURLS: [NSURL]?
    
    
    /// 用户信息
    var user: NNUser?
    
    /// 转发微博
    var retweeted_status: NNStatus?
    
    // 如果有转发, 原创就没有配图
    /// 定义一个计算属性, 用于返回原创获取转发配图的URL数组
    var pictureURLS: [NSURL]? {
        return retweeted_status != nil ? retweeted_status?.storedPicURLS : storedPicURLS
    }
    
    /// 定义一个计算属性, 用于返回原创或者转发配图的大图URL数组
    var largepictureURLS: [NSURL]? {
        return retweeted_status != nil ? retweeted_status?.storedLargePicURLS : storedLargePicURLS
    }
    
    
    /**
     *  加载微博数据
     */
    class func loadStatuses(since_id: Int, max_id: Int, finished: (models: [NNStatus]?, error: NSError?) -> ())  {
        let path = "2/statuses/home_timeline.json"
        var params = ["access_token": NNUserAccount.loadAccount()!.access_token!]
        
        // 下拉刷新
        if since_id > 0 {
            params["since_id"] = "\(since_id)"
        }
        
        // 上拉刷新
        if max_id > 0 {
            params["max_id"] = "\(max_id - 1)"
        }
        
        NNNetworkTools.shareNetWorkTools().GET(path, parameters: params, progress: nil, success: { (_, JSON) -> Void in
            
            // 1.取出statuses key对应的数组 (存储的都是字典)
            // 2.遍历数组, 将字典转换为模型
            let models = dictModel(JSON!["statuses"] as! [[String: AnyObject]])
            // 3.缓存微博配图
            cacheStatusImage(models, finished: finished)
        }) {
            (_, error) -> Void in
            finished(models: nil, error: error)
        }
    }
    
    /// 缓存配图
    class func cacheStatusImage(list: [NNStatus], finished:(models: [NNStatus]?, error:NSError?)->()) {
        
        if list.count == 0 {
            finished(models: list, error: nil)
            return
        }
        
        // 1.创建一个组
        let group = dispatch_group_create()
        
        // 1.缓存图片
        for status in list {
            guard let _ = status.pictureURLS else {
                continue
            }
            
            for url in status.pictureURLS! {
                // 将当前的下载操作添加到组中
                dispatch_group_enter(group)
                
                // 缓存图片
                SDWebImageManager.sharedManager().downloadImageWithURL(url, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (_, _, _, _, _) -> Void in
                    // 离开当前组
                    dispatch_group_leave(group)
                })
            }
            
            // 2.当所有图片都下载完毕再通过闭包通知调用者
            dispatch_group_notify(group, dispatch_get_main_queue()) {
            () -> Void in
                // 能够来到这个地方, 一定是所有图片都下载完毕
                finished(models: list, error: nil)
            }
        }
        
    }
    
    /// 将字典数组转换为模型数组
    class func dictModel(list: [[String: AnyObject]]) -> [NNStatus] {
        
        var models = [NNStatus]()
        for dict in list {
            models.append(NNStatus(dict: dict))
        }
        return models
    }
    
    // 字典转模型
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    // setValuesForKeysWithDictionary内部会调用以下方法
    override func setValue(value: AnyObject?, forKey key: String) {
        
        // 1.判断当前是否正在给微博字典中的user字典赋值
        if "user" == key {
            // 2.根据user key对应的字典创建一个模型
            user = NNUser(dict: value as! [String : AnyObject])
            return
        }
        
        // 2.判断是否是转发微博, 如果是就自己处理
        if "retweeted_status" == key {
            retweeted_status = NNStatus(dict: value as! [String : AnyObject])
            return
        }
        
        // 3,调用父类方法, 按照系统默认处理
        super.setValue(value, forKey: key)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    // 打印当前模型
    var properties = ["created_at", "id", "text", "source", "pic_urls"]
    override var description: String {
        let dict = dictionaryWithValuesForKeys(properties)
        return "\(dict)"
    }
    

}
