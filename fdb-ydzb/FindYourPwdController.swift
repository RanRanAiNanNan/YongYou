//
//  FindYourPwdController.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/8/31.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit

class FindYourPwdController:BaseViewController {
    var loginService = LoginService.getInstance()
    @IBOutlet weak var mobileView: UIView!
    @IBOutlet weak var authCodeView: UIView!
    @IBOutlet weak var passwordView: UIView!
    
    @IBOutlet weak var mobileTf: UITextField!
    @IBOutlet weak var authCodeTf: UITextField!
    @IBOutlet weak var pwdTf: UITextField!
    
    
    @IBOutlet weak var authCodeBtn: UIButton!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var timeLB: UILabel!
    
    //获取延迟时间
    var leftTime = 180
    //定时器
    var timer:NSTimer!
    
    var findYourPwdService = FindYourPwdService.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAutoLayout()
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        initView()
    }
    override func viewWillAppear(animated: Bool) {
        
    }
    
    
    
    func initView() {
        self.initNav("密码找回")
        
        mobileTf.delegate = self
        authCodeTf.delegate = self
        pwdTf.delegate = self
        
        authCodeBtn.layer.cornerRadius = 5
        postBtn.layer.cornerRadius = 5
        
//        mobileView.layer.borderWidth = 1
//        mobileView.layer.cornerRadius = 5
//        mobileView.layer.borderColor = B.RL_VIEW_BRODER_COLOR
//        authCodeView.layer.borderWidth = 1
//        authCodeView.layer.cornerRadius = 5
//        authCodeView.layer.borderColor = B.RL_VIEW_BRODER_COLOR
//        passwordView.layer.borderWidth = 1
//        passwordView.layer.cornerRadius = 5
//        passwordView.layer.borderColor = B.RL_VIEW_BRODER_COLOR

        
        postBtn.setBackgroundImage(createImageWithColor(), forState: UIControlState.Highlighted)
    }
    
    @IBAction func postClick(sender: AnyObject) {
        
        if registerCheck() {return}
        loadingShow()
//        let mm = userDefaultsUtil.enMobile(mobileTf.text!)
//        findYourPwdService.register(B.FYP_POST, params: ["mm" : mm,"password":userDefaultsUtil.enTxt(pwdTf.text!),"code": authCodeTf.text!], calback: {
//            msg in
//            self.loadingHidden()
//            if msg.isEmpty {
//                self.performSegueWithIdentifier("fypToLoginSegue", sender: nil)
//            }else{
//                KGXToast.showToastWithMessage(msg, duration: ToastDisplayDuration.LengthShort)
//            }
//        })
        
        loginService.wangJiMiMa(mobileTf.text!, verifyCode: authCodeTf.text!, passwd: pwdTf.text!) { (data) -> () in
          self.loadingHidden()
            
            if data == "修改成功"{
                
            
            self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        
        
    }
    
    @IBAction func sendAuth(sender: AnyObject) {
        closeKeyBoard()
        requestAuthCode();
    }
    
    
    func requestAuthCode() {
        if checkMobile() {return}
        
//        authCodeBtn.backgroundColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
//        authCodeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)

//        findYourPwdService.getAuthCode(B.FYP_SEND_AUTHCODE, params: ["mm" : userDefaultsUtil.enMobile(mobileTf.text!)], calback: {
//            msg in
//            if msg.isEmpty {
        loginService.wanghuoQuYanZhengMa(mobileTf.text!, flag: "forget_code", codeType: "3", calback: { (data) -> () in
            if data == "成功"{
                self.authCodeBtn.enabled = false
                self.timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(1), target: self, selector: Selector("tickDown"), userInfo: nil, repeats: true)
                
  
            }
            
        })
 
    
    
        
//                KGXToast.showToastWithMessage("验证码发送成功!", duration: ToastDisplayDuration.LengthShort)
                //            }else{
//                KGXToast.showToastWithMessage(msg, duration: ToastDisplayDuration.LengthShort)
//                self.authCodeBtn.enabled = true
////                self.authCodeBtn.backgroundColor = B.BTN_GOLDEN_COLOR
////                self.authCodeBtn.setTitle("获取验证码", forState: UIControlState.Normal)
//            }
//        })
    }
    
    
    //按钮显示秒数变化方法
    func tickDown(){
        leftTime -= 1
//        authCodeBtn.setTitle("\(leftTime)秒后重发", forState: UIControlState.Normal)
        timeLB.text = "倒计时\(leftTime - 1)s"
        authCodeBtn.enabled = false
        if leftTime <= 0 {
            timer.invalidate()
//            authCodeBtn.enabled = true
//            authCodeBtn.backgroundColor = B.BTN_GOLDEN_COLOR
//            authCodeBtn.setTitle("获取验证码", forState: UIControlState.Normal)
            timeLB.text = "获取验证码"
            authCodeBtn.enabled = true
            leftTime = 180
        }
        
    }
    
    //验证是否有末通过
    func registerCheck() -> Bool{
        if checkMobile() { return true}
        if checkAuthCode() { return true}
        if checkPwd() { return true}
        return false
    }
    
    //验证手机号是否未通过
    func checkMobile() ->Bool {
        closeKeyBoard()
        let mobile = mobileTf.text
        if RegexUtil("^1\\d{10}$").test(mobile!) {
            return false
        }else if mobileTf.text == ""{
            KGXToast.showToastWithMessage("请输入手机号", duration: ToastDisplayDuration.LengthShort)
            return true
        }else{
            KGXToast.showToastWithMessage("手机号码格式错误", duration: ToastDisplayDuration.LengthShort)
            return true
        }
    }
    
    //验证验证码是否末通过
    func checkAuthCode() ->Bool{
        closeKeyBoard()
        if RegexUtil("^\\d{6}$").test(authCodeTf.text!)  {
            return false
        }else{
            KGXToast.showToastWithMessage("验证码格式不正确", duration: ToastDisplayDuration.LengthShort)
            return true
        }
    }
    
    //验证密码是否末通过
    func checkPwd() ->Bool{
        closeKeyBoard()
        //^(?![^a-zA-Z]+$)(?!\\D+$).{6,20}$
        if RegexUtil("^[0-9A-Za-z]{6,20}$").test(pwdTf.text!) {
            return false
        }else{
            KGXToast.showToastWithMessage("输入6-20位数字或字母", duration: ToastDisplayDuration.LengthShort)
            return true
        }
    }
    
    func initAutoLayout(){

        switch Device.version() {
        case .iPhone4, .iPhone4S:
            mobileTf.font = UIFont.systemFontOfSize(14)
            authCodeTf.font = UIFont.systemFontOfSize(14)
            pwdTf.font = UIFont.systemFontOfSize(14)
            authCodeBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
            
            constrain(mobileView, authCodeView, passwordView, authCodeBtn){
                mobileView, authCodeView, passwordView, authCodeBtn in
                mobileView.height == 40
                passwordView.height == 40
                authCodeView.height == 40
                authCodeBtn.height == 40
            }
        default:
            break
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}