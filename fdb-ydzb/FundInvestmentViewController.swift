//
//  FundInvestmentViewController.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 16/2/18.
//  Copyright © 2016年 银多资本. All rights reserved.
//

import Foundation
import UIKit

class FundInvestmentViewController:BaseViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        loadUrl()
    }
    

    

    
    func loadUrl(){
        let passUrl = B.ASSEST_FUNDINVESTMENT_ADDRESS.stringByAppendingString(userDefaultsUtil.getMobile()!)
        //print("passUrl:\(passUrl)")
        let url: NSURL = NSURL(string: passUrl)!
        let request = NSURLRequest(URL: url)
        webView?.loadRequest(request)
        webView?.delegate = self
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
    
    func webViewDidFinishLoad(webView: UIWebView) {
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "WebKitCacheModelPreferenceKey")
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "WebKitOfflineWebApplicationCacheEnabled")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url = request.URL
        print(".....url=\(url)")
        //加载列表数据
        if url?.scheme == "voice" {
            print("123.....")
        }
        return true
    }
    
    
    func initView(){
        initNav("基金投资")
        self.webView.backgroundColor = B.VIEW_BG
        self.webView.delegate = self
        
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
        //关闭按钮
        let closeBtn = UIButton()
        closeBtn.setTitle("关闭", forState: UIControlState.Normal)
        closeBtn.setTitleColor(B.NAV_TITLE_CORLOR, forState: UIControlState.Normal)
        closeBtn.frame = CGRectMake(0, 0, 50, 20);
        closeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        closeBtn.addTarget(self, action: "closeClick", forControlEvents: UIControlEvents.TouchUpInside)
        let closeBtnItem = UIBarButtonItem(customView: closeBtn)
        self.navigationItem.rightBarButtonItem = closeBtnItem
    }
    
    func closeClick(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
}