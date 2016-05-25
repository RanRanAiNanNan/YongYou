//
//  ProductMainViewController.swift
//  fdb-ydzb
//
//  Created by 123 on 16/3/24.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class ProductMainViewController:BaseViewController , UITableViewDataSource , UITableViewDelegate {
    
    @IBOutlet weak var zongShuLB: UILabel!
    @IBOutlet weak var chengJiaoLB: UILabel!
    @IBOutlet weak var daKuanLB: UILabel!
    //股票型
    var stockBT: UIButton!
    //债券型
    var debentureBT: UIButton!
    //量化型
    var quantificationBT: UIButton!
    //多策略
    var strategyBT: UIButton!
    
    var productTableView: UITableView!
    
    var xianView : UIView!
    var lieBiaoArr:[ProductModel]!
    
//    var lieBiaoArr:NSArray!
    var dingDan : Int!
    var chengJiao : Int!
    var daiDaKuan : Int!
    
    @IBOutlet weak var chengJiao_wight: NSLayoutConstraint!
    
    @IBOutlet weak var daKuan_wight: NSLayoutConstraint!
    
    @IBOutlet weak var zongShu_wight: NSLayoutConstraint!
    
    let fenLei = ProductMainService.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       initView()
      
    }
    override func viewWillAppear(animated: Bool) {
         super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: ""), forBarMetrics: UIBarMetrics.Default)

        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.backItem?.title = ""
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.translucent = false
        //设置标题颜色
        _ = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        //self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as [NSObject : AnyObject]
        //self.view.backgroundColor = B.VIEW_BG
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        
        self.loadingShow()
        fenLei.fenLei { (data) -> () in
            if let hm = data as? ProductMainModel {
                self.loadingHidden()
                self.lieBiaoArr = hm.MyOrder
                self.dingDan = hm.allOrders
                self.chengJiao = hm.successOrders
                self.daiDaKuan = hm.unpaidOrders
                self.initLabel()
                self.productTableView.reloadData()
                if self.lieBiaoArr.count == 0{
                   self.productTableView.hidden = true
                    self.view.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
                    var imageView = UIImageView()
                    imageView = UIImageView(frame: CGRectMake(B.SCREEN_WIDTH / 2 - 40 , B.SCREEN_HEIGHT / 2 - 80, 80 , 80))
                    imageView.image = UIImage(named:"no_item_order")
                    self.view.addSubview(imageView)
                    
                    let mobileLabel = UILabel(frame: CGRectMake(10 , B.SCREEN_HEIGHT / 2 + 10, B.SCREEN_WIDTH - 20, 30))
                    mobileLabel.font = UIFont.systemFontOfSize(17)
                    mobileLabel.text = "您还没有相关订单"
                    mobileLabel.textAlignment = NSTextAlignment.Center
                    mobileLabel.textColor = UIColor(red: 172/255, green: 172/255, blue: 173/255, alpha: 1)
                    self.view.addSubview(mobileLabel)

                    let xuanButton = UIButton(frame: CGRectMake( 20 ,B.SCREEN_HEIGHT / 2 + 40 , B.SCREEN_WIDTH - 40 ,70 ))
                    xuanButton.setBackgroundImage(UIImage(named:"queding-1"),forState:.Normal)
                    xuanButton.addTarget(self,action:Selector("myButton:"),forControlEvents:.TouchUpInside)
                    self.view.addSubview(xuanButton)

                    
                    
                    
//                self.initLabel()
                }else{
                
                }
            }
   
        }
        
    }
    
    func initView(){
        
        initNav("我的订单")
        self.initTableView()
    }
    func initLabel(){

        zongShuLB.layer.masksToBounds = true
        zongShuLB.layer.cornerRadius = 7
        

        if dingDan < 10 {
            
        zongShu_wight.constant = 15
        zongShuLB.text = String(dingDan)
            
        }else{
        
        zongShu_wight.constant = 25
        zongShuLB.text = String(dingDan)
        }
            
        chengJiaoLB.layer.masksToBounds = true
        chengJiaoLB.layer.cornerRadius = 7
        if chengJiao < 10 {
            
            chengJiao_wight.constant = 15
            chengJiaoLB.text = String(chengJiao)
            
        }else{
            
            chengJiao_wight.constant = 25
            chengJiaoLB.text = String(chengJiao)
        }

        daKuanLB.layer.masksToBounds = true
        daKuanLB.layer.cornerRadius = 7
        if daiDaKuan < 10 {
            
            daKuan_wight.constant = 15
            daKuanLB.text = String(daiDaKuan)
            
        }else{
            
            daKuan_wight.constant = 25
            daKuanLB.text = String(daiDaKuan)
        }

    }
    
    func initTableView(){
        productTableView =  UITableView(frame: CGRectMake(0, 60, self.view.bounds.size.width, self.view.bounds.size.height - 49 - 44 - 60 - 20), style: UITableViewStyle.Plain)
        self.view.addSubview(productTableView)
        productTableView.delegate = self
        productTableView.dataSource = self
        productTableView.registerClass(RichesCell.self, forCellReuseIdentifier: "productMain")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.lieBiaoArr != nil{
            return self.lieBiaoArr.count
        }else{
            return 0
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 129
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("productMain", forIndexPath: indexPath) as! RichesCell
        if self.lieBiaoArr != nil{
        
//          print(self.lieBiaoArr[indexPath.section].status)
        if self.lieBiaoArr[indexPath.section].status  == "2"{
            cell.nameLabel?.text = self.lieBiaoArr[indexPath.section].productName
            let string = NSString(string: self.lieBiaoArr[indexPath.section].orderDate)
            
            let timeSta:NSTimeInterval = string.doubleValue
            let dfmatter = NSDateFormatter()
            dfmatter.dateFormat="yyyy年MM月dd日 HH:mm:ss"
            
            let date = NSDate(timeIntervalSince1970: timeSta)
            
            print(dfmatter.stringFromDate(date))

            cell.dateLabel?.text = dfmatter.stringFromDate(date)
            cell.moneyLabel?.text = "\(self.lieBiaoArr[indexPath.section].money)元"
            cell.auditorLabel?.text = "预约待审核"
            
            cell.cancelButton?.hidden = true
            cell.modificationButton?.hidden = true
            cell.selectButton?.hidden = true
            cell.modificationButton2?.hidden = false
            cell.modificationButton2?.addTarget(self,action:Selector("xiuGaiDiZhi:"),forControlEvents:.TouchDown)
            cell.modificationButton2?.tag = indexPath.section
            cell.cancelButton2?.hidden = false
            cell.shangchunButton?.hidden = true
            cell.chongxin?.hidden = true
            cell.shangchunButton1?.hidden = true
            cell.cancelButton2?.addTarget(self,action:Selector("quXiaoYuYue2:"),forControlEvents:.TouchDown)
            cell.cancelButton2?.tag = indexPath.section
        }else if self.lieBiaoArr[indexPath.section].status  == "3"{
            cell.nameLabel?.text = self.lieBiaoArr[indexPath.section].productName
            let string = NSString(string: self.lieBiaoArr[indexPath.section].orderDate)
            
            let timeSta:NSTimeInterval = string.doubleValue
            let dfmatter = NSDateFormatter()
            dfmatter.dateFormat="yyyy年MM月dd日 HH:mm:ss"
            
            let date = NSDate(timeIntervalSince1970: timeSta)
            
            print(dfmatter.stringFromDate(date))
            
            cell.dateLabel?.text = dfmatter.stringFromDate(date)
            cell.moneyLabel?.text = "\(self.lieBiaoArr[indexPath.section].money)元"
            cell.auditorLabel?.text = "预约成功"
            cell.cancelButton?.hidden = false
            cell.cancelButton?.addTarget(self,action:Selector("quXiaoYuYue2:"),forControlEvents:.TouchDown)
            cell.cancelButton?.tag = indexPath.section
            cell.modificationButton?.hidden = false
            cell.modificationButton?.addTarget(self,action:Selector("xiuGaiDiZhi:"),forControlEvents:.TouchDown)
            cell.modificationButton?.tag = indexPath.section
            cell.selectButton?.hidden = false
            cell.selectButton?.addTarget(self,action:Selector("shangChang1:"),forControlEvents:.TouchDown)
            cell.selectButton?.tag = indexPath.section
            cell.modificationButton2?.hidden = true
            cell.cancelButton2?.hidden = true
            cell.shangchunButton?.hidden = true
            cell.chongxin?.hidden = true
            cell.shangchunButton1?.hidden = true
        }else if self.lieBiaoArr[indexPath.section].status  == "4"{
            cell.nameLabel?.text = self.lieBiaoArr[indexPath.section].productName
            let string = NSString(string: self.lieBiaoArr[indexPath.section].orderDate)
            
            let timeSta:NSTimeInterval = string.doubleValue
            let dfmatter = NSDateFormatter()
            dfmatter.dateFormat="yyyy年MM月dd日 HH:mm:ss"
            
            let date = NSDate(timeIntervalSince1970: timeSta)
            
            print(dfmatter.stringFromDate(date))
            
            cell.dateLabel?.text = dfmatter.stringFromDate(date)
            cell.moneyLabel?.text = "\(self.lieBiaoArr[indexPath.section].money)元"
            cell.auditorLabel?.text = "重新上传打款凭证"
            cell.cancelButton?.hidden = true
            cell.modificationButton?.hidden = true
            cell.selectButton?.hidden = false
            cell.selectButton?.addTarget(self,action:Selector("shangChang1:"),forControlEvents:.TouchDown)
            cell.selectButton?.tag = indexPath.section
            cell.modificationButton2?.hidden = true
            cell.cancelButton2?.hidden = true
            cell.shangchunButton?.hidden = true
            cell.chongxin?.hidden = true
            cell.shangchunButton1?.hidden = true
        }else if self.lieBiaoArr[indexPath.section].status  == "5"{
            cell.nameLabel?.text = self.lieBiaoArr[indexPath.section].productName
            let string = NSString(string: self.lieBiaoArr[indexPath.section].orderDate)
            
            let timeSta:NSTimeInterval = string.doubleValue
            let dfmatter = NSDateFormatter()
            dfmatter.dateFormat="yyyy年MM月dd日 HH:mm:ss"
            
            let date = NSDate(timeIntervalSince1970: timeSta)
            
            print(dfmatter.stringFromDate(date))
            
            cell.dateLabel?.text = dfmatter.stringFromDate(date)
            cell.moneyLabel?.text = "\(self.lieBiaoArr[indexPath.section].money)元"
            cell.auditorLabel?.text = "打款凭证审核"
            cell.cancelButton?.hidden = true
            cell.modificationButton?.hidden = true
            cell.selectButton?.hidden = true
            cell.modificationButton2?.hidden = true
            cell.cancelButton2?.hidden = true
            cell.shangchunButton?.hidden = true
            cell.chongxin?.hidden = true
            cell.shangchunButton1?.hidden = true
        }else if self.lieBiaoArr[indexPath.section].status  == "6"{
            cell.nameLabel?.text = self.lieBiaoArr[indexPath.section].productName
            let string = NSString(string: self.lieBiaoArr[indexPath.section].orderDate)
            
            let timeSta:NSTimeInterval = string.doubleValue
            let dfmatter = NSDateFormatter()
            dfmatter.dateFormat="yyyy年MM月dd日 HH:mm:ss"
            
            let date = NSDate(timeIntervalSince1970: timeSta)
            
            print(dfmatter.stringFromDate(date))
            
            cell.dateLabel?.text = dfmatter.stringFromDate(date)
            cell.moneyLabel?.text = "\(self.lieBiaoArr[indexPath.section].money)元"
            cell.auditorLabel?.text = "客户完成交易"
            cell.cancelButton?.hidden = true
            cell.modificationButton?.hidden = true
            cell.selectButton?.hidden = true
            cell.modificationButton2?.hidden = true
            cell.cancelButton2?.hidden = true
            cell.shangchunButton?.hidden = true
            cell.shangchunButton1?.hidden = false
            cell.shangchunButton1?.addTarget(self,action:Selector("shangChuanQianShu:"),forControlEvents:.TouchDown)
            cell.shangchunButton1?.tag = indexPath.section
            cell.chongxin?.hidden = true
            
        }else if self.lieBiaoArr[indexPath.section].status  == "7"{
            cell.nameLabel?.text = self.lieBiaoArr[indexPath.section].productName
            let string = NSString(string: self.lieBiaoArr[indexPath.section].orderDate)
            
            let timeSta:NSTimeInterval = string.doubleValue
            let dfmatter = NSDateFormatter()
            dfmatter.dateFormat="yyyy年MM月dd日 HH:mm:ss"
            
            let date = NSDate(timeIntervalSince1970: timeSta)
            
            print(dfmatter.stringFromDate(date))
            
            cell.dateLabel?.text = dfmatter.stringFromDate(date)
            cell.moneyLabel?.text = "\(self.lieBiaoArr[indexPath.section].money)元"
            cell.auditorLabel?.text = "重新上传合同"
            cell.cancelButton?.hidden = true
            cell.modificationButton?.hidden = true
            cell.selectButton?.hidden = true
            cell.modificationButton2?.hidden = true
            cell.cancelButton2?.hidden = true
            cell.shangchunButton?.hidden = false
            cell.shangchunButton?.addTarget(self,action:Selector("shangChuanQianShu:"),forControlEvents:.TouchDown)
            cell.shangchunButton?.tag = indexPath.section
            cell.chongxin?.hidden = true
            cell.shangchunButton1?.hidden = true
        }else if self.lieBiaoArr[indexPath.section].status  == "8"{
            cell.nameLabel?.text = self.lieBiaoArr[indexPath.section].productName
            cell.dateLabel?.text = self.lieBiaoArr[indexPath.section].orderDate
            cell.moneyLabel?.text = "\(self.lieBiaoArr[indexPath.section].money)元"
            cell.auditorLabel?.text = "合同签署页审核"
            cell.cancelButton?.hidden = true
            cell.modificationButton?.hidden = true
            cell.selectButton?.hidden = true
            cell.modificationButton2?.hidden = true
            cell.cancelButton2?.hidden = true
            cell.shangchunButton?.hidden = true
            cell.chongxin?.hidden = true
            cell.shangchunButton1?.hidden = true
        }else if self.lieBiaoArr[indexPath.section].status  == "9"{
            cell.nameLabel?.text = self.lieBiaoArr[indexPath.section].productName
            let string = NSString(string: self.lieBiaoArr[indexPath.section].orderDate)
            
            let timeSta:NSTimeInterval = string.doubleValue
            let dfmatter = NSDateFormatter()
            dfmatter.dateFormat="yyyy年MM月dd日 HH:mm:ss"
            
            let date = NSDate(timeIntervalSince1970: timeSta)
            
            print(dfmatter.stringFromDate(date))
            
            cell.dateLabel?.text = dfmatter.stringFromDate(date)
            cell.moneyLabel?.text = "\(self.lieBiaoArr[indexPath.section].money)元"
            cell.auditorLabel?.text = "首次返佣"
            cell.cancelButton?.hidden = true
            cell.modificationButton?.hidden = true
            cell.selectButton?.hidden = true
            cell.modificationButton2?.hidden = true
            cell.cancelButton2?.hidden = true
            cell.shangchunButton?.hidden = true
            cell.chongxin?.hidden = true
            cell.shangchunButton1?.hidden = true
        }else if self.lieBiaoArr[indexPath.section].status  == "10"{
            cell.nameLabel?.text = self.lieBiaoArr[indexPath.section].productName
            let string = NSString(string: self.lieBiaoArr[indexPath.section].orderDate)
            
            let timeSta:NSTimeInterval = string.doubleValue
            let dfmatter = NSDateFormatter()
            dfmatter.dateFormat="yyyy年MM月dd日 HH:mm:ss"
            
            let date = NSDate(timeIntervalSince1970: timeSta)
            
            print(dfmatter.stringFromDate(date))
            
            cell.dateLabel?.text = dfmatter.stringFromDate(date)
            cell.moneyLabel?.text = "\(self.lieBiaoArr[indexPath.section].money)元"
            cell.auditorLabel?.text = "回收合同"
            cell.cancelButton?.hidden = true
            cell.modificationButton?.hidden = true
            cell.selectButton?.hidden = true
            cell.modificationButton2?.hidden = true
            cell.cancelButton2?.hidden = true
            cell.shangchunButton?.hidden = true
            cell.chongxin?.hidden = true
            cell.shangchunButton1?.hidden = true
        }else if self.lieBiaoArr[indexPath.section].status  == "11"{
            cell.nameLabel?.text = self.lieBiaoArr[indexPath.section].productName
            let string = NSString(string: self.lieBiaoArr[indexPath.section].orderDate)
            
            let timeSta:NSTimeInterval = string.doubleValue
            let dfmatter = NSDateFormatter()
            dfmatter.dateFormat="yyyy年MM月dd日 HH:mm:ss"
            
            let date = NSDate(timeIntervalSince1970: timeSta)
            
            print(dfmatter.stringFromDate(date))
            
            cell.dateLabel?.text = dfmatter.stringFromDate(date)
            cell.moneyLabel?.text = "\(self.lieBiaoArr[indexPath.section].money)元"
            cell.auditorLabel?.text = "交易结束，并存入计量"
            cell.cancelButton?.hidden = true
            cell.modificationButton?.hidden = true
            cell.selectButton?.hidden = true
            cell.modificationButton2?.hidden = true
            cell.cancelButton2?.hidden = true
            cell.shangchunButton?.hidden = true
            cell.chongxin?.hidden = true
            cell.shangchunButton1?.hidden = true
        }else if self.lieBiaoArr[indexPath.section].status  == "12"{
            cell.nameLabel?.text = self.lieBiaoArr[indexPath.section].productName
            let string = NSString(string: self.lieBiaoArr[indexPath.section].orderDate)
            
            let timeSta:NSTimeInterval = string.doubleValue
            let dfmatter = NSDateFormatter()
            dfmatter.dateFormat="yyyy年MM月dd日 HH:mm:ss"
            
            let date = NSDate(timeIntervalSince1970: timeSta)
            
            print(dfmatter.stringFromDate(date))
            
            cell.dateLabel?.text = dfmatter.stringFromDate(date)
            cell.moneyLabel?.text = "\(self.lieBiaoArr[indexPath.section].money)元"
            cell.auditorLabel?.text = "订单关闭"
            cell.cancelButton?.hidden = true
            cell.modificationButton?.hidden = true
            cell.selectButton?.hidden = true
            cell.modificationButton2?.hidden = true
            cell.cancelButton2?.hidden = true
            cell.shangchunButton?.hidden = true
            cell.chongxin?.hidden = true
            cell.shangchunButton1?.hidden = true
        }else if self.lieBiaoArr[indexPath.section].status  == "13"{
            cell.nameLabel?.text = self.lieBiaoArr[indexPath.section].productName
            let string = NSString(string: self.lieBiaoArr[indexPath.section].orderDate)
            
            let timeSta:NSTimeInterval = string.doubleValue
            let dfmatter = NSDateFormatter()
            dfmatter.dateFormat="yyyy年MM月dd日 HH:mm:ss"
            
            let date = NSDate(timeIntervalSince1970: timeSta)
            
            print(dfmatter.stringFromDate(date))
            
            cell.dateLabel?.text = dfmatter.stringFromDate(date)
            cell.moneyLabel?.text = "\(self.lieBiaoArr[indexPath.section].money)元"
            cell.auditorLabel?.text = "预约失败"
            cell.cancelButton?.hidden = true
            cell.modificationButton?.hidden = true
            cell.selectButton?.hidden = true
            cell.modificationButton2?.hidden = true
            cell.cancelButton2?.hidden = true
            cell.shangchunButton?.hidden = true
            cell.chongxin?.hidden = false
            cell.chongxin?.addTarget(self,action:Selector("chongXin:"),forControlEvents:.TouchDown)
            cell.chongxin?.tag = indexPath.section
            cell.shangchunButton1?.hidden = true
            }
        }
        return cell
    }
        

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
        let rpvc:DingDanXiangQingNewViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("DingDanXiangQingNewViewController") as! DingDanXiangQingNewViewController
        rpvc.addrId = self.lieBiaoArr[indexPath.section].addrId
        rpvc.orderId = self.lieBiaoArr[indexPath.section].orderId
        rpvc.proId = self.lieBiaoArr[indexPath.section].proId
//        userDefaultsUtil.setket_orderId(self.lieBiaoArr[indexPath.section].orderId)
//        userDefaultsUtil.setkey_addrId(self.lieBiaoArr[indexPath.section].addrId)
        rpvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(rpvc, animated: true)


    }
    
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
//        
//       print("删除删除")
//    }

    func quXiao(button:UIButton){
        
    }
    func xiugai(button:UIButton){
        print("上传打款凭条")
        self.navigationController!.navigationBarHidden = true
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
        let rpvc:ShangChuanDaKuanViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ShangChuanDaKuanViewController") as! ShangChuanDaKuanViewController
        //        rpvc.str = "aaa"
        rpvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(rpvc, animated: true)

        
    }
    func quXiaoYuYue2 (button : UIButton){
//        print(self.lieBiaoArr[button.tag].orderId)
        fenLei.quXiaoDingDan(self.lieBiaoArr[button.tag].orderId) { (data) -> () in
           
            self.productTableView.reloadData()
            self.loadingShow()
            self.fenLei.fenLei { (data) -> () in
                if let hm = data as? ProductMainModel {
                    self.loadingHidden()
                    self.lieBiaoArr = hm.MyOrder
                    self.dingDan = hm.allOrders
                    self.chengJiao = hm.successOrders
                    self.daiDaKuan = hm.unpaidOrders
                    self.initLabel()
                    self.productTableView.reloadData()
                    if self.lieBiaoArr.count == 0{
                        self.productTableView.hidden = true
                        self.view.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
                        var imageView = UIImageView()
                        imageView = UIImageView(frame: CGRectMake(B.SCREEN_WIDTH / 2 - 40 , B.SCREEN_HEIGHT / 2 - 80, 80 , 80))
                        imageView.image = UIImage(named:"no_item_order")
                        self.view.addSubview(imageView)
                        
                        let mobileLabel = UILabel(frame: CGRectMake(10 , B.SCREEN_HEIGHT / 2 + 10, B.SCREEN_WIDTH - 20, 30))
                        mobileLabel.font = UIFont.systemFontOfSize(17)
                        mobileLabel.text = "您还没有相关订单"
                        mobileLabel.textAlignment = NSTextAlignment.Center
                        mobileLabel.textColor = UIColor(red: 172/255, green: 172/255, blue: 173/255, alpha: 1)
                        self.view.addSubview(mobileLabel)
                        
                        let xuanButton = UIButton(frame: CGRectMake( 20 ,B.SCREEN_HEIGHT / 2 + 40 , B.SCREEN_WIDTH - 40 ,70 ))
                        xuanButton.setBackgroundImage(UIImage(named:"queding-1"),forState:.Normal)
                        xuanButton.addTarget(self,action:Selector("myButton:"),forControlEvents:.TouchUpInside)
                        self.view.addSubview(xuanButton)
                        
                        
                        
                        
                        //                self.initLabel()
                    }else{
                        
                    }
                }
                
            }

        }
    }
    func shangChuanQianShu(button: UIButton){
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
        let rpvc:ShangChuanQianShuViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ShangChuanQianShuViewController") as! ShangChuanQianShuViewController
        rpvc.orderId = self.lieBiaoArr[button.tag].orderId
        rpvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(rpvc, animated: true)

    }
    func xiuGaiDiZhi (button : UIButton){
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
        let rpvc:FixAddressViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("FixAddressViewController") as! FixAddressViewController
        rpvc.addrId = self.lieBiaoArr[button.tag].addrId
        print(self.lieBiaoArr[button.tag].addrId)
        rpvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(rpvc, animated: true)
    }
    func chongXin (button:UIButton){
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let rpvc:ImmediatelyViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ImmediatelyViewController") as! ImmediatelyViewController
        rpvc.str = self.lieBiaoArr[button.tag].proId
        rpvc.chongXinYuYue = "重新预约"
        rpvc.orderId = self.lieBiaoArr[button.tag].orderId
        rpvc.addrId = self.lieBiaoArr[button.tag].addrId
        rpvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(rpvc, animated: true)

    }
    func shangChang1(button:UIButton){
        self.navigationController!.navigationBarHidden = true
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
        let rpvc:ShangChuanDaKuanViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ShangChuanDaKuanViewController") as! ShangChuanDaKuanViewController
        rpvc.orderId = self.lieBiaoArr[button.tag].orderId
        rpvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(rpvc, animated: true)
 
    }
    func myButton(button : UIButton){
        print("现在去预约")
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let oneController:UIViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("mainCtrl")
        self.presentViewController(oneController, animated: true, completion: nil)

    }
    
}