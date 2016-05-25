//
//  EditBankcardViewController.swift
//  ydzbapp-hybrid
//
//  Created by yinduo-zdy on 15/3/10.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit



class EditBankcardViewController: BaseViewController,choseBankDelegate,ProvinceNameDelegate,CityNameDelegate {
   let userSafetyService =  UserSafetyInfoService.getInstance();
    
    @IBOutlet weak var prvnButton: UIButton!   //sheng
    @IBOutlet weak var choedbankButton: UIButton!;  //bank
    @IBOutlet weak var cardnoInput: UITextField!;   //bankcard
    @IBOutlet weak var subButton: UIButton!
    @IBOutlet weak var ctyButton: UIButton!     //city
    @IBOutlet weak var obank: UITextField!
    
//    @IBOutlet weak var realNameTf: UITextField!
//    @IBOutlet weak var cardIdTf: UITextField!
    
    
    var ifLoad = false                                                      //是否加载数据
    
    var delegate:ChoseBankViewController = ChoseBankViewController();
    var pindex:Int?;
    
    var bankCardNumber = ""
    
   // var pdelegate:ProvinceNameDelegate = ProvinceNameDelegate();
    override func viewDidLoad() {
        
        super.viewDidLoad();
        self.initView();

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        //如果从上次界面进入加载数据
        if ifLoad {
            loadData()
            self.ifLoad = false
        }
    }
    
    func loadData(){
        loadingShow()
        userSafetyService.loadBankInfoGet({
            (data) -> () in
            self.loadingHidden()
            if let ubcm = data as? UserBankCardModel {
                //println("bankCardNumber::\(ubcm.bankCardNumber)")
                self.bankCardNumber = ubcm.bankCardNumber
                if ubcm.bankCardNumber.characters.count >= 10 {
                    let b4 = (self.bankCardNumber as NSString).substringToIndex(4)
                    let a4 = (self.bankCardNumber as NSString).substringFromIndex(ubcm.bankCardNumber.characters.count - 4)
                    self.cardnoInput.text = b4 + "******" + a4
                }else{
                    self.cardnoInput.text = ubcm.bankCardNumber
                    self.bankCardNumber = ubcm.bankCardNumber
                }
                self.prvnButton.setTitle(ubcm.bankProvince, forState: .Normal)
                self.ctyButton.setTitle(ubcm.bankCity, forState: .Normal)
                self.obank.text = ubcm.openingBank
                self.choedbankButton.setTitle(ubcm.bankName, forState: .Normal)
            }
        })
    }
    
    @IBAction func touchUpInsideAction(sender: AnyObject) {
        cardnoInput.resignFirstResponder()
        obank.resignFirstResponder()
    }
    
    
    //mark:银行选择
    @IBAction func toChoseBank(){
     
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "SafetyCenter", bundle: NSBundle.mainBundle())
        let oneController:ChoseBankViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("chosebank") as! ChoseBankViewController
          oneController.delegate = self;
        self.navigationController?.pushViewController(oneController, animated: true)
      
    }
    //mark:根据省的名称查询城市
    @IBAction func toChoseCity(){
        
        if(self.pindex == nil){
            KGXToast.showToastWithMessage("没选择省份", duration: ToastDisplayDuration.LengthShort)
        }else{
            self.performSegueWithIdentifier("TOCITYSEGUE", sender: self)
            
        }
       
    
    }
    //mark:隐藏键盘
    @IBAction func hiddKeyBorad(){
        
        self.cardnoInput.resignFirstResponder();
    }
    //mark:选择省按钮出发，跳转到省选择tableview
    @IBAction func choseProvince(){
        
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "SafetyCenter", bundle: NSBundle.mainBundle())
        let oneController:ChoseProvinceViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("provinceinfo") as! ChoseProvinceViewController
        oneController.delegate = self;
        self.navigationController?.pushViewController(oneController, animated: true)
    }
    
    
    
    func initView(){
        initNav("银行卡")
        
        cardnoInput.delegate = self
        obank.delegate = self
        cardnoInput.clearButtonMode = UITextFieldViewMode.Always
        //  提交按钮边框设置
        //subButton.layer.borderWidth = 1
        subButton.layer.cornerRadius = 5
        //subButton.layer.borderColor = B.WORD_COLOR.CGColor

    }
    
    func  setBankName(bankname:String){
        
        choedbankButton.setTitle(bankname, forState: .Normal)
        choedbankButton.setTitleColor(B.WORD_COLOR, forState: .Normal)
    }
    
    func setProvincename(pname:String,pindex:Int){
        self.prvnButton.setTitle(pname, forState: .Normal)
        self.prvnButton.setTitleColor(B.WORD_COLOR, forState: .Normal)
        self.pindex = pindex;
        self.ctyButton.setTitle("", forState: .Normal)
    }
    
    func setCityname(cname:String){
        self.ctyButton.setTitle(cname, forState: .Normal)
        self.ctyButton.setTitleColor(B.WORD_COLOR, forState: .Normal)

    }
    
    override  func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        let aass :ChoseCityViewController =  segue.destinationViewController as! ChoseCityViewController;
        aass.pid = self.pindex ;
        aass.delegate = self;
    }
    
    @IBAction func submisAction(){
        closeKeyBoard()
        let  bank:NSString = self.choedbankButton.titleLabel!.text!;
        var  obank:NSString = self.obank.text!;
        var  bcard:NSString =  self.cardnoInput.text!;
        let  pro:NSString = self.prvnButton.titleLabel!.text!;
        let  cty:NSString = self.ctyButton.titleLabel!.text!;
//        var realName = self.realNameTf.text
//        var cardId = self.cardIdTf.text
        
        if bcard.componentsSeparatedByString("*").count > 1 {
            //println("包含")
            bcard = bankCardNumber
        }else{
            if self.cardnoInput.text!.characters.count < 10 {
                KGXToast.showToastWithMessage("您输入的银行卡号格式错误", duration: ToastDisplayDuration.LengthShort)
                return
            }
        }
        
        bcard = bcard.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet());
        obank = obank.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet());
       
        loadingShow()
        //bank_realName: realName as String, bank_cardId: cardId as String,
        userSafetyService.bindsBankinfo(bank as String, opening_bank: obank as String, bank_card_number: bcard as String, bank_province: pro as String, bank_city: cty as String, calback: {
            data in
            self.loadingHidden()
            KGXToast.showToastWithMessage(data as! String, duration: ToastDisplayDuration.LengthShort)
            self.navigationController?.popViewControllerAnimated(true)
            
        })
        
        
    }
    

//    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//        super.touchesBegan(touches as Set<NSObject>, withEvent: event)
//        self.view.endEditing(true)
//    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
