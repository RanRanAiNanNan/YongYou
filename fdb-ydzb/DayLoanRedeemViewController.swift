//
//  DayLoanRedeemViewController.swift
//  ydzbapp-hybrid
//  活期宝赎回
//  Created by 刘驰 on 15/3/7.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit


class DayLoanRedeemViewController: BaseViewController {
    
    //可赎回份数
    @IBOutlet weak var usableRedeemNumLab: UILabel!
    //赎回份数
    @IBOutlet weak var redeemNumTf: UITextField!
    //交易密码
    //    @IBOutlet weak var pwdTf: UITextField!
    //赎回按钮
    @IBOutlet weak var redeemBtn: UIButton!
    
    //    @IBOutlet weak var pwdView: UIView!
    
    
    let ydFinancingService = YdFinancingService.getInstance()
    //天标赎回模型
    var dayLoanRedeemModel:DayLoanRedeemModel!
    
    var parm:[String : AnyObject] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }
    
    func initView(){
        initNav("活期宝赎回")
        
        self.redeemNumTf.delegate = self
        //        self.pwdTf.delegate = self
        
        //redeemBtn.layer.borderWidth = 1
        redeemBtn.layer.cornerRadius = 5
        //redeemBtn.layer.borderColor = B.WORD_COLOR.CGColor
    }
    
    func loadData(){
        loadingShow()
        ydFinancingService.dayLoanRedeemData({
            (data) -> () in
            if let _ = data as? DayLoanRedeemModel {
                self.dayLoanRedeemModel = data as! DayLoanRedeemModel
                self.usableRedeemNumLab.text = "¥ \(self.dayLoanRedeemModel.dayloanData)"
                if self.dayLoanRedeemModel.pwdStatus == 0 {
                    //跳转到安全中心
                    //self.pwdView.hidden = true
                }
            }
            self.loadingHidden()
        })
    }
    
    @IBAction func touchUpInsideAction(sender: AnyObject) {
        redeemNumTf.resignFirstResponder()
        //        pwdTf.resignFirstResponder()
    }
    
    //赎回提交
    @IBAction func redeemClick(sender: AnyObject) {
        closeKeyBoard()
        if redeemNumTf.text != "" {
            if RegexUtil("^(?!0+(?:\\.0+)?$)(?:[1-9]\\d*|0)(?:\\.\\d{1,2})?$").test(redeemNumTf.text!) {
                let red = (self.dayLoanRedeemModel.dayloan_money as NSString).doubleValue
                if red >= (self.redeemNumTf.text! as NSString).doubleValue {
                    ydFinancingService.dayLoanRedeemData({
                        (data) -> () in
                        if let _ = data as? DayLoanRedeemModel {
                            self.dayLoanRedeemModel = data as! DayLoanRedeemModel
                            self.parm["mm"] = userDefaultsUtil.getMobile()!
                            let buy = userDefaultsUtil.enTxt(self.redeemNumTf.text!)
                            self.parm["redemption_fund"] = buy
                            self.parm["pay_password"] = self.dayLoanRedeemModel.productId
                            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "Finance", bundle: NSBundle.mainBundle())
                            let ppVC:PayPasswordViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("PayPasswordVC") as! PayPasswordViewController
                            ppVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
                            self.presentViewController(ppVC, animated: true, completion: { () -> Void in
                                ppVC.parm = self.parm
                            })
                        }
                    })
                }else{
                    KGXToast.showToastWithMessage("赎回金额不能超过可赎回金额", duration: ToastDisplayDuration.LengthShort)
                }
            }else{
                KGXToast.showToastWithMessage("赎回金额格式不正确", duration: ToastDisplayDuration.LengthShort)
            }
        }else{
            KGXToast.showToastWithMessage("请输入赎回金额", duration: ToastDisplayDuration.LengthShort)
        }
        
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
}