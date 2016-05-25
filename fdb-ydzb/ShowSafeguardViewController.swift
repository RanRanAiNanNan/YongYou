//
//  HelpCenterViewController.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/9/14.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit

class ShowSafeguardViewController: BaseViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    var url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        loadUrl()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    
    func loadUrl(){
        let urlobj = NSURL(string: url)
        let request = NSURLRequest(URL: urlobj!)
        self.webView.loadRequest(request)
    }
    
    func initView(){
        initNav("债权详情")
        self.webView.backgroundColor = B.VIEW_BG
        self.webView.delegate = self
        //退回按钮
        let backBtn = UIButton()
        let backImage = UIImage(named: "peizi_return_icon")
        backBtn.frame = CGRectMake(0, 0, backImage!.size.width, backImage!.size.height);
        backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0)
        backBtn.setImage(backImage, forState: UIControlState.Normal)
        backBtn.addTarget(self, action: "backClick", forControlEvents: UIControlEvents.TouchUpInside)
        let backBtnItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backBtnItem
    }
    
    func closeClick(){
        self.navigationController?.popViewControllerAnimated(true)
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