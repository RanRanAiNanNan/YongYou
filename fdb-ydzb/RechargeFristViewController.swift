//
//  RechargeViewController.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/9/2.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit

class RechargeFristViewController: BaseTableViewController, UITextFieldDelegate, SelectBankIdDelegate, SubmitStatusDelegate {
    
    @IBOutlet weak var realNamCell: UITableViewCell!        //姓名
    @IBOutlet weak var cardIdCell: UITableViewCell!         //身份证号
    
    @IBOutlet weak var telCell: UITableViewCell!            //电话号码
    @IBOutlet weak var authCode: UITableViewCell!           //验证码
    
    
    @IBOutlet weak var bankNameLab: UILabel!                //银行名
    @IBOutlet weak var cardNoLab: UILabel!                  //卡号
    @IBOutlet weak var addBankLab: UILabel!                 //添加银行卡
    
    @IBOutlet weak var moneyTf: UITextField!                //充值金额
    @IBOutlet weak var cardIdTf: UITextField!               //身份证号
    @IBOutlet weak var realNameTf: UITextField!             //姓名
    @IBOutlet weak var telTf: UITextField!                  //电话号码
    @IBOutlet weak var authCodeTf: UITextField!             //验证码
    @IBOutlet weak var authBtn: UIButton!                   //获取验证码按钮
    
    @IBOutlet weak var rechargeTotalLab: UILabel!           //充值总额
    @IBOutlet weak var rechargeQuotaLab: UILabel!           //可充值金额
    
    var rfm = RechargeFirstModel()                          //充值对象
    
    var val = [1, 1, 1, 1, 0, 0]                            //5个值代表tableview四个分组，值为每个分组显示的行数。默认三四分组为隐藏
    
    let assestService = AssestService.getInstance()
    
    var bankId = ""                                         //银行ID
    var leftTime = 60                                       //获取延迟时间
    var timer:NSTimer!                                      //获取验证码定时器
    var payPassword = ""                                    //交易密码
    var subBtn:UIButton!                                    //提交按钮
    var rechargeTotal:Float = 0.0                           //可充值金额
    var customView:JCAlertView!
    var vip = false                                         //是否是vip
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        addHelpCenter("")

    }
    

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    func loadData(){
        self.loadingShow()
        //第一次从资产进入不用bank_id参数，选择银行卡后须加入
        var params = [String:String]()
        params["mm"] = userDefaultsUtil.getMobile()!
        if !bankId.isEmpty {
           params["bank_id"] = bankId
        }
        assestService.rechargeGet(params,calback:
            {
                data in
                self.loadingHidden()
                if let rfm = data as? RechargeFirstModel {
                    self.rfm = rfm
                    self.initText()
                    self.rechargeTotalLab.text = rfm.rechargeTotal
                    self.rechargeQuotaLab.text = "￥\(rfm.rechargeQuotaShow)"
                    //根据加载的充值数据重新判断是否显示可充值金额(-1为VIP用户)
                    if rfm.rechargeQuota == "v" {
                        self.val[2] = 0
                        self.vip = true
                    }else{
                        self.val[2] = 1
                        self.rechargeTotal = (rfm.rechargeQuota as NSString).floatValue
                        self.vip = false
                    }
                    //self.rechargeTotalLab.text = "0.00"
                    self.tableView.reloadData()
                    
                }
            }
        )
    }
    
    func initText(){

        //设置数据，数组长度为4，表示四个分组，值为每个分组应显示的行数
        if rfm.hideCheck {
            val[4] = 0
        }else{
            val[4] = 2
        }
        if rfm.hideRecharge {
            val[5] = 0
        }else{
            val[5] = 2
        }
        
        //根据流水号有无，判断第一行显示添加银行卡还是显示默认银行卡
        if rfm.order.isEmpty {
            addBankLab.text = "添加银行卡"
            bankNameLab.text = ""
            cardNoLab.text = ""
            val[4] = 0
            val[5] = 0
        }else{
            addBankLab.text = ""
            bankNameLab.text = rfm.bankName
            cardNoLab.text = rfm.cardNo
        }
        
    }
    
    func initView(){
        self.initNav("充值")
        addFoot()
        authBtn.layer.cornerRadius = 5
        moneyTf.delegate = self
        cardIdTf.delegate = self
        realNameTf.delegate = self
        telTf.delegate = self
        authCodeTf.delegate = self
        //设置触摸背景颜色
        authBtn.setBackgroundImage(createImageWithColor(), forState: UIControlState.Highlighted)
        showVip()
    }
    
    //如果是vip显示可充值列
    func showVip(){
        let vip = userDefaultsUtil.getVip()
        //print("vip:\(vip)")
        if Int(vip) > 0 {
            val[2] = 0
        }else{
            val[2] = 1
        }
        self.tableView.reloadData()
    }

    
    func addFoot(){
        let footView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 60))
        self.subBtn = UIButton(frame: CGRectMake(15, 15, UIScreen.mainScreen().bounds.width - 30, 40))
        subBtn.setTitle("确认充值", forState: UIControlState.Normal)
        subBtn.addTapAction("subClick", target: self)
        subBtn.backgroundColor = B.BTN_NO_SELECTED
        subBtn.layer.cornerRadius = 5
        //设置触摸背景颜色
        subBtn.setBackgroundImage(createImageWithColor(), forState: UIControlState.Highlighted)
        footView.addSubview(subBtn)
        self.tableView.tableFooterView = footView
    }
    
    //充值提交事件
    func subClick(){
        closeKeyBoard()
        if checkBankCard(){return}
        if checkMoney(){return}
        if checkRechargeTotal(){return}
        var params = [String:String]()
        params["mm"] = userDefaultsUtil.getMobile()
        params["money"] = userDefaultsUtil.enTxt(moneyTf.text!)
        params["token"] = rfm.token
        params["bank_code"] = rfm.bankCode
        
        //println("交易流水号:\(rfm.order)")
        params["bank_id"] = rfm.bankId
        params["order"] = rfm.order
        
        
        if !rfm.hideCheck {
            if checkRealName() {return}
            if checkCardId(){return}
            params["real_name"] = realNameTf.text
            params["id_card"] = cardIdTf.text
        }
        
        if !rfm.hideRecharge {
            if checkMobile(){return}
            if checkAuthCodeData(){return}
            if checkAuthCode(){return}
            params["code"] = authCodeTf.text
            params["mobile"] = telTf.text
//            for (key, value) in params {
//                println(":::\(key)=\(value)")
//            }
            subBtn.enabled = false
            assestService.rechargePost(params, calback: {
                data in
                self.loadingHidden()
                self.subBtn.enabled = true
                if let mm = data as? MsgModel {
                    if !mm.msg.isEmpty {
                        KGXToast.showToastWithMessage(mm.msg, duration: ToastDisplayDuration.LengthShort)
                    }
                    if mm.status == 1 {
                        self.navigationController?.popViewControllerAnimated(true)
                    }else{
                        self.getSubmitStatus(0)
                    }
                }
                
            })
            
        }else{
            //if checkAuthCodeData(){return}
            //params["pay_password"] = payPassword
            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "Finance", bundle: NSBundle.mainBundle())
            let ppVC:PayPasswordViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("PayPasswordVC") as! PayPasswordViewController
            
            ppVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            self.presentViewController(ppVC, animated: true, completion: { () -> Void in
                ppVC.parm = params
                ppVC.delegate = self
            })
        }
    }
    
    
    //每个分组间距高度，隐藏的分组为0
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //第一行header为0
        if section == 0 {
            return 0
        }
        if val[section] == 0 {
            return 0
        }else if val[2] == 1 && section == 3{
          return 0
        }else{
            return 10
        }
    }
    
    //返回每个分组的行数，用于隐藏行
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return val[section]
    }
    
    
    //收起键盘
    func touchUpInsideKeyBoard() {
        self.moneyTf.resignFirstResponder()
        self.cardIdTf.resignFirstResponder()
        self.realNameTf.resignFirstResponder()
        self.telTf.resignFirstResponder()
        self.authCodeTf.resignFirstResponder()
    }
    
    //跳转到选择银行界面
    func toSelectBank(){
        //如果流水号为空到添加银行卡页面，否则到选择银行卡界面
        if rfm.order.isEmpty {
            gotoPage("SafetyCenter", pageName: "addBankCardCtrl")
        }else{
            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "Assest", bundle: NSBundle.mainBundle())
            let bcstc:BankCardSelectTableViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("selectBankCardCtrl") as! BankCardSelectTableViewController
            bcstc.delegate = self
            self.navigationController?.pushViewController(bcstc, animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        touchUpInsideKeyBoard()
        //tableview第一个分组的第一行
        if indexPath.section == 0 && indexPath.row == 0 {
            //toSelectBank()
            if (rechargeTotalLab.text! as NSString).doubleValue > 0  {
                self.performSegueWithIdentifier("rechargeRecordSegue", sender: nil)
            }
            
        }
        if indexPath.section == 1 && indexPath.row == 0 {
            toSelectBank()
        }
    }
    
    //获取验证码事件
    @IBAction func authCodeClick(sender: AnyObject) {
        closeKeyBoard()
        if checkMoney(){return}
        var params = [String:String]()
        params["mm"] = userDefaultsUtil.getMobile()
        params["money"] = userDefaultsUtil.enTxt(moneyTf.text!)
        //println("交易流水号:\(rfm.order)")
        params["bank_id"] = rfm.bankId
        params["order"] = rfm.order
        
        if !rfm.hideCheck {
            if checkRealName() {return}
            if checkCardId(){return}
            params["real_name"] = realNameTf.text
            params["id_card"] = cardIdTf.text
        }
        
        if !rfm.hideRecharge {
            if checkMobile(){return}
            //if checkAuthCode(){return}
            //params["code"] = authCodeTf.text
            params["mobile"] = telTf.text
        }
        
        authBtn.enabled = false
        authBtn.backgroundColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
        authBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.loadingShow()
        assestService.getAuthCode(params, calback: {
            data in
            self.loadingHidden()
            if let authRfm = data as? RechargeFirstModel {
                self.rfm.token = authRfm.token
                self.rfm.bankCode = authRfm.bankCode
                KGXToast.showToastWithMessage("验证码发送成功!", duration: ToastDisplayDuration.LengthShort)
                self.timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(1), target: self, selector: Selector("tickDown"), userInfo: nil, repeats: true)
            }else{
                self.getSubmitStatus(0)
                self.authBtn.enabled = true
                self.authBtn.backgroundColor = B.BTN_GOLDEN_COLOR
                self.authBtn.setTitle("获取验证码", forState: UIControlState.Normal)
            }
        })
    }
    
    //密码状态回调方法
    func getSubmitStatus(status:Int){
        //println("----密码状态回调方法:\(status)-----")
        if status == 0 {
            var params = [String:String]()
            params["mm"] = userDefaultsUtil.getMobile()
            params["bank_id"] = rfm.bankId
            assestService.getOrder(params, calback: {
                data in
                self.loadingHidden()
                self.subBtn.enabled = true
                if let mm = data as? MsgModel {
                    if mm.status == 1 {
                        //println("old:\(self.rfm.order) new:\(mm.msg)")
                        self.rfm.order = mm.msg
                    }else{
                        //KGXToast.showToastWithMessage("获取充值数据出错!", duration: ToastDisplayDuration.LengthShort)
                    }
                }
            })
        }else{
            self.subBtn.enabled = true
        }
    }
    
    //弹出可充值金额说明
    @IBAction func infoShow(sender: AnyObject) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 265, height: 200))
        view.backgroundColor = UIColor.whiteColor()
        view.layer.cornerRadius = 5
        //JCAlertView.showOneButtonWithTitle("", message: msg, buttonType: JCAlertViewButtonType.Gold, buttonTitle: "知道了", click: nil)
        customView = JCAlertView(customView: view, dismissWhenTouchedBackground: true)
        let textLab = UILabel(frame: CGRect(x: 8, y: 20, width: 240, height: 20))
        textLab.text = "【充值限额为】"
        textLab.textColor = UIColor(red: 67/255, green: 83/255, blue: 103/255, alpha: 1)
        textLab.font = UIFont(name: "Arial", size: 14)
        customView.addSubview(textLab)
        
        let textLab1 = UILabel(frame: CGRect(x: 15, y: 40, width: 240, height: 20))
        textLab1.textColor = UIColor(red: 67/255, green: 83/255, blue: 103/255, alpha: 1)
        textLab1.font = UIFont(name: "Arial", size: 14)
        textLab1.text = "活期宝限额-可用余额-活期宝在投金额"
        customView.addSubview(textLab1)
        
        let textLab2 = UILabel(frame: CGRect(x: 8, y: 80, width: 240, height: 20))
        textLab2.textColor = UIColor(red: 67/255, green: 83/255, blue: 103/255, alpha: 1)
        textLab2.font = UIFont(name: "Arial", size: 14)
        textLab2.text = "【提示】"
        customView.addSubview(textLab2)
        
        let textLab3 = UILabel(frame: CGRect(x: 15, y: 100, width: 240, height: 40))
        textLab3.textColor = UIColor(red: 67/255, green: 83/255, blue: 103/255, alpha: 1)
        textLab3.font = UIFont(name: "Arial", size: 14)
        textLab3.text = "活期宝份额投满的用户，可先将活期宝赎回后购买定存宝，然后充值。"
        textLab3.numberOfLines = 2
        textLab3.lineBreakMode = NSLineBreakMode.ByCharWrapping
        customView.addSubview(textLab3)
        
        let button = UIButton(frame: CGRect(x: 10, y: 150, width: 245, height: 30))
        button.setTitle("知道了", forState: UIControlState.Normal)
        button.backgroundColor = B.NAV_TITLE_CORLOR
        button.titleLabel?.font = UIFont(name: "Arial", size: 14)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: "closeInfo", forControlEvents: UIControlEvents.TouchUpInside)
        customView.addSubview(button)
        customView.show()
    }
    
    func closeInfo(){
        customView.dismissWithCompletion(nil)
    }

    
    
    
    //按钮显示秒数变化方法
    func tickDown(){
        leftTime -= 1
        authBtn.setTitle("\(leftTime)秒后重发", forState: UIControlState.Normal)
        if leftTime <= 0 {
            timer.invalidate()
            authBtn.enabled = true
            authBtn.backgroundColor = B.BTN_GOLDEN_COLOR
            authBtn.setTitle("获取验证码", forState: UIControlState.Normal)
            leftTime = 60
        }
        
    }
    
    func checkAuthCodeData() -> Bool {
        //println("rfm.token:\(rfm.token) == rfm.bankCode:\(rfm.bankCode)")
        if !rfm.token.isEmpty && !rfm.bankCode.isEmpty {
            return false
        }else{
            KGXToast.showToastWithMessage("请获取验证码", duration: ToastDisplayDuration.LengthShort)
            return true
        }
    }
    //验证是否绑定银行卡
    func checkRechargeTotal() -> Bool {
        //为VIP用户不验证可充值额
        if self.vip {
            return false
        }
        let userMoney = (self.moneyTf.text! as NSString).floatValue
        if self.rechargeTotal - userMoney >= 0 {
            return false
        }else{
            KGXToast.showToastWithMessage("充值金额超出充值限额", duration: ToastDisplayDuration.LengthShort)
            return true
        }
    }
    
    //验证是否绑定银行卡
    func checkBankCard() ->Bool {
        if !rfm.order.isEmpty {
            return false
        }else{
            KGXToast.showToastWithMessage("请绑定银行卡", duration: ToastDisplayDuration.LengthShort)
            return true
        }
    }
    
    //验证手机号是否为空
    func checkMobileEmpty() ->Bool {
        closeKeyBoard()
        let mobile = telTf.text!
        if !mobile.isEmpty {
            return false
        }else{
            KGXToast.showToastWithMessage("请输入手机号码", duration: ToastDisplayDuration.LengthShort)
            return true
        }
    }
    
    
    //验证手机号是否未通过
    func checkMobile() ->Bool {
        closeKeyBoard()
        let mobile = telTf.text!
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
    
    //验证验证码是否末通过
    func checkAuthCode() ->Bool{
        closeKeyBoard()
        if authCodeTf.text!.isEmpty {
            KGXToast.showToastWithMessage("请输入验证码", duration: ToastDisplayDuration.LengthShort)
            return true
        }
        if RegexUtil("^\\d{6}$").test(authCodeTf.text!)  {
            return false
        }else{
            KGXToast.showToastWithMessage("验证码格式不正确", duration: ToastDisplayDuration.LengthShort)
            return true
        }
    }
    //验证身份证是否末通过
    func checkCardId() -> Bool {
        closeKeyBoard()
        if cardIdTf.text!.characters.count >= 15 && cardIdTf.text!.characters.count <= 18 {
            return false
        }else{
            KGXToast.showToastWithMessage("身份证格式不正确", duration: ToastDisplayDuration.LengthShort)
            return true
        }
    }
    //验证姓名是否末通过
    func checkRealName() -> Bool {
        closeKeyBoard()
        if !realNameTf.text!.isEmpty {
            return false
        }else{
            KGXToast.showToastWithMessage("请输入姓名", duration: ToastDisplayDuration.LengthShort)
            return true
        }
    }
    
    
    //验证金额
    func checkMoney() -> Bool {
        closeKeyBoard()
        if !moneyTf.text!.isEmpty {
            return false
        }else{
            KGXToast.showToastWithMessage("请输入充值金额", duration: ToastDisplayDuration.LengthShort)
            return true
        }
    }
    
    //选择银行卡页面的回调方法
    func setSelectBankId(bankId: String) {
//        println("bankId:\(bankId)")
        self.bankId = bankId
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
}