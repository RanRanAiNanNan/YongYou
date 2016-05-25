//
//  RemoteProductViewController.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/5/19.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit

class RemoteProductViewController: BaseViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    var url = ""
    var productName = ""
    
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
        initNav(productName)
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