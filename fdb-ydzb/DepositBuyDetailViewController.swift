//
//  DepositBuyDetailViewController.swift
//  ydzbapp-hybrid
//  定存购买详细页
//  Created by qinxin on 15/9/1.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

struct REDPACKET {
    static let Notification = "红包广播"
    static let Name = "红包名字"
    static let RedId = "红包Id"
    static let RedApr = "红包利率"
}

class DepositBuyDetailViewController: BaseViewController {
    
    //MARK: - Outlet
    
    @IBOutlet weak var useableFundLabel: UILabel!           //账户余额
    @IBOutlet weak var deadLineLabel: UILabel!              //锁定期
    @IBOutlet weak var surplusLabel: UILabel!               //可购份数
    @IBOutlet weak var buyCopiesTextField: UITextField! {   //购买份数
        didSet {
            buyCopiesTextField.delegate = self
        }
    }
    @IBOutlet weak var investSwitch: UISwitch!              //是否复投
    @IBOutlet weak var refoundSwitch: UISwitch!
    @IBOutlet weak var redpacketLabel: UILabel!             //红包提示文字
    @IBOutlet weak var rightImageView: UIImageView!         //红包提示图片
    @IBOutlet weak var redpacketView: UIView! {             //选择红包
        didSet {
            redpacketView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "selectRedpacketAction"))
        }
    }
    @IBOutlet weak var payFundLabel: UILabel!               //支付金额
    @IBOutlet weak var expectEarningsLabel: UILabel!        //预期收益
    @IBOutlet weak var buyButton: UIButton! {
        didSet {
            buyButton.layer.cornerRadius = 10.0
        }
    }
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "resignTextField"))
        }
    }
    @IBOutlet weak var rechargeButton: UIButton! {
        didSet {
            rechargeButton.layer.cornerRadius = 5.0
        }
    }
    @IBOutlet weak var serviceContract: UIView! {
        didSet {
            serviceContract.userInteractionEnabled = true
            serviceContract.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "serviceAction"))
        }
    }
    
    
    
    //MARK: - Other
    
    let ydFinancingService = YdFinancingService.getInstance()
    var depositBuyModel = DepositBuyModel()
    var productId: String = ""
    var redId: String = ""
    var redApr: Double = 0.00
    var days: Double = 0.00
    var vipApr: Double = 0.00
    var redpacketName: String = ""
    
    
    //MARK: - Life view Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let center = NSNotificationCenter.defaultCenter()
        center.removeObserver(self)
    }
    
    
    //MARK: - Private Methods
    
    private func initView() {
        initNav("定存宝购买")
        
        //添加监听广播
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        center.addObserverForName(REDPACKET.Notification, object: nil, queue: queue) { notification -> Void in
            if let name = notification.userInfo?[REDPACKET.Name] as? String {
                if name != "" {
                    self.redpacketLabel.text = name
                }
            }
            if let red = notification.userInfo?[REDPACKET.RedId] as? String {
                if red != "" {
                    self.redId = red
                }
            }
            if let apr = notification.userInfo?[REDPACKET.RedApr] as? String {
                if apr != "" {
                    self.redApr = (apr as NSString).doubleValue
                    self.calculate(self.buyString)
                }
            }
        }
    }
    
    private func loadData(){
        loadingShow()
        self.ydFinancingService.depositBuy([ "mm" : userDefaultsUtil.getMobile()!,"product_id" : self.productId,"redpacket_id":self.redId],calback: {
            (data) -> () in
            self.depositBuyModel = data as! DepositBuyModel
            self.useableFundLabel.text = "¥ \(self.depositBuyModel.usableFund)"
            self.deadLineLabel.text = self.depositBuyModel.deadline
            self.surplusLabel.text = "¥ \(self.depositBuyModel.remainingCopies)"
            if self.depositBuyModel.msg != "" {
                self.redpacketLabel.text = self.depositBuyModel.msg
                self.rightImageView.hidden = true
                self.redpacketView.userInteractionEnabled = false
            }
            if self.redpacketName != "" {
                self.redpacketLabel.text = self.redpacketName
            }
            self.days = (self.depositBuyModel.days as NSString).doubleValue
            self.vipApr = (self.depositBuyModel.vipApr as NSString).doubleValue
            self.redApr = (self.depositBuyModel.redpacketApr as NSString).doubleValue
            self.loadingHidden()
        })
    }
    
    private func calculate(buy: String){
        if buy == "" {
            self.payFundLabel.text = "¥ 0.00"
            self.expectEarningsLabel.text = "¥ 0.00"
        }else{
            self.payFundLabel.text = "¥ \(buy)"
        }
        
        //购买份数
        let caps = (buy as NSString).doubleValue
        //定存利率+红包利率+vip利率
        let apr = (self.depositBuyModel.productApr as NSString).doubleValue + redApr + vipApr
        
        if days == 365 {
            let num = caps * apr / 100.00
            expectEarningsLabel.text = "¥" + (NSString(format: "%.02f", floor(num * 100) / 100) as String)
        }else{
            let num = caps * apr * days / 360.00 / 100.00
            //print("num:\(num)")
            expectEarningsLabel.text = "¥" + (NSString(format: "%.02f", floor(num * 100) / 100) as String)
        }
    }
    
    
    //MARK: - Action
    
    func resignTextField() {
        buyCopiesTextField.resignFirstResponder()
    }
    
    func selectRedpacketAction() {
        let brtvc:BuyRedpacketTableViewController = storyboard?.instantiateViewControllerWithIdentifier("BuyRedpacketTVC") as! BuyRedpacketTableViewController
        brtvc.redId = redId
        brtvc.redpacketList = depositBuyModel.redpacketList
        self.navigationController?.pushViewController(brtvc, animated: true)
    }
    
    @IBAction func buyAction(sender: UIButton) {
        closeKeyBoard()
        loadingShow()
        self.ydFinancingService.checkIdCard { (data) -> () in
            let msg = data as! MsgModel
            if msg.status == 1 {
                if self.buyCopiesTextField.text != "" {
                    if let buy = Int(self.buyCopiesTextField.text!) {
                        if buy == 0 {
                            KGXToast.showToastWithMessage("购买金额不能为0", duration: ToastDisplayDuration.LengthShort)
                            return
                        }
                    }
                    if RegexUtil("^[0-9]{1}[\\d]*$").test(self.buyCopiesTextField.text!) {
                        var parm:[String : AnyObject] = [:]
                        parm["mm"] = userDefaultsUtil.getMobile()!
                        parm["product_id"] = self.productId
                        let buy = userDefaultsUtil.enTxt(self.buyCopiesTextField.text!)
                        parm["buy_copies"] = buy
                        parm["device"] = "0"
                        if self.redId != "" {
                            parm["redpacket_id"] = self.redId
                        }
                        if self.investSwitch.on {
                            parm["expire_mode"] = "1"
                        }else{
                            parm["expire_mode"] = "0"
                        }
                        //                if self.refoundSwitch.on {
                        //                    parm["income_mode"] = "1"
                        //                }else{
                        //                    parm["income_mode"] = "0"
                        //                }
                        self.ydFinancingService.depositBuyPost(parm, calback: {
                            msg in
                            self.loadingHidden()
                            let model = msg as! MsgModel
                            if model.status == 1 {
                                self.navigationController?.popViewControllerAnimated(true)
                            }
                            KGXToast.showToastWithMessage(model.msg, duration: ToastDisplayDuration.LengthShort)
                        })
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
    
    func serviceAction() {
        let customAllowedSet =  NSCharacterSet(charactersInString:"=\"#%/<>?@\\^`{|}").invertedSet
        let escapedStr = B.SERVICE_CONTRACT_2M.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
        let url = NSURL(string:B.SERVICE_CONTRACT_BASE + escapedStr!)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    
    //MARK: - UITextFieldDelegate
    
    override func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    var buyString: String = ""
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if range.location > 7 {// NSRange: location:增加元素时 ＋1
            return false
        }else{
            
            if string != ""{
                buyString = buyString.stringByAppendingString(string)
            }else{
                let string = buyString as NSString
                buyString = string.substringToIndex(range.location)
            }
            
            calculate(buyString)
            
            return true
        }
    }
    
}
