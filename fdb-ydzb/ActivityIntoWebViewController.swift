//
//  ImageIntoWebViewController.swift
//  ydzbapp-hybrid
//
//  Created by qinxin on 15/5/14.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class ActivityIntoWebViewController: BaseViewController{
    
    @IBOutlet weak var productWebView: UIWebView!
    @IBOutlet weak var myWeb: UIWebView!
    
    var passUrl : String = ""               //webview url
    var name    : String = ""               //标题栏文字
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        initView()
        myWeb.loadRequest(NSURLRequest(URL:NSURL(string:passUrl)!))

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func initView(){
////        initNav(name)
//        self.loadUrl()
//    }
//    
//    func loadUrl(){
////        passUrl = passUrl.stringByAppendingString(userDefaultsUtil.getMobile()!)
//        let url: NSURL = NSURL(string: passUrl)!
//        let request = NSURLRequest(URL: url)
////        webView?.loadRequest(request)
////        webView?.delegate = self
//    }
//    
//    
//    
//    //MARK: - Webview delegate
//    
//    func webViewDidStartLoad(webView: UIWebView) {
//        loadingShow()
//    }
//    
//    func webViewDidFinishLoad(webView: UIWebView) {
//        loadingHidden()
//        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "WebKitCacheModelPreferenceKey")
//        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "WebKitOfflineWebApplicationCacheEnabled")
//        NSUserDefaults.standardUserDefaults().synchronize()
//    }
//    
//    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
//        loadingHidden()
//    }
}
