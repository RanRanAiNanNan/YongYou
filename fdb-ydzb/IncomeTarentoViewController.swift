//
//  IncomeTarentoViewController.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/7/10.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit

class IncomeTarentoViewController: BaseViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    let wealthService = WealthService.getInstance()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        loadUrl()
        //        var backBtn = UIButton()
        //        var backImage = UIImage(named: "peizi_return_icon")
        //        backBtn.frame = CGRectMake(0, 0, backImage!.size.width, backImage!.size.height);
        //        backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0)
        //        backBtn.setImage(backImage, forState: UIControlState.Normal)
        //        backBtn.addTarget(self, action: "backClick", forControlEvents: UIControlEvents.TouchUpInside)
        //        var backBtnItem = UIBarButtonItem(customView: backBtn)
        //        self.navigationItem.leftBarButtonItem = backBtnItem
    }
    
    override func viewWillAppear(animated: Bool) {
        webView.stringByEvaluatingJavaScriptFromString("startLoad()")
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        webView.stringByEvaluatingJavaScriptFromString("stopLoad()")
        super.viewDidDisappear(animated)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func loadUrl(){
        let path = NSBundle.mainBundle().pathForResource("./hybrid/wealth/caifuquan-index", ofType: "html")
        let url = NSURL.fileURLWithPath(path!)
        let request = NSURLRequest(URL: url)
        webView.scalesPageToFit = false
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
        if url?.scheme == "deal" {
            self.loadingShow()
            self.wealthService.investList({
                data in
                webView.stringByEvaluatingJavaScriptFromString("setDeal(\(data))")
                self.loadingHidden()
            })
            //加载详细信息
        }else if url?.scheme == "invest" {
            self.loadingShow()
            self.wealthService.realTimeList({
                data in
                webView.stringByEvaluatingJavaScriptFromString("setInvest(\(data))")
                self.loadingHidden()
            })
        }else if url?.scheme == "linki" {
            //截取ID
            gotoLink(url!.absoluteString)
        }else if url?.scheme == "linku" {
            //截取ID
            let param = splitParameter(url!.absoluteString)
            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "Wealth", bundle: NSBundle.mainBundle())
            let tdCtrl:TarentoDetailViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("wealthTaremtpCtrl") as! TarentoDetailViewController
            _ = param["uname"]!
            tdCtrl.tarento = TarentoModel(id: param["uid"]!, name: param["uname"]!.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!, mobile: param["mobile"]!)
            self.navigationController?.pushViewController(tdCtrl, animated: true)
        }
        return true
    }
    
    /**
     *产品跳转
     */
    func gotoLink(parms:String){
        let parm = splitParameter(parms)
        switch parm["type"]! {
        case "dayloan" :
            gotoPage("Finance", pageName: "dayloanMainCtrl")
        case "deposit":
            gotoPage("Finance", pageName: "depositMainCtrl")
        case "jumu":
            gotoPage("HighFinance", pageName: "jumuCtrl")
        case "transfer":
            gotoPage("HighFinance", pageName: "transferCtrl")
        case "peizi":
            gotoPage("HighFinance", pageName: "peiziCtrl")
        case "stable":
            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "HighFinance", bundle: NSBundle.mainBundle())
            let rpvc:RemoteProductViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("remoteProductCtrl") as! RemoteProductViewController
            //rpvc.url = B.STABLE_WEB_ADDRESS + userDefaultsUtil.getMobile()!
            rpvc.productName = "稳进宝"
            self.navigationController?.pushViewController(rpvc, animated: true)
            //            case "wangdai":
            //                gotoPage("HighFinance", pageName: "peiziCtrl")
        case "zizhu":
            gotoPage("Main", pageName: "mainpoiCtrl")
        default:
            break
        }
        
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
        initNav("财富圈")
        self.webView.backgroundColor = B.VIEW_BG
        self.webView.delegate = self
    }
    
}
