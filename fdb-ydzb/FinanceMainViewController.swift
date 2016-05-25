//
//  FinanceMainViewController.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/5/19.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class FinanceMainViewController:BaseViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    var financeMainService = FinanceMainService.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        //showBack()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadUrl()
        let financeTabBarItem = tabBarController?.tabBar.items![1]
        financeTabBarItem?.image = UIImage(named: "64-icon-yongyou2")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
    }
    
    func showBack(){
        let backBtn = UIButton()
        let backImage = UIImage(named: "peizi_return_icon")
        backBtn.frame = CGRectMake(0, 0, backImage!.size.width, backImage!.size.height);
        backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0)
        backBtn.setImage(backImage, forState: UIControlState.Normal)
        backBtn.addTarget(self, action: "backClick", forControlEvents: UIControlEvents.TouchUpInside)
        let backBtnItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backBtnItem
    }
    
    func hideBack(){
        self.navigationItem.leftBarButtonItem = nil
    }
    
    
    func loadUrl(){
        let path = NSBundle.mainBundle().pathForResource("./hybrid/addItem", ofType: "html")
        let url = NSURL.fileURLWithPath(path!)
        let request = NSURLRequest(URL: url)
        webView.scalesPageToFit = true
        webView.loadRequest(request)
        //webView.scrollView.bounces = false;
        
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
            loadingShow()
            financeMainService.loadList({
                data in
                self.loadingHidden()
                webView.stringByEvaluatingJavaScriptFromString("setData(\(data))")
            })
        }else if url?.scheme == "gore" {
            let mm = userDefaultsUtil.getMobile()!
            let json: JSON =  ["mm": mm, "url": B.FINANCE_USERRECOMMEND_ADDRESS]
            webView.stringByEvaluatingJavaScriptFromString("recommendData(\(json))")
        }else if url?.scheme == "link" {
            //截取ID
            self.gotoLink(url!.absoluteString)
        }else if url?.scheme == "freedom" {
            self.gotoAutoInvest()
        }else if url?.scheme == "gopo" {
            self.goPo()
        }
        return true
    }
    
    func goPo(){
        self.performSegueWithIdentifier("financeToPoSegue", sender: nil)
    }
    
    func gotoLink(parms:String){
        let parm = splitParameter(parms)
        if parm.0 == "0" {
            switch parm.1 {
            case "dayloan":
                gotoPage("Finance", pageName: "dayloanMainCtrl")
            case "deposit":
                gotoPage("Finance", pageName: "depositMainCtrl")
            case "jumu":
                gotoPage("HighFinance", pageName: "jumuCtrl")
            case "transfer":
                gotoPage("Finance", pageName: "TransferBuyTVC")
            case "peizi":
                gotoPage("HighFinance", pageName: "peiziCtrl")
            default:
                break
            }
        }else{
            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "HighFinance", bundle: NSBundle.mainBundle())
            let rpvc:RemoteProductViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("remoteProductCtrl") as! RemoteProductViewController
            rpvc.url = parm.1 + userDefaultsUtil.getMobile()!
            rpvc.productName = parm.2.stringByRemovingPercentEncoding!
            self.navigationController?.pushViewController(rpvc, animated: true)
        }
    }
    
    //跳转在线客服
    func gotoAutoInvest(){
        gotoPage("Main", pageName: "mainpoiCtrl")
    }
    
    
    /*
    *拆分参数数据，上传购买数据
    *返回(类型，外网地址，产品名称)
    */
    func splitParameter(params:String) -> (String,String,String){
        var parm = (cate:"",addr:"",name:"")
        _ = (params as NSString).rangeOfString("?")
        let result = params.componentsSeparatedByString("?").last
        let arr = result!.componentsSeparatedByString("&")
        for str in arr {
            let ss = str.componentsSeparatedByString("=")
            if ss.first! == "cate" {
                parm.cate = ss.last!
            }else if ss.first! == "addr" {
                parm.addr = ss.last!
            }else if ss.first! == "name" {
                parm.name = ss.last!
            }
        }
        return parm
    }
    
    func initView(){
        initNav("理财")
        self.webView.backgroundColor = B.VIEW_BG
        self.webView.delegate = self
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        loadingShow()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        loadingHidden()
        //防止webview内存泄露
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "WebKitCacheModelPreferenceKey")
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "WebKitOfflineWebApplicationCacheEnabled")
        NSUserDefaults.standardUserDefaults().synchronize()
    }

}