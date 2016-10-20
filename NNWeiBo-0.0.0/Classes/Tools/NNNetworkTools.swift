//
//  NNNetworkTools.swift
//  NNWeiBo-0.0.0
//
//  Created by iOS on 16/10/12.
//  Copyright © 2016年 YMWM. All rights reserved.
//

import UIKit
import AFNetworking

class NNNetworkTools: AFHTTPSessionManager{
    
    static let tools: NNNetworkTools = {
        let url = NSURL(string: "https://api.weibo.com/")
        let netWork = NNNetworkTools(baseURL: url)
        
        // 设置AFN能够接收得数据类型
        netWork.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/plain") as? Set<String>
        return netWork
    }()
    
    /// 获取单粒的方法
    class func shareNetWorkTools() -> NNNetworkTools {
        return tools
    }
    
    
    /**
     发送微博
     */
    func sendStatus(text: String, image: UIImage?, successCallback: (status: NNStatus) -> (), errorCallback: (error: NSError)->()) {
        var path = "2/statuses/"
        let params = ["access_token":NNUserAccount.loadAccount()!.access_token! , "status": text]
        if image != nil {
            // 发送图片微博
            path += "upload.json"
            
            POST(path, parameters: params, constructingBodyWithBlock: { (formData) -> Void in
                // 将数据转换为二进制
                let data = UIImagePNGRepresentation(image!)!
                
                // 上传数据
                formData.appendPartWithFileData(data
                    , name:"pic", fileName:"abc.png", mimeType:"application/octet-stream");
                
                }, progress: nil, success: {
                    (_, JSON) -> Void in
                    successCallback(status: NNStatus(dict: JSON as! [String : AnyObject]))
                }, failure: { (_, error) -> Void in
                    errorCallback(error: error)
            })
        } else {
            
            // 发送文字微博
            path += "update.json"
            POST(path, parameters: params, progress: nil, success: { (_, JSON) -> Void in
                successCallback(status: NNStatus(dict: JSON as! [String : AnyObject]))
            }) { (_, error) -> Void in
                errorCallback(error: error)
            }
        }
    }
}
