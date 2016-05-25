//
//  RegisterViewController.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/1/28.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit
class RegisterViewController: BaseViewController {
    
    @IBOutlet weak var mobileView: UIView!
    @IBOutlet weak var authCodeView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var referrerView: UIView!
    
    @IBOutlet weak var mobileTf: UITextField! {
        didSet {
            mobileTf.delegate = self
            mobileTf.tag = 101
        }
    }
    @IBOutlet weak var authCodeTf: UITextField! {
        didSet {
            authCodeTf.delegate = self
            authCodeTf.tag = 102
        }
    }
    @IBOutlet weak var pwdTf: UITextField! {
        didSet {
            pwdTf.delegate = self
            pwdTf.tag = 103
        }
    }
    @IBOutlet weak var referrerTf: UITextField! {
        didSet {
            referrerTf.delegate = self
            referrerTf.tag = 104
        }
    }
    
    
    @IBOutlet weak var authCodeBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    //获取延迟时间
    var leftTime = 60
    //定时器
    var timer:NSTimer!
    
    var findYourPwdService = FindYourPwdService.getInstance()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initAutoLayout()
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Default
        initView()
    }
    
    
    
    
    
    func initView() {
        
        initNav("注册")
        
        mobileTf.delegate = self
        authCodeTf.delegate = self
        pwdTf.delegate = self
        referrerTf.delegate = self
        
        authCodeBtn.layer.cornerRadius = 5
        registerBtn.layer.cornerRadius = 5
        
        mobileView.layer.borderWidth = 1
        mobileView.layer.cornerRadius = 5
        mobileView.layer.borderColor = B.RL_VIEW_BRODER_COLOR
        authCodeView.layer.borderWidth = 1
        authCodeView.layer.cornerRadius = 5
        authCodeView.layer.borderColor = B.RL_VIEW_BRODER_COLOR
        passwordView.layer.borderWidth = 1
        passwordView.layer.cornerRadius = 5
        passwordView.layer.borderColor = B.RL_VIEW_BRODER_COLOR
        referrerView.layer.borderWidth = 1
        referrerView.layer.cornerRadius = 5
        referrerView.layer.borderColor = B.RL_VIEW_BRODER_COLOR
        
        registerBtn.setBackgroundImage(createImageWithColor(), forState: UIControlState.Highlighted)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //注册单击事件
    @IBAction func registerClick(sender: AnyObject) {
        if registerCheck() {return}
        loadingShow()
        let mm = userDefaultsUtil.enMobile(mobileTf.text!)
        findYourPwdService.register(B.REGISTER_POST, params: ["mm": mm, "password": pwdTf.text!, "code": authCodeTf.text!, "referral_code": referrerTf.text!, "agree":"1"], calback: {
            msg in
            self.loadingHidden()
            if msg.isEmpty {
                userDefaultsUtil.setMobile(mm)
                userDefaults.setObject(true, forKey: KeyLoggedIn)
                self.performSegueWithIdentifier("regToGesture", sender: nil)
            }else{
                KGXToast.showToastWithMessage(msg, duration: ToastDisplayDuration.LengthShort)
            }
        })
    }
    
    @IBAction func sendAuth(sender: AnyObject) {
        closeKeyBoard()
        requestAuthCode();
    }
    
    
    //发送验证码
    func requestAuthCode() {
        if checkMobile() {return}
        authCodeBtn.enabled = false
        authCodeBtn.backgroundColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
        authCodeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        findYourPwdService.getAuthCode(B.REGISTER_SEND_AUTHCODE, params: ["mm" : userDefaultsUtil.enMobile(mobileTf.text!)], calback: {
            msg in
            if msg.isEmpty {
                KGXToast.showToastWithMessage("验证码发送成功!", duration: ToastDisplayDuration.LengthShort)
                self.timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(1), target: self, selector: Selector("tickDown"), userInfo: nil, repeats: true)
            }else{
                KGXToast.showToastWithMessage(msg, duration: ToastDisplayDuration.LengthShort)
                self.authCodeBtn.enabled = true
                self.authCodeBtn.backgroundColor = B.BTN_GOLDEN_COLOR
                self.authCodeBtn.setTitle("获取验证码", forState: UIControlState.Normal)
            }
        })
    }
    //服务协议
    @IBAction func serviceContractClick(sender: AnyObject) {
        let customAllowedSet =  NSCharacterSet(charactersInString:"=\"#%/<>?@\\^`{|}").invertedSet
        let escapedStr = B.SERVICE_REGISTER.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
        let url = NSURL(string:B.SERVICE_CONTRACT_BASE + escapedStr!)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    
    
    //按钮显示秒数变化方法
    func tickDown(){
        leftTime -= 1
        authCodeBtn.setTitle("\(leftTime)秒后重发", forState: UIControlState.Normal)
        if leftTime <= 0 {
            timer.invalidate()
            authCodeBtn.enabled = true
            authCodeBtn.backgroundColor = B.BTN_GOLDEN_COLOR
            authCodeBtn.setTitle("获取验证码", forState: UIControlState.Normal)
            leftTime = 90
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
        let mobile = mobileTf.text!
        if RegexUtil("^1\\d{10}$").test(mobile) {
            return false
        }else{
            KGXToast.showToastWithMessage("手机号码格式不正确", duration: ToastDisplayDuration.LengthShort)
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
        if RegexUtil("^(?![^a-zA-Z]+$)(?!\\D+$).{6,20}$").test(pwdTf.text!) {
            return false
        }else{
            KGXToast.showToastWithMessage("密码格式不正确", duration: ToastDisplayDuration.LengthShort)
            return true
        }
    }
    
    
    //MARK: - UITextFieldDelegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == 101 {
            if range.location > 10 {
                return false
            }else{
                return true
            }
        }
        
        if textField.tag == 102 {
            if range.location > 5 {
                return false
            }else{
                return true
            }
        }
        
        if textField.tag == 103 {
            if range.location > 19 {
                return false
            }else{
                return true
            }
        }
        
        if textField.tag == 104 {
            if range.location > 7 {
                return false
            }else{
                return true
            }
        }
        
        return true
        
    }
    
    func initAutoLayout(){
        
        switch Device.version() {
        case .iPhone4, .iPhone4S:
            mobileTf.font = UIFont.systemFontOfSize(14)
            authCodeTf.font = UIFont.systemFontOfSize(14)
            pwdTf.font = UIFont.systemFontOfSize(14)
            referrerTf.font = UIFont.systemFontOfSize(14)
            authCodeBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
            
            constrain(mobileView, authCodeView, passwordView, referrerView,authCodeBtn){
                mobileView, authCodeView, passwordView, referrerView, authCodeBtn in
                mobileView.height == 40
                passwordView.height == 40
                authCodeView.height == 40
                referrerView.height == 40
                authCodeBtn.height == 40
                //registerBtn.height == 40
            }
        default:
            break
            //            print("Unknown")
        }
    }
    
    
}
