//
//  CustomerServiceViewController.swift
//  ydzbapp-hybrid
//
//  Created by qinxin on 15/7/22.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit
//RCIMUserInfoFetcherDelegagte
class CustomerServiceViewController: BaseViewController{
    
    let myDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNav("在线客服")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if myDelegate.direction {
            returnClick()
        }else{
            //addVoice()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let array = self.navigationController?.viewControllers {
            if array.count > 1 {
                myDelegate.direction = true
            }else{
                myDelegate.direction = false
            }
            //            if array.count > 1 {
            //                if let vc = array[1] as? RCChatViewController {
            //                    vc.navigationController?.interactivePopGestureRecognizer.enabled = false
            //                }
            //            }
        }
    }
    
    //    private func addVoice() {
    //        //获取融云token
    //        let rong_userToken = userDefaultsUtil.getRcToken()
    //        RCIM.setUserInfoFetcherWithDelegate(self, isCacheUserInfo: true)
    //
    //        //连接融云服务器
    //        if rong_userToken != "" {
    //            loadingShow()
    //            RCIM.connectWithToken(rong_userToken, completion: {
    //                userId in
    //                let vc = RCIM.sharedRCIM().createCustomerService(B.RONGCLOUD_CUSTOMER_ID, title: "在线客服", completion: nil)
    //                //返回按钮
    //                let backBtn = UIButton()
    //                let backImage = UIImage(named: "peizi_return_icon")
    //                backBtn.frame = CGRectMake(0, 0, backImage!.size.width, backImage!.size.height);
    //                backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0)
    //                backBtn.setImage(backImage, forState: UIControlState.Normal)
    //                backBtn.addTarget(self, action: "returnClick", forControlEvents: UIControlEvents.TouchUpInside)
    //                let leftBtn = UIBarButtonItem(customView: backBtn)
    //                //客服controller
    //                vc.view.backgroundColor = B.VIEW_BG
    //                vc.chatListTableView.backgroundColor = B.VIEW_BG
    //                vc.navigationItem.leftBarButtonItem = leftBtn
    //                vc.hidesBottomBarWhenPushed = true
    //                self.navigationController?.pushViewController(vc, animated: false)
    //                self.loadingHidden()
    //                }, error: {
    //                    (status:RCConnectErrorCode) -> Void in
    //                    KGXToast.showToastWithMessage("抱歉，客服暂时无法连接", duration: ToastDisplayDuration.LengthShort)
    //                    self.loadingHidden()
    //            })
    //
    //        }else{
    //            KGXToast.showToastWithMessage("抱歉，客服暂时无法连接", duration: ToastDisplayDuration.LengthShort)
    //        }
    //    }
    
    func returnClick(){
        
        myDelegate.direction = false
        
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let viewController:UIViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("mainCtrl")
        let transition = CATransition();
        transition.duration = 0.3;
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromRight
        viewController.view.layer.addAnimation(transition, forKey: nil)
        self.presentViewController(viewController, animated: true, completion: nil)
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
