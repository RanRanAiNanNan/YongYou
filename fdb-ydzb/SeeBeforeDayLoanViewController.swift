//
//  SeeBeforeDepositViewController.swift
//  ydzbapp-hybrid
//  查看往期
//  Created by 刘驰 on 15/9/12.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit

class SeeBeforeDayLoanViewController: BaseViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    let ydfService = YdFinancingService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        loadUrl()
    }
    
    func loadUrl(){
        let path = NSBundle.mainBundle().pathForResource("./hybrid/viewPast", ofType: "html")
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
        if url?.scheme == "load" {
            let parm = splitParameter(url!.absoluteString)
            ydfService.loadDayLoanSeeBefore(parm, calback: {
                data in
                webView.stringByEvaluatingJavaScriptFromString("createData(\(data))")
                
            })
            //提交购买数据
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
        return parm
        
    }
    
    
    func initView(){
        initNav("查看往期")
        self.webView.backgroundColor = B.VIEW_BG
        self.webView.delegate = self
    }
}
