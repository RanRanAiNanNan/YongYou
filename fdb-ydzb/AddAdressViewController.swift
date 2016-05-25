//
//  AddAdressViewController.swift
//  fdb-ydzb
//
//  Created by 123 on 16/3/31.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class AddAdressViewController:BaseTableViewController  {
  
    var myPickerView: UIPickerView?
    
    @IBOutlet weak var addressTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
  
    }
    
    override func viewWillDisappear(animated: Bool) {
      
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
    }
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.backItem?.title = ""
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 27/255, green: 31.0/255, blue: 32.0/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 91/255, green: 95.0/255, blue: 111.0/255, alpha: 1)
        
        self.navigationController?.navigationBar.translucent = false
       
    

    }

    func initView(){
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.backItem?.title = ""
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 27/255, green: 31.0/255, blue: 32.0/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 91/255, green: 95.0/255, blue: 111.0/255, alpha: 1)

        self.navigationController?.navigationBar.translucent = false
        let lab = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        lab.text = "添加新收货地址"
        lab.textColor = UIColor.whiteColor()
//            UIColor(red: 192/255, green: 192.0/255, blue: 192.0/255, alpha: 1)
        self.navigationItem.titleView = lab
        
        
        let button2 = UIButton(frame:CGRectMake(0, 0, 30, 30))
        button2.setTitle("提交", forState: .Normal)
        button2.setTitleColor(B.NAV_TITLE_CORLOR, forState: UIControlState.Normal)
        button2.titleLabel?.font = UIFont.systemFontOfSize(14)
        button2.addTarget(self,action:Selector("tapped"),forControlEvents:.TouchUpInside)
        let barButton2 = UIBarButtonItem(customView: button2)
        self.navigationItem.rightBarButtonItem = barButton2

      
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: Selector("tongzhi:"), name: "add_address_tongzhi", object: nil)
        let center1 = NSNotificationCenter.defaultCenter()
        center1.addObserver(self, selector: Selector("tong:"), name: "add_address_tong", object: nil)

    }
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func myButton(sender: AnyObject) {
    let addressPickView = AddressPickView.shareInstance()
    self.view.addSubview(addressPickView)
    
    }
    func tongzhi(text : NSNotification){
        print("\(text.userInfo!["province"])  \(text.userInfo!["city"])  \(text.userInfo!["town"])")
        let str1 = text.userInfo!["province"]as! String
        let str2 = text.userInfo!["city"]as! String
        let str3 = text.userInfo!["town"]as! String
        let str4 = " - "
        self.addressTF.text = str1 + str4 + str2 + str4 + str3 
    }
    func tong(text : NSNotification){
        self.addressTF.text = ""

    }
    
    func tapped(){
        print("添加收货地址提交")
    }
    
    
    
}