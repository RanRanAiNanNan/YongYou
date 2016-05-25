//
//  InternalTransferViewController.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 16/1/28.
//  Copyright © 2016年 银多资本. All rights reserved.
//

import Foundation
import UIKit

class InternalTransferTableViewController: BaseTableViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var allIntoLab: UILabel!                     //转入总额
    @IBOutlet weak var allOutLab: UILabel!                      //转出总额
    
    @IBOutlet weak var usableFundLab: UILabel!                  //可转账金额
    @IBOutlet weak var userNameTf: UITextField!                 //用户昵称
    @IBOutlet weak var mobileTf: UITextField!                   //手机号
    @IBOutlet weak var realNameTf: UITextField!                 //真实姓名
    @IBOutlet weak var idCardTf: UITextField!                   //身份证号
    @IBOutlet weak var moneyTf: UITextField!                    //转账金额
    @IBOutlet weak var transferBtn: UIButton!                   //确认转账按钮
    
    
    let userCenterService = UserCenterService.getInstance()
    
    var usableFund = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func initView(){
        initNav("转账")
        transferBtn.layer.cornerRadius = 5
        self.userNameTf.delegate = self
        self.realNameTf.delegate = self
        self.mobileTf.delegate = self
        self.idCardTf.delegate = self
        self.moneyTf.delegate = self
    }
    
    func loadData(){
        loadingShow()
        userCenterService.internalTransferGet({
            (data) -> () in
            self.loadingHidden()
            if let itm = data as? InternalTransferModel {
                self.usableFundLab.text = itm.usableFundShow
                self.usableFund = (itm.usableFund as NSString).doubleValue
                self.allIntoLab.text = itm.allInto
                self.allOutLab.text = itm.allOutto
            }
        })
        
    }
    
    //转账提交事件
    @IBAction func subimtClick(sender: AnyObject) {
        if checkUserName(){return}
        if checkMobile(){return}
        if checkRealName() {return}
        if checkCardId(){return}
        if checkMoney(){return}
        if checkUsableFound(){return}
        if checkTransfer(){return}
        
        var params = [String:String]()
        params["mm"] = userDefaultsUtil.getMobile()
        params["mobile"] = userDefaultsUtil.enTxt(mobileTf.text!)
        params["user_name"] = userDefaultsUtil.enTxt(userNameTf.text!)
        params["real_name"] = userDefaultsUtil.enTxt(realNameTf.text!)
        params["id_card"] = userDefaultsUtil.enTxt(idCardTf.text!)
        params["money"] = userDefaultsUtil.enTxt(moneyTf.text!)
        params["internal_transfer"] = ""    //交易密码识别ID,提交前删掉
        
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "Finance", bundle: NSBundle.mainBundle())
        let ppVC:PayPasswordViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("PayPasswordVC") as! PayPasswordViewController
        ppVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        self.presentViewController(ppVC, animated: true, completion: { () -> Void in
            ppVC.parm = params
        })
        
    }
    
    /* 转入总额跳转 */
    @IBAction func allIntoClick(sender: AnyObject) {
        if (allIntoLab.text! as NSString).doubleValue > 0  {
            self.performSegueWithIdentifier("intoTransferRecordSegue", sender: nil)
        }
        
    }
    
    /* 转出总额跳转 */
    @IBAction func allOutClick(sender: AnyObject) {
        if (allOutLab.text! as NSString).doubleValue > 0  {
            self.performSegueWithIdentifier("outTransferRecordSegue", sender: nil)
        }
    }
    
    
    
    /** 检验转账金额 **/
    func checkTransfer() -> Bool {
        let money = (moneyTf.text! as NSString).doubleValue
        //println("uf:\(uf)")
        if money > usableFund {
            KGXToast.showToastWithMessage("转账金额应少于可转账金额", duration: ToastDisplayDuration.LengthShort)
            return true
        }else{
            return false
        }
    }
    
    
    
    /**验证手机号是否未通过**/
    func checkMobile() ->Bool {
        closeKeyBoard()
        let mobile = mobileTf.text!
        if mobile.isEmpty {
            KGXToast.showToastWithMessage("请输入手机号码", duration: ToastDisplayDuration.LengthShort)
            return true
        }
        if RegexUtil("^1\\d{10}$").test(mobile) {
            return false
        }else{
            KGXToast.showToastWithMessage("手机号码格式错误", duration: ToastDisplayDuration.LengthShort)
            return true
        }
    }
    
    /**验证身份证是否末通过**/
    func checkCardId() -> Bool {
        closeKeyBoard()
        if idCardTf.text!.characters.count >= 15 && idCardTf.text!.characters.count <= 18 {
            return false
        }else{
            KGXToast.showToastWithMessage("身份证格式不正确", duration: ToastDisplayDuration.LengthShort)
            return true
        }
    }
    
    /**验证昵称是否末通过**/
    func checkUserName() -> Bool {
        closeKeyBoard()
        if !userNameTf.text!.isEmpty {
            return false
        }else{
            KGXToast.showToastWithMessage("请输入昵称", duration: ToastDisplayDuration.LengthShort)
            return true
        }
    }
    
    /**验证姓名是否末通过**/
    func checkRealName() -> Bool {
        closeKeyBoard()
        if !realNameTf.text!.isEmpty {
            return false
        }else{
            KGXToast.showToastWithMessage("请输入姓名", duration: ToastDisplayDuration.LengthShort)
            return true
        }
    }
    
    
    /**验证金额**/
    func checkMoney() -> Bool {
        closeKeyBoard()
        if !moneyTf.text!.isEmpty {
            return false
        }else{
            KGXToast.showToastWithMessage("请输入转账金额", duration: ToastDisplayDuration.LengthShort)
            return true
        }
    }
    
    func checkUsableFound() -> Bool {
        if !RegexUtil("^(?!0+(?:\\.0+)?$)(?:[1-9]\\d*|0)(?:\\.\\d{1,2})?$").test(moneyTf.text!) {
            KGXToast.showToastWithMessage("转账金额格式不正确", duration: ToastDisplayDuration.LengthShort)
            return true
        }else{
            return false
        }
    }
    
    
    //每个分组间距高度，隐藏的分组为0
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //第一行header为0
        if section == 1 {
            return 15
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        touchUpInsideKeyBoard()
    }
    
    
    
    //收起键盘
    func touchUpInsideKeyBoard() {
        self.userNameTf.resignFirstResponder()
        self.realNameTf.resignFirstResponder()
        self.mobileTf.resignFirstResponder()
        self.idCardTf.resignFirstResponder()
        self.moneyTf.resignFirstResponder()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}