//
//  SafeguardViewController.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/9/9.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit

class SafeguardViewController: BaseViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    let userCenterService = UserCenterService.getInstance()
    
    var showUrl = ""
    
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
    
    func webViewDidFinishLoad(webView: UIWebView) {
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "WebKitCacheModelPreferenceKey")
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "WebKitOfflineWebApplicationCacheEnabled")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func loadUrl(){
        let path = NSBundle.mainBundle().pathForResource("./hybrid/transfer-list", ofType: "html")
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
        //println("url:\(url)")
        //加载配资随机数据
        if url?.scheme == "invest" {
            let parm = splitParameter(url!.absoluteString)
            userCenterService.loadSafeguardInvestData(parm, calback: {
                data in
                //print("data:\(data)")
                self.webView.stringByEvaluatingJavaScriptFromString("setInvest(\(data))")

            })
            //提交购买数据
        }else if url?.scheme == "platform" {
            let parm = splitParameter(url!.absoluteString)
            userCenterService.loadSafeguardPlatformData(parm, calback: {
                data in
                self.webView.stringByEvaluatingJavaScriptFromString("setPlatform(\(data))")

            })
        }else if url?.scheme == "total" {
            userCenterService.loadSafeguardTotalData({
                data in
                self.webView.stringByEvaluatingJavaScriptFromString("setTotal(\(data))")
                
            })
        }else if url?.scheme == "link" {
            var parm = splitParameter(url!.absoluteString)
            self.showUrl = (parm["url"]! as NSString).stringByDecodingURLFormat()
            self.performSegueWithIdentifier("showSafeguardSegue", sender: nil)
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
        initNav("安全保障")
        self.webView.backgroundColor = B.VIEW_BG
        self.webView.delegate = self
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSafeguardSegue" {
            let ssvc:ShowSafeguardViewController = segue.destinationViewController as! ShowSafeguardViewController
            ssvc.url = showUrl
        }
    }
    

}
