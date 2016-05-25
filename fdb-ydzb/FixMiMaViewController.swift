//
//  FixMiMaViewController.swift
//  fdb-ydzb
//
//  Created by 123 on 16/4/16.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation
class FixMiMaViewController:BaseViewController {
    
    @IBOutlet weak var password1: UITextField!
    @IBOutlet weak var password2: UITextField!
    @IBOutlet weak var password3: UITextField!
    let geRenService = GeRenService.getInstance()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initView()
        
        
    }
    
    func initView(){
        
//        self.navigationController!.navigationBarHidden = true
        password1.delegate = self
        password2.delegate = self
        password3.delegate = self
    }
    override func textFieldShouldReturn(textField: UITextField) -> Bool {
        password1.resignFirstResponder()
        password2.resignFirstResponder()
        password3.resignFirstResponder()
        return true
    }
    
    @IBAction func back(sender: AnyObject) {
         self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func tiJiao(sender: AnyObject) {
        password1.resignFirstResponder()
        password2.resignFirstResponder()
        password3.resignFirstResponder()
        if password1.text == ""{
             KGXToast.showToastWithMessage("请输入旧密码", duration: ToastDisplayDuration.LengthShort)
        }
        else if password2.text == ""{
            KGXToast.showToastWithMessage("请输入新密码", duration: ToastDisplayDuration.LengthShort)
        }
        else if password3.text == ""{
            KGXToast.showToastWithMessage("请再次输入新密码", duration: ToastDisplayDuration.LengthShort)
        }else if password2.text != password3.text{
            KGXToast.showToastWithMessage("两次密码不一致", duration: ToastDisplayDuration.LengthShort)
        }else if password1.text == password2.text{
            KGXToast.showToastWithMessage("原密码和新密码不能相同", duration: ToastDisplayDuration.LengthShort)
        }else if !RegexUtil("^[0-9A-Za-z]{6,20}$").test(password2.text!){
            KGXToast.showToastWithMessage("输入6-20位数字或字母", duration: ToastDisplayDuration.LengthShort)
        }else if !RegexUtil("^[0-9A-Za-z]{6,20}$").test(password2.text!) || !RegexUtil("^[0-9A-Za-z]{6,20}$").test(password3.text!){
            KGXToast.showToastWithMessage("请输入6~20位数字或字母", duration: ToastDisplayDuration.LengthShort)
        }
        else if password1.text != "" && password2.text != "" && password3.text != ""{

        geRenService.xiuGaiMiMa(password1.text!, password2: password2.text!, password3: password3.text!, calback: { (data) -> () in
            if data as! String == "成功"{
                userDefaultsUtil.exitSetting()
                KeychainWrapper.removeObjectForKey(kSecValueData as String)
                let twoStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let twoController:LoginViewController = twoStoryBoard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                twoController.hidesBottomBarWhenPushed = true
                self.presentViewController(twoController, animated: true, completion: nil)
//              self.navigationController?.popViewControllerAnimated(true)  
            }
        })
        }
    }
    
    
    
    
    
    
}