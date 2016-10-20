//
//  NNOAuthViewController.swift
//  NNWeiBo-0.0.0
//
//  Created by iOS on 16/10/12.
//  Copyright © 2016年 YMWM. All rights reserved.
//

import UIKit
import SVProgressHUD

class NNOAuthViewController: UIViewController {
    
    let NN_AppKey = "1259004689"
    let NN_AppSecret = "40570bd5c487679cfd592b4bf27ee0e5"
    let NN_Redirect_url = "http://www.baidu.com"
    
    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "NN微博"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(NSStream.close))
        
        // 1.获取未授权的RequestToken
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(NN_AppKey)&redirect_uri=\(NN_Redirect_url)"
        let url = NSURL(string: urlStr)
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }
    func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - 懒加载
    private lazy var webView: UIWebView = {
        let web = UIWebView()
        web.delegate = self
        return web
    }()
}

extension NNOAuthViewController: UIWebViewDelegate {

    // 返回ture正常加载 , 返回false不加载
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        
        // 1.判断是否是授权回调页面, 如果不是就继续加载
        let urlStr = request.URL!.absoluteString
        
        
        if !urlStr.hasPrefix(NN_Redirect_url) {
            // 继续加载
            return true
        }
        
        // 2.判断是否授权成功
        let codeStr = "code="
        if request.URL!.query!.hasPrefix(codeStr) {
            
            // 授权成功
            // 1.取出已经授权的RequestToken
           let code = request.URL!.query?.substringFromIndex(codeStr.endIndex)
            
            // 2.利用已经授权的RequestToken换取AccessToken
            loadAccessToken(code!)
        } else {
            // 取消授权
            // 关闭界面
            close()
        }
        return false
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        // 提示用户正在加载
        SVProgressHUD.showInfoWithStatus("正在加载...")
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        // 关闭提示
         SVProgressHUD.dismiss()
    }
    
    
    
    /**
     换取AccessToken
     */
    private func loadAccessToken(code: String) {
        // 1.定义路径
        let path = "oauth2/access_token"
        // 2.封装参数
        let params = ["client_id":NN_AppKey, "client_secret":NN_AppSecret, "grant_type":"authorization_code", "code":code, "redirect_uri":NN_Redirect_url]
        // 3.发送POST请求
        NNNetworkTools.shareNetWorkTools().POST(path, parameters: params, progress: nil, success: { (_, JSON) -> Void in
          
            let account = NNUserAccount(dict: JSON as! [String : AnyObject])
            // 2.归档模型
            account.loadUserInfo { (account, error) -> () in
                if account != nil {
                    account!.saveAccount()
                    
                    NSNotificationCenter.defaultCenter().postNotificationName(NNSwitchRootViewControllerKey, object: false)
                    return
                }
                SVProgressHUD.showInfoWithStatus("网络不给力")
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
            }
            
        }) { (_, error) -> Void in
            SVProgressHUD.showInfoWithStatus("网络不给力")
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
        }
    }
}
