//
//  YesterdayTotalViewController.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/10/27.
//  Copyright © 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit

class YesterdayTotalViewController: BaseViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    var assestService = AssestService.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        loadUrl()
        //addInfo(B.ROLE_SHARE)
        //addHelpCenter("")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    
    func loadUrl(){
        let path = NSBundle.mainBundle().pathForResource("./hybrid/share-yesterday", ofType: "html")
        let url = NSURL.fileURLWithPath(path!)
        let request = NSURLRequest(URL: url)
        webView.scalesPageToFit = true
        webView.loadRequest(request)
        //webView.scrollView.bounces = false;
    }
    
    
    //回退
    func backClick(){
        //如果没有浏览器回退
        if !webView.canGoBack {
            //应用回退
            self.navigationController?.popViewControllerAnimated(true)
        }else{
            //浏览器回退
            webView.goBack()
        }
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url = request.URL
        //加载列表数据
        if url?.scheme == "load" {
            assestService.yesterdayTotalData({
                data in
                webView.stringByEvaluatingJavaScriptFromString("getData(\(data))")
                
            })
        }
        return true
    }
    
    
    
    func initView(){
        initNav("昨日收益详情")
        self.webView.backgroundColor = B.VIEW_BG
        self.webView.delegate = self
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        loadingShow()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        loadingHidden()
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "WebKitCacheModelPreferenceKey")
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "WebKitOfflineWebApplicationCacheEnabled")
        NSUserDefaults.standardUserDefaults().synchronize()
    }

}