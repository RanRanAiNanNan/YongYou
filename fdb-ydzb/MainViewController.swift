//
//  MainController.swift
//  ydzbApp
//
//  Created by 刘驰 on 15/1/23.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit


class MainViewController: UITabBarController,UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = self.tabBar.items!.count as Int
        self.tabBar.backgroundColor = B.NAV_BG
        self.tabBar.tintColor = B.TAB_SELECTED
        self.delegate = self
        //        addVoice()
    }
    
    //加载客服页面
    //    func addVoice() {
    //
    //        //获取融云token
    //        let rong_userToken = userDefaultsUtil.getRcToken()
    //        RCIM.setUserInfoFetcherWithDelegate(self, isCacheUserInfo: true)
    //        //连接融云服务器
    //        RCIM.connectWithToken(rong_userToken, completion: {
    //            userId in
    //            let chatViewController = RCIM.sharedRCIM().createCustomerService(B.RONGCLOUD_CUSTOMER_ID, title: "在线客服", completion: nil)
    //            //返回按钮
    //            let backBtn = UIButton()
    //            let backImage = UIImage(named: "peizi_return_icon")
    //            backBtn.frame = CGRectMake(0, 0, backImage!.size.width, backImage!.size.height);
    //            backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0)
    //            backBtn.setImage(backImage, forState: UIControlState.Normal)
    //            backBtn.addTarget(self, action: "returnClick", forControlEvents: UIControlEvents.TouchUpInside)
    //            let leftBtn = UIBarButtonItem(customView: backBtn)
    //            //客服controller
    //            chatViewController.view.backgroundColor = B.VIEW_BG
    //            chatViewController.chatListTableView.backgroundColor = B.VIEW_BG
    //            chatViewController.navigationItem.leftBarButtonItem = leftBtn
    //            chatViewController.hidesBottomBarWhenPushed = true
    //            chatViewController.tabBarItem.title = "客服"
    //            chatViewController.tabBarItem.image = UIImage(named: "home_nav_voice")
    //            let navCtrl = UINavigationController()
    //            navCtrl.addChildViewController(chatViewController)
    //            navCtrl.navigationBar.barTintColor = B.NAV_BG
    //            self.viewControllers?.append(navCtrl)
    //            }, error: {
    //                (status:RCConnectErrorCode) -> Void in
    //        })
    //
    //    }
    
    func returnClick(){
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
    //            user.userId = userDefaultsUtil.getMobile()
    //            user.name = userDefaultsUtil.getUsername()
    //            user.portraitUri = userDefaultsUtil.getAvatarLink()
    //            return completion(user)
    //        }
    //    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if item == tabBar.items![1] {
                let center = NSNotificationCenter.defaultCenter()
                let notification = NSNotification(name: FinanceKeyRadio.Notification, object: nil, userInfo: nil)
                center.postNotification(notification)

            
            
        } else if item == tabBar.items![2] {
                let center = NSNotificationCenter.defaultCenter()
                let notification = NSNotification(name: DiscoverKeyRadio.Notification, object: nil, userInfo: nil)
                center.postNotification(notification)            }

    }
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        //用户是否末登录
        if !userDefaultsUtil.isLoggedIn() {
            //是否为资产
//            if tabBarController.tabBar.selectedItem == tabBar.items![1] {
//                
//                let twoStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//                let twoController:LoginViewController = twoStoryBoard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
//                twoController.hidesBottomBarWhenPushed = true
////                self.navigationController?.pushViewController(twoController, animated: false)
//                userDefaultsUtil.setTiaoZhuan("订单")
//                self.presentViewController(twoController, animated: true, completion: nil)
//
//                return false
//            }else if tabBarController.tabBar.selectedItem == tabBar.items![2]{
//                let twoStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//                let twoController:LoginViewController = twoStoryBoard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
//                twoController.hidesBottomBarWhenPushed = true
//                userDefaultsUtil.setTiaoZhuan("财富")
//                //                self.navigationController?.pushViewController(twoController, animated: false)
////                twoController.index = 2
//                self.presentViewController(twoController, animated: true, completion: nil)
//                return false
//            }
//            return false
//        }
//        return true
//    }
    
//}
            //是否为资产
            if tabBarController.tabBar.selectedItem == tabBar.items![1] || tabBarController.tabBar.selectedItem == tabBar.items![2]{
                let twoStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let twoController:LoginViewController = twoStoryBoard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                twoController.hidesBottomBarWhenPushed = true
                if tabBarController.tabBar.selectedItem == tabBar.items![1]{
                    userDefaultsUtil.setTiaoZhuan("1")
                }else if tabBarController.tabBar.selectedItem == tabBar.items![2]{
                    userDefaultsUtil.setTiaoZhuan("2")
                }
                //                self.navigationController?.pushViewController(twoController, animated: false)
                self.presentViewController(twoController, animated: true, completion: nil)
                
                return false
            }else{
                return true
            }
        }
        return true
    }
    
}
