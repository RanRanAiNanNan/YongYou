//
//  WithdrawViewController.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/3/11.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit

class WithdrawTableViewController: BaseTableViewController, UITextFieldDelegate, OnlySelectBankIdDelegate {
    
    @IBOutlet weak var withdrawTf: UITextField!                 //提现金额
    @IBOutlet weak var advanceLab: UILabel!                     //到帐金额
    @IBOutlet weak var withdrawBtn: UIButton!                   //提现按钮
    @IBOutlet weak var withrawCountLabel: UILabel!
    @IBOutlet weak var poundageLabel: UILabel!
    
    @IBOutlet weak var bankNameLab: UILabel!
    @IBOutlet weak var cardNoLab: UILabel!
    
    
    
    @IBOutlet weak var roleWebView: UIWebView!
    
    var usableFund = ""
    let assestService = AssestService.getInstance()
    
    var parm:[String : AnyObject] = [:]
    //扣费
    var deduct:Double = 3.00                                //扣费
    var minVal:Double = 1                                   //最小值提现值
    var bankId = ""
    
    @IBOutlet weak var withdrawTotalLab: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        addHelpCenter("")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }
    
    
    func initView(){
        initNav("提现")
        withdrawBtn.layer.cornerRadius = 5
        
        self.withdrawBtn.enabled = false
        self.withdrawBtn.backgroundColor = UIColor.lightGrayColor()
        self.withdrawTf.delegate = self
        
        roleWebView.scalesPageToFit = true
        roleWebView.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        let urlobj = NSURL(string: B.ROLE_WITHDRAW)
        let request = NSURLRequest(URL: urlobj!)
        roleWebView.loadRequest(request)
        //initAutoLayout()
    }
    
    func loadData(){
        
        var params = [String:String]()
        params["mm"] = userDefaultsUtil.getMobile()!
        if !bankId.isEmpty {
            params["bank_id"] = bankId
        }
        loadingShow()
        assestService.withdrawGet(params, calback:{
            (data) -> () in
            self.loadingHidden()
            if let wm = data as? WithrawModel {
                self.usableFund = wm.money
                //测试，一定在删掉
                //wm.kou = 3
                self.deduct = wm.kou
                self.poundageLabel.text = wm.kouShow
                self.withrawCountLabel.text = wm.usableFund
                self.withdrawBtn.enabled = true
                self.withdrawBtn.backgroundColor = B.BTN_NO_SELECTED
                self.bankNameLab.text = wm.bankName
                self.cardNoLab.text = wm.cardNo
                self.bankId = wm.bankId
                self.withdrawTotalLab.text = wm.withdrawTotal
                //self.withdrawTotalLab.text = "1000000.00"
            }
        })
        
    }
    
    //选择银行卡页面的回调方法
    func setSelectBankId(bankId: String) {
        self.bankId = bankId
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        calculate()
        return true
    }
    
    @IBAction func withdrawClick(sender: AnyObject) {
        closeKeyBoard()
       
        //检查提现输入格式是否正确
        if self.check() {
            self.loadingShow()
            //获取到账金额
            assestService.getAccountMoney(withdrawTf.text!, calback: {
                (data) -> () in
                self.loadingHidden()
                if let amm = data as? AccountMoneyModel {
                    //如果状态不为1表示用户输入金额有问题
                    if amm.status != 1 {
                        if !amm.msg.isEmpty{
                            KGXToast.showToastWithMessage(amm.msg, duration: ToastDisplayDuration.LengthShort)
                        }
                        return
                    }
                    //格式化提现金额
                    let showMoney = self.formatMenoy((self.withdrawTf.text! as NSString).doubleValue) + "元"
                    KGXToast.shortDismiss()
                    //交易密码对话框
                    LcAlertView().showWithdrawConfirmation(
                        showMoney,
                        account:amm.money + "元",
                        rule:amm.msg,
                        animStyle: .FlyFromBottom,
                        okTitle:"确定",
                        cancelTitle: "取消",
                        placeHolder: "请输入交易密码",
                        isSecured: true
                    ){
                        alertView, identifier in
                        //点击确定按钮
                        if identifier == "okBtn" {
                            alertView.inputTf.resignFirstResponder()
                            self.parm["mm"] = userDefaultsUtil.getMobile()!
                            self.parm["withdraw_money"] = userDefaultsUtil.enTxt(self.withdrawTf.text!)
                            self.parm["bank_id"] = self.bankId
                            self.parm["pay_password"] = userDefaultsUtil.enTxt(alertView.inputTf.text!)
                            self.loadingShow()
                            
                            //提交提现
                            self.assestService.withdrawPost(self.parm, calback: {
                                (data) -> () in
                                self.loadingHidden()
                                if let mm = data as? MsgModel {
                                    if !mm.msg.isEmpty{
                                        KGXToast.showToastWithMessage(mm.msg, duration: ToastDisplayDuration.LengthSuperShort)
                                    }
                                    //提现成功跳回上一页面
                                    if mm.status == 1 {
                                        self.navigationController?.popViewControllerAnimated(true)
                                    }
                                    
                                }
                            })
                        }
                    }
                }
            })
            
            
            
//            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "Finance", bundle: NSBundle.mainBundle())
//            let ppVC:PayPasswordViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("PayPasswordVC") as! PayPasswordViewController
//            ppVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
//            self.presentViewController(ppVC, animated: true, completion: { () -> Void in
//                ppVC.parm = self.parm
//            })
        }
    }
    
    func check() -> Bool{
        if withdrawTf.text!.isEmpty {
            KGXToast.showToastWithMessage("请输入提现金额", duration: ToastDisplayDuration.LengthShort)
            return false
        }
        if !RegexUtil("^(?!0+(?:\\.0+)?$)(?:[1-9]\\d*|0)(?:\\.\\d{1,2})?$").test(withdrawTf.text!) {
            KGXToast.showToastWithMessage("提现金额格式不正确", duration: ToastDisplayDuration.LengthShort)
            return false
        }
        let withdrawFund = (withdrawTf.text! as NSString).doubleValue
        let uf = (usableFund as NSString).doubleValue
        if withdrawFund > uf {
            KGXToast.showToastWithMessage("提现金额应少于可提现金额", duration: ToastDisplayDuration.LengthShort)
            return false
        }
        return true
    }
    
    
    /** 提现扣费计算 （现在没有用了！！！！！！！！！！！！！！！！）
     *  提现规则帮助（会变）帮助理解
     *  1.普通用户每个自然月可免费提现3次，第4次-第10次提现，平台每次收取3元手续费
     *  2.VIP用户每个自然月可免费提现5次，第6次-第10次提现，平台每次收取3元手续费
     *  3.所有用户（普通用户+VIP用户）每个自然月的提现次数若累计超过10次（从第11次开始计算），平台将对超出次数的提现行为以每次提现金额的千分之三收取手续费
     */
    func calculate() -> Bool {
        if withdrawTf.text!.isEmpty {
            KGXToast.showToastWithMessage("请输入提现金额", duration: ToastDisplayDuration.LengthShort)
            return false
        }
        if RegexUtil("^(?!0+(?:\\.0+)?$)(?:[1-9]\\d*|0)(?:\\.\\d{1,2})?$").test(withdrawTf.text!) {
            //计算提款金额
            let advance = (withdrawTf.text! as NSString).doubleValue
            if advance < minVal {
                let showMin = NSString(format: "%.02f", minVal) as String
                KGXToast.showToastWithMessage("提现金额应不少于\(showMin)元", duration: ToastDisplayDuration.LengthShort)
                return false
            }
            
            //实际扣费值
            var kou:Double = 0
            //计算扣款与提现最少值
            if deduct == 0 {                        //扣款免费为0元，最少提现1元
                kou = 0
                minVal = 1
            }else if deduct > 0 && deduct < 1 {     //扣款千分之几手续费，最少提现1元
                kou = advance * deduct
                minVal = 0.01
            }else if deduct >= 1 {                  //扣款大于1为整数手续费，最少提现等于手续费
                kou = deduct
                minVal = 0.01
            }
            

            //print("kou:\(kou),minVal:\(minVal)")
            
            //提现金额大于扣费（用于判断是否大于整数手续费）
            if advance >= kou {
                let v = NSDecimalNumber(string: NSString(format:"%f", advance) as String).decimalNumberBySubtracting(NSDecimalNumber(string: NSString(format:"%f", kou) as String)).doubleValue
                //计算实际提现金额
                let val = floor(v * 100) / 100
                //print("val:\(val)")
                //判断实际提现金额是否大于最少提现金额
                if val >= minVal {
                    //self.advanceLab.text = NSString(format: "%.02f", val) as String
                    return true
                }else{
                    self.advanceLab.text = "0.00"
                    //let showMin = NSString(format: "%.02f", minVal) as String
                    KGXToast.showToastWithMessage("到账金额应大于0.00元", duration: ToastDisplayDuration.LengthShort)
                    return false
                }
            }else{
                //self.advanceLab.text = "0.00"
                let showMin = NSString(format: "%.02f", kou) as String
                KGXToast.showToastWithMessage("提现金额应不少于\(showMin)元", duration: ToastDisplayDuration.LengthShort)
                return false
            }
        }else{
            KGXToast.showToastWithMessage("提现金额格式不正确", duration: ToastDisplayDuration.LengthShort)
            return false
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        calculate()
    }
    
    //每个分组间距高度，隐藏的分组为0
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //第一行header为0
        if section == 1 {
            return 15
        }
        if section == 2 {
            return 15
        }
        return 0
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        touchUpInsideKeyBoard()
        //tableview第一个分组的第一行
        if indexPath.section == 0 && indexPath.row == 0 {
            //toSelectBank()
            self.withdrawTotalClick()
            
        }
    }

    
    /**提现总额跳转**/
    @IBAction func withdrawTotalClick() {
        if (withdrawTotalLab.text! as NSString).doubleValue > 0  {
            self.performSegueWithIdentifier("withdrawRecordSegue", sender: nil)
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "withdrawSelectBankCardSegue" {
            let bcostvc:BankCardOnlySelectTableViewController = segue.destinationViewController as! BankCardOnlySelectTableViewController
            bcostvc.delegate = self
            
        }
    }
    
    func formatMenoy(money:Double) -> String {
        let numberFormatter = NSNumberFormatter()
        numberFormatter.positiveFormat = "###,##0.00;"
        let formattedNumberString = numberFormatter.stringFromNumber(NSNumber(double: money))
        return formattedNumberString!
    }
    
    //收起键盘
    func touchUpInsideKeyBoard() {
        self.withdrawTf.resignFirstResponder()
        calculate()
    }
    
    
}