//
//  PeiziViewController.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/4/13.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON


class PeiziViewController: BaseViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    var peiziService = PeiziService.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        loadUrl()
        //var backBtn = UIBarButtonItem(title: "返回", style:UIBarButtonItemStyle.Done, target: self, action: "backClick")
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
        let path = NSBundle.mainBundle().pathForResource("./hybrid/peizi/index", ofType: "html")
        let url = NSURL.fileURLWithPath(path!)
        let request = NSURLRequest(URL: url)
        webView.scalesPageToFit = true
        webView.loadRequest(request)
        webView.scrollView.bounces = false;
        
    }
    //回退
    func backClick(){
        self.navigationController?.popViewControllerAnimated(true)
        //如果没有浏览器回退
        //        if !webView.canGoBack {
        //        //应用回退
        //            self.navigationController?.popViewControllerAnimated(true)
        //        }else{
        //        //浏览器回退
        //            webView.goBack()
        //        }
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url = request.URL
        //加载配资随机数据
        if url?.scheme == "peizi" {
            peiziService.randomData({
                data in
                webView.stringByEvaluatingJavaScriptFromString("getRandomData(\(data))")
            })
            //提交购买数据
        }else if url?.scheme == "commit" {
            splitParameter("\(url?.absoluteString)")
            //加载排行榜数据
        }else if url?.scheme == "top" {
            peiziService.topList({
                data in
                webView.stringByEvaluatingJavaScriptFromString("getTopData(\(data))")
            })
            //服务协议
        }else if url?.scheme == "service" {
            serviceContractClick()
            //按天配资购买
        }else if url?.scheme == "daybuy" {
            let parm = splitParam(url!.absoluteString)
            self.loadingShow()
            //提交购买信息
            peiziService.dayBuy(parm,calback: {
                data in
                self.webView.stringByEvaluatingJavaScriptFromString("getCommitData(\(data))")
                self.loadingHidden()
            })
            //按月配资购买
        }else if url?.scheme == "monthbuy" {
            let parm = splitParam(url!.absoluteString)
            self.loadingShow()
            //提交购买信息
            peiziService.monthBuy(parm,calback: {
                data in
                self.webView.stringByEvaluatingJavaScriptFromString("getCommitData(\(data))")
                self.loadingHidden()
            })
        }
        return true
    }
    
    
    //拆分参数数据，上传购买数据
    func splitParam(params:String) -> [String:String] {
        let result = params.componentsSeparatedByString("?").last
        let arr = result!.componentsSeparatedByString("&")
        var parm:[String : String] = [:]
        for str in arr {
            let ss = str.componentsSeparatedByString("=")
            parm[ss.first!] = ss.last
        }
        
        parm["mobile"] = userDefaultsUtil.getMobile()
        
        //        for (key, value) in parm {
        //            println(":::\(key)=\(value)")
        //        }
        
        return parm
        
    }
    
    
    //拆分参数数据，上传购买数据
    func splitParameter(params:String) {
        
        _ = (params as NSString).rangeOfString("?")
        let result = params.componentsSeparatedByString("?").last
        let arr = result!.componentsSeparatedByString("&")
        var parm:[String : String] = [:]
        for str in arr {
            let ss = str.componentsSeparatedByString("=")
            parm[ss.first!] = ss.last
        }
        parm["mobile"] = userDefaultsUtil.getMobile()
        
        //        for (key, value) in parm {
        //            println(":::\(key)=\(value)")
        //        }
        
        //上传购买数据
        peiziService.commitData(parm,calback: {
            data in
            self.webView.stringByEvaluatingJavaScriptFromString("getCommitData(\(data))")
            
        })
    }
    
    
    
    func serviceContractClick() {
        let customAllowedSet =  NSCharacterSet(charactersInString:"=\"#%/<>?@\\^`{|}").invertedSet
        let escapedStr = B.SERVICE_PEIZI.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
        let url = NSURL(string:B.SERVICE_CONTRACT_BASE + escapedStr!)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    
    func initView(){
        initNav("股票配资")
        self.webView.backgroundColor = B.VIEW_BG
        self.webView.delegate = self
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        loadingShow()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        loadingHidden()
    }
    
}