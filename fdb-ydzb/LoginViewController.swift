
//
//  LoginViewController.swift
//  ydzbApp
//
//  Created by 刘驰 on 15/1/22.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//


import UIKit


class LoginViewController: BaseViewController {
    
    var index : Int!
    
    @IBOutlet weak var yanZhengMaLB: UILabel!
    @IBOutlet weak var diXiaZhuCe: UIButton!
    @IBOutlet weak var yanZhengMa: UIButton!
    @IBOutlet weak var dengLuView: UIView!
    @IBOutlet weak var zhuCeView: UIView!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var mobileView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var zhuCeMobileTF: UITextField!
    @IBOutlet weak var zhuCeYanZhengTF: UITextField!
    @IBOutlet weak var zhuCeMiMaTF: UITextField!
    @IBOutlet weak var beiJing: UIImageView!
    @IBOutlet weak var tuiJianRenShouJiHao: UITextField!
    
    var timer:NSTimer!
    var time : NSInteger!
    @IBOutlet weak var diXia: NSLayoutConstraint!
    //用户名
    @IBOutlet weak var usernameTextField: UITextField! {
        didSet {
            usernameTextField.delegate = self
            usernameTextField.tag = 101
        }
    }
    //密码
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.delegate = self
            passwordTextField.tag = 102
        }
    }
    //登录按钮
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var versionLab: UILabel!
    
//    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var paswordView: UIView!
    
    @IBOutlet weak var denglu: UIButton!
    
    @IBOutlet weak var zhuce: UIButton!
    var loginService = LoginService.getInstance()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let myimagweView = UIImageView(frame: CGRectMake(0, 0, B.SCREEN_WIDTH, B.SCREEN_HEIGHT))
//        myimagweView.image = UIImage(named: "背景")
//        self.view.addSubview(myimagweView)
        initAutoLayout()
//        initNav("登录")
//        self.navigationController!.navigationBarHidden = true
        zhuCeView.hidden = true
        //清除用户信息
        userDefaultsUtil.exitSetting()
        //清除手势密码
        //KeychainWrapper.removeObjectForKey(kSecValueData)
        initView()
        
        zhuCeMobileTF.delegate = self
        zhuCeMobileTF.tag = 10030
        zhuCeYanZhengTF.delegate = self
        zhuCeYanZhengTF.tag = 10010
        zhuCeMiMaTF.delegate = self
        zhuCeMiMaTF.tag = 10020
        tuiJianRenShouJiHao.delegate = self
        tuiJianRenShouJiHao.tag = 10040
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
//        if userDefaultsUtil.getZhangHao()! == ""{
        if userDefaultsUtil.getMobile()! == ""{
            
        }else{
//            usernameTextField.text = userDefaultsUtil.getZhangHao()!
            usernameTextField.text = userDefaultsUtil.getMobile()!
        }
        
        let infoDict:NSDictionary = NSBundle.mainBundle().infoDictionary!
        let version = infoDict.objectForKey("CFBundleShortVersionString") as! String
        let build = infoDict.objectForKey("CFBundleVersion") as! String
        versionLab.text = "version:" + version + " build:" + build
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = true
        
    }
    
    func initView() {
        loginBtn.layer.cornerRadius = 5
        loginBtn.layer.borderColor = UIColor(red: 190/255, green: 158/255, blue: 118/255, alpha: 1).CGColor
        
//        usernameView.layer.borderWidth = 1
//        usernameView.layer.cornerRadius = 5
//        usernameView.layer.borderColor = B.RL_VIEW_BRODER_COLOR
//        paswordView.layer.borderWidth = 1
//        paswordView.layer.cornerRadius = 5
//        paswordView.layer.borderColor = B.RL_VIEW_BRODER_COLOR
        //设置触摸背景颜色
//        loginBtn.setBackgroundImage(createImageWithColor(), forState: UIControlState.Highlighted)
        
    }
    
    @IBAction func touchUpInsideAction(sender: AnyObject) {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    
    @IBAction func login(sender: AnyObject) {
        
        if usernameTextField.text == "" {
            KGXToast.showToastWithMessage("请输入用户昵称", duration: ToastDisplayDuration.LengthShort)
        }else if passwordTextField.text == "" {
            KGXToast.showToastWithMessage("密码不能为空", duration: ToastDisplayDuration.LengthShort)
        }else if !RegexUtil("^[0-9A-Za-z]{6,20}$").test(passwordTextField.text!){
            KGXToast.showToastWithMessage("请输入6~20位数字或密码", duration: ToastDisplayDuration.LengthShort)
        }else{
            UIApplication.sharedApplication().sendAction("resignFirstResponder", to: nil, from: nil, forEvent: nil)
            loadingShow()
            loginService.login(usernameTextField.text!, password: passwordTextField.text! ,
                calback: {
                    msg in
                    self.loadingHidden()
                    if msg == "aa" {
                        //添加友盟Alias
//                        UMessage.setAlias(userDefaultsUtil.showMobile(), type: kUMessageAliasTypeSina, response: {
//                            (responsetObject, error) -> Void in
//                            print(error)
//                            print("alias登陆成功")
//                        })
                        //开启美洽
//                        MQManager.openMeiqiaService()
//                        if self.index == 1 {
//                            self.performSegueWithIdentifier("loginToGesture", sender: nil)
//                        }else if self.index == 2{
////                        self.performSegueWithIdentifier("loginToGesture1", sender: nil)
//                           self.performSegueWithIdentifier("loginToGesture", sender: nil)
//                        }else{
                        KGXToast.showToastWithMessage("登陆成功", duration: ToastDisplayDuration.LengthShort)
                        if userDefaultsUtil.getTiaoZhuan()! == "1"{
                            userDefaultsUtil.setTiaoZhuan("订单")
                        }else if userDefaultsUtil.getTiaoZhuan()! == "2"{
                            userDefaultsUtil.setTiaoZhuan("财富")
                        }
                        KeychainWrapper.removeObjectForKey(kSecValueData as String)
                        self.performSegueWithIdentifier("loginToGesture", sender: nil)
//                        }
                    }
//                    else if msg == "adddddddd"{
//                        KGXToast.showToastWithMessage("账号名或密码错误", duration: ToastDisplayDuration.LengthShort)
//                    
//                    }
                    else if msg == "adddddddd"{
                        print(msg)
                        KGXToast.showToastWithMessage("账号名或密码错误", duration: ToastDisplayDuration.LengthShort)
                    }
                }
            )
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        self.view.endEditing(true)
    }
    
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        if textField.tag == 10010 {
            zhuCeMobileTF.userInteractionEnabled = false
            zhuCeMiMaTF.userInteractionEnabled = false
            yanZhengMa.userInteractionEnabled = false
            denglu.userInteractionEnabled = false
            diXiaZhuCe.userInteractionEnabled = false
            tuiJianRenShouJiHao.userInteractionEnabled = false
            self.diXia.constant += 150
            
 
        }else if textField.tag == 10020{
            zhuCeMobileTF.userInteractionEnabled = false
            zhuCeYanZhengTF.userInteractionEnabled = false
            yanZhengMa.userInteractionEnabled = false
            denglu.userInteractionEnabled = false
            diXiaZhuCe.userInteractionEnabled = false
            tuiJianRenShouJiHao.userInteractionEnabled = false
            self.diXia.constant += 150
        }else if textField.tag == 10030{
            zhuCeYanZhengTF.userInteractionEnabled = false
            yanZhengMa.userInteractionEnabled = false
            denglu.userInteractionEnabled = false
            diXiaZhuCe.userInteractionEnabled = false
            zhuCeMiMaTF.userInteractionEnabled = false
            tuiJianRenShouJiHao.userInteractionEnabled = false

        }else if textField.tag == 10040{
            zhuCeYanZhengTF.userInteractionEnabled = false
            yanZhengMa.userInteractionEnabled = false
            denglu.userInteractionEnabled = false
            diXiaZhuCe.userInteractionEnabled = false
            zhuCeMiMaTF.userInteractionEnabled = false
            tuiJianRenShouJiHao.userInteractionEnabled = false
            zhuCeMobileTF.userInteractionEnabled = false
            self.diXia.constant += 150
        }
        
       return true
    }
    
    override func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.tag == 10010 {
        self.diXia.constant -= 150
            zhuCeMobileTF.userInteractionEnabled = true
            zhuCeMiMaTF.userInteractionEnabled = true
            yanZhengMa.userInteractionEnabled = true
            denglu.userInteractionEnabled = true
            diXiaZhuCe.userInteractionEnabled = true
            tuiJianRenShouJiHao.userInteractionEnabled = true
        }else if textField.tag == 10020{
            self.diXia.constant -= 150
            zhuCeMobileTF.userInteractionEnabled = true
            zhuCeYanZhengTF.userInteractionEnabled = true
            yanZhengMa.userInteractionEnabled = true
            denglu.userInteractionEnabled = true
            diXiaZhuCe.userInteractionEnabled = true
            tuiJianRenShouJiHao.userInteractionEnabled = true
        }else if textField.tag == 10030{
            zhuCeYanZhengTF.userInteractionEnabled = true
            yanZhengMa.userInteractionEnabled = true
            denglu.userInteractionEnabled = true
            diXiaZhuCe.userInteractionEnabled = true
            zhuCeMiMaTF.userInteractionEnabled = true
            tuiJianRenShouJiHao.userInteractionEnabled = true
        }else if textField.tag == 10040{
            zhuCeYanZhengTF.userInteractionEnabled = true
            tuiJianRenShouJiHao.userInteractionEnabled = true
            zhuCeMobileTF.userInteractionEnabled = true
            zhuCeMiMaTF.userInteractionEnabled = true
            yanZhengMa.userInteractionEnabled = true
            denglu.userInteractionEnabled = true
            diXiaZhuCe.userInteractionEnabled = true
            self.diXia.constant -= 150
        }
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        zhuCeMobileTF.resignFirstResponder()
        zhuCeYanZhengTF.resignFirstResponder()
        zhuCeMiMaTF.resignFirstResponder()
        tuiJianRenShouJiHao.resignFirstResponder()

        return true
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == 101 {
            if range.location > 19 {
                return false
            }else{
                return true
            }
        }
        if textField.tag == 10040 {
            if range.location > 10 {
                return false
            }else{
                return true
            }
        }

        if textField.tag == 102 {
            if range.location > 19 {
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
            usernameTextField.font = UIFont(name: "Arial", size: 14)
            passwordTextField.font = UIFont(name: "Arial", size: 14)
            
            constrain(logoImg, mobileView, passwordView,loginBtn){
                logoImg, mobileView, passwordView,loginBtn in
                logoImg.width == 120
                logoImg.height == 120
                logoImg.top == logoImg.superview!.top + 15
                mobileView.height == 40
                passwordView.height == 40
                loginBtn.height == 40
            }
        default:
            break
        }
    }
    @IBAction func dengLu(sender: AnyObject) {
        denglu.setTitleColor(UIColor(red: 190.0/255, green: 158.0/255, blue: 118.0/255, alpha: 1), forState: .Normal)
        zhuce.setTitleColor(UIColor(red: 255.0/255, green: 255.0/255, blue: 255.0/255, alpha: 1), forState: .Normal)
        zhuCeMobileTF.resignFirstResponder()
        zhuCeYanZhengTF.resignFirstResponder()
        zhuCeMiMaTF.resignFirstResponder()
        tuiJianRenShouJiHao.resignFirstResponder()
        dengLuView.hidden = false
        zhuCeView.hidden = true
    }
    
    @IBAction func zhuce(sender: AnyObject) {
        zhuce.setTitleColor(UIColor(red: 190.0/255, green: 158.0/255, blue: 118.0/255, alpha: 1), forState: .Normal)
        denglu.setTitleColor(UIColor(red: 255.0/255, green: 255.0/255, blue: 255.0/255, alpha: 1), forState: .Normal)
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        dengLuView.hidden = true
        zhuCeView.hidden = false
    }
    
    @IBAction func back(sender: AnyObject) {
        if userDefaultsUtil.getForgetGesturePassword() != "aaa"{
            self.navigationController?.navigationBar.hidden = false
            self.dismissViewControllerAnimated(true, completion: nil)
//            self.performSegueWithIdentifier("loginToGesture", sender: nil);
//            self.navigationController?.popToRootViewControllerAnimated(true)
//            self.performSegueWithIdentifier("gestureToHome", sender: nil)
            
        }else{
            self.performSegueWithIdentifier("loginTohomeSegue", sender: nil)
            self.navigationController?.popViewControllerAnimated(true)
//        self.performSegueWithIdentifier("loginToGesture", sender: nil)
            userDefaultsUtil.setForgetGesturePassword("")
        }
//        if !userDefaultsUtil.isLoggedIn(){
////        self.navigationController?.navigationBar.hidden = false
////        self.dismissViewControllerAnimated(true, completion: nil)
//            self.performSegueWithIdentifier("loginTohomeSegue", sender: nil)
//        }else{
//           
//        print("1111111111111111111111111111111111111111")
////            self.navigationController?.navigationBar.hidden = false
//            //        self.navigationController!.navigationBarHidden = false
//            //        self.navigationController?.popViewControllerAnimated(true)
////            self.dismissViewControllerAnimated(true, completion: nil)
//                    self.navigationController?.popToRootViewControllerAnimated(true)
//            //        self.navigationController?.popToViewController(HomeViewController, animated: true)
//            //        self.navigationController.dismissViewControllerAnimated:YES completion:nil
//            //        self.navigationController?.dismissViewControllerAnimated(true, completion: { () -> Void in
//            //            
//            //        })
//
//
//        }
        
    }
    
    @IBAction func forget(sender: AnyObject) {
 
        let threeStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let threeController:FindYourPwdController = threeStoryBoard.instantiateViewControllerWithIdentifier("FindYourPwdController") as! FindYourPwdController
        self.presentViewController(threeController, animated: true, completion: nil)
    }
    
    @IBAction func zhuCeButton(sender: AnyObject) {
        zhuCeMobileTF.resignFirstResponder()
        zhuCeYanZhengTF.resignFirstResponder()
        zhuCeMiMaTF.resignFirstResponder()
        tuiJianRenShouJiHao.resignFirstResponder()

        if zhuCeMobileTF.text == "" {
            KGXToast.showToastWithMessage("手机号不能为空", duration: ToastDisplayDuration.LengthShort)
        }else if zhuCeMiMaTF.text == "" {
            KGXToast.showToastWithMessage("密码不能为空", duration: ToastDisplayDuration.LengthShort)
            
            
        }else if !RegexUtil("^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$").test(zhuCeMobileTF.text!){
            KGXToast.showToastWithMessage("手机格式错误", duration: ToastDisplayDuration.LengthShort)
        }else if !RegexUtil("^\\d{6}$").test(zhuCeYanZhengTF.text!){
            KGXToast.showToastWithMessage("验证码格式错误", duration: ToastDisplayDuration.LengthShort)
        }else if !RegexUtil("^[0-9A-Za-z]{6,20}$").test(zhuCeMiMaTF.text!){
            KGXToast.showToastWithMessage("请输入6~20位数字或密码", duration: ToastDisplayDuration.LengthShort)
        }else{
//            self.loadingShow()
            loginService.regist(zhuCeMobileTF.text!, password: zhuCeMiMaTF.text!,referMobile: tuiJianRenShouJiHao.text!,verifyCode:zhuCeYanZhengTF.text!, calback: {
                
            msg in
//            self.loadingHidden()
            if msg == "成功"{
                UIApplication.sharedApplication().sendAction("resignFirstResponder", to: nil, from: nil, forEvent: nil)

                self.loginService.login(self.zhuCeMobileTF.text!, password: self.zhuCeMiMaTF.text! ,
                    calback: {
                        msg in
                        if msg == "aa" {
                            KeychainWrapper.removeObjectForKey(kSecValueData as String)

                            self.performSegueWithIdentifier("loginToGesture", sender: nil)
                        }else if msg == "adddddddd"{
                            KGXToast.showToastWithMessage("账号名或密码错误", duration: ToastDisplayDuration.LengthShort)
                            
                        }else{
                            print(msg)
                            KGXToast.showToastWithMessage("账号名或密码错误", duration: ToastDisplayDuration.LengthShort)
                        }
                    }
                )
                }
           })
        }
    }
    
    @IBAction func yanZhengMa(sender: AnyObject) {
        
        if zhuCeMobileTF.text == "" {
            KGXToast.showToastWithMessage("请输入手机号", duration: ToastDisplayDuration.LengthShort)
            //^(([1-9]\\d{0,9})|0)(\\.\\d{1,2})?$
        }else if !RegexUtil("^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$").test(zhuCeMobileTF.text!){
            KGXToast.showToastWithMessage("手机格式错误", duration: ToastDisplayDuration.LengthShort)
        }else{
            loginService.huoQuYanZhengMa(zhuCeMobileTF.text!, flag: "register_code", codeType: "1", calback: { (data) -> () in
                if data == "成功"{
                    self.time = 180
                    self.timer = NSTimer.scheduledTimerWithTimeInterval(1,
                        target:self,selector:Selector("tickDown"),
                        userInfo:nil,repeats:true)

                }
            })
            
        }
    }
    func tickDown()
    {
        if time != 0{
        yanZhengMaLB.text = "倒计时\(time - 1)s"
        time = time - 1
        yanZhengMa.enabled = false
//        print("tick...")
        }else{
//        print("到了")
        yanZhengMaLB.text = "获取验证码"
        yanZhengMa.enabled = true
        timer.invalidate()
        }
    }
    
}
