//
//  SafeBankNewViewController.swift
//  fdb-ydzb
//
//  Created by 123 on 16/4/5.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation
import UIKit


class SafeBankNewViewController: BaseTableViewController {
    
    var assestService = AssestService.getInstance()
    
    var bandCardRecordData = Array<BandCarModel>()
    
    var oldSelectRow = ""
    
    var currentShadeCell:UITableViewCell?
    
    var delTag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //加载初始化视图
        initView()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }
    
    func loadData(){
        loadingShow()
        assestService.bankCardDataGet({
            data in
            self.loadingHidden()
            switch data {
            case let d as String:
                KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
            case let d as Array<BandCarModel>:
                self.bandCardRecordData = d
                self.tableView.reloadData()
            default:
                break
            }
            }
        )
    }
    
    func initView() {
        initNav("银行卡")
        addHeadView()
    }
    //加入head
    func addHeadView(){
        let screenWidth = UIScreen.mainScreen().bounds.width
        let headView = UIView(frame: CGRectMake(0, 0, screenWidth, 15))
        headView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        self.tableView.tableHeaderView = headView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.bandCardRecordData.count == 0 {
            return 1
        }else{
            return self.bandCardRecordData.count + 1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if self.bandCardRecordData.count != indexPath.row {
            //println("row:\(indexPath.row)  type:\(self.bandCardRecordData[indexPath.row].type)")
            let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("SAFECENTER_SELECT_BANKCARD_CELL", forIndexPath: indexPath)
            //银行名
            let bannerNameLable:UILabel = cell.viewWithTag(201) as! UILabel!
            bannerNameLable.text = self.bandCardRecordData[indexPath.row].bankName
            //卡号
            let bannerNoLable:UILabel = cell.viewWithTag(202) as! UILabel!
            bannerNoLable.text = "\(self.bandCardRecordData[indexPath.row].cardNo)"
            //真实姓名
            let realNameLable:UILabel = cell.viewWithTag(205) as! UILabel!
            realNameLable.text = "\(self.bandCardRecordData[indexPath.row].realName)"
            //默认选择
            let selectedImg:UIImageView = cell.viewWithTag(203) as! UIImageView!
            let type = self.bandCardRecordData[indexPath.row].type
            if type == "0" {
                selectedImg.hidden = true
            }else {
                self.oldSelectRow = "\(indexPath.row)"
                selectedImg.hidden = false
            }
            let addBgView:UIView = cell.viewWithTag(204) as UIView!
            addBgView.layer.cornerRadius = 5
            //返回按钮
            let returnBtn = cell.viewWithTag(102) as! UIButton
            returnBtn.addTarget(self, action: "returnClick", forControlEvents: UIControlEvents.TouchUpInside)
            //删除按钮
            let delBtn = cell.viewWithTag(103) as! UIButton
            delBtn.addTarget(self, action: "delClick", forControlEvents: UIControlEvents.TouchUpInside)
            //阴影列表
            let shadeView = cell.viewWithTag(101) as UIView!
            shadeView.hidden = true
            shadeView.layer.cornerRadius = 5
            
            
            //长按手势
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: Selector("longPressCell:"))
            cell.addGestureRecognizer(longPressGesture)
            
            return cell
            
        }else{
            let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("SAFECENTER_SELECT_ADD_CELL", forIndexPath: indexPath)
            let addBgView:UIView = cell.viewWithTag(201) as UIView!
            addBgView.layer.cornerRadius = 5
            return cell
        }
    }
    
    func returnClick(){
        (currentShadeCell?.viewWithTag(101) as UIView!).hidden = true
    }
    
    func delClick(){
        self.loadingShow()
        let bankId = self.bandCardRecordData[delTag].id
        assestService.deleteBankCard(["mm" : userDefaultsUtil.getMobile()!, "bank_id" : bankId], calback: {
            data in
            self.loadingHidden()
            if let mm = data as? MsgModel {
                KGXToast.showToastWithMessage(mm.msg, duration: ToastDisplayDuration.LengthShort)
                if mm.status == 1 {
                    self.bandCardRecordData.removeAtIndex(self.delTag)
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    
    
    func longPressCell(recognizer: UIGestureRecognizer){
        if recognizer.state == UIGestureRecognizerState.Began {
            let location = recognizer.locationInView(self.tableView)
            let indexPath = self.tableView.indexPathForRowAtPoint(location)
            self.delTag = indexPath!.row
            let cell = recognizer.view as! UITableViewCell
            if currentShadeCell != nil {
                (currentShadeCell!.viewWithTag(101) as UIView!).hidden = true
            }
            (cell.viewWithTag(101) as UIView!).hidden = false
            currentShadeCell = cell
        }
        
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //println("row:\(indexPath.row) oldselectRow:\(oldSelectRow)")
        if self.bandCardRecordData.count != indexPath.row {
            if Int(oldSelectRow) != indexPath.row {
                let bcm:BandCarModel = self.bandCardRecordData[indexPath.row]
                
                self.loadingShow()
                assestService.updateDefaultBankCard(["mm" : userDefaultsUtil.getMobile()!, "bank_id" : bcm.id], calback: {
                    data in
                    self.loadingHidden()
                    if let mm = data as? MsgModel {
                        KGXToast.showToastWithMessage(mm.msg, duration: ToastDisplayDuration.LengthShort)
                        if mm.status == 1 {
                            bcm.type = "1"
                            //println("oldSelectRow:\(oldSelectRow)")
                            let oldbcm:BandCarModel = self.bandCardRecordData[Int(self.oldSelectRow)!]
                            oldbcm.type = "0"
                            self.tableView.reloadData()
                        }
                    }
                })
            }
        }else{
            self.performSegueWithIdentifier("addBankCardSegue", sender: nil)
        }
    }
    
}