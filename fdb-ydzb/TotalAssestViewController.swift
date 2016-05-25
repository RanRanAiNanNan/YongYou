//
//  TotalAssestViewController.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/9/9.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit

class TotalAssestViewController: BaseViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    var assestService = AssestService.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        loadUrl()
    }
    

    func loadUrl(){
        let path = NSBundle.mainBundle().pathForResource("./hybrid/assets-ratio", ofType: "html")
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
            //gotoCustomer()
            assestService.loadTotalAssestData({
                data in
                webView.stringByEvaluatingJavaScriptFromString("setData(\(data))")
                
            })
        }
        return true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "WebKitCacheModelPreferenceKey")
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "WebKitOfflineWebApplicationCacheEnabled")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func initView(){
        initNav("总资产")
        self.webView.backgroundColor = B.VIEW_BG
        self.webView.delegate = self
    }
}