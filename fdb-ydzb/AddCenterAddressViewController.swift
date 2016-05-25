//
//  AddCenterAddressViewController.swift
//  fdb-ydzb
//
//  Created by 123 on 16/4/14.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation
class AddCenterAddressViewController:BaseTableViewController,UITextFieldDelegate,UITextViewDelegate ,MobileDelegate {
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var mobileTF: UITextField!
//    @IBOutlet weak var diQuTF: UITextField!
    @IBOutlet weak var xiangXiTF: UITextView!
    
    @IBOutlet weak var mySwifch: UISwitch!
    
    @IBOutlet weak var addTF: UITextField!
    
    var int : NSInteger!
    
    let geRenService = GeRenService.getInstance()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        nameTF.delegate = self
        mobileTF.delegate = self
        addTF.delegate = self
        xiangXiTF.delegate = self
        
        initView()
        
        
    }
    override func viewWillAppear(animated: Bool) {
//       self.navigationController!.navigationBarHidden = true
       int = 1
       self.navigationController?.navigationBar.barTintColor = UIColor(red: 27 / 255, green: 31 / 255, blue: 32 / 255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: Selector("tongzhi:"), name: "add_address_tongzhi", object: nil)
        let center1 = NSNotificationCenter.defaultCenter()
        center1.addObserver(self, selector: Selector("tong:"), name: "add_address_tong", object: nil)
    }

    func initView(){
        
        self.mySwifch.setOn(false, animated: true)
        self.navigationController!.navigationBarHidden = false
//        initNav("添加新收货地址")
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.backItem?.title = ""
        
        
        self.navigationController?.navigationBar.translucent = false
        let lab = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        lab.text = "添加新收货地址"
        lab.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = lab
        //设置标题颜色
        //let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        //self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as [NSObject : AnyObject]
        self.view.backgroundColor = B.VIEW_BG

        let button2 = UIButton(frame:CGRectMake(0, 0, 30, 30))
        button2.setTitle("提交", forState: .Normal)
        button2.setTitleColor(B.NAV_TITLE_CORLOR, forState: UIControlState.Normal)
        button2.titleLabel?.font = UIFont.systemFontOfSize(14)
        button2.addTarget(self,action:Selector("tapped2"),forControlEvents:.TouchUpInside)
        let barButton2 = UIBarButtonItem(customView: button2)
        self.navigationItem.rightBarButtonItem = barButton2

        
        

    }
    
    @IBAction func dianji(sender: AnyObject) {
        nameTF.resignFirstResponder()
        mobileTF.resignFirstResponder()
        addTF.resignFirstResponder()
        xiangXiTF.resignFirstResponder()
        let addressPickView = AddressPickView.shareInstance()
        self.view.addSubview(addressPickView) 
        
    }
    func tongzhi(text : NSNotification){
        print("\(text.userInfo!["province"])  \(text.userInfo!["city"])  \(text.userInfo!["town"])")
        let str1 = text.userInfo!["province"]as! String
        let str2 = text.userInfo!["city"]as! String
        let str3 = text.userInfo!["town"]as! String
        let str4 = ""
        self.addTF.text = str1 + str4 + str2 + str4 + str3
    }
    func tong(text : NSNotification){
        self.addTF.text = ""
        
    }
  
    @IBAction func myButton(sender: AnyObject) {
        print("我的")
        self.navigationController!.navigationBarHidden = false
    }
    func tapped2(){
        print(int)
        if nameTF.text == ""{
           KGXToast.showToastWithMessage("请输入收件人姓名", duration: ToastDisplayDuration.LengthShort)
        }else if mobileTF.text == ""{
            KGXToast.showToastWithMessage("请输入手机号", duration: ToastDisplayDuration.LengthShort)
        }else if addTF.text == ""{
            KGXToast.showToastWithMessage("请输入所在地区", duration: ToastDisplayDuration.LengthShort)
        }
//        else if xiangXiTF.text == "请输入详细地址"{
//           KGXToast.showToastWithMessage("请输入详细地址", duration: ToastDisplayDuration.LengthShort)
//        }
        else if !RegexUtil("^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$").test(mobileTF.text!){
            KGXToast.showToastWithMessage("请输入真实手机号", duration: ToastDisplayDuration.LengthShort)
        }else{
            print(int)
            geRenService.addAddress(mobileTF.text!, realName: nameTF.text!, addr: xiangXiTF.text!, isDef: int, areaName: addTF.text!) { (data) -> () in
            if data as! String == "成功"{
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
        
        }
    }
    @IBAction func mySwitch(sender: AnyObject) {
        
        
        if mySwifch.on{
            int = 0
            mySwifch.setOn(true, animated:true)
        }else{
            int = 1
            mySwifch.setOn(false, animated:true)
        }
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        nameTF.resignFirstResponder()
        mobileTF.resignFirstResponder()
        addTF.resignFirstResponder()
        return true
    }
    func textViewShouldBeginEditing(textView: UITextView) -> Bool{
        if xiangXiTF.text == "请输入详细地址"{
            
            xiangXiTF.text = ""
            xiangXiTF.textColor = UIColor.blackColor()
        }
        return true
    }
    func textViewDidChange(textView: UITextView) {
        
        
//        let string = "121312131414"
        textView.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        
        let number : NSInteger = (textView.text as NSString).length
          if number > 49 {
        textView.resignFirstResponder()
        KGXToast.showToastWithMessage("详细地址过长", duration: ToastDisplayDuration.LengthShort)
        }
        
        
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool{
        if text == "\n"{
            if xiangXiTF.text == ""{
                xiangXiTF.text = "请输入详细地址"
                xiangXiTF.textColor = UIColor(red: 192.0/255, green: 199.0/255, blue: 210.0/255, alpha: 1)
                xiangXiTF.resignFirstResponder()
                return false
            }else{
                xiangXiTF.textColor = UIColor.blackColor()
                xiangXiTF.resignFirstResponder()
                
            }
        }
        return true
    }
    
    
    
    //代理方法
    func sendValue(value: String?) {
//        print(value)
        mobileTF.text = value
    }

    @IBAction func allPhoneBT(sender: AnyObject) {
        
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
        let rpvc:AllPhoneNumberViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("AllPhoneNumberViewController") as! AllPhoneNumberViewController
        rpvc.delegate = self
        rpvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(rpvc, animated: true)

    }
 
    
}
