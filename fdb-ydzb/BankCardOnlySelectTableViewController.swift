//
//  JumuRecordViewController.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/5/20.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit

protocol OnlySelectBankIdDelegate{
    func setSelectBankId(bankId:String);
}
class BankCardOnlySelectTableViewController: BaseTableViewController {
    
    var assestService = AssestService.getInstance()
    
    var bandCardRecordData = Array<BandCarModel>()
    
    var oldSelectRow = ""
    
    var delegate:OnlySelectBankIdDelegate?
    
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
        initNav("选择银行卡")
        addHeadView()
        addFootView()
    }
    //加入head
    func addHeadView(){
        let screenWidth = UIScreen.mainScreen().bounds.width
        let headView = UIView(frame: CGRectMake(0, 0, screenWidth, 15))
        headView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        self.tableView.tableHeaderView = headView
    }
    
    //加入foot
    func addFootView(){
        let screenWidth = UIScreen.mainScreen().bounds.width
        let footView = UIView(frame: CGRectMake(0, 0, screenWidth, 200))
        let imgView = UIImageView(frame: CGRectMake(screenWidth / 2 - 60, 20, 120, 120))
        imgView.image = UIImage(named: "recharge_sum_icon")
        footView.addSubview(imgView)
        
        let firstLab = UILabel()
        firstLab.text = "资金安全由阳光保险承保"
        firstLab.textColor = UIColor.grayColor()
        firstLab.textAlignment = NSTextAlignment.Center
        firstLab.width = 120
        firstLab.frame = CGRectMake(screenWidth / 2 - 100, 150, 200, 20)
        footView.addSubview(firstLab)
        
        let secondLab = UILabel()
        secondLab.text = "极速按约赔付"
        secondLab.textColor = UIColor.grayColor()
        secondLab.textAlignment = NSTextAlignment.Center
        secondLab.width = 120
        secondLab.frame = CGRectMake(screenWidth / 2 - 80, 175, 160, 20)
        footView.addSubview(secondLab)
        
        self.tableView.tableFooterView = footView
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.bandCardRecordData.count == 0 {
            return 1
        }else{
            return self.bandCardRecordData.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if self.bandCardRecordData.count > 0 {
            tableView.rowHeight = 60
            let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("RECHARGE_ONLY_SELECT_BANKCARD_CELL", forIndexPath: indexPath) 
            //银行名
            let bannerNameLable:UILabel = cell.viewWithTag(201) as! UILabel!
            bannerNameLable.text = self.bandCardRecordData[indexPath.row].bankName
            //卡号
            let bannerNoLable:UILabel = cell.viewWithTag(202) as! UILabel!
            bannerNoLable.text = self.bandCardRecordData[indexPath.row].cardNo
            //默认选择
            let selectedImg:UIImageView = cell.viewWithTag(203) as! UIImageView!
            let type = self.bandCardRecordData[indexPath.row].type
            if type == "0" {
                selectedImg.hidden = true
            }else {
                self.oldSelectRow = "\(indexPath.row)"
                selectedImg.hidden = false
            }
            return cell
        }else{
            let cell = UITableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier: "RECHARGE_ONLY_SELECT_BANKCARD_CELL_NODATA")
            tableView.rowHeight = self.view.frame.height
            cell.textLabel?.text = "暂无银行卡数据"
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.textLabel?.font = UIFont.systemFontOfSize(20)
            cell.textLabel?.textColor = UIColor.grayColor()
            cell.textLabel?.textAlignment = .Center
            cell.textLabel?.backgroundColor = UIColor.redColor()
            cell.backgroundColor = B.TABLEVIEW_BG
            return cell
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //println("row:\(indexPath.row) oldselectRow:\(oldSelectRow)")
        if self.bandCardRecordData.count != indexPath.row {
            //if oldSelectRow.toInt() != indexPath.row {
                let bcm:BandCarModel = self.bandCardRecordData[indexPath.row]
                bcm.type = "1"
                //println("oldSelectRow:\(oldSelectRow)")
                let oldbcm:BandCarModel = self.bandCardRecordData[Int(oldSelectRow)!]
                oldbcm.type = "0"
                self.tableView.reloadData()
                if (delegate != nil) {
                    delegate?.setSelectBankId(bcm.id)
                    self.navigationController?.popViewControllerAnimated(true)
                    
                }
            //}
        }
    }
    
}