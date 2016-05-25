//
//  ProductDetailsViewController.swift
//  fdb-ydzb
//
//  Created by 123 on 16/3/25.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation

import UIKit
import SwiftyJSON

class ProductDetailsViewController:BaseViewController , UMSocialUIDelegate {
    var str : String!
    //立即购买
    var messageBtn: UIBarButtonItem!
    
    @IBOutlet weak var timeLB: UILabel!
    @IBOutlet weak var yuyueBt: UIButton!
    @IBOutlet weak var yuYueBT: UIButton!
    @IBOutlet weak var productWebView: UIWebView!
    let homeService = HomeService.getInstance()
    var int : Int!
    var date1 : String!
    
    var title1 : String!
    var content : String!
    var proName : String!
    var url : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initNav("产品详情")
        
        let financeTabBarItem = tabBarController?.tabBar.items![1]
        financeTabBarItem?.image = UIImage(named: "64-icon-yongyou2")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
    }
    override func viewWillAppear(animated: Bool) {
    
        homeService.fenXiang(str) { (data) -> () in
            if let hm = data as? FenXiangModel{
                self.title1 = hm.title
                self.content = hm.content
                self.proName = hm.proName
                self.url = hm.url
                
            }
        }
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        loadUrl()
    }

    func initView(){
        
        let string = NSString(string: date1)
        
        let timeSta:NSTimeInterval = string.doubleValue
        let dfmatter = NSDateFormatter()
        dfmatter.dateFormat="yyyy年MM月dd日 HH:mm:ss"
        
        let date = NSDate(timeIntervalSince1970: timeSta)
        
        print(dfmatter.stringFromDate(date))
        timeLB.text = dfmatter.stringFromDate(date)

        
        
        let msgBtn = UIButton()
        let backImage = UIImage(named: "share")
        msgBtn.frame = CGRectMake(0, 0, backImage!.size.width, backImage!.size.height)
        msgBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        msgBtn.setImage(backImage, forState: UIControlState.Normal)
        msgBtn.addTarget(self, action: "messageClick", forControlEvents: UIControlEvents.TouchUpInside)
        //var backBtnItem = UIBarButtonItem(customView: backBtn)
        messageBtn = UIBarButtonItem(customView: msgBtn)
        self.navigationItem.rightBarButtonItem = messageBtn
        
        yuyueBt!.layer.borderColor = UIColor(red: 207/255, green: 174/255, blue: 120/255, alpha: 1).CGColor

        
    }
    
    func messageClick(){
        
        
     print("分享")
        UMSocialSnsService.presentSnsIconSheetView(self, appKey: B.UMENG_APP_KEY, shareText: "分享", shareImage: UIImage(named:"referral_share_icon"), shareToSnsNames: [UMShareToWechatSession, UMShareToWechatTimeline/*, UMShareToSina, UMShareToQQ, UMShareToQzone*/], delegate: self)
        
        //注册地址 + 推荐码
        let url = B.SOCIAL_REGISTER_ADDRESS //+ self.referralCodeLab.text!
        let title = "不知道要分享什么"
        let shareText = "还是不知道"
        let shareImage = UIImage(named: "referral_share_icon")
   

//        print(self.title1)
//        print(self.content)
//        print(self.proName)
//        print(self.url)

        //微信好友与朋友圈
        UMSocialData.defaultData().extConfig.wechatSessionData.url = self.url
        UMSocialData.defaultData().extConfig.wechatTimelineData.url = self.url
        UMSocialData.defaultData().extConfig.wechatSessionData.title = self.title1
        UMSocialData.defaultData().extConfig.wechatTimelineData.title = self.title1
        UMSocialData.defaultData().extConfig.wechatSessionData.shareText = self.content
        UMSocialData.defaultData().extConfig.wechatTimelineData.shareText = self.content
        UMSocialData.defaultData().extConfig.wechatTimelineData.shareImage = shareImage
        UMSocialData.defaultData().extConfig.wechatSessionData.shareImage = shareImage
        UMSocialData.defaultData().extConfig.wxMessageType = UMSocialWXMessageTypeWeb
        //新浪分享
        UMSocialData.defaultData().extConfig.sinaData.urlResource.setResourceType(UMSocialUrlResourceTypeDefault, url: url)
        UMSocialData.defaultData().extConfig.sinaData.shareText = "戳这里 秒变壕! 携手银多，跟我一起壕!" + url
        UMSocialData.defaultData().extConfig.sinaData.shareImage = UIImage(named: "referral_share_icon")
        UMSocialData.defaultData().extConfig.sinaData.snsName = "银多资本"
        //QQ与Qzone
        UMSocialData.defaultData().extConfig.qqData.url = url
        UMSocialData.defaultData().extConfig.qzoneData.url = url
        UMSocialData.defaultData().extConfig.qqData.title = title
        UMSocialData.defaultData().extConfig.qzoneData.title = title
        UMSocialData.defaultData().extConfig.qqData.shareText  = shareText
        UMSocialData.defaultData().extConfig.qzoneData.shareText  = shareText
        UMSocialData.defaultData().extConfig.qqData.shareImage  = shareImage
        UMSocialData.defaultData().extConfig.qzoneData.shareImage = shareImage
        
        
    }
    
    func loadUrl(){
//        let path = NSBundle.mainBundle().pathForResource("./hybrid/addItem", ofType: "html")
//        let url = NSURL.fileURLWithPath(path!)
//        let request = NSURLRequest(URL: url)
//        productWebView.scalesPageToFit = true
//        productWebView.loadRequest(request)
        //webView.scrollView.bounces = false;
         productWebView.loadRequest(NSURLRequest(URL:NSURL(string:"http://121.43.118.86:10220/Home/Index/product/id/\(str)")!))
    }
    
    @IBAction func yuYue(sender: AnyObject) {
//        print(str)
        
        if !userDefaultsUtil.isLoggedIn(){
            let twoStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let twoController:LoginViewController = twoStoryBoard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            twoController.hidesBottomBarWhenPushed = true
            self.presentViewController(twoController, animated: true, completion: nil)
        }else{ 
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let rpvc:ImmediatelyViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ImmediatelyViewController") as! ImmediatelyViewController
        rpvc.str = self.str
            rpvc.chongXinYuYue = ""
            print(rpvc.str)
        rpvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(rpvc, animated: true)
//        gotoPage("Main", pageName: "ImmediatelyViewController")
        }
    }
    
    
    
    
    
}