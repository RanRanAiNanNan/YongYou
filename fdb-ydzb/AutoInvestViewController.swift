//
//  AutoInvestViewController.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/7/13.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit

class AutoInvestViewController:BaseViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    let assestService = AssestService.getInstance()
    
    
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
        self.navigationItem.leftBarButtonItem = backBtnItem
        
    }
    
    func loadUrl(){
        let path = NSBundle.mainBundle().pathForResource("./hybrid/freedom-invest", ofType: "html")
        let url = NSURL.fileURLWithPath(path!)
        let request = NSURLRequest(URL: url)
        webView.scalesPageToFit = true
        webView.loadRequest(request)
        webView.scrollView.bounces = false;
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url = request.URL
        //加载列表数据
        if url?.scheme == "wait" {
            self.loadingShow()
            let param = splitParameter(url!.absoluteString)
            self.assestService.loadAutoNoList(param["page"]!,calback: {
                data in
                webView.stringByEvaluatingJavaScriptFromString("setWait(\(data))")
                self.loadingHidden()
            })
            //加载详细信息
        }else if url?.scheme == "done" {
            let param = splitParameter(url!.absoluteString)
            self.loadingShow()
            self.assestService.loadAutoYesList(param["page"]!, calback: {
                data in
                webView.stringByEvaluatingJavaScriptFromString("setDone(\(data))")
                self.loadingHidden()
            })
            //加载详细信息
        }else if url?.scheme == "commit" {
            let param = splitParameter(url!.absoluteString)
            self.loadingShow()
            self.assestService.buyAutoInvest(param["trade_id"]!, calback: {
                data in
                webView.stringByEvaluatingJavaScriptFromString("investSuc(\(data))")
                self.loadingHidden()
            })
            //加载详细信息
        }
        return true
    }
    
    //拆分参数数据，上传购买数据
    func splitParameter(params:String) -> [String:String] {
        let result = params.componentsSeparatedByString("?").last
        let arr = result!.componentsSeparatedByString("&")
        var parm:[String : String] = [:]
        for str in arr {
            let ss = str.componentsSeparatedByString("=")
            parm[ss.first!] = ss.last
        }
        
        //        for (key, value) in parm {
        //            println(":::\(key)=\(value)")
        //        }
        
        return parm
        
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
    
    func initView(){
        initNav("私人订制")
        self.webView.backgroundColor = B.VIEW_BG
        self.webView.delegate = self
    }

    

}