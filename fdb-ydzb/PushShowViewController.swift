//
//  PushShowViewController.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/7/28.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit

class PushShowViewController: BaseViewController,UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    var passUrl : String = ""
    var name    : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView(){
        
        initNav(name)
        self.loadUrl()
        let backBtn = UIButton()
        let backImage = UIImage(named: "peizi_return_icon")
        backBtn.frame = CGRectMake(0, 0, backImage!.size.width, backImage!.size.height);
        backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0)
        backBtn.setImage(backImage, forState: UIControlState.Normal)
        backBtn.addTarget(self, action: "backClick", forControlEvents: UIControlEvents.TouchUpInside)
        let backBtnItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backBtnItem
        
    }
    
    func backClick(){
        self.performSegueWithIdentifier("pushToGesture", sender: nil)
    }
    
    func loadUrl(){
        passUrl = passUrl.stringByAppendingString(userDefaultsUtil.getMobile()!)
        let url: NSURL = NSURL(string: passUrl)!
        let request = NSURLRequest(URL: url)
        webView?.loadRequest(request)
        webView?.delegate = self
    }
    
    
    //MARK: - Webview delegate
    
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