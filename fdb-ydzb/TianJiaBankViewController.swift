//
//  TianJiaBankViewController.swift
//  fdb-ydzb
//
//  Created by 123 on 16/4/22.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation

class TianJiaBankViewController:BaseViewController ,UIPickerViewDataSource,UIPickerViewDelegate{
    
    
    @IBOutlet weak var kaiHuYinHangLB: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var bankNumTF: UITextField!
    @IBOutlet weak var zhiHangBangTF: UITextField!
    var  bankArr : NSArray!
    
    var  myView : UIView!
    
    var  navigationView : UIView!
    
    var  pickView : UIPickerView!
    
    var bankInt : Int!

    @IBOutlet weak var gengGaiButton: UIButton!
    @IBOutlet weak var queDingButton: UIButton!
    @IBOutlet weak var queDingLB: UILabel!
    @IBOutlet weak var xuanZeLB: UILabel!
    @IBOutlet weak var xuanZeButton: UIButton!
    @IBOutlet weak var myImage: UIImageView!
    let geRenService = GeRenService.getInstance()
    
    var panDuan : String! = "1"
    override func viewDidLoad() {
        
        super.viewDidLoad()
        bankNumTF.delegate = self
        bankNumTF.tag = 101
        initView()
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        self.nameTF.text = userDefaultsUtil.getMobile()!
        geRenService.myBank("\(bankInt)") { (data) -> () in
            if (data as! NSDictionary).objectForKey("name") != nil {
            self.myImage.image = UIImage(named: (data["bank"] as? String)!)
            self.nameTF.text = data["name"] as? String
            self.kaiHuYinHangLB.text = data["bank"] as? String
            let str = data["bankNum"] as? String
            self.bankNumTF.text = data["bankNum"] as? String
            self.zhiHangBangTF.text = data["openBank"] as? String
            }
        }
        
    }
    func initView(){
        
        nameTF.delegate = self
        bankNumTF.delegate = self
        zhiHangBangTF.delegate = self
        
        if bankInt == 0 {
        nameTF.userInteractionEnabled = false
        bankNumTF.userInteractionEnabled = false
        zhiHangBangTF.userInteractionEnabled = false
        xuanZeLB.hidden = true
        xuanZeButton.hidden = true
        queDingButton.hidden = true
        queDingLB.hidden = true
        gengGaiButton.hidden = false
//        gengGaiButton.hidden = false
        }else{
        queDingButton.hidden = false
        queDingLB.hidden = false
        xuanZeLB.hidden = false
        xuanZeButton.hidden = false
        gengGaiButton.hidden = true
        }
        
    }
    override func textFieldShouldReturn(textField: UITextField) -> Bool {
        bankNumTF.resignFirstResponder()
        nameTF.resignFirstResponder()
        zhiHangBangTF.resignFirstResponder()
        return true
    }
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == 101 {
            if range.location > 19 {
                return false
            }else{
                return true
            }
        }
        
            return true
    }

    @IBAction func queDing(sender: AnyObject) {
        bankNumTF.resignFirstResponder()
        nameTF.resignFirstResponder()
        zhiHangBangTF.resignFirstResponder()
        
        
        if nameTF.text == ""{
             KGXToast.showToastWithMessage("请输入账户姓名", duration: ToastDisplayDuration.LengthShort)
        }else if kaiHuYinHangLB.text == ""{
            KGXToast.showToastWithMessage("请选择开户银行", duration: ToastDisplayDuration.LengthShort)
        }else if bankNumTF.text == ""{
           KGXToast.showToastWithMessage("请输入银行卡号", duration: ToastDisplayDuration.LengthShort)
        }else if zhiHangBangTF.text == ""{
           KGXToast.showToastWithMessage("请输入所在支行", duration: ToastDisplayDuration.LengthShort)
        }else if !RegexUtil("^[0-9]*$").test(bankNumTF.text!){
            KGXToast.showToastWithMessage("请输入正确银行卡号", duration: ToastDisplayDuration.LengthShort)
        }else{

        geRenService.addBank(nameTF.text!, bank: kaiHuYinHangLB.text!, bankNum: bankNumTF.text!, openBank: zhiHangBangTF.text!) { (data) -> () in
            if data as! String == "成功"{
//              self.navigationController?.popViewControllerAnimated(true)
                self.nameTF.userInteractionEnabled = false
                self.bankNumTF.userInteractionEnabled = false
                self.zhiHangBangTF.userInteractionEnabled = false
                self.xuanZeLB.hidden = true
                self.xuanZeButton.hidden = true
                self.queDingButton.hidden = true
                self.queDingLB.hidden = true
                self.gengGaiButton.hidden = false

            }
          }
            //           self.navigationController?.popViewControllerAnimated(true)
        }
        print("添加银行卡 确定")
    }
    @IBAction func xuanZeBank(sender: AnyObject) {
        if panDuan == "1"{
        
        addTapGestureRecognizerToSelf()
        getPickerData()
        createView()
            bankNumTF.resignFirstResponder()
            nameTF.resignFirstResponder()
            zhiHangBangTF.resignFirstResponder()

        panDuan = "aa"
        }else{
        hiddenBottomView()
            bankNumTF.resignFirstResponder()
            nameTF.resignFirstResponder()
            zhiHangBangTF.resignFirstResponder()

        }
        
        
    }
    func getPickerData()
    {
     bankArr = ["中国银行","中信银行","中国光大银行","交通银行","平安银行","浦发银行","中国民生银行","招商银行","中国建设银行","中国工商银行","中国农业银行","兴业银行"]
    }
    
    func addTapGestureRecognizerToSelf()
    {
    self.view.userInteractionEnabled = true
    let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hiddenBottomView")
    self.view.addGestureRecognizer(tap)

    }
    func createView()
    {
       myView = UIView(frame: CGRectMake(0, B.SCREEN_HEIGHT - 224, B.SCREEN_WIDTH, 224))
       self.view.addSubview(myView)
        

//    //导航视图
       navigationView = UIView(frame: CGRectMake(0, 0, B.SCREEN_WIDTH, 44))
       navigationView.backgroundColor = UIColor(red: 242/255, green: 244/255, blue: 245/255, alpha: 1)
       myView.addSubview(navigationView)
       //这里添加空手势不然点击navigationView也会隐藏
        let tapNavigationView : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
        self.myView.addGestureRecognizer(tapNavigationView)
        navigationView.addGestureRecognizer(tapNavigationView)
        
        let buttonTitleArray = ["取消","确定"]
        
    for var i = 0 ; i < buttonTitleArray.count ; i++ {
        let button : UIButton = UIButton(frame: CGRectMake((B.SCREEN_WIDTH - 60) * CGFloat(Float(i)) , 0 , 60,44 ))
        button.titleLabel?.font = UIFont.systemFontOfSize(14)
        button.setTitle(buttonTitleArray[i] , forState: UIControlState.Normal)
        if i == 0{
             button.setTitleColor(UIColor(red: 91/255, green: 95/255, blue: 101/255, alpha: 1), forState: UIControlState.Normal)
        }else{
            button.setTitleColor(UIColor(red: 91/255, green: 98/255, blue: 197/255, alpha: 1), forState: UIControlState.Normal)
        }
        
        button.tag = i
        
        button.addTarget(self,action:Selector("tapButton:"),forControlEvents:.TouchUpInside)
        self.myView.addSubview(button)

        }
        
        let laa = UILabel(frame: CGRectMake(B.SCREEN_WIDTH / 2 - 40, 0, 80, 44))
        laa.font = UIFont.systemFontOfSize(15)
        laa.textAlignment=NSTextAlignment.Center
        laa.text = "选择银行"
        laa.textColor = UIColor(red: 91/255, green: 95/255, blue: 101/255, alpha: 1)
        self.myView.addSubview(laa)

      pickView = UIPickerView(frame: CGRectMake(0, 44, B.SCREEN_WIDTH, 200))
      pickView.backgroundColor = UIColor.whiteColor()
      pickView.dataSource = self
      pickView.delegate = self
      myView.addSubview(pickView)
    
    
    }
    func tapButton(button :UIButton)
    {
    //点击确定回调block
    if (button.tag == 1) {
    
    let str = self.bankArr.objectAtIndex(pickView.selectedRowInComponent(0))
    kaiHuYinHangLB.text = str as? String
    self.myImage.image = UIImage(named: (str as? String)!)
    
    print(str)
    }else {

    kaiHuYinHangLB.text = ""
    self.myImage.image = UIImage(named: "")
        
        }
    hiddenBottomView()
    }

    func showBottomView()
    {
        self.myView.backgroundColor = UIColor.clearColor()
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.myView.top = B.SCREEN_HEIGHT - 44 - 200
            self.view.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2)

            }, completion: { (Bool) -> Void in
                
        })
        
    }
    func hiddenBottomView()
    {
       panDuan = "1"
      UIView.animateWithDuration(0.3, animations: { () -> Void in
        self.myView.top = B.SCREEN_HEIGHT
        self.view.backgroundColor = UIColor.clearColor()
        }) { (Bool) -> Void in
            self.myView.removeFromSuperview()
        }
        
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bankArr.count
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
        let lable = UILabel()
        lable.textAlignment = NSTextAlignment.Center
        lable.text = bankArr.objectAtIndex(row) as? String
        
        return lable
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return B.SCREEN_WIDTH
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let str = self.bankArr.objectAtIndex(row) as! String
        print(str)
    }


    @IBAction func gengGai(sender: AnyObject) {
        print("更改银行卡")
        gengGaiButton.hidden = true
        nameTF.userInteractionEnabled = true
        bankNumTF.userInteractionEnabled = true
        zhiHangBangTF.userInteractionEnabled = true
        xuanZeLB.hidden = false
        xuanZeButton.hidden = false
        queDingButton.hidden = false
        queDingLB.hidden = false

    }
    

}
