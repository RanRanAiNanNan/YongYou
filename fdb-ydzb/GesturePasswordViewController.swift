//
//  GesturePasswordControllerViewController.swift
//  GesturePassword4Swift
//
//  Created by feiin on 14/11/22.
//  Copyright (c) 2014年 swiftmi. All rights reserved.
//

import UIKit
import LocalAuthentication

class GesturePasswordControllerViewController: BaseViewController,VerificationDelegate,ResetDelegate,GesturePasswordDelegate,TouchIDDelegate {

    var timer:NSTimer!
    var time : NSInteger!
    
    var gesturePasswordView:GesturePasswordView!
    
    var previousString:String? = ""
    var password:String? = ""
    
    let normalColor = UIColor(red: 2/255, green: 174/255, blue: 240/255, alpha: 1)
    
    var errorCount = 5
    
    var toWhere = ""            //跳转到页面
    
    var checkVersionService = CheckVersionService.getInstance()
    
    let touchIDAuth = TouchID()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !toWhere.isEmpty {
            self.tabBarController!.tabBar.hidden = true
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
        let ver = getVersion()
        checkVersionService.uploadUserVersion(["ver": ver, "mobile": userDefaultsUtil.getMobile()!, "type": "0"])
        //print("mobile::\(userDefaultsUtil.getMobile()!)")
        //判断用户手机号是否为空
        if userDefaultsUtil.getMobile()!.isEmpty {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewControllerWithIdentifier("login") as! LoginMainViewController
            self.presentViewController(viewController, animated: true, completion: nil)
        //判断手机号是否是明文
        }else if userDefaultsUtil.getMobile()?.characters.count == 11 {
            //手机号加密
//            userDefaultsUtil.setMobile(userDefaultsUtil.enMobile(userDefaultsUtil.getMobile()!))
        }
        
        ((UIApplication.sharedApplication().delegate) as! AppDelegate).meiqiaLogin(userDefaultsUtil.showMobile())
//
//        //美洽顾客信息
//        MQChatViewManager().setClientInfo(["name": userDefaultsUtil.getUsername()!,"Avatar@2x(1)": userDefaultsUtil.getAvatarLink()!, "mobile": userDefaultsUtil.showMobile()])
        //每次进来让远程推送的message为空
        userDefaultsUtil.setNotificationMessageKey("")
//
//        //添加友盟alias
//        UMessage.addAlias(userDefaultsUtil.showMobile(), type: kUMessageAliasTypeSina) {
//            (responseObject, error) -> Void in
//            if responseObject != nil{
//                print(responseObject)
//            }else if error != nil{
//                print(error)
//            }
//        }
        
        previousString = ""
        password = KeychainWrapper.stringForKey(kSecValueData as String)
        print(password)
        if( password == "" || password == nil){
            
            self.reset()
        }
        else{
            self.verify()
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getVersion() -> String {
        let infoDict:NSDictionary = NSBundle.mainBundle().infoDictionary!
        let version = infoDict.objectForKey("CFBundleShortVersionString") as! String
        let build = infoDict.objectForKey("CFBundleVersion") as! String
        let ver = "version:" + version + " build:" + build
        return ver
    }
    
    

    //MARK: - 验证手势密码
    func verify(){
        gesturePasswordView = GesturePasswordView(frame: UIScreen.mainScreen().bounds)
        gesturePasswordView.tentacleView!.rerificationDelegate = self
        gesturePasswordView.tentacleView!.style = 1
        gesturePasswordView.gesturePasswordDelegate = self
        self.view.addSubview(gesturePasswordView)
        //用户是否开启了指纹解锁
        if userDefaultsUtil.getFingerprint() {
            touchFingerInit()
        }
    }
    
    //MARK: - 重置手势密码
    func reset(){
        gesturePasswordView = GesturePasswordView(frame: UIScreen.mainScreen().bounds)
        gesturePasswordView.tentacleView!.resetDelegate = self
        gesturePasswordView.tentacleView!.style = 2
        gesturePasswordView.forgetButton!.hidden = true
        //gesturePasswordView.changeButton!.hidden = true
        
        gesturePasswordView.state!.textColor = normalColor
        gesturePasswordView.state!.text = "请绘制手势密码"
        
        self.view.addSubview(gesturePasswordView)
        
    }
    
    func exist() ->Bool{
        password = KeychainWrapper.stringForKey(kSecValueData as String)
        print(password)
        if password == "" {
            return false
        }
        return true
    }
    
    //MARK: - 清空记录
    func clear(){
        KeychainWrapper.removeObjectForKey(kSecValueData as String)
    }
    
    //MARK: - 改变手势密码
    func change(){
        forget()
    }
    
    //MARK: - 忘记密码
    func forget(){
        self.clear();
        self.reset();
        self.performSegueWithIdentifier("gestureToLogin", sender: nil);
    }
    
    
    func verification(result:String)->Bool{
        if(result == password){
            gesturePasswordView.state!.textColor = UIColor.whiteColor()
            gesturePasswordView.state!.text = "手势密码解锁成功"
            
            
            
            gotoHome()
            

            return true
        }
        if --errorCount > 0 {
//            time = 5
//            timer = NSTimer.scheduledTimerWithTimeInterval(1,
//                target:self,selector:Selector("tickDown"),
//                userInfo:nil,repeats:true)
            gesturePasswordView.state!.textColor = UIColor.redColor()
            gesturePasswordView.state!.text = "手势密码错误,您还可以输入\(errorCount)次"
            
                    }else{
            self.performSegueWithIdentifier("gestureToLogin", sender: nil);
            userDefaultsUtil.setForgetGesturePassword("aaa")
            KGXToast.showToastWithMessage("您已经连续5次输入手势密码错误,请重置手势密码", duration: ToastDisplayDuration.LengthShort)
        }
        return false
    }
//    func tickDown()
//    {
//        if time != 0{
//            time = time - 1
//            gesturePasswordView.state!.textColor = UIColor.redColor()
//            gesturePasswordView.state!.text = "手势密码错误,您还可以输入\(errorCount)次"
//        }else{
//            
//            gesturePasswordView.state!.text = ""
//            timer.invalidate()
//        }
//    }

    func resetPassword(result: String) -> Bool {
        if(previousString == ""){
            if result.characters.count > 3 {
                previousString = result
                gesturePasswordView.tentacleView!.enterArgin()
                gesturePasswordView.state!.textColor = UIColor(red: 2/255, green: 174/255, blue: 240/255, alpha: 1)
                gesturePasswordView.state!.text = "请再次绘制手势密码"
                return true
            }else{
                previousString = "";
                gesturePasswordView.state!.textColor = UIColor.redColor()
                gesturePasswordView.state!.text = "至少连接4个点,请重试"
                
                return false
            }
        }else{
            if(result == previousString){
                KeychainWrapper.setString(result, forKey: kSecValueData as String)
                gesturePasswordView.state!.textColor = UIColor(red: 2/255, green: 174/255, blue: 240/255, alpha: 1)
                gesturePasswordView.state!.text = "已保存手势密码"
                KGXToast.showToastWithMessage("手势密码设置成功", duration: ToastDisplayDuration.LengthShort)
                if toWhere == "safetycenter" {
//                    self.tabBarController!.tabBar.hidden == false
//                    self.hidesBottomBarWhenPushed = false
                    //跳转到登陆页
                    self.navigationController?.popViewControllerAnimated(true)
                }
                self.performSegueWithIdentifier("gestureToHome", sender: nil);
                return true;
            }else{
                previousString = "";
                gesturePasswordView.state!.textColor = UIColor.redColor()
                gesturePasswordView.state!.text = "与上次输入不一致,请重新绘制"
                
                return false
            }
            
        }
    }
    
    func gotoHome(){
        //判断用户手机号是否为空
        print(userDefaultsUtil.getMobile())
        if userDefaultsUtil.getMobile()! == ""{
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewControllerWithIdentifier("login") as! LoginMainViewController
            //跳转到登陆页
            self.presentViewController(viewController, animated: true, completion: nil)
        }
//        self.loadingShow()
//        checkVersionService.checkLogin({
//            data in
        
//            if let mm = data as? MsgModel {
//                if !mm.msg.isEmpty {
//                    KGXToast.showToastWithMessage(mm.msg, duration: ToastDisplayDuration.LengthShort)
//                }
//                if mm.status == 1 {
                    self.performSegueWithIdentifier("gestureToHome", sender: nil)
//                }else if mm.status == 0 {
//                    self.loadingHidden()
//                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                    let viewController = mainStoryboard.instantiateViewControllerWithIdentifier("login") as! LoginMainViewController
//                    //跳转到登陆页
//                    self.presentViewController(viewController, animated: true, completion: nil)
//                }
//            }
//        })
    }
    
    //初始化指纹解锁
    func touchFingerInit(){
        touchIDAuth.touchIDReasonString = "指纹解锁登录"
        touchIDAuth.delegate = self
        touchIDAuth.touchIDAuthentication()
    }
    
    //指纹解锁成功方法
    func touchIDAuthenticationWasSuccessful() {
        self.gotoHome()
    }
    
    //指纹解锁失败方法
    func touchIDAuthenticationFailed(errorCode: TouchIDErrorCode) {
        var msg = ""
        switch errorCode{
        case .TouchID_CanceledByTheSystem:
            msg = "指纹解锁失败"
            
        case .TouchID_CanceledByTheUser:
            msg = "您取消指纹解锁"
            
        case .TouchID_PasscodeNotSet:
            msg = "没有打开或设置指纹密码"
            
        case .TouchID_TouchIDNotAvailable:
            msg = "指纹解锁不可用"
            
        case .TouchID_TouchIDNotEnrolled:
            msg = "没有可用的指纹"
            
        case .TouchID_UserFallback:
            msg = "指纹解锁失败"
            
        default:
            msg = "指纹解锁失败"
        }
        gesturePasswordView.state!.textColor = UIColor.redColor()
        gesturePasswordView.state!.text = msg
    }
 

}
