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

class WithdrawRecordController: BaseTableViewController{
    
    var assestService = AssestService.getInstance()
    
    var withdrawRecordData = Array<WithdrawRecordModel>()
    
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
            self.assestService.loadWithdrawData(self.currentPage,
                calback: {
                    data in
                    self.loadingHidden()
                    switch data {
                    case let d as String:
                        KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
                    case let d as Array<WithdrawRecordModel>:
                        self.withdrawRecordData = d
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
            self.assestService.loadWithdrawData(self.currentPage,
                calback: {
                    data in
                    self.loadingHidden()
                    switch data {
                    case let d as String:
                        KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
                    case let d as Array<WithdrawRecordModel>:
                        self.withdrawRecordData += d
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
        assestService.loadWithdrawData(1, calback: {
            data in
            self.loadingHidden()
            switch data {
            case let d as String:
                KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
            case let d as Array<WithdrawRecordModel>:
                self.withdrawRecordData = d
                self.tableView.reloadData()
            default:
                break
            }
            }
        )
    }
    
    func initView() {
        initNav("提现记录")
        self.refreshControl?.tintColor = UIColor.whiteColor()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.withdrawRecordData.count == 0 {
            return 1
        }else{
            return self.withdrawRecordData.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.withdrawRecordData.count > 0 {
            tableView.rowHeight = 140
            let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("WITHDRAW_RECORD_CELL", forIndexPath: indexPath) 
            //提现金额
            let interestLable:UILabel = cell.viewWithTag(201) as! UILabel!
            interestLable.text = "￥\(self.withdrawRecordData[indexPath.row].fund)"
            //银行卡号
            let bankLable:UILabel = cell.viewWithTag(204) as! UILabel!
            bankLable.text = self.withdrawRecordData[indexPath.row].bank
            //扣费金额
            let feeLable:UILabel = cell.viewWithTag(202) as! UILabel!
            feeLable.text = "￥\(self.withdrawRecordData[indexPath.row].fee)"
            //时间
            let timeLable:UILabel = cell.viewWithTag(203) as! UILabel!
            timeLable.text = self.withdrawRecordData[indexPath.row].time
            cell.backgroundColor = UIColor.clearColor()
            return cell
        }else{
            let cell = UITableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier: "WITHDRAW_RECORD_CELL_NODATA")
            tableView.rowHeight = self.view.frame.height
            let imageView = UIImageView(image: UIImage(named: "empty_states"))
            imageView.center = CGPointMake(tableView.centerx, tableView.height / 2 - imageView.height / 2)
            cell.addSubview(imageView)
            cell.backgroundColor = B.TABLEVIEW_BG
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    
    
}