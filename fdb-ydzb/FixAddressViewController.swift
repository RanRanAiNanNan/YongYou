//
//  FixAddressViewController.swift
//  fdb-ydzb
//
//  Created by 123 on 16/4/5.
//  Copyright © 2016年 然. All rights reserved.
//
import Foundation

protocol FixAddressViewControllerDelegate{
    
    func sendValue(addrId:String?,orderId:String?)
}

class FixAddressViewController: BaseViewController,MobileDelegate,UITextViewDelegate{
    
    var nav : String! = ""
    var orderId : String!
    var addrId :String!
    var id : String!
    var isDef : String!
    var delegate:FixAddressViewControllerDelegate?
    @IBOutlet weak var shouJianRen: UITextField!
    @IBOutlet weak var shouJiHao: UITextField!
    @IBOutlet weak var diQu: UITextField!
    @IBOutlet weak var xiangXi: UITextView!
    let fenLei = ProductMainService.getInstance()
    override func viewDidLoad() {
        super.viewDidLoad()
                fenLei.chaXunDiZhi(addrId) { (data) -> () in
            if let hm = data as? UserAddrsModel{
                
                self.shouJianRen.text = hm.realName
                self.shouJiHao.text = hm.mobile
                self.diQu.text = hm.areaName
                self.xiangXi.text = hm.addr
                self.id = hm.id
                self.isDef = hm.isDef
            }
        }

        //加载初始化视图
        initView()
    }
    func initView(){
//        self.navigationController!.navigationBarHidden = true
        
        let item = UIBarButtonItem(title: "提交", style: UIBarButtonItemStyle.Plain, target: self, action:"tiJiao:")
        item.tintColor = B.NAV_TITLE_CORLOR
        self.navigationItem.rightBarButtonItem=item
        
        shouJianRen.delegate = self
        shouJiHao.delegate = self
        diQu.delegate = self
        xiangXi.delegate = self
        xiangXi.text = "请输入详细地址"
        
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 38.0/255, green: 40.0/255, blue: 41.0/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: Selector("tongzhi:"), name: "add_address_tongzhi", object: nil)
        let center1 = NSNotificationCenter.defaultCenter()
        center1.addObserver(self, selector: Selector("tong:"), name: "add_address_tong", object: nil)
        print(addrId)
        
        self.navigationController!.navigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.backItem?.title = ""
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 38.0/255, green: 40.0/255, blue: 41.0/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.translucent = false
        let lab = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        lab.text = "修改合同地址"
        lab.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = lab
        //设置标题颜色
        _ = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black

   
    }

    @IBAction func addressButton(sender: AnyObject) {
        shouJianRen.resignFirstResponder()
        shouJiHao.resignFirstResponder()
        diQu.resignFirstResponder()
        xiangXi.resignFirstResponder()
        let addressPickView = AddressPickView.shareInstance()
        self.view.addSubview(addressPickView)

    }
    func tongzhi(text : NSNotification){
        print("\(text.userInfo!["province"])  \(text.userInfo!["city"])  \(text.userInfo!["town"])")
        let str1 = text.userInfo!["province"]as! String
        let str2 = text.userInfo!["city"]as! String
        let str3 = text.userInfo!["town"]as! String
        let str4 = ""
        self.diQu.text = str1 + str4 + str2 + str4 + str3
    }
    func tong(text : NSNotification){
        self.diQu.text = ""
        
    }
    override func textFieldShouldReturn(textField: UITextField) -> Bool{
        shouJianRen.resignFirstResponder()
        shouJiHao.resignFirstResponder()
        diQu.resignFirstResponder()
        return true
    }
    func textViewShouldBeginEditing(textView: UITextView) -> Bool{
        if xiangXi.text == "请输入详细地址"{
            
            xiangXi.text = ""
        }
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool{
        if text == "\n"{
            if xiangXi.text == ""{
                xiangXi.text = "请输入详细地址"
                xiangXi.resignFirstResponder()
                return false
            }else{
                xiangXi.resignFirstResponder()
                
            }
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


    @IBAction func mobileButton(sender: AnyObject) {
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
        let rpvc:AllPhoneNumberViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("AllPhoneNumberViewController") as! AllPhoneNumberViewController
        rpvc.delegate = self
        rpvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(rpvc, animated: true)

    }
    //代理方法
    func sendValue(value: String?) {
        //        print(value)
        shouJiHao.text = value
    }

    @IBAction func tiJiao(sender: AnyObject) {
        if shouJiHao.text == ""{
            KGXToast.showToastWithMessage("请输入手机号", duration: ToastDisplayDuration.LengthShort)
        }else if shouJianRen.text == ""{
            KGXToast.showToastWithMessage("请输入收件人姓名", duration: ToastDisplayDuration.LengthShort)
        }else if xiangXi.text == ""{
            KGXToast.showToastWithMessage("请输入详细地址", duration: ToastDisplayDuration.LengthShort)
        }else if diQu.text == ""{
            KGXToast.showToastWithMessage("请输入所在地区", duration: ToastDisplayDuration.LengthShort)
        }else if !RegexUtil("^[1][358][0-9]{9}$").test(shouJiHao.text!){
            KGXToast.showToastWithMessage("请输入真实手机号", duration: ToastDisplayDuration.LengthShort)
        }else{
        fenLei.tiJiaoXiuGaiDiZhi(shouJiHao.text!, addrId: id, realName: shouJianRen.text!, addr: xiangXi.text!, areaName: diQu.text!) { (data) -> () in
            if data as! String == "成功"{
                if self.nav == "aaa"{
                    self.navigationController!.navigationBarHidden = true
                }else{
                    self.navigationController!.navigationBarHidden = false
                }
                
                //        self.navigationController!.navigationBarHidden = false
                self.delegate?.sendValue(self.addrId, orderId: self.orderId)
                self.navigationController?.popViewControllerAnimated(true)

            }
            }
        }
    }
    @IBAction func back(sender: AnyObject) {
        if self.nav == "aaa"{
            self.navigationController!.navigationBarHidden = true
        }else{
            self.navigationController!.navigationBarHidden = false
        }

//        self.navigationController!.navigationBarHidden = false
        self.navigationController?.popViewControllerAnimated(true)
    }
}