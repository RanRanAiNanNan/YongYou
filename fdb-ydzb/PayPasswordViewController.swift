//
//  PayPasswordViewController.swift
//  ydzbapp-hybrid
//
//  Created by qinxin on 15/6/5.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit
//返回提交状态代理
protocol SubmitStatusDelegate{
    func getSubmitStatus(status:Int);
}
class PayPasswordViewController: BaseViewController {
    
    var delegate: SubmitStatusDelegate?

    @IBOutlet weak var payTextField: UITextField! {
        didSet {
            payTextField.delegate = self
            payTextField.becomeFirstResponder()
            payTextField.secureTextEntry = true
        }
    }
    
    @IBOutlet weak var okTappped: UIButton! {
        didSet {
            okTappped.layer.cornerRadius = 5.0
        }
    }
    
    
    let ydFinancingService = YdFinancingService.getInstance()
    let homeService = HomeService.getInstance()
    let assestService = AssestService.getInstance()
    let userCenterService = UserCenterService.getInstance()
    
    var parm:[String : AnyObject] = [:]
    var array = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView() {
        view.backgroundColor = UIColor.clearColor()
    }
    
    @IBAction func close(sender: UIButton) {
        payTextField.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func okTapped(sender: UIButton) {
        
        if payTextField.text == "" {
            KGXToast.showToastWithMessage("交易密码不能为空", duration: ToastDisplayDuration.LengthShort)
        }else{
            let payPassword = userDefaultsUtil.enTxt(self.payTextField.text!)
            parm["pay_password"] = payPassword
            
            loadingShow()
            let nsParm: NSDictionary = parm as NSDictionary
            if let _: AnyObject = nsParm.objectForKey("withdraw_money") {
//                assestService.withdrawPost(parm, calback: {
//                    msg in
//                    //提现交易密码
//                    self.loadingHidden()
//                    KGXToast.showToastWithMessage(msg, duration: ToastDisplayDuration.LengthShort)
//                    self.payTextField.resignFirstResponder()
//                    self.dismissViewControllerAnimated(true, completion: nil)
//                    if let vc = self.presentingViewController as? UINavigationController{
//                        vc.popViewControllerAnimated(true)
//                    }
//                })
            }else if let _: AnyObject = nsParm.objectForKey("redemption_fund"){
                ydFinancingService.dayLoanRedeemPost(parm, calback: {
                    msg in
                    //赎回交易密码
                    self.loadingHidden()
                    KGXToast.showToastWithMessage(msg, duration: ToastDisplayDuration.LengthShort)
                    self.payTextField.resignFirstResponder()
                    self.dismissViewControllerAnimated(true, completion: nil)
                    if let vc = self.presentingViewController as? UINavigationController{
                        vc.popViewControllerAnimated(true)
                    }
                })
            }else if let _: AnyObject = nsParm.objectForKey("buy_copies"){
                ydFinancingService.dayLoanPrepayPost(parm, calback: {
                    msg in
                    //预投交易密码
                    self.loadingHidden()
                    KGXToast.showToastWithMessage(msg, duration: ToastDisplayDuration.LengthShort)
                    self.payTextField.resignFirstResponder()
                    self.dismissViewControllerAnimated(true, completion: nil)
                    if let vc = self.presentingViewController as? UINavigationController{
                        vc.popViewControllerAnimated(true)
                    }
                })
            }else if let _: AnyObject = nsParm.objectForKey("bank_code"){
                //充值
                assestService.rechargePost(parm, calback: {
                    data in
                    if let mm = data as? MsgModel {
                        self.loadingHidden()
                        KGXToast.showToastWithMessage(mm.msg, duration: ToastDisplayDuration.LengthShort)
                        self.payTextField.resignFirstResponder()
                        self.dismissViewControllerAnimated(true, completion: nil)
                        if mm.status == 1 {
                            if let vc = self.presentingViewController as? UINavigationController{
                                vc.popViewControllerAnimated(true)
                            }
                        }else{
                            if self.delegate != nil {
                                self.delegate?.getSubmitStatus(mm.status)
                                self.navigationController?.popViewControllerAnimated(true)
                            }
                        }
                    }
                })
                
            }else if let _: AnyObject = nsParm.objectForKey("internal_transfer"){
                parm.removeValueForKey("internal_transfer")
                //转账
                userCenterService.internalTransferPost(parm, calback: {
                    data in
                    if let mm = data as? MsgModel {
                        self.loadingHidden()
                        if !mm.msg.isEmpty{
                            KGXToast.showToastWithMessage(mm.msg, duration: ToastDisplayDuration.LengthShort)
                        }
                        self.payTextField.resignFirstResponder()
                        self.dismissViewControllerAnimated(true, completion: nil)
                        if mm.status == 1 {
                            if let vc = self.presentingViewController as? UINavigationController{
                                vc.popViewControllerAnimated(true)
                            }
                        }else{
                            if self.delegate != nil {
                                self.delegate?.getSubmitStatus(mm.status)
                                self.navigationController?.popViewControllerAnimated(true)
                            }
                        }
                    }
                })
                
            }else{
                //债权转让
                ydFinancingService.depositTransfer(parm, calback: { (data) -> () in
                    let msg = data as! MsgModel
                    
                    if self.delegate != nil {
                        self.delegate?.getSubmitStatus(msg.status)
                    }
                    
                    self.loadingHidden()
                    KGXToast.showToastWithMessage("\(msg.msg)", duration: ToastDisplayDuration.LengthShort)
                    
                    self.payTextField.resignFirstResponder()
                    self.dismissViewControllerAnimated(true, completion: nil)
                    if let vc = self.presentingViewController as? UINavigationController{
                        vc.popViewControllerAnimated(true)
                    }
                })
            }
        }
    }
    
    
    // MARK: - UITextFieldDelegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if string != ""{
            array.append(string)
        } else {
            array.removeLast()
        }
        
        if array.count > 5 {
            okTappped.backgroundColor = UIColor(red: 237.0 / 255, green: 91.0 / 255, blue: 90.0 / 255, alpha: 1)
        }else{
            okTappped.backgroundColor = UIColor(red: 243.0 / 255, green: 145.0 / 255, blue: 144.0 / 255, alpha: 1)
        }
        
        return true
    }
    
    override func textFieldShouldReturn(textField: UITextField) -> Bool {
        return false
    }

}
