//
//  editEmergencyContactsViewController.swift
//  ydzbapp-hybrid
//  紧急联系人模块
//  Created by 刘驰 on 15/12/16.
//  Copyright © 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit

class EditEmergencyContactsViewController:BaseViewController {
    
    @IBOutlet weak var emergencyContactsTf: UITextField!{            //紧急联系人
        didSet {
            emergencyContactsTf.setValue(B.MENU_NORMAL_FONT_COLOR, forKeyPath: "placeholderLabel.textColor")
            emergencyContactsTf.delegate = self
        }
    }
    @IBOutlet var submit :UIButton!                                 //确认按钮
    let userSafetyService =  UserSafetyInfoService.getInstance()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        loadData()
    }
    
    
    func loadData(){
        loadingShow()
        userSafetyService.loadEmergencyContactsGet({
            (data) -> () in
            self.loadingHidden()
            if let ecm = data as? EmergencyContactsModel {
                self.emergencyContactsTf.text = ecm.contact
            }
        })
    }
    
    
    func initView(){
        initNav("紧急联系人")
        emergencyContactsTf.delegate = self
        submit.layer.cornerRadius = 5
    }
    
    @IBAction func touchUpInsideAction(sender: AnyObject) {
        emergencyContactsTf.resignFirstResponder()
    }
    
    //点击确认按钮事件
    @IBAction func submitClick(sender:UIButton){
        closeKeyBoard()
        let ec = emergencyContactsTf.text!;
        if checkMobile() {return}
        loadingShow()
        userSafetyService.emergencyContactsPost(ec, calback: {
            data in
            self.loadingHidden()
            let msg = data as! MsgModel
            KGXToast.showToastWithMessage(msg.msg, duration: ToastDisplayDuration.LengthShort)
            if msg.status != 0 {
                self.navigationController?.popViewControllerAnimated(true)
            }
        })
    }
    
    //验证手机号是否未通过
    func checkMobile() ->Bool {
        closeKeyBoard()
        let mobile = emergencyContactsTf.text!
        if mobile == userDefaultsUtil.showMobile() {
            KGXToast.showToastWithMessage("不能与注册号码相同", duration: ToastDisplayDuration.LengthShort)
            return true
        }
        if RegexUtil("^1\\d{10}$").test(mobile) {
            return false
        }else{
            KGXToast.showToastWithMessage("紧急联系人手机号格式不正确", duration: ToastDisplayDuration.LengthShort)
            return true
        }
    }

    
}
