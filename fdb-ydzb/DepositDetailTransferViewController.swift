//
//  DepositDetailTransferViewController.swift
//  ydzbapp-hybrid
//  债权转让
//  Created by qinxin on 15/9/25.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class DepositDetailTransferViewController: BaseViewController, SubmitStatusDelegate {
    
    //    @IBOutlet var bgView: UIView! {
    //        didSet {
    //            bgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "resignTextField"))
    //        }
    //    }
    //    @IBOutlet weak var interestRates: UILabel!
    //    @IBOutlet weak var transferCountField: UITextField! {
    //        didSet {
    //            transferCountField.delegate = self
    //        }
    //    }
    
    @IBOutlet weak var productNameLabel: UILabel!               //产品名称
    @IBOutlet weak var allMoneyLabel: UILabel!                  //投资金额
    @IBOutlet weak var overMoneyLabel: UILabel!                 //折损利息
    @IBOutlet weak var feeMoneyLabel: UILabel!                  //手续费
    @IBOutlet weak var moneyLabel: UILabel!                     //到账金额
    
    @IBOutlet weak var transferButton: UIButton! {
        didSet {
            transferButton.layer.cornerRadius = 10.0
        }
    }
    @IBOutlet weak var transferServiceLabel: UILabel! {
        didSet {
            transferServiceLabel.userInteractionEnabled = true
            transferServiceLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "serviceAction"))
        }
    }
    @IBOutlet weak var transferRuleLabel: UILabel! {
        didSet {
            transferRuleLabel.userInteractionEnabled = true
            transferRuleLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "ruleAction"))
        }
    }
    
    let service = YdFinancingService()
    
    var productId: String = ""
    var parm:[String : AnyObject] = [:]
    var model = DepositBuyProductsModel()
    
    
    //MARK: - Life view cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    
    //MARK: - Private methods
    
    private func initView() {
        initNav("债权转让")
    }
    
    private func loadData() {
        
        //产品名称
        self.productNameLabel.text = self.model.productName
        
        //投资金额
        self.allMoneyLabel.text = "¥ \(self.model.allMoney)"
        
        //折损利息
        self.overMoneyLabel.text = "¥ \(self.model.overMoney)"
        
        //手续费
        self.feeMoneyLabel.text = "¥ \(self.model.feeMoney)"
        
        //到账金额
        self.moneyLabel.text = "¥ \(self.model.money)"
        
        
        
        //        //输入提示
        //        self.transferCountField.placeholder = "请输入转让金额"
        
        //按钮状态
        if self.model.status == "0" {
            self.transferButton.setTitle("确认转让", forState: UIControlState.Normal)
        }else if self.model.status == "2"{
            self.transferButton.setTitle("取消转让", forState: UIControlState.Normal)
            //            self.transferCountField.text = "¥ \(self.model.applyFund)"
            //            self.transferCountField.userInteractionEnabled = false
            //            calculate(self.transferCountField.text!)
        }else{
            self.transferButton.setTitle("转让中", forState: UIControlState.Normal)
            self.transferButton.enabled = false
            //            self.transferCountField.text = "¥ \(self.model.applyFund)"
            //            self.transferCountField.userInteractionEnabled = false
            //            calculate(self.transferCountField.text!)
        }
    }
    
    //    private func calculate(buy: String) {
    //        //折合利率 = (投资金额 － 转让金额 ＋ formulaAdd) / formulaDiv
    //        //到账金额 = 转让金额 － 手续费
    //        if buy == "" {
    //            self.interestRates.text = "0"
    //            self.ToTheFound.text = "¥ 0.0"
    //        }else{
    //            let buyStr = stringByReplaceing(buy)
    //
    //            //投资金额
    //            let allMoney = (self.model.allMoney as NSString).stringByReplacingOccurrencesOfString(",", withString: "")
    //            let allMoenyDouble = (allMoney as NSString).doubleValue
    //
    //            //折合利率
    //            let interest = (allMoenyDouble - (buyStr as NSString).doubleValue + (self.model.formulaAdd as NSString).doubleValue) / (buyStr as NSString).doubleValue * (self.model.formulaDiv as NSString).doubleValue
    //            self.interestRates.text = "\(NSString(format: "%.02f", floor(interest * 100) / 100) as String) %"
    //
    //            //到账
    //            let fee = (self.model.feeMoney as NSString).stringByReplacingOccurrencesOfString(",", withString: "")
    //            let toTheFound = (buyStr as NSString).doubleValue - (fee as NSString).doubleValue
    //            self.ToTheFound.text = "¥ \(NSString(format: "%.02f", floor(toTheFound * 100) / 100) as String)"
    //        }
    //
    //    }
    
    //textfielf string 处理
    //    private func stringByReplaceing(buy: String) -> String {
    //        let transCount1 = (buy as NSString).stringByReplacingOccurrencesOfString(",", withString: "")
    //        let transCount2 = (transCount1 as NSString).stringByReplacingOccurrencesOfString("¥", withString: "")
    //        return (transCount2 as NSString).stringByReplacingOccurrencesOfString(" ", withString: "")
    //    }
    
    
    //MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DepositDetail_List" {
            let dpidtvc: DepositeIncomeDetailTableViewController = segue.destinationViewController as! DepositeIncomeDetailTableViewController
            dpidtvc.productId = productId
        }
    }
    
    
    //MARK: - Action
    
    //    func resignTextField() {
    //        transferCountField.resignFirstResponder()
    //        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(0.5), target: self, selector: Selector("transferButtonActionInterface"), userInfo: nil, repeats: false)
    //    }
    
    //    func transferButtonActionInterface() {
    //        transferButton.userInteractionEnabled = true
    //        transferServiceLabel.userInteractionEnabled = true
    //        transferRuleLabel.userInteractionEnabled = true
    //    }
    
    
    @IBAction func transferAction(sender: UIButton) {
        loadingShow()
        service.dayLoanRedeemPwd { (data) -> () in
            self.loadingHidden()
            if let dlrm = data as? DayLoanRedeemModel {
                if dlrm.pwdStatus == 0 {
                    //跳转到安全中心
                    KGXToast.showToastWithMessage("请先设置交易密码", duration: ToastDisplayDuration.LengthShort)
                    let oneStoryBoard:UIStoryboard = UIStoryboard(name: "SafetyCenter", bundle: NSBundle.mainBundle())
                    let oneController:UIViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("safetystoryboard")
                    self.navigationController?.pushViewController(oneController, animated: true)
                }else{
                    self.popPayPasswordWindow()
                }
            }
        }
        //        service.dayLoanRedeemPwd { (data) -> () in
        //
        //            self.loadingHidden()
        //
        //            let transCount = self.stringByReplaceing(self.transferCountField.text!)
        //
        //            if transCount == "0" {
        //                KGXToast.showToastWithMessage("转让金额不能为0", duration: ToastDisplayDuration.LengthShort)
        //            }else if transCount == "" {
        //                KGXToast.showToastWithMessage("请输入转让金额", duration: ToastDisplayDuration.LengthShort)
        //            }else if (transCount as NSString).doubleValue < (self.model.feeMoney as NSString).doubleValue {
        //                KGXToast.showToastWithMessage("转让金额不能小于手续费", duration: ToastDisplayDuration.LengthShort)
        //            }else if (transCount as NSString).doubleValue > (self.model.max as NSString).doubleValue {
        //                KGXToast.showToastWithMessage("转让金额不能大于\(self.model.max)元", duration: ToastDisplayDuration.LengthShort)
        //            }else if RegexUtil("^(?!0+(?:\\.0+)?$)(?:[1-9]\\d*|0)(?:\\.\\d{1,2})?$").test(transCount){
        //                if let dlrm = data as? DayLoanRedeemModel {
        //                    if dlrm.pwdStatus == 0 {
        //                        //跳转到安全中心
        //                        KGXToast.showToastWithMessage("请先设置交易密码", duration: ToastDisplayDuration.LengthShort)
        //                        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "SafetyCenter", bundle: NSBundle.mainBundle())
        //                        let oneController:UIViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("safetystoryboard")
        //                        self.navigationController?.pushViewController(oneController, animated: true)
        //                    }else{
        //                        self.popPayPasswordWindow()
        //                    }
        //                }
        //            }else{
        //                KGXToast.showToastWithMessage("转让金额格式不正确", duration: ToastDisplayDuration.LengthShort)
        //            }
        //        }
    }
    
    private func popPayPasswordWindow() {
        loadingShow()
        parm["mm"] = userDefaultsUtil.getMobile()!
        parm["id"] = productId
        
        //        let transCount = stringByReplaceing(self.transferCountField.text!)
        //        parm["apply_fund"] = transCount
        
        if self.model.status == "0" {
            parm["status"] = "2"
        }else{
            parm["status"] = "0"
        }
        
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "Finance", bundle: NSBundle.mainBundle())
        let ppVC:PayPasswordViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("PayPasswordVC") as! PayPasswordViewController
        ppVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        ppVC.delegate = self
        self.presentViewController(ppVC, animated: true, completion: { () -> Void in
            ppVC.parm = self.parm
        })
    }
    
    func serviceAction() {
        let customAllowedSet =  NSCharacterSet(charactersInString:"=\"#%/<>?@\\^`{|}").invertedSet
        let escapedStr = B.SERVICE_TRANSFER.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
        let url = NSURL(string:B.SERVICE_CONTRACT_BASE + escapedStr!)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    func ruleAction() {
        self.info_cid = B.ROLE_TRANSFER
        infoShow()
    }
    
    
    //MARK: - SubmitStatusDelegate
    
    func getSubmitStatus(status: Int) {
        if status == 0 {
            return
        }else{
            if self.transferButton.titleLabel?.text == "确认转让" {
                self.transferButton.setTitle("取消转让", forState: .Normal)
            }else{
                self.transferButton.setTitle("确认转让", forState: .Normal)
            }
        }
    }
    
    
    //MARK: - UITextFieldDelegate
    
    //    override func textFieldShouldReturn(textField: UITextField) -> Bool {
    //        return true
    //    }
    //
    //    var buyString: String = ""
    //
    //    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    //
    //        transferButton.userInteractionEnabled = false
    //        transferServiceLabel.userInteractionEnabled = false
    //        transferRuleLabel.userInteractionEnabled = false
    //
    //        //text field 判断
    //        if range.location > 7 {
    //            return false
    //        }else{
    //
    //            //获取值
    //            if string != "" {
    //                if self.transferCountField.text! == "" && string == "0"{
    //                    return false
    //                }else{
    //                    buyString = buyString.stringByAppendingString(string)
    //                }
    //            }else{
    //                let string = buyString as NSString
    //                buyString = string.substringToIndex(range.location)
    //            }
    //            
    //            //将值计算
    //            if (buyString as NSString).doubleValue > (self.model.max as NSString).doubleValue {
    //                KGXToast.showToastWithMessage("转账金额不能大于\(self.model.max)", duration: ToastDisplayDuration.LengthShort)
    //                self.resignTextField()
    //                return false
    //            }else{
    //                calculate(buyString)
    //                return true
    //            }
    //            
    //        }
    //    }
    
}
