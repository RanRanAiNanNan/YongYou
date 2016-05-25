//
//  YesterdayEarningsRecordModel.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/5/27.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class YesterdayIncomeRecordController: BaseTableViewController{
    
    var assestService = AssestService.getInstance()
    
    var yirmData = Array<YesterdayIncomeRecordModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //加载初始化视图
        initView()
        addTotalIcon()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }
    
    func loadData(){
        loadingShow()
        assestService.loadYesterdayIncomeData({
                data in
                self.loadingHidden()
                switch data {
                case let d as String:
                    KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
                case let d as Array<YesterdayIncomeRecordModel>:
                    self.yirmData = d
                    self.tableView.reloadData()
                default:
                    break
                }
            }
        )
    }
    
    func initView() {
        initNav("昨日收益")
        self.refreshControl?.tintColor = UIColor.whiteColor()
        
    }
    
    //添加合计按钮
    func addTotalIcon(){
        let backBtn = UIButton()
        //let backImage = UIImage(named: "assest_yesterdayTotal_icon")
        backBtn.frame = CGRectMake(0, 0, 50, 20);
        //backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        //backBtn.setImage(backImage, forState: UIControlState.Normal)
        backBtn.setTitle("详情", forState: UIControlState.Normal)
        backBtn.setTitleColor(B.NAV_TITLE_CORLOR, forState: UIControlState.Normal)
        backBtn.addTarget(self, action: "gotoTotal", forControlEvents: UIControlEvents.TouchUpInside)
        let backBtnItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.rightBarButtonItem = backBtnItem
    }
    
    func gotoTotal(){
        gotoPage("Assest", pageName: "yesterdayTotalCtrl")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.yirmData.count == 0 {
            return 1
        }else{
            return self.yirmData.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.yirmData.count > 0 {
            tableView.rowHeight = 110
            let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("YESTERDAY_INCOME_RECORD_CELL", forIndexPath: indexPath) 
            //产品名称
            let productLable:UILabel = cell.viewWithTag(201) as! UILabel!
            productLable.text = self.yirmData[indexPath.row].name
            //收益
            let interestLable:UILabel = cell.viewWithTag(202) as! UILabel!
            interestLable.text = "￥\(self.yirmData[indexPath.row].fund)"
            //时间
            let timeLable:UILabel = cell.viewWithTag(203) as! UILabel!
            timeLable.text = "\(self.yirmData[indexPath.row].time)"
            cell.backgroundColor = UIColor.clearColor()
            return cell
        }else{
            let cell = UITableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier: "YESTERDAY_INCOME_RECORD_CELLNODATA")
            tableView.rowHeight = self.view.frame.height
            cell.textLabel?.text = "暂无数据"
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.textLabel?.font = UIFont.systemFontOfSize(20)
            cell.textLabel?.textColor = UIColor.grayColor()
            cell.textLabel?.textAlignment = .Center
            cell.textLabel?.backgroundColor = UIColor.redColor()
            cell.backgroundColor = B.TABLEVIEW_BG
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    

    
}