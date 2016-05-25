//
//  AddTradepasswordViewController.swift
//  ydzbapp-hybrid
//
//  Created by yinduo-zdy on 15/3/9.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class AddTradepasswordViewController: BaseViewController {
    
    let userSafetyService =  UserSafetyInfoService.getInstance();
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
        initNav("交易密码")
        
        newpw.delegate = self
        
        //  提交按钮边框设置
        //submit.layer.borderWidth = 1
        submit.layer.cornerRadius = 5
        //submit.layer.borderColor = B.WORD_COLOR.CGColor
        
        self.newpw.clearsOnBeginEditing = true;
        self.newpw.secureTextEntry = true;
    }
    
    @IBAction func touchUpInsideAction(sender: AnyObject) {
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
        
        
        
        if newpw.text!.isEmpty {
            KGXToast.showToastWithMessage("请输入交易密码", duration: ToastDisplayDuration.LengthShort)
            return
        }
        if !RegexUtil("^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$").test(newpw.text!) {
            KGXToast.showToastWithMessage("密码格式不正确", duration: ToastDisplayDuration.LengthShort)
            return
        }
        
        var  np:NSString = self.newpw.text!
       
        np = np.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet());
        
        loadingShow()
        userSafetyService.changePayPassword(userDefaultsUtil.enMobile(""), newpsw: userDefaultsUtil.enTxt(np as String),calback: {
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
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if range.location > 19 {
            return false
        }else{
            return true
        }
    }
}
