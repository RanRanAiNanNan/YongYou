//
//  MyRecommendViewController.swift
//  ydzbapp-hybrid
//  我的推荐
//  Created by qinxin on 15/9/6.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class MyRecommendViewController: BaseViewController/*, UMSocialUIDelegate*/{
    
    @IBOutlet weak var imageView: UIImageView!          //gif动态图
    
    @IBOutlet weak var referralCodeLab: UILabel!        //推荐码
    
    @IBOutlet weak var recommendAction: UILabel! {      //查看推荐纪录
        didSet {
            recommendAction.userInteractionEnabled = true
            recommendAction.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "recommendPush"))
        }
    }
    
    var referralService = ReferralService.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAutoLayout()
        initNav("我的推荐")
        //addHelpCenter("")
        addInfo(B.ROLE_RECOMMEND)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func loadData(){
        loadingShow()
        referralService.queryUserReferralCode(
            {
                (data:String, status:Int) in
                self.loadingHidden()
                if status == 0 {
                    if data.isEmpty {
                        self.referralCodeLab.text = "暂无"
                    }else{
                        self.referralCodeLab.text = data
                    }
                }else if status == -1 {
                    KGXToast.showToastWithMessage(data, duration: ToastDisplayDuration.LengthShort)
                }
            }
        )
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let imageData = NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("my_recommend", withExtension: "gif")!)
        let recommend = UIImage.animatedImageWithData(imageData!)
        imageView.image = recommend
        
    }
    
    //分享推荐码
    @IBAction func shareClick(sender: AnyObject) {
//        if self.referralCodeLab.text != "暂无" {
//            UMSocialSnsService.presentSnsIconSheetView(self, appKey: B.UMENG_APP_KEY, shareText: "分享", shareImage: UIImage(named:"app_logo"), shareToSnsNames: [UMShareToWechatSession, UMShareToWechatTimeline, UMShareToSina, UMShareToQQ, UMShareToQzone], delegate: self)
//        
//            //注册地址 + 推荐码
//            let url = B.SOCIAL_REGISTER_ADDRESS + self.referralCodeLab.text!
//            let title = "戳这里 秒变壕!"
//            let shareText = "携手银多，跟我一起壕!"
//            let shareImage = UIImage(named: "referral_share_icon")
//            //微信好友与朋友圈
//            UMSocialData.defaultData().extConfig.wechatSessionData.url = url
//            UMSocialData.defaultData().extConfig.wechatTimelineData.url = url
//            UMSocialData.defaultData().extConfig.wechatSessionData.title = title
//            UMSocialData.defaultData().extConfig.wechatTimelineData.title = title
//            UMSocialData.defaultData().extConfig.wechatSessionData.shareText = shareText
//            UMSocialData.defaultData().extConfig.wechatTimelineData.shareText = shareText
//            UMSocialData.defaultData().extConfig.wechatTimelineData.shareImage = shareImage
//            UMSocialData.defaultData().extConfig.wechatSessionData.shareImage = shareImage
//            UMSocialData.defaultData().extConfig.wxMessageType = UMSocialWXMessageTypeWeb
//            //新浪分享
//            UMSocialData.defaultData().extConfig.sinaData.urlResource.setResourceType(UMSocialUrlResourceTypeDefault, url: url)
//            UMSocialData.defaultData().extConfig.sinaData.shareText = "戳这里 秒变壕! 携手银多，跟我一起壕!" + url
//            UMSocialData.defaultData().extConfig.sinaData.shareImage = UIImage(named: "referral_share_icon")
//            UMSocialData.defaultData().extConfig.sinaData.snsName = "银多资本"
//            //QQ与Qzone
//            UMSocialData.defaultData().extConfig.qqData.url = url
//            UMSocialData.defaultData().extConfig.qzoneData.url = url
//            UMSocialData.defaultData().extConfig.qqData.title = title
//            UMSocialData.defaultData().extConfig.qzoneData.title = title
//            UMSocialData.defaultData().extConfig.qqData.shareText  = shareText
//            UMSocialData.defaultData().extConfig.qzoneData.shareText  = shareText
//            UMSocialData.defaultData().extConfig.qqData.shareImage  = shareImage
//            UMSocialData.defaultData().extConfig.qzoneData.shareImage = shareImage
//        }else{
//           KGXToast.showToastWithMessage("暂无推荐码，请联系客服!", duration: ToastDisplayDuration.LengthShort)
//        }
//    }
//    
//    func didFinishGetUMSocialDataInViewController(response: UMSocialResponseEntity!) {
//        if response.responseCode == UMSResponseCodeSuccess {
//            print("分享成功！！！")
//        }
    }
    
    //复制推荐码
    @IBAction func copyClick(sender: AnyObject) {
        if self.referralCodeLab.text != "暂无" {
            let pasteboard = UIPasteboard.generalPasteboard()
            pasteboard.string = self.referralCodeLab.text
            KGXToast.showToastWithMessage("复制成功", duration: ToastDisplayDuration.LengthShort)
        }else{
            KGXToast.showToastWithMessage("暂无推荐码，请联系客服!", duration: ToastDisplayDuration.LengthShort)
        }
    }
    
    func recommendPush() {
        self.performSegueWithIdentifier("gotoRecommendList", sender: self)
    }
    
    func initAutoLayout(){
        switch Device.version() {
        case .iPhone4, .iPhone4S:
            constrain(imageView){
                imageView in
                imageView.width == 150
                imageView.height == 150
                imageView.top == imageView.superview!.top + 10
            }
        default:
            break
//            print("Unknown")
        }
    }

}
