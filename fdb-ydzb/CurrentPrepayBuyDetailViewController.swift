//
//  CurrentPrepayBuyDetailViewController.swift
//  ydzbapp-hybrid
//  活期宝预投VIP用户
//  Created by qinxin on 15/9/10.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class CurrentPrepayBuyDetailViewController: BaseViewController {
    
    //MARK: - Outlet
    //立即预投按钮
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
    @IBOutlet weak var preBuyTextField: UITextField! {          //预投金额
        didSet {
            preBuyTextField.delegate = self
        }
    }
    
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
    var dayLoanPrepayModel = DayLoanPrepayModel()
    var parm = [String:AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNav("活期宝预投")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func loadData(){
        loadingShow()
        ydFinancingService.dayLoanPrepayData({ (data) -> () in
            if let msg = data as? DayLoanPrepayModel {
                self.dayLoanPrepayModel = msg
                if (self.dayLoanPrepayModel.usableFund as NSString).doubleValue == 0 {
                    self.usableFundLabel.text = "¥ 0"
                }else{
                    self.usableFundLabel.text = "¥ \(self.dayLoanPrepayModel.usableFund)"
                }
                self.userExpmoneyLabel.text = "¥ \(self.dayLoanPrepayModel.userExpmoney)"
                self.loadingHidden()
            }
        })
    }
    
    
    //MARK: - Action
    
    @IBAction func buyAction(sender: UIButton) {
        closeKeyBoard()
        if preBuyTextField.text != "" {
            if RegexUtil("^[0-9]{1}[\\d]*$").test(preBuyTextField.text!) {
                let buy = Int(self.preBuyTextField.text!)
                if buy == 0 {
                    KGXToast.showToastWithMessage("预投金额不能为0", duration: ToastDisplayDuration.LengthShort)
                    return
                }
                //10:00前预投为当前份额，\n 11:35之后为次日份额，隔日起息
                let alertview = HHAlertView(title: "预投提示", detailText: "预投为优先购买下一期开放债权", addView: view, cancelButtonTitle: "取消", otherButtonTitles: ["确认"])
                alertview.center = CGPointMake(view.centerx, view.centery-100)
                alertview.maskView?.backgroundColor = UIColor.blackColor()
                alertview.show()
                alertview.showWithBlock({ (buttonIndex) -> Void in
                    if buttonIndex == 0 {
                        return
                    }else if buttonIndex == 1 {
                        self.loadingShow()
                        self.ydFinancingService.dayLoanRedeemPwd { (data) -> () in
                            self.loadingHidden()
                            if let dlrm = data as? DayLoanRedeemModel {
                                if dlrm.pwdStatus == 0 {
                                    //跳转到安全中心
                                    KGXToast.showToastWithMessage("请先设置交易密码", duration: ToastDisplayDuration.LengthShort)
                                    let oneStoryBoard:UIStoryboard = UIStoryboard(name: "SafetyCenter", bundle: NSBundle.mainBundle())
                                    let oneController:UIViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("safetystoryboard")
                                    self.navigationController?.pushViewController(oneController, animated: true)
                                }else{
                                    let oneStoryBoard:UIStoryboard = UIStoryboard(name: "Finance", bundle: NSBundle.mainBundle())
                                    let ppVC:PayPasswordViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("PayPasswordVC") as! PayPasswordViewController
                                    ppVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
                                    self.presentViewController(ppVC, animated: true, completion: { () -> Void in
                                        self.parm["mm"] = userDefaultsUtil.getMobile()!
                                        let buy = userDefaultsUtil.enTxt(self.preBuyTextField.text!)
                                        self.parm["buy_copies"] = buy
                                        self.parm["device"] = "0"
                                        ppVC.parm = self.parm
                                    })
                                }
                            }
                        }
                    }
                })
            }else{
                KGXToast.showToastWithMessage("预投金额格式不正确", duration: ToastDisplayDuration.LengthShort)
                loadingHidden()
            }
        }else{
            KGXToast.showToastWithMessage("请输入预投金额", duration: ToastDisplayDuration.LengthShort)
            loadingHidden()
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
