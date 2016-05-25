//
//  债权转让
//  TransferViewController.swift
//  ydzbApp
//
//  Created by 刘驰 on 15/5/4.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit

class TransferViewController: BaseViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    let highFinancingService = HighFinancingService.getInstance()
    
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
        let path = NSBundle.mainBundle().pathForResource("./hybrid/gaoduan/zhaiquanzhuanrang", ofType: "html")
        let url = NSURL.fileURLWithPath(path!)
        let request = NSURLRequest(URL: url)
        webView.scalesPageToFit = true
        webView.loadRequest(request)
        webView.scrollView.bounces = false;
        
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
        //加载配资随机数据
        if url?.scheme == "list" {
            self.loadingShow()
            highFinancingService.loadTransferData({
                data in
                webView.stringByEvaluatingJavaScriptFromString("getListData(\(data))")
                self.loadingHidden()
            })
            //提交购买数据
        }else if url?.scheme == "detail" {
            
            var parm = splitParameter(url!.absoluteString)
            parm["mobile"] = userDefaultsUtil.getMobile()
            self.loadingShow()
            //加载详细信息
            highFinancingService.loadTransferDetail(parm,calback: {
                data in
                self.webView.stringByEvaluatingJavaScriptFromString("getDetailData(\(data))")
                self.loadingHidden()
            })
            //提交购买数据
        }else if url?.scheme == "buy" {
            let parm = splitParameter(url!.absoluteString)
            self.loadingShow()
            //提交购买信息
            highFinancingService.transferBuy(parm,calback: {
                data in
                self.webView.stringByEvaluatingJavaScriptFromString("buy(\(data))")
                self.loadingHidden()
            })
            //服务协议
        }else if url?.scheme == "service" {
            serviceContractClick()
        }
        return true
    }
    
    func serviceContractClick() {
        let customAllowedSet =  NSCharacterSet(charactersInString:"=\"#%/<>?@\\^`{|}").invertedSet
        let escapedStr = B.SERVICE_TRANSFER.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
        let url = NSURL(string:B.SERVICE_CONTRACT_BASE + escapedStr!)
        UIApplication.sharedApplication().openURL(url!)
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
    
    
    func initView(){
        initNav("债权转让")
        self.webView.backgroundColor = B.VIEW_BG
        self.webView.delegate = self
    }
    
}