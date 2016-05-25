//
//  RealNameViewController.swift
//  ydzbapp-hybrid
//
//  Created by yinduo-zdy on 15/3/9.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class RealNameViewController: BaseViewController {
    
    @IBOutlet weak var submit: UIButton!
    
    @IBOutlet weak var cardNO: UITextField!
    @IBOutlet weak var realname: UITextField!
    
    let userSafetyService:UserSafetyInfoService = UserSafetyInfoService.getInstance();
    override func viewDidLoad() {
        super.viewDidLoad();
        self.initView();
    }
    
    func initView(){
        initNav("实名认证")
        
        cardNO.delegate = self
        realname.delegate = self
        
        //  提交按钮边框设置
        //submit.layer.borderWidth = 1
        submit.layer.cornerRadius = 5
        //submit.layer.borderColor = B.WORD_COLOR.CGColor
        
    }
    
    @IBAction func touchUpInsideAction(sender: AnyObject) {
        cardNO.resignFirstResponder()
        realname.resignFirstResponder()
    }
    
    @IBAction func submisAction(){
        
        closeKeyBoard()
        var  cno:NSString = self.cardNO.text!
        var  rnm:NSString = self.realname.text!
        //去空格
        cno = cno.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet());
        rnm = rnm.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet());
        
        if cno == "" || rnm == "" {
            KGXToast.showToastWithMessage("姓名或身份证号格式错误", duration: ToastDisplayDuration.LengthShort)
        }else{
            loadingShow()
            userSafetyService.realNameVerify(rnm as String,cardno: cno as String,calback: {
                data in
                self.loadingHidden()
                if let mm = data as? MsgModel {
                    if !mm.msg.isEmpty {
                        KGXToast.showToastWithMessage(mm.msg, duration: ToastDisplayDuration.LengthShort)
                    }
                    if mm.status == 1 {
                       self.navigationController?.popViewControllerAnimated(true);
                    }
                }
            })
        }
    }

}