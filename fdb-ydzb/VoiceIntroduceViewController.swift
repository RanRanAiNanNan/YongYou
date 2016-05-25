//
//  VoiceIntroduceViewController.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/7/7.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit

class VoiceIntroduceViewController: BaseViewController {
    
    @IBOutlet weak var voiceImgView: UIImageView!
    @IBOutlet weak var animView: PulsingRadarView!
    
    var radarView: PulsingRadarView!                                //扩散动画
    
    var connStatus = false                                          //融云服务连接状态
    
    //var chatViewController:RCChatViewController?                    //融云客服controller
    
    var navCtrl:UINavigationController?                             //融云
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //addVoice()
        let radarSize = CGSizeMake(80, 80)
        radarView = PulsingRadarView(frame: CGRectMake(self.view.frame.size.width/2 - 20,self.view.frame.size.height/4 * 3 - 20,
            40,40))
        radarView.tag = 211
        let image = UIImageView(frame: CGRectMake(self.view.frame.size.width/2 - 40,self.view.frame.size.height/4 * 3 - 40,
            radarSize.width,radarSize.height))
        image.userInteractionEnabled = true
        let imgTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "gotoCustomer")
        image.addGestureRecognizer(imgTap)
        
        image.image = UIImage(named: "voice_icon")
        self.view.addSubview(radarView)
        self.view.addSubview(image)
    }
    
    
    
    //加载客服页面
    //    func addVoice() {
    //        //获取融云token
    //        let rong_userToken = userDefaultsUtil.getRcToken()
    //        RCIM.setUserInfoFetcherWithDelegate(self, isCacheUserInfo: true)
    //        //连接融云服务器
    //        RCIM.connectWithToken(rong_userToken, completion: {
    //            userId in
    //            self.connStatus = true
    //            self.chatViewController = RCIM.sharedRCIM().createCustomerService(B.RONGCLOUD_CUSTOMER_ID, title: "在线客服", completion: nil)
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
    //            self.navCtrl = UINavigationController(rootViewController: self.chatViewController!)
    //            self.navCtrl!.navigationBar.barTintColor = B.NAV_BG
    //
    //            }, error: {
    //                (status:RCConnectErrorCode) -> Void in
    //        })
    //
    //    }
    
    func initView() {
        initNav("在线客服")
    }
    
    
    @IBAction func intoVoiceClick(sender: AnyObject) {
        //gotoCustomer()
    }
    
    //    func gotoCustomer(){
    //        if connStatus {
    //            self.navigationController?.pushViewController(chatViewController!, animated: true)
    //        }
    //    }
    
    func returnClick(){
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let viewController:UIViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("mainCtrl")
        let transition = CATransition();
        transition.duration = 0.3;
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromRight
        viewController.view.layer.addAnimation(transition, forKey: nil)
        self.navigationController?.popToRootViewControllerAnimated(true)
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
    //            user.userId = userDefaultsUtil.getMobile()
    //            user.name = userDefaultsUtil.getUsername()
    //            user.portraitUri = userDefaultsUtil.getAvatarLink()
    //            return completion(user)
    //        }
    //    }
    
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        radarView.removeFromSuperview()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}