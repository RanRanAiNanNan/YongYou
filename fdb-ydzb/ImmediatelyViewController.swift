
//
//  ImmediatelyViewController.swift
//  fdb-ydzb
//
//  Created by 123 on 16/3/25.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation

import UIKit
import SwiftyJSON

protocol ImmediatelyViewControllerDelegate{
    
    func sendValue2(orderId:String?,addrId : String?)
}

class ImmediatelyViewController:BaseTableViewController,UINavigationControllerDelegate /*,UITableViewDataSource ,UITableViewDelegate */ , UITextViewDelegate , UITextFieldDelegate , SecondViewControllerDelegate {
   
    var chongXinYuYue : String!
    
    @IBOutlet weak var beizhuTV: UITextView!
    @IBOutlet weak var moneyTF: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var diZhi: UITextView!
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var addressTV: UITextView!
    let fenLei = ProductMainService.getInstance()
    var str : String!
    
    var myId : String!
    var messageBtn: UIBarButtonItem!
    var orderId : String!
    var addrId : String!
    var delegate:ImmediatelyViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
        if self.chongXinYuYue == "重新预约"{
            
            fenLei.dingDanXiangQing(orderId, addrId: addrId) { (data) -> () in
                if let hm = data as? DingDanXiangQingModel{
                    
                    
                    self.moneyTF.text = hm.money
                    self.addressTV.text = hm.userAddrs_addr + hm.userAddrs_areaName
                    self.nameTextField.text = hm.realRame
                    self.beizhuTV.text = hm.remark
                    self.mobileTF.text = hm.phoneNumb
                    self.myId = hm.userAddrs_id
                }
            }
            
            
        }else{
            
            fenLei.yuYueXiangQingMoRen { (data) -> () in
                
                
                if let hm = data as? moRenModel{
                    self.mobileTF.text = hm.mobile
                    self.addressTV.text = hm.addr
                    self.myId = hm.addrId
                }
            }
            
        }

        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItem!.enabled = true
        
    }

    override func viewDidAppear(animated: Bool) {
        
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        
    }
    func initView(){
        
        if beizhuTV.text == ""{
            beizhuTV.text = "请输入备注信息"
        }
        
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.backItem?.title = ""
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.translucent = false
        let lab = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        lab.text = "预约详情"
        lab.textColor = UIColor.blackColor()
        self.navigationItem.titleView = lab
       
        
        let button2 = UIButton(frame:CGRectMake(0, 0, 30, 30))
        button2.setTitle("提交", forState: .Normal)
        button2.setTitleColor(B.NAV_TITLE_CORLOR, forState: UIControlState.Normal)
        button2.titleLabel?.font = UIFont.systemFontOfSize(14)
        button2.addTarget(self,action:Selector("tapped2"),forControlEvents:.TouchUpInside)
        let barButton2 = UIBarButtonItem(customView: button2)
        self.navigationItem.rightBarButtonItem = barButton2
        moneyTF.delegate = self
        nameTextField.delegate = self
        mobileTF.delegate = self
        mobileTF.tag = 9999

        self.moneyTF.tag = 1
        self.addressTV.tag = 100
        addressTV.editable = false
//        moneyTF.resignFirstResponder()

        
    }

    
    
    func myButton(button : UIButton){
        print("立即购买")
    }
    func messageClick(){
        print("提交")
        
        
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool{
        
        print("点击fielf")
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        moneyTF.resignFirstResponder()
        nameTextField.resignFirstResponder()
        mobileTF.resignFirstResponder()
        return true
    }
    func textViewShouldBeginEditing(textView: UITextView) -> Bool{
        
            if beizhuTV.text == "请输入备注信息"{
                
                beizhuTV.text = ""
            }
        
                return true
      
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == 1 {
            if range.location > 9 {
                return false
            }else{
                return true
            }
        }
                
        return true
    }

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool{
        if text == "\n"{
                if beizhuTV.text == ""{
                    beizhuTV.text = "请输入备注信息"
                    beizhuTV.resignFirstResponder()
                    return false
                }else{
                    beizhuTV.resignFirstResponder()
                    
                }
            }
                      return true
    }

    
    @IBAction func dianJiBT(sender: AnyObject) {
        
//         gotoPage("My", pageName:"AddAdressViewController")
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
        let rpvc:AddressViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("AddressViewController") as! AddressViewController
        rpvc.delegate = self
        rpvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(rpvc, animated: true)

    }
    //代理方法
    
    func sendValue(value: String?, name: String?, mobile: String?,id:String?) {
        diZhi.text = value
//        nameTextField.text = name
//        mobileTF.text = mobile
        myId = id
    }

    func tapped2(){
        moneyTF.resignFirstResponder()
        nameTextField.resignFirstResponder()
        mobileTF.resignFirstResponder()
        beizhuTV.resignFirstResponder()
        
        if moneyTF.text == ""{
            KGXToast.showToastWithMessage("请输入预约金额", duration: ToastDisplayDuration.LengthShort)
        }else if nameTextField.text == ""{
            KGXToast.showToastWithMessage("请输入您的姓名", duration: ToastDisplayDuration.LengthShort)
        }else if mobileTF.text == ""{
            KGXToast.showToastWithMessage("请输入您的手机号", duration: ToastDisplayDuration.LengthShort)
        }else if !RegexUtil("^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$").test(mobileTF.text!){
            KGXToast.showToastWithMessage("请输入真实手机号", duration: ToastDisplayDuration.LengthShort)
        }else if !RegexUtil("^[0-9]*$").test(moneyTF.text!){
            KGXToast.showToastWithMessage("请输入正确金额", duration: ToastDisplayDuration.LengthShort)
        }else{
        print("预约详情提交")
         
       self.navigationItem.rightBarButtonItem!.enabled = false
        fenLei.tiJiaoYuYue(str, name: nameTextField.text!, mobile: mobileTF.text!, remark: beizhuTV.text!, money: moneyTF.text!, addrId: myId, calback: { (data) -> () in
            self.orderId = self.str
            print(data)
            if (data as! String) != "失败"{
            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
            let rpvc:DingDanXiangQingNewViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("DingDanXiangQingNewViewController") as! DingDanXiangQingNewViewController
            rpvc.orderId = data as! String
            rpvc.addrId = self.myId
//            userDefaultsUtil.setket_orderId(data as! String)
//            userDefaultsUtil.setkey_addrId(self.myId)

            print(self.orderId)
            print(self.myId)
            rpvc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(rpvc, animated: true)
            }else{
//                self.navigationController?.popViewControllerAnimated(true)
            }
        })
    }
    }
    
    
    
}
