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

class RechargeRecordController: BaseTableViewController{
    
    var assestService = AssestService.getInstance()
    
    var rechargeRecordData = Array<RechargeRecordModel>()
    
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //加载初始化视图
        initView()
        //加载刷新
        setupRefresh()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }
    
    func setupRefresh(){
        //上拉刷新
        self.tableView.addHeaderWithCallback({
            self.currentPage = 1
            self.assestService.loadRechargeData(self.currentPage,
                calback: {
                    data in
                    self.loadingHidden()
                    switch data {
                    case let d as String:
                        KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
                    case let d as Array<RechargeRecordModel>:
                        self.rechargeRecordData = d
                        let delayInSeconds:Int64 =  1000000000  * 0
                        let popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
                        dispatch_after(popTime, dispatch_get_main_queue(), {
                            self.tableView.reloadData()
                            self.tableView.headerEndRefreshing()
                        })
                    default:
                        break
                    }
                }
            )
        })
        //下拉刷新
        self.tableView.addFooterWithCallback({
            self.currentPage += 1
            self.assestService.loadRechargeData(self.currentPage,
                calback: {
                    data in
                    self.loadingHidden()
                    switch data {
                    case let d as String:
                        KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
                    case let d as Array<RechargeRecordModel>:
                        self.rechargeRecordData += d
                        let delayInSeconds:Int64 =  1000000000  * 0
                        let popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
                        dispatch_after(popTime, dispatch_get_main_queue(), {
                            self.tableView.reloadData()
                            self.tableView.footerEndRefreshing()
                        })
                    default:
                        break
                    }
                }
            )
        })
    }
    
    func loadData(){
        loadingShow()
        assestService.loadRechargeData(1, calback: {
            data in
            self.loadingHidden()
            switch data {
            case let d as String:
                KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
            case let d as Array<RechargeRecordModel>:
                self.rechargeRecordData = d
                self.tableView.reloadData()
            default:
                break
            }
            }
        )
    }
    
    func initView() {
        initNav("充值记录")
        self.refreshControl?.tintColor = UIColor.whiteColor()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.rechargeRecordData.count == 0 {
            return 1
        }else{
            return self.rechargeRecordData.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.rechargeRecordData.count > 0 {
            tableView.rowHeight = 50
            let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("RECHARGE_RECORD_CELL", forIndexPath: indexPath) 
            //收益
            let interestLable:UILabel = cell.viewWithTag(201) as! UILabel!
            interestLable.text = "￥\(self.rechargeRecordData[indexPath.row].fund)"
            //时间
            let timeLable:UILabel = cell.viewWithTag(202) as! UILabel!
            timeLable.text = "日期: \(self.rechargeRecordData[indexPath.row].time)"
            cell.backgroundColor = UIColor.clearColor()
            return cell
        }else{
            let cell = UITableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier: "RECHARGE_RECORD_CELL_NODATA")
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