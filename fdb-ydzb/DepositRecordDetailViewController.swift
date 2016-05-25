//
//  DepositRecordDetailViewController.swift
//  ydzbapp-hybrid
//  定存宝已购详情
//  Created by qinxin on 15/8/31.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class DepositRecordDetailViewController: BaseViewController {
    
    @IBOutlet weak var isModelSwitch: UISwitch!                 //本金复投
    @IBOutlet weak var expireTimeLabel: UILabel!                //到期时间
    @IBOutlet weak var buyTimeLabel: UILabel!                   //购买时间
    @IBOutlet weak var predictIncomeLabel: UILabel!             //预期收益
    @IBOutlet weak var productIncomeLabel: UILabel!             //产品收益
    @IBOutlet weak var buyFundLabel: UILabel!                   //投资金额
    @IBOutlet weak var productNameLabel: UILabel!               //产品名称
    @IBOutlet weak var aprLabel: UILabel!                       //收益率文字
    @IBOutlet weak var grandAprLabel: UILabel!                  //红包加息
    @IBOutlet weak var vipAprLabel: UILabel!                    //vip加息
    
    @IBOutlet weak var aprView: UIView!                         //收益率view
    @IBOutlet weak var grandView: UIView!                       //红包利率view
    @IBOutlet weak var vipView: UIView!                         //vip利率View
    @IBOutlet weak var expectView: UIView!                      //预期收益view
    
    @IBOutlet weak var aprValLabel: UILabel!                    //收益率
    @IBOutlet weak var detailButton: UIButton! {                //详情按钮
        didSet {
            detailButton.layer.cornerRadius = 5.0
        }
    }
    @IBOutlet weak var transferButton: UIButton! {              //债权转让按钮
        didSet {
            transferButton.layer.cornerRadius = 10.0
        }
    }
    @IBOutlet weak var transferServiceLabel: UILabel! {         //债权协议
        didSet {
            transferServiceLabel.userInteractionEnabled = true
            transferServiceLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "serviceAction"))
        }
    }
    @IBOutlet weak var transferRuleLabel: UILabel! {            //债权规则
        didSet {
            transferRuleLabel.userInteractionEnabled = true
            transferRuleLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "ruleAction"))
        }
    }
    
    
    
    let service = YdFinancingService()
    
    var dbpm = DepositBuyProductsModel()
    var productId: String = ""
    var transCountId: String = ""
    var parm:[String : AnyObject] = [:]
    
    
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
        initNav("定存宝")
        //修改收益率文字
        if transCountId == "0" {
            aprLabel.text = "年化收益率"
        }else if transCountId == "1" {
            aprLabel.text = "折合收益率"
        }
    }
    
    private func loadData() {
        loadingShow()
        service.depositBuyProductDetail(productId, calback: { (data) -> () in
            self.dbpm = data as! DepositBuyProductsModel
            
            if self.dbpm.isMode == "1" {
                self.isModelSwitch.on = true
            }else{
                self.isModelSwitch.on = false
            }
            
            self.expireTimeLabel.text = self.dbpm.expireTime
            self.buyTimeLabel.text = self.dbpm.buyTime
            self.predictIncomeLabel.text = "¥ \(self.dbpm.predictIncome)"
            self.buyFundLabel.text = "¥ \(self.dbpm.buyFund)"
            self.productNameLabel.text = self.dbpm.productName
            self.productIncomeLabel.text = "¥ \(self.dbpm.interest_fund)"
            //收益率self.dbpm.apr
            self.aprValLabel.text = "\(NSString(format: "%.02f", (self.dbpm.apr as NSString).floatValue))%"
            //是否隐藏红包和vip利率VIEW
            self.hideView((self.dbpm.grandApr as NSString).floatValue, vipApr: (self.dbpm.vipApr as NSString).floatValue)
            //修改按钮文字
            if self.dbpm.status == "0" && self.dbpm.redpacket == "1" && self.self.transCountId != "1" {
                self.transferButton.setTitle("债权转让", forState: UIControlState.Normal)
            }else if self.dbpm.status == "2" {
                self.transferButton.setTitle("取消转让", forState: UIControlState.Normal)
            }else{
                self.transferButton.setTitle("不可转让", forState: UIControlState.Normal)
                self.transferButton.setTitleColor(B.BUY_DISABLE_BUTTON_BG, forState: UIControlState.Normal)
                self.transferButton.backgroundColor = UIColor(red: 194/255, green: 194/255, blue: 194/255, alpha: 1)
            }
            
            self.loadingHidden()
        })
    }
    
    //根据变量值隐藏view
    func hideView(grandApr:Float, vipApr:Float) {
        if grandApr == 0 && vipApr == 0 {
            grandView.hidden = true
            vipView.hidden = true
            constrain(aprView, expectView){
                //隐藏红包加息，VIP加息
                aprView, expectView in
                expectView.top == aprView.bottom + 1
            }
            
            //self.expectView.top == aprView.bottom
        }else if grandApr == 0 && vipApr != 0 {
            //隐藏红包加息，显示VIP加息
            grandView.hidden = true
            constrain(aprView, vipView){
                aprView, vipView in
                vipView.top == aprView.bottom + 1
            }
            self.vipAprLabel.text = "\(NSString(format: "%.02f", vipApr))%"
        }else if grandApr != 0 && vipApr == 0 {
            //隐藏VIP加息，显示红包加息
            vipView.hidden = true
            constrain(grandView, expectView){
                grandView, expectView in
                expectView.top == grandView.bottom + 1
            }
            grandAprLabel.text = "\(NSString(format: "%.02f", grandApr))%"
        }else{
            grandAprLabel.text = "\(NSString(format: "%.02f", grandApr))%"
            vipAprLabel.text = "\(NSString(format: "%.02f", vipApr))%"
        }
    }
    
    
    //MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DepositDetail_List" {
            let dpidtvc: DepositeIncomeDetailTableViewController = segue.destinationViewController as! DepositeIncomeDetailTableViewController
            dpidtvc.productId = productId
        }else if segue.identifier == "Transfer_Detail" {
            let ddtvc: DepositDetailTransferViewController = segue.destinationViewController as! DepositDetailTransferViewController
            ddtvc.model = dbpm
            ddtvc.parm = parm
            ddtvc.productId = productId
        }
    }
    
    
    //MARK: - Action
    //本金
    @IBAction func switchAction(sender: UISwitch) {
        loadingShow()
        if isModelSwitch.on == true {
            service.depositBuyProductExpireMode(["mm":userDefaultsUtil.getMobile()!,"id":productId,"expire_mode":"1"], calback: { (data) -> () in
                self.loadingHidden()
                KGXToast.showToastWithMessage("\(data)", duration: ToastDisplayDuration.LengthShort)
            })
        }else{
            service.depositBuyProductExpireMode(["mm":userDefaultsUtil.getMobile()!,"id":productId,"expire_mode":"0"], calback: { (data) -> () in
                self.loadingHidden()
                KGXToast.showToastWithMessage("\(data)", duration: ToastDisplayDuration.LengthShort)
            })
        }
    }
    
    //利息
    //    @IBAction func refoundAction(sender: UISwitch) {
    //        if refoundSwitch.on == true {
    //            service.depositBuyProductIncomeMode(["mm":userDefaultsUtil.getMobile()!,"id":productId,"income_mode":"1"], calback: { (data) -> () in
    //                self.loadingHidden()
    //                KGXToast.showToastWithMessage("\(data)", duration: ToastDisplayDuration.LengthShort)
    //            })
    //        }else{
    //            service.depositBuyProductIncomeMode(["mm":userDefaultsUtil.getMobile()!,"id":productId,"income_mode":"0"], calback: { (data) -> () in
    //                self.loadingHidden()
    //                KGXToast.showToastWithMessage("\(data)", duration: ToastDisplayDuration.LengthShort)
    //            })
    //        }
    //    }
    
    @IBAction func transferAction(sender: UIButton) {
        if dbpm.status == "2" || dbpm.status == "0" {
            if self.dbpm.redpacket == "0" {
                KGXToast.showToastWithMessage("不可转让，该产品已使用红包", duration: ToastDisplayDuration.LengthShort)
                return
            }else if transCountId == "1" {
                KGXToast.showToastWithMessage("不可转让，定存宝产品只可转让一次", duration: ToastDisplayDuration.LengthShort)
                return
            }else{
                self.performSegueWithIdentifier("Transfer_Detail", sender: self)
            }
        }
        
    }
}
