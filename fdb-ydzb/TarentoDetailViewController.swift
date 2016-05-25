//
//  TarentoDetailViewController.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/7/10.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//


import Foundation
import UIKit

class TarentoDetailViewController: BaseViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    var tarento:TarentoModel?
    
    
    
    let wealthService = WealthService.getInstance()
    
    let userCenterService = UserCenterService.getInstance()
    
    
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
        let path = NSBundle.mainBundle().pathForResource("./hybrid/wealth/caifuquan-personal", ofType: "html")
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
        //加载列表数据
        if url?.scheme == "load" {
            self.loadingShow()
            self.wealthService.tarentDetailList(tarento!.mobile, calback: {
                data in
                webView.stringByEvaluatingJavaScriptFromString("setData(\(data))")
                self.loadingHidden()
            })
        }else if url?.scheme == "attention" {
            self.loadingShow()
            self.userCenterService.cancelFollow(tarento!.id, calback: {
                data in
                self.loadingHidden()
                if let mm = data as? MsgModel {
                    if !mm.msg.isEmpty {
                        KGXToast.showToastWithMessage(mm.msg, duration: ToastDisplayDuration.LengthShort)
                    }
                    webView.stringByEvaluatingJavaScriptFromString("getAttentionData()")
                }
                
            })
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
    
    
    func initView(){
        initNav(tarento!.name)
        self.webView.backgroundColor = B.VIEW_BG
        self.webView.delegate = self
    }
    
}
