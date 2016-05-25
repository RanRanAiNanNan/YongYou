//
//  FanXianViewController.swift
//  fdb-ydzb
//
//  Created by 123 on 16/4/14.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation
class FanXianViewController:BaseViewController {
    
    @IBOutlet weak var tiXianMoneyTF: UITextField!
    @IBOutlet weak var addressLB: UILabel!
    @IBOutlet weak var bankNumLB: UILabel!
    @IBOutlet weak var kaiHuBankLB: UILabel!
    @IBOutlet weak var nameTF: UILabel!
    @IBOutlet weak var bankImage: UIImageView!
    let geRenService = GeRenService.getInstance()
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    
    @IBOutlet weak var tiXianBT: UIButton!
    
    @IBOutlet weak var myView: UIView!
    var int : Int!
    var bankId : String!
    var money : String!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initView()
        self.tiXianMoneyTF.delegate = self
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        geRenService.tiXian { (data) -> () in
            if let hm = data as? TiXianModel{
                self.view1.hidden = false
                self.view2.hidden = false
                self.view3.hidden = false
                self.view4.hidden = false
                self.nameTF.text = hm.name
                self.kaiHuBankLB.text = hm.bank
                self.bankImage.image = UIImage(named: hm.bank)
                self.bankNumLB.text = hm.bankNum
                self.addressLB.text = hm.openBank
                self.bankId = hm.bankId
                self.myView.hidden = true
                self.int = 100
                
            }else{
                self.view1.hidden = true
                self.view2.hidden = true
                self.view3.hidden = true
                self.view4.hidden = true
                self.myView.hidden = false
                self.int = 0
//                print("zhaozhoahzoahzoahzoahozhozha")
            }
        }
        
        
        
        
    }

    
    func initView(){
        
        if money == "0" || money == "0.00"{
            
        }
        
        self.tiXianMoneyTF.placeholder = "最多可提现\(money)"
        self.tiXianMoneyTF.tag = 1003
        self.navigationController!.navigationBarHidden = true
    }
    
    @IBAction func back(sender: AnyObject) {
        
       self.navigationController?.popViewControllerAnimated(true) 
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.tag == 1003{
//            textField.keyboardType = UIKeyboardType.NumberPad
//            self.view.userInteractionEnabled = true
//            let tapGR = UITapGestureRecognizer(target: self, action: "touXiang:")
//            self.view.addGestureRecognizer(tapGR)
            
        }
    }
    func touXiang(sender:UITapGestureRecognizer){
        self.tiXianMoneyTF.resignFirstResponder()
    }
    override func textFieldShouldReturn(textField: UITextField) -> Bool {
        tiXianMoneyTF.resignFirstResponder()
        
        return true
    }

    @IBAction func tianJia(sender: AnyObject) {
        
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
        let rpvc:TianJiaBankViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("TianJiaBankViewController") as! TianJiaBankViewController
        rpvc.bankInt = 1
        rpvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(rpvc, animated: true)

        
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == 1003 {
            if range.location > 8 {
                return false
            }else{
                return true
            }
        }
        
        return true
    }

    @IBAction func queDing(sender: AnyObject) {
        tiXianMoneyTF.resignFirstResponder()

        let myString: String = money
        let myInt: Double? = Double(myString)

        let myString1: String = tiXianMoneyTF.text!
        let myInt1: Double? = Double(myString1)
        print(myInt!)
        
//        print(myInt1!)
//        KGXToast.showToastWithMessage("\(myInt)", duration: ToastDisplayDuration.LengthShort)

//        if int == 0{
//            KGXToast.showToastWithMessage("请添加银行卡", duration: ToastDisplayDuration.LengthShort)
//        }else if money == "0" || money == "0.00"{
//            KGXToast.showToastWithMessage("没有可提现金额", duration: ToastDisplayDuration.LengthShort)
//        }else if tiXianMoneyTF.text! != ""{
//            if !RegexUtil("^(([1-9]\\d{0,9})|0)(\\.\\d{1,2})?$").test(tiXianMoneyTF.text!){
//             KGXToast.showToastWithMessage("请输入正确金额", duration: ToastDisplayDuration.LengthShort)   
//            }else if myInt! - myInt1! < 0{
//                KGXToast.showToastWithMessage("提现金额不足", duration: ToastDisplayDuration.LengthShort)
//            }
//        }
//       else{
//        if int == 100{
//            if tiXianMoneyTF.text! == ""{
//               KGXToast.showToastWithMessage("请输入提现金额", duration: ToastDisplayDuration.LengthShort)
//                
//            }else if !RegexUtil("^(([1-9]\\d{0,9})|0)(\\.\\d{1,2})?$").test(tiXianMoneyTF.text!){
//                KGXToast.showToastWithMessage("请输入正确金额", duration: ToastDisplayDuration.LengthShort)
//            }else{
//            geRenService.tiXianMoney(nameTF.text!, bankId: self.bankId, cardNumber: bankNumLB.text!, openBank: kaiHuBankLB.text!, cashvalue: tiXianMoneyTF.text!, calback: { (data) -> () in
//                
//              })
//            }
//        }else{
//            KGXToast.showToastWithMessage("请添加银行卡", duration: ToastDisplayDuration.LengthShort)
//        }
//        
//        }
//    }
    
        if int == 100{
        
            if money == "0" || money == "0.00"{
                if tiXianMoneyTF.text! == "0"{
                    KGXToast.showToastWithMessage("请输入正确金额", duration: ToastDisplayDuration.LengthShort)
                }else{
                KGXToast.showToastWithMessage("可提现金额不足", duration: ToastDisplayDuration.LengthShort)
                }
            }else if tiXianMoneyTF.text! == ""{
                KGXToast.showToastWithMessage("请输入提现金额", duration: ToastDisplayDuration.LengthShort)
            }else if tiXianMoneyTF.text! != ""{
                if !RegexUtil("^(([1-9]\\d{0,9})|0)(\\.\\d{1,2})?$").test(tiXianMoneyTF.text!){
                    KGXToast.showToastWithMessage("请输入正确金额", duration: ToastDisplayDuration.LengthShort)
                }else if myInt! - myInt1! < 0{
                    KGXToast.showToastWithMessage("提现金额不足", duration: ToastDisplayDuration.LengthShort)
                }else{
                    if tiXianMoneyTF.text! == "0"{
                       KGXToast.showToastWithMessage("请输入正确金额", duration: ToastDisplayDuration.LengthShort)
                    }else if tiXianMoneyTF.text! == "0.0"{
                        KGXToast.showToastWithMessage("请输入正确金额", duration: ToastDisplayDuration.LengthShort)
                    }else if tiXianMoneyTF.text! == "0.00"{
                        KGXToast.showToastWithMessage("请输入正确金额", duration: ToastDisplayDuration.LengthShort)
                    }else if tiXianMoneyTF.text! == "00.00"{
                        KGXToast.showToastWithMessage("请输入正确金额", duration: ToastDisplayDuration.LengthShort)
                    }else if tiXianMoneyTF.text! == "00.0"{
                        KGXToast.showToastWithMessage("请输入正确金额", duration: ToastDisplayDuration.LengthShort)
                    }else if tiXianMoneyTF.text! == "000.0"{
                        KGXToast.showToastWithMessage("请输入正确金额", duration: ToastDisplayDuration.LengthShort)
                    }else if tiXianMoneyTF.text! == "000.00"{
                        KGXToast.showToastWithMessage("请输入正确金额", duration: ToastDisplayDuration.LengthShort)
                    }else{
                       geRenService.tiXianMoney(nameTF.text!, bankId: self.bankId, cardNumber: bankNumLB.text!, openBank: kaiHuBankLB.text!, cashvalue: tiXianMoneyTF.text!, calback: { (data) -> () in
                        if data as! String == "提现成功"{
                            self.navigationController?.popViewControllerAnimated(true)
                        }
                        
                       })
                    }
                }
            }
        }else{
           KGXToast.showToastWithMessage("请添加银行卡", duration: ToastDisplayDuration.LengthShort)
        }
        
    }
        
}
