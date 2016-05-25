//
//  CurrentCommonBuyViewController.swift
//  ydzbapp-hybrid
//  活期宝购买普通用户
//  Created by qinxin on 15/9/16.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class CurrentCommonBuyViewController: BaseViewController {
    
    //MARK: - Outlet
    //确认购买按钮
    @IBOutlet weak var buyButton: UIButton! {
        didSet {
            buyButton.layer.cornerRadius = 5.0
        }
    }
    //充值按钮
    @IBOutlet weak var rechargeButton: UIButton! {
        didSet {
            rechargeButton.layer.cornerRadius = 5.0
        }
    }
    @IBOutlet weak var usableFundLabel: UILabel!                //账户余额
    @IBOutlet weak var userExpmoneyLabel: UILabel!              //可用体验金
    @IBOutlet weak var surplusLabel: UILabel!                   //可购份数
    @IBOutlet weak var preBuyTextField: UITextField! {          //购买金额
        didSet {
            preBuyTextField.delegate = self
        }
    }
    @IBOutlet weak var canbeBuyLabel: UILabel!                  //可购限额
    
    @IBOutlet weak var viewbg: UIScrollView! {                  //背景
        didSet {
            viewbg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "resignTextField"))
        }
    }
    @IBOutlet weak var serviceContract: UIView! {               //服务协议
        didSet {
            serviceContract.userInteractionEnabled = true
            serviceContract.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "serviceAction"))
        }
    }
    
    
    
    let ydFinancingService = YdFinancingService.getInstance()
    var dayLoanBuyModel = DayLoanBuyModel()
    
    var productId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNav("活期宝购买")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func loadData(){
        loadingShow()
        self.ydFinancingService.dayloanBuy(self.productId, calback: { (data) -> () in
            if let _ = data as? DayLoanBuyModel {
                self.dayLoanBuyModel = data as! DayLoanBuyModel
                self.productId = self.dayLoanBuyModel.productId
                self.usableFundLabel.text = "¥ \(self.dayLoanBuyModel.usableFund)"
                self.userExpmoneyLabel.text = "¥ \(self.dayLoanBuyModel.userExpmoney)"
                self.surplusLabel.text = "¥ \(self.dayLoanBuyModel.surplus)"
                self.canbeBuyLabel.text = "¥ \(self.dayLoanBuyModel.quotaShow)"
                self.loadingHidden()
            }
        })
    }
    
    
    //MARK: - Action
    
    @IBAction func buyAction(sender: UIButton) {
        loadingShow()
        ydFinancingService.checkIdCard { (data) -> () in
            let msg = data as! MsgModel
            if msg.status == 1 {
                if self.preBuyTextField.text != "" {
                    if let buy = Int(self.preBuyTextField.text!) {
                        if buy == 0 {
                            KGXToast.showToastWithMessage("购买金额不能为0", duration: ToastDisplayDuration.LengthShort)
                            return
                        }
                    }
                    if RegexUtil("^[0-9]{1}[\\d]*$").test(self.preBuyTextField.text!) {
                        if let buy = Int(self.preBuyTextField.text!) {
                            if let canbeBuy = Int(self.dayLoanBuyModel.quota) {
                                if buy > canbeBuy {
                                    KGXToast.showToastWithMessage("购买金额不能超过可购限额", duration: ToastDisplayDuration.LengthShort)
                                    self.loadingHidden()
                                }else{
                                    
                                    let buy = userDefaultsUtil.enTxt(self.preBuyTextField.text!)
                                    self.ydFinancingService.dayLoanBuyPost(["mm":userDefaultsUtil.getMobile()!,"product_id":self.productId,"buy_copies":buy,"device":"0"], calback: {
                                        msg in
                                        self.loadingHidden()
                                        if let model = msg as? MsgModel {
                                            if model.status == 1 {
                                                self.navigationController?.popViewControllerAnimated(true)
                                            }
                                            KGXToast.showToastWithMessage(model.msg, duration: ToastDisplayDuration.LengthShort)
                                        }
                                    })
                                }
                            }
                        }
                    }else{
                        KGXToast.showToastWithMessage("购买金额格式不正确", duration: ToastDisplayDuration.LengthShort)
                        self.loadingHidden()
                    }
                }else{
                    KGXToast.showToastWithMessage("请输入购买金额", duration: ToastDisplayDuration.LengthShort)
                    self.loadingHidden()
                }
            }else{
                //跳转到安全中心
                KGXToast.showToastWithMessage(msg.msg, duration: ToastDisplayDuration.LengthShort)
                let oneStoryBoard:UIStoryboard = UIStoryboard(name: "SafetyCenter", bundle: NSBundle.mainBundle())
                let oneController:UIViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("safetystoryboard")
                self.navigationController?.pushViewController(oneController, animated: true)
                self.loadingHidden()
            }
        }
    }
    
    @IBAction func rechargeClick(sender: AnyObject) {
        gotoPage("Assest", pageName: "rechargeFristCtrl")
    }
    
    func resignTextField() {
        preBuyTextField.resignFirstResponder()
    }
    
    func serviceAction() {
        let customAllowedSet =  NSCharacterSet(charactersInString:"=\"#%/<>?@\\^`{|}").invertedSet
        let escapedStr = B.SERVICE_CONTRACTM_20.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
        let url = NSURL(string:B.SERVICE_CONTRACT_BASE + escapedStr!)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    
    //MARK: - UITextFieldDelegate
    
    override func textFieldShouldReturn(textField: UITextField) -> Bool {
        preBuyTextField.resignFirstResponder()
        return true
    }
    
}
