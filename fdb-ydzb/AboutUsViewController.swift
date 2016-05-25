//
//  AboutusViewController.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/9/9.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit
//RCIMUserInfoFetcherDelegagte
class AboutUsViewController:BaseViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!
    
    //    var connStatus = false                                          //融云服务连接状态
    
    //var chatViewController:RCChatViewController?                    //融云客服controller
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        loadUrl()
        //addVoice()
    }
    
    //加载客服页面
//    func addVoice() {
//        //获取融云token
//        let rong_userToken = userDefaultsUtil.getRcToken()
//        RCIM.setUserInfoFetcherWithDelegate(self, isCacheUserInfo: true)
//        //连接融云服务器
//        RCIM.connectWithToken(rong_userToken, completion: {
//            userId in
//            //            self.connStatus = true
//            self.chatViewController = RCIM.sharedRCIM().createCustomerService(B.RONGCLOUD_CUSTOMER_ID, title: "客服", completion: nil)
//            //返回按钮
//            let backBtn = UIButton()
//            let backImage = UIImage(named: "peizi_return_icon")
//            backBtn.frame = CGRectMake(0, 0, backImage!.size.width, backImage!.size.height);
//            backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0)
//            backBtn.setImage(backImage, forState: UIControlState.Normal)
//            backBtn.addTarget(self, action: "returnClick", forControlEvents: UIControlEvents.TouchUpInside)
//            let leftBtn = UIBarButtonItem(customView: backBtn)
//            
//            //客服controller
//            self.chatViewController!.view.backgroundColor = B.VIEW_BG
//            self.chatViewController!.chatListTableView.backgroundColor = B.VIEW_BG
//            self.chatViewController!.navigationItem.leftBarButtonItem = leftBtn
//            self.chatViewController!.hidesBottomBarWhenPushed = true
//            self.chatViewController!.setNavigationTitle("客服", textColor: B.NAV_TITLE_CORLOR)
//            
//            
//            }, error: {
//                (status:RCConnectErrorCode) -> Void in
//        })
//        
//    }
    
    func addBackBtn(){
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
        let path = NSBundle.mainBundle().pathForResource("./hybrid/aboutUs", ofType: "html")
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
        if url?.scheme == "voice" {
            //gotoCustomer()
        }
        return true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "WebKitCacheModelPreferenceKey")
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "WebKitOfflineWebApplicationCacheEnabled")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    
    
    func initView(){
        initNav("关于我们")
        self.webView.backgroundColor = B.VIEW_BG
        self.webView.delegate = self
    }
    
    
//    func gotoCustomer(){
//        if chatViewController != nil && !userDefaultsUtil.getRcToken()!.isEmpty{
//            self.navigationController?.pushViewController(chatViewController!, animated: true)
//        }else{
//            KGXToast.showToastWithMessage("抱歉，客服暂时无法连接", duration: ToastDisplayDuration.LengthShort)
//        }
//        
//        //self.tabBarController?.selectedIndex = 3
//    }
    
    
    
    func returnClick(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
//    func getUserInfoWithUserId(userId: String!, completion: ((RCUserInfo!) -> Void)!) {
//        //客服user
//        if userId == B.RONGCLOUD_CUSTOMER_ID {
//            let user = RCUserInfo()
//            user.userId = userId
//            user.name = "银多客服"
//            user.portraitUri = B.KEFU_AVATAR_LINK
//            return completion(user)
//        }else{
//            let user = RCUserInfo()
//            user.userId = userDefaultsUtil.showMobile()
//            user.name = userDefaultsUtil.getUsername()
//            user.portraitUri = userDefaultsUtil.getAvatarLink()
//            return completion(user)
//        }
//    }

}