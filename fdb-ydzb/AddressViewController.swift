//
//  AddressViewController.swift
//  fdb-ydzb
//
//  Created by 123 on 16/3/28.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
protocol SecondViewControllerDelegate{
    
    func sendValue(value:String? ,name:String?,mobile : String?,id :String?)
}

class AddressViewController:BaseViewController ,UITableViewDataSource ,UITableViewDelegate{
    
    //tableView
    var addressTableView : UITableView?
    
    var delegate:SecondViewControllerDelegate?
    
    let geRenService = GeRenService.getInstance()
    var Arr = NSArray?()
    
    var tiao : String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.navigationBarHidden = true
        geRenService.myAddress { (data) -> () in
            if data as? NSArray != nil{
            self.Arr = (data as? NSArray)!
            self.addressTableView!.reloadData()
            }
        }
        
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        
    }
    func initView(){
        
        initTableView()
        initButton()
    }
    func initTableView(){
        self.Arr = NSArray()
        addressTableView =  UITableView(frame: CGRectMake(0,64, B.SCREEN_WIDTH , B.SCREEN_HEIGHT - 64 - 60), style: UITableViewStyle.Plain)
        self.view.addSubview(addressTableView!)
        addressTableView!.delegate = self
        addressTableView!.dataSource = self
        addressTableView!.registerClass(AddressCell.self, forCellReuseIdentifier: "AddressCell")
        
    }
    func initButton(){
        let modificationButton = UIButton(type: .System)
        modificationButton.frame = CGRectMake(0, B.SCREEN_HEIGHT  - 60, B.SCREEN_WIDTH , 60)
        modificationButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        modificationButton.backgroundColor = UIColor(red: 37/255, green: 41/255, blue: 42/255, alpha: 1)
        modificationButton.setTitle("+ 添加收货地址", forState: UIControlState.Normal)
        modificationButton.addTarget(self,action:Selector("addButton:"),forControlEvents:.TouchUpInside)
        modificationButton.setTitleColor(B.NAV_TITLE_CORLOR,forState: .Normal)
        self.view.addSubview(modificationButton)
        
        let button2 = UIButton(frame:CGRectMake(0, 0, 30, 30))
        button2.setTitle("提交", forState: .Normal)
        button2.setTitleColor(B.NAV_TITLE_CORLOR, forState: UIControlState.Normal)
        button2.titleLabel?.font = UIFont.systemFontOfSize(14)
        button2.addTarget(self,action:Selector("tapped2"),forControlEvents:.TouchUpInside)
        let barButton2 = UIBarButtonItem(customView: button2)
        self.navigationItem.rightBarButtonItem = barButton2


    }
    func addButton(button : UIButton){
        
//        gotoPage("My", pageName:"AddCenterAddressViewController")
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
        let rpvc:AddCenterAddressViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("AddCenterAddressViewController") as! AddCenterAddressViewController
        rpvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(rpvc, animated: true)
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 110
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.Arr?.count == 0{
            return 0
        }else{
            return (self.Arr?.count)!
        }
        
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AddressCell", forIndexPath: indexPath) as! AddressCell
        if self.Arr != nil{
        
        cell.backgroundColor = UIColor(red: 239/255, green: 243/255, blue: 249/255, alpha: 1)
        //名称
        cell.nameLabel?.text = self.Arr![indexPath.section]["realName"] as? String
        //手机号
        let str = self.Arr![indexPath.section]["mobile"]
        cell.mobileLabel?.text = "\(str as! String)"
        let str1 = self.Arr![indexPath.section]["areaName"] as? String
        let str2 = self.Arr![indexPath.section]["addr"] as? String
            if self.Arr![indexPath.section]["isDef"] as! Int == 0{
            cell.addLabel?.hidden = false
            }else{
            cell.addLabel?.hidden = true
            }
        //详细
        cell.addressLabel?.text = str1! + str2!
        
        }
        return cell;
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tiao == "11"{
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
        let rpvc:FixAddressViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("FixAddressViewController") as! FixAddressViewController
        let str = self.Arr![indexPath.section]["id"] as! Int
        rpvc.nav = "aaa"
         rpvc.addrId = "\(str)"
        rpvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(rpvc, animated: true)
        }
        
       print("点点点")
        if((delegate) != nil)
        {
            let str1 = self.Arr![indexPath.section]["areaName"] as? String
            let str2 = self.Arr![indexPath.section]["addr"] as? String

            let str = self.Arr![indexPath.section]["mobile"] as! String
            let str11 = self.Arr![indexPath.section]["id"] as! Int
            self.navigationController!.navigationBarHidden = false
            delegate?.sendValue(str1! + str2!, name: self.Arr![indexPath.section]["realName"] as? String, mobile: str,id:"\(str11)")
            
            self.navigationController?.popViewControllerAnimated(true)
        }
   
        
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        self.loadingShow()
        let str = self.Arr![indexPath.section]["id"] as! NSNumber
        let set1 = "\(str)"
        geRenService.deleteAddress(set1) { (data) -> () in
//            self.addressTableView?.reloadData()
            self.Arr = NSArray()
            self.addressTableView?.reloadData()
            self.geRenService.myAddress { (data) -> () in
                print("--------\(data)")
                self.Arr = NSArray()
                self.Arr = (data as? NSArray)!
                self.addressTableView?.reloadData()
            }
              self.loadingHidden()
        }
       
        print("删除删除")
    }
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
//        let rpvc:FixAddressViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("FixAddressViewController") as! FixAddressViewController
////        rpvc.str = self.lieBiao[indexPath.section].id
//        rpvc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(rpvc, animated: true)
//        
//        
//    }
//    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//        print("aaa")
//    }
    
    
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController!.navigationBarHidden = false
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func tapped2(){
        print("main添加新地址")
    }

    
    
}