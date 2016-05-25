//
//  BaseViewController.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/3/18.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit
import SwiftyDrop

class BaseViewController:UIViewController,UITextFieldDelegate {
    
    var loadingView: LoadingView!
    
    var helpCenter_Cid = ""
    
    var info_cid = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //注册推送跳转界面通知
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "pushNav", name: UIApplicationDidBecomeActiveNotification, object: nil)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        let center = NSNotificationCenter.defaultCenter()
        center.removeObserver(self)
    }
    
    func addHelpCenter(cid:String){
        self.helpCenter_Cid = cid
        let backBtn = UIButton()
        let backImage = UIImage(named: "helpCenter_icon")
        backBtn.frame = CGRectMake(0, 0, backImage!.size.width, backImage!.size.height);
        backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0)
        backBtn.setImage(backImage, forState: UIControlState.Normal)
        backBtn.addTarget(self, action: "helpClick", forControlEvents: UIControlEvents.TouchUpInside)
        let backBtnItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.rightBarButtonItem = backBtnItem
    }
    
    func helpClick(){
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "UserCenter", bundle: NSBundle.mainBundle())
        let viewController:HelpCenterViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("helpCenterCtrl") as! HelpCenterViewController
        viewController.parm = self.helpCenter_Cid
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //添加规则按钮
    func addInfo(cid:String){
        self.info_cid = cid
        let backBtn = UIButton()
        let backImage = UIImage(named: "helpCenter_icon")
        backBtn.frame = CGRectMake(0, 0, backImage!.size.width, backImage!.size.height);
        backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        backBtn.setImage(backImage, forState: UIControlState.Normal)
        backBtn.addTarget(self, action: "infoShow", forControlEvents: UIControlEvents.TouchUpInside)
        let backBtnItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.rightBarButtonItem = backBtnItem
    }
    
    //显示规则
    func infoShow(){
        let view = ModalView.instantiateFromNib()
        view.loadUrl(info_cid)
        let window = UIApplication.sharedApplication().delegate?.window
        let modal = PathDynamicModal()
        modal.showMagnitude = 200.0
        modal.closeMagnitude = 130.0
        view.closeButtonHandler = {[weak modal] in
            modal?.closeWithLeansRandom()
            return
        }
        view.bottomButtonHandler = {[weak modal] in
            modal?.closeWithLeansRandom()
            return
        }
        modal.show(modalView: view, inView: window!!)
    }
    
    
    func initNav(name:String){
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.backItem?.title = ""
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.translucent = false
        let lab = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        lab.text = name
        lab.textColor = UIColor.blackColor()
        self.navigationItem.titleView = lab
        //设置标题颜色
        _ = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        //self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as [NSObject : AnyObject]
        //self.view.backgroundColor = B.VIEW_BG
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
    }
    
    //页面跳转
    func gotoPage(sbName:String, pageName:String){
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: sbName, bundle: NSBundle.mainBundle())
        let viewController:UIViewController = oneStoryBoard.instantiateViewControllerWithIdentifier(pageName) 
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //显示等待视图
    func loadingShow(){
        SwiftSpinner.show("加载中", animated: true)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
//        delay(seconds: 30.0, completion: {
//            self.loadingHidden()
//        })
    }
    
    //设置最长时间
//    func delay(seconds seconds: Double, completion:()->()) {
//        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
//        dispatch_after(popTime, dispatch_get_main_queue()) {
//            completion()
//        }
//    }
    
    //隐藏等待视图
    func loadingHidden(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        SwiftSpinner.hide()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func closeKeyBoard(){
        UIApplication.sharedApplication().sendAction("resignFirstResponder", to: nil, from: nil, forEvent: nil)
    }
    
    func pushNav() {
        
        let myDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let notification = myDelegate.notificationDic {
            if let type = notification.valueForKeyPath("type") as? String {
                switch type {
                    case "1":
                        if let url = notification.valueForKeyPath("url") as? String {
                            if let name = notification.valueForKeyPath("name") as? String {
                                if !userDefaultsUtil.isLoggedIn() {
                                    KGXToast.showToastWithMessage("请您登录后在发现中查看\'\(name)\'内容!", duration: ToastDisplayDuration.LengthShort)
                                    myDelegate.notificationDic = nil
                                    return
                                }
//                                UMessage.sendClickReportForRemoteNotification(notification as Dictionary)
                                let oneStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                                let webViewVC:ActivityIntoWebViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("imageintoweb") as! ActivityIntoWebViewController
                                webViewVC.name = name
                                webViewVC.passUrl = url
                                self.navigationController?.pushViewController(webViewVC, animated: true)
                                myDelegate.notificationDic = nil
                            }
                    }
                    //客服服务
                   case "4":
                    if  notification.valueForKeyPath("message") as? String != "" {
                        if userDefaultsUtil.getMessage() != "message"{
                            userDefaultsUtil.setNotificationMessageKey("message")
                        }
                    }
                    
                    case "3":
                        if let id = notification.valueForKeyPath("url") as? String {
                            if !userDefaultsUtil.isLoggedIn() {
                                KGXToast.showToastWithMessage("请您登录后在公告中查看详细内容!", duration: ToastDisplayDuration.LengthShort)
                                myDelegate.notificationDic = nil
                                return
                            }
//                            UMessage.sendClickReportForRemoteNotification(notification as Dictionary)
                            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "UserCenter", bundle: NSBundle.mainBundle())
                            let mdvc:MessageDetailViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("MessageDetailVC") as! MessageDetailViewController
                            mdvc.id = id
                            self.navigationController?.pushViewController(mdvc, animated: true)
                            myDelegate.notificationDic = nil
                    }
                    
                    
                    default:
                        break
                }
            }
        }
    }
    
    /** 颜色转图片 **/
    func createImageWithColor() -> UIImage {
        let color = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5).CGColor
        let rect = CGRectMake(0, 0, 1, 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color)
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image;
        
    }
    
//    func hideBar(){
//        if self.tabBarController?.tabBar.hidden == true {
//            return
//        }
//        var contentView = UIView();
//        if self.tabBarController!.view.subviews[0].isKindOfClass(UITabBar) {
//            contentView = self.tabBarController!.view.subviews[1] as! UIView
//        }else{
//            contentView = self.tabBarController!.view.subviews[0] as! UIView
//        }
//        contentView.frame = CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height - self.tabBarController!.tabBar.frame.size.height)
//        contentView.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
//        self.tabBarController?.tabBar.hidden = true
//        
//    }
    
    func setTabBarVisible(visible:Bool, animated:Bool) {
        
        //* This cannot be called before viewDidLayoutSubviews(), because the frame is not set before this time
        
        // bail if the current state matches the desired state
        if (tabBarIsVisible() == visible) { return }
        
        // get a frame calculation ready
        let frame = self.tabBarController?.tabBar.frame
        let height = frame?.size.height
        let offsetY = (visible ? -height! : height)
        
        // zero duration means no animation
        let duration:NSTimeInterval = (animated ? 0.3 : 0.0)
        
        //  animate the tabBar
        if frame != nil {
            UIView.animateWithDuration(duration) {
                self.tabBarController?.tabBar.frame = CGRectOffset(frame!, 0, offsetY!)
                return
            }
        }
    }
    
    func tabBarIsVisible() -> Bool {
        return self.tabBarController?.tabBar.frame.origin.y < UIScreen.mainScreen().bounds.height
    }
    
}