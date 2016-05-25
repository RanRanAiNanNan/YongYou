//  添加银行卡ctrl，页面在安全中心故事版
//  BankCardAddTableViewController.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/9/5.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit

class BankCardAddTableViewController: BaseTableViewController,UITextFieldDelegate {
    
    var assestService = AssestService.getInstance()
    
    @IBOutlet weak var bankNameLab: UILabel!                //银行名称
    @IBOutlet weak var cardNoTf: UITextField!   {           //银行卡号
        didSet {
            cardNoTf.delegate = self
        }
    }
    @IBOutlet weak var reCardNoTf: UITextField!  {          //重复银行卡号
        didSet {
            reCardNoTf.delegate = self
        }
    }
//    @IBOutlet weak var bankProvinceLab: UILabel!            //开户省份
//    @IBOutlet weak var bankCityLab: UILabel!                //开户城市
//    @IBOutlet weak var openBankNameTf: UITextField! {       //开户行名称
//        didSet {
//            openBankNameTf.delegate = self
//        }
//    }
    @IBOutlet weak var realNameTf: UITextField!    {        //开户姓名
        didSet {
            realNameTf.delegate = self
        }
    }
//    @IBOutlet weak var idCardTf: UITextField!      {        //身份证号
//        didSet {
//            idCardTf.delegate = self
//        }
//    }
//    @IBOutlet weak var mobileTf: UITextField!     {         //手机号
//        didSet {
//            mobileTf.delegate = self
//        }
//    }
//    @IBOutlet weak var authCodeTf: UITextField!    {        //验证码
//        didSet {
//            authCodeTf.delegate = self
//        }
//    }
//    @IBOutlet weak var authBtn: UIButton!          {        //验证码按钮
//        didSet {
//            authBtn.layer.cornerRadius = 5
//            //设置触摸背景颜色
//            authBtn.setBackgroundImage(createImageWithColor(), forState: UIControlState.Highlighted)
//        }
//    }
    let myMobileArr :NSMutableArray = NSMutableArray()
    var val = [6, 0, 2]                                     //3个值代表tableview三个分组，值为每个分组显示的行数。默认二分组为隐藏
    var pindex:Int?                                         //省份与城市回调参数
    var bankCard = BandCarModel()                           //银行卡
    var leftTime = 60                                       //获取延迟时间
    var timer:NSTimer!                                      //获取验证码定时器
    var bankList = []                                       //银行名称列表
    var hideList = []                                       //隐藏手机号与验证码的银行列表
    var checkUserInfo = false                               //是否需要验证用户姓名与身份证号
    var checkUserAuth = true                                //是否需要验证用户手机号与验证码
    let selectBlue = UIColor(red: 63/255, green: 82/255, blue: 102/255, alpha: 1)   //回显字体蓝色
    let selectGrey = UIColor(red: 204/255, green: 203/255, blue: 208/255, alpha: 1)   //回显字体蓝色
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //加载初始化视图
        initView()
//        loadData()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    
    func loadData(){
        loadingShow()
        assestService.addBankCardGet({
            data in
            self.loadingHidden()
            if let bcm = data as? BandCarModel {
                self.bankCard = bcm
                //bcm.realName = ""
                //bcm.idCard = ""
                self.bankList = bcm.bankList
                self.hideList = bcm.hideList
                //print("银行列表个数:\(self.bankList.count)")
                if bcm.idCard.isEmpty && bcm.realName.isEmpty {
                    self.val[1] = 2
                    //需要验证用户信息(姓名与身份证号)
                    self.checkUserInfo = true
                }
                
                self.tableView.reloadData()
            }
        })
    }
    
    
    func initView() {
        initNav("添加手机号")
        addHeadView()
        addFootView()
    }
    
    //加入head
    func addHeadView(){
        let screenWidth = UIScreen.mainScreen().bounds.width
        let headView = UIView(frame: CGRectMake(0, 0, screenWidth, 15))
        headView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        self.tableView.tableHeaderView = headView
    }
    
    
//    //获取验证码事件
//    @IBAction func authCodeClick(sender: AnyObject) {
//        closeKeyBoard()
//        var params = [String:String]()
//        params["mm"] = userDefaultsUtil.getMobile()
//        //print("交易流水号:\(bankCard.order)")
//        params["order"] = bankCard.order
//        //是否需要验证用户信息(姓名与身份证号)
//        if checkUserInfo {
//            if checkRealName() {return}
//            params["real_name"] = realNameTf.text
//        }else{
//            params["real_name"] = bankCard.realName
//        }
//        
//        
//        if checkMobile(){return}
//
//        params["mobile"] = mobileTf.text
//
//        
//        authBtn.enabled = false
//        authBtn.backgroundColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
//        authBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
//        self.loadingShow()
//        assestService.bankCardGetAuthCode(params, calback: {
//            data in
//            
//            if let mm = data as? MsgModel {
//                //令牌用于验证用户是否获取验证码
//                self.bankCard.token = mm.msg
//                if mm.status == 1 {
//                    self.loadingHidden()
//                    self.timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(1), target: self, selector: Selector("tickDown"), userInfo: nil, repeats: true)
//                }else{
//                    //重新获取订单号
//                    self.regetOrder()
//                    self.authBtn.enabled = true
//                    self.authBtn.backgroundColor = B.BTN_GOLDEN_COLOR
//                    self.authBtn.setTitle("获取验证码", forState: UIControlState.Normal)
//                }
//            }else{
//                self.regetOrder()
//                self.authBtn.enabled = true
//                self.authBtn.backgroundColor = B.BTN_GOLDEN_COLOR
//                self.authBtn.setTitle("获取验证码", forState: UIControlState.Normal)
//            }
//        })
//    }
    
    //重新获取订单号
    func regetOrder(){
        assestService.bankCardGetOrder({
            data in
            self.loadingHidden()
            if let mm = data as? MsgModel {
                if mm.status == 1 {
                    self.bankCard.order = mm.msg
                }
            }
        })
    }
    
    //添加银行卡事件
    func addBandCardClick(){
        print(cardNoTf.text)
        closeKeyBoard()
        if cardNoTf.text!.isEmpty {
            KGXToast.showToastWithMessage("请输入手机号", duration: ToastDisplayDuration.LengthShort)
            return
        }
        if self.cardNoTf.text!.characters.count < 10 {
            KGXToast.showToastWithMessage("您输入的手机号格式错误", duration: ToastDisplayDuration.LengthShort)
            return
        }
        if self.cardNoTf.text != self.reCardNoTf.text {
            KGXToast.showToastWithMessage("您输入的两次手机号不一致", duration: ToastDisplayDuration.LengthShort)
            return
        }
//        if bankNameLab.text!.isEmpty {
//            KGXToast.showToastWithMessage("请您选择银行", duration: ToastDisplayDuration.LengthShort)
//            return
//        }
//        if bankProvinceLab.text!.isEmpty || bankProvinceLab.text == "请选择开户省份" {
//            KGXToast.showToastWithMessage("请您选择开户省份", duration: ToastDisplayDuration.LengthShort)
//            return
//        }
//        if bankCityLab.text!.isEmpty || bankCityLab.text == "请选择开户城市"{
//            KGXToast.showToastWithMessage("请您选择开户城市", duration: ToastDisplayDuration.LengthShort)
//            return
//        }
//        if isEmpty(openBankNameTf.text!) {
//            KGXToast.showToastWithMessage("请您输入开户行名称", duration: ToastDisplayDuration.LengthShort)
//            return
//        }
        else{
    
            
            let myMobileNumDic :NSMutableDictionary = ["number" : cardNoTf.text! ,"name" : realNameTf.text!]
           
            myMobileArr.addObject(myMobileNumDic)

            NSUserDefaults.standardUserDefaults().setObject(myMobileArr, forKey: "myPhoneNumber")
            print("合法")
            print(myMobileArr)
        }
    }
        //是否需要验证用户姓名与身份证号
//        if checkUserInfo {
//            if checkRealName() {return}
//            if checkCardId(){return}
//        }
        //是否需要验证手机号与验证码
//        if checkUserAuth {
//            //验证手机号
//            if checkMobile(){return}
//            //验证是否获取验证码
//            if self.bankCard.token.isEmpty {
//                KGXToast.showToastWithMessage("请获取验证码", duration: ToastDisplayDuration.LengthShort)
//                return
//            }
//            //验证验证码
//            if checkAuthCode(){return}
//        }
//        loadingShow()
//        var parms = [String:String]()
//        parms["mm"] = userDefaultsUtil.getMobile()!
//        parms["bank_no"] = cardNoTf.text
//        parms["bank_name"] = bankNameLab.text
//        parms["bank_opening"] = openBankNameTf.text
//        parms["bank_province"] = bankProvinceLab.text
//        parms["bank_city"] = bankCityLab.text
//        
//        parms["real_name"] = realNameTf.text
//        parms["id_card"] = idCardTf.text
//        
//        parms["code"] = authCodeTf.text
//        parms["mobile"] = mobileTf.text
//        
//        parms["order"] = bankCard.order
    
//        print("mm:\(userDefaultsUtil.getMobile()!)")
//        print("bank_no:\(cardNoTf.text)")
//        print("bank_name:\(bankNameLab.text)")
//        print("bank_opening:\(openBankNameTf.text)")
//        print("bank_province:\(bankProvinceLab.text)")
//        print("bank_city:\(bankCityLab.text)")
//        
//        print("real_name:\(realNameTf.text)")
//        print("id_card:\(idCardTf.text)")
//        print("code:\(authCodeTf.text)")
//        print("mobile:\(mobileTf.text)")
//        print("order:\(bankCard.order)")
        
//        assestService.addBankCard(parms, calback: {
//            data in
//            if let mm = data as? MsgModel {
//                KGXToast.showToastWithMessage(mm.msg, duration: ToastDisplayDuration.LengthShort)
//                if mm.status == 1 {
//                    self.loadingHidden()
//                    self.navigationController?.popViewControllerAnimated(true)
//                }else{
//                    self.bankCard.token = ""
//                    self.regetOrder()
//                }
//            }else{
//                self.loadingHidden()
//            }
//            
//        })
//    }

    //验证身份证是否末通过
//    func checkCardId() -> Bool {
//        closeKeyBoard()
//        if idCardTf.text!.characters.count >= 15 && idCardTf.text!.characters.count <= 18 {
//            return false
//        }else{
//            KGXToast.showToastWithMessage("请输入正确的身份证号码", duration: ToastDisplayDuration.LengthShort)
//            return true
//        }
//    }
//    //验证姓名是否末通过
//    func checkRealName() -> Bool {
//        closeKeyBoard()
//        if !realNameTf.text!.isEmpty {
//            return false
//        }else{
//            KGXToast.showToastWithMessage("请输入姓名", duration: ToastDisplayDuration.LengthShort)
//            return true
//        }
//    }

//    //验证手机号是否未通过
//    func checkMobile() ->Bool {
//        closeKeyBoard()
//        let mobile = mobileTf.text!
//        if mobile.isEmpty {
//            KGXToast.showToastWithMessage("请输入手机号码", duration: ToastDisplayDuration.LengthShort)
//            return true
//        }
//        if RegexUtil("^1\\d{10}$").test(mobile) {
//            return false
//        }else{
//            KGXToast.showToastWithMessage("请输入正确的手机号码", duration: ToastDisplayDuration.LengthShort)
//            return true
//        }
//    }

//    //验证验证码是否末通过
//    func checkAuthCode() ->Bool{
//        closeKeyBoard()
//        if authCodeTf.text!.isEmpty {
//            KGXToast.showToastWithMessage("请输入验证码", duration: ToastDisplayDuration.LengthShort)
//            return true
//        }
//        if RegexUtil("^\\d{6}$").test(authCodeTf.text!)  {
//            return false
//        }else{
//            KGXToast.showToastWithMessage("验证码格式不正确", duration: ToastDisplayDuration.LengthShort)
//            return true
//        }
//    }

    
    //加入foot
    func addFootView(){
        let screenWidth = UIScreen.mainScreen().bounds.width
        let footView = UIView(frame: CGRectMake(0, 0, screenWidth, 200))
        //提交按钮
        let subBtn = UIButton(frame: CGRectMake(15, 20, screenWidth - 30, 40))
        subBtn.setTitle("提交", forState: UIControlState.Normal)
        subBtn.backgroundColor = UIColor(red: 63/255, green: 84/255, blue: 102/255, alpha: 1)
        subBtn.layer.cornerRadius = 5
        subBtn.addTapAction("addBandCardClick", target: self)
        //设置触摸背景颜色
        subBtn.setBackgroundImage(createImageWithColor(), forState: UIControlState.Highlighted)
        footView.addSubview(subBtn)
        
        self.tableView.tableFooterView = footView
    }
//    //回显银行名称
//    func  setBankName(bankname:String){
//        bankNameLab.text = bankname
//        bankNameLab.textColor = selectBlue
//        //print("数组包含:\(hideList.containsObject(bankname))")
//        //如果选择的银行包含在hideList数组中，就隐藏手机号与验证码文本输入框
//        if hideList.containsObject(bankname) {
//            self.val[2] = 0
//            self.checkUserAuth = false
//            self.tableView.reloadData()
//        }else{
//            self.val[2] = 2
//            self.checkUserAuth = true
//            self.tableView.reloadData()
//        }
//    }
//    //回显省份名
//    func setProvincename(pname:String,pindex:Int){
//        self.bankProvinceLab.text = pname
//        self.bankProvinceLab.textColor = selectBlue
//        self.pindex = pindex
//        self.bankCityLab.text = "请选择开户城市"
//        self.bankCityLab.textColor = selectGrey
//    }
//    //回显城市名
//    func setCityname(cname:String){
//        self.bankCityLab.text = cname
//        self.bankCityLab.textColor = selectBlue
//    }
//    
//    func touchUpInsideKeyBoard() {
//        self.cardNoTf.resignFirstResponder()
//        self.openBankNameTf.resignFirstResponder()
//        self.reCardNoTf.resignFirstResponder()
//    }
//    
//    
//    //银行选择
//    func toChoseBank(){
//        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "SafetyCenter", bundle: NSBundle.mainBundle())
//        let bankCtrl:ChoseBankViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("chosebank") as! ChoseBankViewController
//        bankCtrl.banklist = self.bankList
//        bankCtrl.delegate = self
//        self.navigationController?.pushViewController(bankCtrl, animated: true)
//        
//    }
//    
//    //mark:根据省的名称查询城市
//    func toChoseCity(){
//        if(self.pindex == nil){
//            KGXToast.showToastWithMessage("请先选择省份", duration: ToastDisplayDuration.LengthShort)
//        }else{
//            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "SafetyCenter", bundle: NSBundle.mainBundle())
//            let cityCtrl:ChoseCityViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("chosecity") as! ChoseCityViewController
//            cityCtrl.delegate = self
//            cityCtrl.pid = self.pindex
//            self.navigationController?.pushViewController(cityCtrl, animated: true)
//            
//        }
//        
//    }
//    
//    //mark:选择省按钮出发，跳转到省选择tableview
//    func choseProvince(){
//        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "SafetyCenter", bundle: NSBundle.mainBundle())
//        let provinceCtrl:ChoseProvinceViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("provinceinfo") as! ChoseProvinceViewController
//        provinceCtrl.delegate = self;
//        self.navigationController?.pushViewController(provinceCtrl, animated: true)
//    }
//    
//    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
//        touchUpInsideKeyBoard()
//        switch indexPath.row {
//        case 0:
//            toChoseBank()
//        case 3:
//            choseProvince()
//        case 4:
//            toChoseCity()
//        default:
//            break
//        }
//    }
//    
//    
//    
//    //按钮显示秒数变化方法
//    func tickDown(){
//        leftTime -= 1
//        authBtn.setTitle("\(leftTime)秒后重发", forState: UIControlState.Normal)
//        if leftTime <= 0 {
//            timer.invalidate()
//            authBtn.enabled = true
//            authBtn.backgroundColor = B.BTN_GOLDEN_COLOR
//            authBtn.setTitle("获取验证码", forState: UIControlState.Normal)
//            leftTime = 60
//        }
//        
//    }
//    
//    //返回每个分组的行数，用于隐藏行
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return val[section]
//    }
//    
//    
//    
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        self.view.endEditing(true)
//    }

}
