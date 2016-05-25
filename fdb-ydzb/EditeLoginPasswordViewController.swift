//
//  EditeLoginPasswordViewController.swift
//  ydzbapp-hybrid
//
//  Created by yinduo-zdy on 15/2/12.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class EditeLoginPasswordViewController: BaseViewController {
    let userSafetyService =  UserSafetyInfoService.getInstance();
    @IBOutlet weak var oldpw:UITextField! {
        didSet {
            oldpw.setValue(B.MENU_NORMAL_FONT_COLOR, forKeyPath: "placeholderLabel.textColor")
            oldpw.delegate = self
        }
    }
    @IBOutlet weak var newpw:UITextField! {
        didSet {
            newpw.setValue(B.MENU_NORMAL_FONT_COLOR, forKeyPath: "placeholderLabel.textColor")
            newpw.delegate = self
        }
    }
    @IBOutlet weak var submit:UIButton!;
    @IBOutlet weak var pswstyle:UIButton!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.initView();
        
    }
    
    func initView(){
        
        initNav("修改登录密码")
        
        oldpw.delegate = self
        newpw.delegate = self
        
        //  提交按钮边框设置
        //submit.layer.borderWidth = 1
        submit.layer.cornerRadius = 5
        //submit.layer.borderColor = B.WORD_COLOR.CGColor
        
        
        self.newpw.clearsOnBeginEditing = true;
        self.newpw.secureTextEntry = true;
    }
    
    @IBAction func touchUpInsideAction(sender: AnyObject) {
        oldpw.resignFirstResponder()
        newpw.resignFirstResponder()
    }
    
    @IBAction func changePassworkStyle(){
        if(self.newpw.secureTextEntry){
            self.newpw.enabled = false
            self.newpw.secureTextEntry = false
            self.newpw.enabled = true
            self.newpw.clearsOnBeginEditing = false
            self.newpw.becomeFirstResponder()
            self.pswstyle.setTitle("隐藏密码", forState:.Normal)
        }else{
            self.newpw.enabled = false
            self.newpw.secureTextEntry = true
            self.newpw.enabled = true
            self.newpw.clearsOnBeginEditing = false
            self.newpw.becomeFirstResponder()
            self.pswstyle.setTitle("显示密码", forState:.Normal)
        }
        
    }
    
    @IBAction func submisAction(){
         closeKeyBoard()
         //var opsw : NSString = self.oldpw.text!
         //var npsw : NSString = self.newpw.text!
         //npsw = npsw.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet());
         //opsw = opsw.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet());
         if RegexUtil("^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$").test(self.newpw.text!) {
            loadingShow()
            userSafetyService.changeLoginPassword(userDefaultsUtil.enTxt(self.oldpw.text!), newpsw: userDefaultsUtil.enTxt(self.newpw.text!), calback: {
                data in
                self.loadingHidden()
                let msg = data as! MsgModel
                KGXToast.showToastWithMessage(msg.msg, duration: ToastDisplayDuration.LengthShort)
                if msg.status == 0 {
                    return
                }else{
                   self.navigationController?.popViewControllerAnimated(true)
                }
                
            })
            
        }else{
             KGXToast.showToastWithMessage("密码格式不正确", duration: ToastDisplayDuration.LengthShort)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    //MARK: - UITextFieldDelegate
    
    override func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if range.location > 19 {
            return false
        }else{
            return true
        }
    }
}