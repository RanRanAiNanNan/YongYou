//
//  BaseTableViewController.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/3/18.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit

class BaseTableViewController:UITableViewController {
    
    var loadingView: LoadingView!
    
    var helpCenter_Cid = ""
    
    var info_cid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //删除table view中多余的分割线
        self.setExtraCellLineHidden()
    }
    
    private func setExtraCellLineHidden() {
        let view = UIView(frame: CGRectMake(0, 0, B.SCREEN_WIDTH, 55))
        view.backgroundColor = UIColor.clearColor()
//        self.tableView.tableFooterView = view
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //注册推送跳转界面通知
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "pushNav", name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //解决table view中分割线左边不对齐
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.tableView.layoutMargins = UIEdgeInsetsZero
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        let center = NSNotificationCenter.defaultCenter()
        center.removeObserver(self)
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layoutMargins = UIEdgeInsetsZero
        cell.separatorInset = UIEdgeInsetsZero
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
        //let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        //self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as [NSObject : AnyObject]
        self.view.backgroundColor = B.VIEW_BG
    }
    
    //添加帮助中心按钮
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
    
    //显示帮助中心内容
    func helpClick(){
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "UserCenter", bundle: NSBundle.mainBundle())
        let viewController:HelpCenterViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("helpCenterCtrl") as! HelpCenterViewController
        viewController.parm = self.helpCenter_Cid
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //页面跳转
    func gotoPage(sbName:String, pageName:String){
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: sbName, bundle: NSBundle.mainBundle())
        let viewController:UIViewController = oneStoryBoard.instantiateViewControllerWithIdentifier(pageName)
        viewController.hidesBottomBarWhenPushed = true
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
    
    
    func closeKeyBoard(){
        UIApplication.sharedApplication().sendAction("resignFirstResponder", to: nil, from: nil, forEvent: nil)
    }
    
    func isEmpty(str:String) -> Bool {
        if str.isEmpty{
            return true
        }else{
            let set = NSCharacterSet.whitespaceAndNewlineCharacterSet()
            let trimedString = str.stringByTrimmingCharactersInSet(set)
            if trimedString.characters.count == 0 {
                return true
            }else{
                return false
            }
        }
    }
}