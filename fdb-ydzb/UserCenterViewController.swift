//
//  UserCenterController.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/9/7.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON



//RCIMUserInfoFetcherDelegagte

class UserCenterViewController: BaseTableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate ,UITextFieldDelegate {
    
    @IBOutlet weak var usernameLab: UILabel!            //用户欢迎
    
    @IBOutlet weak var avatarImg: UIImageView!
    
    @IBOutlet weak var vipImg: UIImageView!
    
    @IBOutlet weak var nameTF: UITextField!
    var messageBtn: UIBarButtonItem!
    
    //var chatViewController:RCChatViewController?                    //融云客服controller
    
    var picker:UIImagePickerController!
    
    @IBOutlet weak var remindSwitch: UISwitch!          //帐户异常提醒
    
    let userSafetyService =  UserSafetyInfoService.getInstance();
    let userCenterService = UserCenterService.getInstance()
    let assestService = AssestService.getInstance()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNav("用户中心")
        //显示VIP图像
        showVip()
        addMsg()
        //swipe()
        //addInfo("usercenter")
        initView()
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.navigationBarHidden = false
//        self.tabBarController!.hidesBottomBarWhenPushed = false
        self.tabBarController!.tabBar.hidden = false
        super.viewWillAppear(true)
        showAvatar()
        nameTF.text = userDefaultsUtil.getUsername()!
        userCenterService.loadDataGet({
            (data) -> () in
            self.loadingHidden()
            if let ucm = data as? UserCenterModel {
                //显示消息
                switch Int(ucm.msg)! {
                case 0:
                    self.setMessageImg("icon－meixin")
                case 1,2,3,4,5:
                    self.setMessageImg("icon－meixin")
                default:
                    self.setMessageImg("icon－meixin")
                }
                //帐号异常提醒
//                if ucm.remind == "1" {
//                    self.remindSwitch.on = true
//                }else{
//                    self.remindSwitch.on = false
//                }
            }
        })
    }
    
    func setMessageImg(name:String){
        (self.navigationItem.rightBarButtonItem!.customView as! UIButton).setImage(UIImage(named: name), forState: UIControlState.Normal)
    }
    
    
    func initView(){
        if !userDefaultsUtil.isLoggedIn(){
//            self.nameTF.hidden = false
//            self.tabBarController!.tabBar.hidden = false
        }else{
        self.loadingShow()
        usernameLab.hidden = true
        self.nameTF.delegate = self
//        self.nameTF.hidden = true
        self.nameTF.textAlignment = .Center
        nameTF.userInteractionEnabled = true
        let singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "nameAction")
        usernameLab.addGestureRecognizer(singleTap)
        }
    }
    func textFieldDidBeginEditing(textField: UITextField){
        
               if !userDefaultsUtil.isLoggedIn(){
            self.nameTF.resignFirstResponder()
            let twoStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let twoController:LoginViewController = twoStoryBoard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(twoController, animated: false);
        }else{
            self.nameTF.becomeFirstResponder()
           }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool{
       self.nameTF.resignFirstResponder()
        print("点击完成")
        closeKeyBoard()
        var usr :NSString = nameTF.text!;
        usr = usr.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet());
        if(usr == "" || usr.length > 10){
            KGXToast.showToastWithMessage("昵称限制在0-10个字母、数字或中文", duration: ToastDisplayDuration.LengthShort)
        }else{
            loadingShow()
            userSafetyService.changeUsername(usr as String,cab: {
                data in
                self.loadingHidden()
                KGXToast.showToastWithMessage(data as String, duration: ToastDisplayDuration.LengthShort)
                self.navigationController?.popViewControllerAnimated(true);
            })
        }

        return true
    }
    func addMsg(){
        let msgBtn = UIButton()
        let backImage = UIImage(named: "icon－meixin")
        msgBtn.frame = CGRectMake(0, 0, backImage!.size.width, backImage!.size.height)
        msgBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        msgBtn.setImage(backImage, forState: UIControlState.Normal)
        msgBtn.addTarget(self, action: "messageClick", forControlEvents: UIControlEvents.TouchUpInside)
        //var backBtnItem = UIBarButtonItem(customView: backBtn)
        messageBtn = UIBarButtonItem(customView: msgBtn)
        self.navigationItem.rightBarButtonItem = messageBtn
    }
    func nameAction(){
//        self.nameTF.hidden = false

    }
    
    func showVip(){
        //判断是否是vip用户
//        let vip = userDefaultsUtil.getVip()
//        if Int(vip) > 0 {
//            vipImg.image = UIImage(named: "usercenter_vip_normal_icon")
//        }else{
//            vipImg.image = UIImage(named: "usercenter_vip_disabled_icon")
//        }
    }
    
    //跳转信息页面
    func messageClick(){
        gotoPage("UserCenter", pageName: "MessageRecordTVC")
    }
    
    //显示头像
    func showAvatar(){
        self.avatarImg.image = PhotoUtils.showAvatar()
        avatarImg.layer.cornerRadius = 35
        avatarImg.layer.borderWidth = 2
        avatarImg.layer.masksToBounds = true
        avatarImg.layer.borderColor = UIColor(red: 190/255, green: 158/255, blue: 118/255, alpha: 0.5).CGColor
        
        avatarImg.userInteractionEnabled = true
        
        let singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "buttonAction")
        avatarImg .addGestureRecognizer(singleTap)
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //右侧滑动返回首页
    func swipe(){
        let transition:CATransition=CATransition();
        transition.duration = 0.3;
        transition.type=kCATransitionMoveIn;
        transition.subtype=kCATransitionFromRight;
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let oneController:UIViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("homeCtrl") 
        self.navigationController?.view.layer.addAnimation(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(oneController, animated: false);
        
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if !userDefaultsUtil.isLoggedIn(){
            return 2
        }else{
            return 4
        }

    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 13
        }else{
            return 12
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return 200
        }
        return 49
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        //退出
        if indexPath.section == 3 && indexPath.row == 0 {
            if !userDefaultsUtil.isLoggedIn(){
                let twoStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let twoController:LoginViewController = twoStoryBoard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                self.navigationController?.pushViewController(twoController, animated: false);
            }else{
                 AlertUtil.simpleAlert(self, title: "退出提示", msg: "此操作将清除本地数据", okBtnTitle: "取消", cancelBtnTitle: "确定")
            }
        }
        //真实姓名
        if indexPath.section == 1 && indexPath.row == 1 {
            if !userDefaultsUtil.isLoggedIn(){
                let twoStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let twoController:LoginViewController = twoStoryBoard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                twoController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(twoController, animated: false);
            }else{
            gotoPage("My", pageName:"editusrname")
            }
        }
        //修改密码
        if indexPath.section == 1 && indexPath.row == 0 {
            if !userDefaultsUtil.isLoggedIn(){
                let twoStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let twoController:LoginViewController = twoStoryBoard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                twoController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(twoController, animated: false);
            }else{
                gotoPage("My", pageName:"editpassword")
            }
        }
        //关联手机
        if indexPath.section == 1 && indexPath.row == 2 {
            if !userDefaultsUtil.isLoggedIn(){
                let twoStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let twoController:LoginViewController = twoStoryBoard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                twoController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(twoController, animated: false);
            }else{
                gotoPage("My", pageName:"AssociaTionMobile")
            }

        }
        //邮寄地址
        if indexPath.section == 1 && indexPath.row == 3 {
            if !userDefaultsUtil.isLoggedIn(){
                let twoStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let twoController: AddressViewController = twoStoryBoard.instantiateViewControllerWithIdentifier("AddressViewController") as! AddressViewController
                self.navigationController?.pushViewController(twoController, animated: false);
            }else{
                gotoPage("My", pageName:"AddressViewController")
            }
            
            
        }
        //修改手势密码
        if indexPath.section == 1 && indexPath.row == 4 {
            if !userDefaultsUtil.isLoggedIn(){
              
                let twoStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let twoController:LoginViewController = twoStoryBoard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                twoController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(twoController, animated: false);
            }else{
                let oneStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let cpctrl:GesturePasswordControllerViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("gesturePassword") as! GesturePasswordControllerViewController
                cpctrl.toWhere = "safetycenter"
//                cpctrl.navigationController?.setNavigationBarHidden(true, animated: false)
                //清除手势密码
                KeychainWrapper.removeObjectForKey(kSecValueData as String)
//                self.hidesBottomBarWhenPushed = true
//                cpctrl.tabBarController!.tabBar.hidden = true
                self.navigationController?.pushViewController(cpctrl, animated: true)

            }
        }
        if indexPath.section == 1 && indexPath.row == 6 {
            if !userDefaultsUtil.isLoggedIn(){
                
                let twoStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let twoController:LoginViewController = twoStoryBoard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                twoController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(twoController, animated: false);
            }else{
               gotoPage("My", pageName:"SafeBankNewViewController")
            }

        }
        if indexPath.section == 1 && indexPath.row == 7 {
            if !userDefaultsUtil.isLoggedIn(){
                
                let twoStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let twoController:LoginViewController = twoStoryBoard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                twoController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(twoController, animated: false);
            }else{
                 gotoPage("My", pageName:"LiCaiShiViewController")
            }
            
        }

    }
    
//    func gotoMeiQia(){
//        print("-----美洽-----")
////        let chatViewManager = MQChatViewManager()
//        chatViewManager.enableOutgoingAvatar(true)
//        let viewCtrl = chatViewManager.pushMQChatViewControllerInViewController(self)
//        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
//    }
    
//    func didReceiveMQMessages(message: [MQMessage]!) {
//        
//    }
    
    func returnClick(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func remindSwitchClick(sender: UISwitch) {
        var remind = "0"
        if sender.on {
            remind = "1"
        }
        userCenterService.uploadUserRemind(remind, calback: {
            msg in
            self.loadingHidden()
            if !msg.isEmpty {
                KGXToast.showToastWithMessage(msg, duration: ToastDisplayDuration.LengthShort)
            }
        })
    }
    
    /** 跳转到内部转账 **/
    func gotoInternalTransfer(){
        loadingShow()
        assestService.checkWithdraw(["mm": userDefaultsUtil.getMobile()!],
            calback: {
                data in
                self.loadingHidden()
                if let mm = data as? MsgModel {
                    if !mm.msg.isEmpty {
                        KGXToast.showToastWithMessage(mm.msg, duration: ToastDisplayDuration.LengthShort)
                    }
                    if mm.status == 0 {
                        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "SafetyCenter", bundle: NSBundle.mainBundle())
                        let oneController:UIViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("safetystoryboard")
                        self.navigationController?.pushViewController(oneController, animated: true)
                    }else if mm.status == 1 {
                        self.gotoPage("UserCenter", pageName: "internalTransferCtrl")
                        //self.performSegueWithIdentifier("centerToInternalTransferCtrl", sender: nil)
                    }
                }
            }
        )
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
    
     func buttonAction() {
        
        if !userDefaultsUtil.isLoggedIn(){
            
            let twoStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let twoController:LoginViewController = twoStoryBoard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(twoController, animated: false);
            print("没登录")
            
        }else{
            let actionSheet:UIActionSheet = UIActionSheet()
            actionSheet.addButtonWithTitle("取消")
            actionSheet.addButtonWithTitle("拍照")
            actionSheet.addButtonWithTitle("从手机相册中选取")
            actionSheet.cancelButtonIndex = 0
            actionSheet.delegate = self
            actionSheet.showInView(self.view)

        
        }
    }
    //头像图片选择
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 1://相机
            picker = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.delegate = self
            picker.allowsEditing = true
            self.presentViewController(picker, animated: true, completion: nil)
        case 2://相册
            picker = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self.presentViewController(picker, animated: true, completion: nil)
        default:
            break
        }
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let dic = info as NSDictionary
        //编辑过后的图片
        let editedImage = dic.objectForKey("UIImagePickerControllerEditedImage") as! UIImage
        //MediaType
        _ = dic.objectForKey("UIImagePickerControllerMediaType") as! String
        let oldImg:UIImage = avatarImg.image!
        let newImg:UIImage = PhotoUtils.thumbnailWithImageWithoutScale(editedImage, toSize: CGSize(width: 84, height: 84))
        avatarImg.image = newImg
        //更换头像动画
        avatarImg.rotate360WithDuration(2.0, repeatCount: 1, timingMode: i7Rotate360TimingModeLinear)
        avatarImg.animationDuration = 2.0
        avatarImg.animationImages = [newImg, oldImg, oldImg, oldImg, oldImg, newImg]
        avatarImg.animationRepeatCount = 1
        avatarImg.startAnimating()
        PhotoUtils.saveImage(avatarImg.image!)
        uploadAvatar()
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    func uploadAvatar(){
        userCenterService.uploadAvatar()
    }

    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 {
            return
        }else{
    
            //解除新浪微博绑定
//            let service = UMSocialDataService.defaultDataService()
//            service.requestUnOauthWithType(UMShareToSina, completion: nil)
//            
          
            //删除掉友盟alias
            UMessage.removeAlias(userDefaultsUtil.showMobile(), type: kUMessageAliasTypeSina) {
                (responseObject, error) -> Void in
                print("安全退出")
            }
//            MQManager.closeMeiqiaService()
            
            userDefaultsUtil.exitSetting()
            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let oneController:UIViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("mainCtrl")
            self.presentViewController(oneController, animated: true, completion: nil)
            
        }
    }
}