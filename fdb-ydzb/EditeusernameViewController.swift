//
//  EditeusernameViewController.swift
//  ydzbapp-hybrid
//
//  Created by yinduo-zdy on 15/2/11.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class EditeusernameViewController:BaseViewController {
    
    @IBOutlet weak var unamedit: UITextField!
    @IBOutlet var submit :UIButton!;
    let userSafetyService =  UserSafetyInfoService.getInstance();
    override func viewDidLoad() {
        
        super.viewDidLoad();
        self.viewinit();
    }
    
    
    func viewinit(){
        
        initNav("用户昵称")
        unamedit.text = userDefaultsUtil.getUsername()
        unamedit.delegate = self
        
        //submit.layer.borderWidth = 1
        submit.layer.cornerRadius = 5
        //submit.layer.borderColor = B.WORD_COLOR.CGColor
        
        
    }
    
    @IBAction func touchUpInsideAction(sender: AnyObject) {
        unamedit.resignFirstResponder()
    }
    
    @IBAction func submitToChangeUsername(sender:UIButton){
//        sender.layer.borderColor = UIColor(red: 60/255, green: 207/255, blue: 163/255,alpha: 1).CGColor;
//        sender.titleLabel?.textColor = UIColor(red: 60/255, green: 207/255, blue: 163/255,alpha: 1)
        closeKeyBoard()
        var usr :NSString = unamedit.text!;
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
    }
    
    @IBAction func changeButtonBorderColor(sender:UIButton){
       
        //sender.layer.backgroundColor = UIColor(red: 60/255, green: 207/255, blue: 163/255,alpha: 1).CGColor;
        
        //sender.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
