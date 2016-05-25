//  收益分享ctrl,混合开发页面在hybrid/share.html
//  RevenueShareViewController.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/9/12.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit

class RevenueShareViewController: BaseViewController, UIWebViewDelegate, UMSocialUIDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    var assestService = AssestService.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        loadUrl()
        //addInfo(B.ROLE_SHARE)
        //addHelpCenter("")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
       
    }
    
    
    func loadUrl(){
        let path = NSBundle.mainBundle().pathForResource("./hybrid/share", ofType: "html")
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
        //加载列表数据
        if url?.scheme == "load" {
            assestService.revenueShareData({
                data in
                webView.stringByEvaluatingJavaScriptFromString("getData(\(data))")
                
            })
        }else if url?.scheme == "share" {
            share()
        }
        return true
    }
    
    func share(){
        UMSocialSnsService.presentSnsIconSheetView(self, appKey: B.UMENG_APP_KEY, shareText: "分享", shareImage: "app_logo", shareToSnsNames: [UMShareToWechatTimeline,UMShareToSina], delegate: self)
        
        //注册地址 + 推荐码
        let url = B.SOCIAL_REVENUE_ADDRESS + "/mm/" + userDefaultsUtil.getMobile()!
        let title = "人民币 克隆记"
        let shareText = "种5块，得10块，银多带你玩转人民币！"
        let shareImage = UIImage(named: "referral_share_icon")
        //微信好友与朋友圈
        UMSocialData.defaultData().extConfig.wechatTimelineData.url = url
        UMSocialData.defaultData().extConfig.wechatTimelineData.title = title
        UMSocialData.defaultData().extConfig.wechatTimelineData.shareText = shareText
        UMSocialData.defaultData().extConfig.wechatTimelineData.shareImage = shareImage
        UMSocialData.defaultData().extConfig.wxMessageType = UMSocialWXMessageTypeWeb

        //新浪分享
        UMSocialData.defaultData().extConfig.sinaData.urlResource.setResourceType(UMSocialUrlResourceTypeDefault, url: url)
        UMSocialData.defaultData().extConfig.sinaData.shareText = "种5块，得10块，银多带你玩转人民币！" + url
        UMSocialData.defaultData().extConfig.sinaData.shareImage = UIImage(named: "referral_share_icon")
        UMSocialData.defaultData().extConfig.sinaData.snsName = "银多资本"

    }
    
    func isDirectShareInIconActionSheet() -> Bool {
        return true
    }
    
    //分享成功回调方法
    func didFinishGetUMSocialDataInViewController(response: UMSocialResponseEntity){
        if response.responseCode == UMSResponseCodeSuccess {
            self.loadingShow()
            //分享成功后给券
            assestService.shareStatus({
                data in
                self.loadingHidden()
                if let mm = data as? MsgModel {
                    if !mm.msg.isEmpty {
                        KGXToast.showToastWithMessage(mm.msg, duration: ToastDisplayDuration.LengthShort)
                    }
                }
            })
        }
    }
    
    
    func initView(){
        initNav("收益分享")
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