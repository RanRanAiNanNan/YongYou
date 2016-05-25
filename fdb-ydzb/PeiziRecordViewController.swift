//
//  PeiziRecordViewController.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/4/18.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit

class PeiziRecordViewController: BaseViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    var peiziService = PeiziService.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        loadUrl()
        let backBtn = UIButton()
        let backImage = UIImage(named: "peizi_return_icon")
        backBtn.frame = CGRectMake(0, 0, backImage!.size.width, backImage!.size.height);
        backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0)
        backBtn.setImage(backImage, forState: UIControlState.Normal)
        backBtn.addTarget(self, action: "backClick", forControlEvents: UIControlEvents.TouchUpInside)
        let backBtnItem = UIBarButtonItem(customView: backBtn)
        
        //        var backBtnItem = UIBarButtonItem(image: UIImage(named: "peizi_return_icon"), style: UIBarButtonItemStyle.Done, target: self, action: "backClick")
        
        self.navigationItem.leftBarButtonItem = backBtnItem
        
    }
    
    func loadUrl(){
        let path = NSBundle.mainBundle().pathForResource("./hybrid/peizi/list", ofType: "html")
        let url = NSURL.fileURLWithPath(path!)
        let request = NSURLRequest(URL: url)
        webView.scalesPageToFit = true
        webView.loadRequest(request)
        webView.scrollView.bounces = false;
        
    }
    
    func backClick(){
        if !webView.canGoBack {
            self.navigationController?.popViewControllerAnimated(true)
        }else{
            webView.goBack()
        }
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let url = request.URL
        if url?.scheme == "list" {
            peiziService.loadList(0,calback: {
                data in
                webView.stringByEvaluatingJavaScriptFromString("getListData(\(data))")
            })
        }else if url?.scheme == "detail" {
            //截取ID
            let id = splitId(url!.absoluteString)
            peiziService.loadDetail(id,calback: {
                data in
                webView.stringByEvaluatingJavaScriptFromString("showDetail(\(data))")
            })
        }
        return true
    }
    
    func initView(){
        initNav("配资记录")
        self.webView.backgroundColor = B.VIEW_BG
        self.webView.delegate = self
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        loadingShow()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        loadingHidden()
    }
    
    //截取ID
    func splitId(param:String) -> String {
        let id = param.componentsSeparatedByString("=").last
        return id!
    }
    
    
}
