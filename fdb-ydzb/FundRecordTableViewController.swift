//
//  FundRecordTableViewController.swift
//  ydzbapp-hybrid
//  资金记录
//  Created by qinxin on 15/9/2.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

struct FUND_LIST {
    static let Notification = "资金记录列表广播"
    static let Model = "资金Model"
    static let Params = "资金过滤参数"
}

class FundRecordTableViewController: BaseTableViewController {
    
    var fundRecordService = FundRecordService.getInstance()
    var fmm = FundMixModel()
    var params = [String:AnyObject]()
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //注册广播
        registerNotification()
        //加载刷新
        setupRefresh()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        let center = NSNotificationCenter.defaultCenter()
        center.removeObserver(self)
    }
    
    private func registerNotification() {
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        center.addObserverForName(FUND_LIST.Notification, object: nil, queue: queue) { notification -> Void in
            if let fm = notification.userInfo?[FUND_LIST.Model] as? FundMixModel {
                self.fmm = fm
                self.tableView.reloadData()
            }
            if let param = notification.userInfo?[FUND_LIST.Params] as? [String:AnyObject] {
                self.params = param
            }
        }
    }
    
    private func setupRefresh(){
        //上拉刷新
        self.tableView.addHeaderWithCallback({
            self.currentPage = 1
            self.params["page"] = self.currentPage
            self.tableView.scrollEnabled = false
            self.fundRecordService.loadDataGet(self.params,
                calback: {
                    data in
                    switch data {
                    case let d as String:
                        KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
                    case let d as FundMixModel:
                        self.fmm.fundRecordData = d.fundRecordData
                        let delayInSeconds:Int64 =  1000000000  * 0
                        let popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
                        dispatch_after(popTime, dispatch_get_main_queue(), {
                            self.tableView.reloadData()
                            self.tableView.headerEndRefreshing()
                            self.tableView.scrollEnabled = true
                        })
                    default:
                        break
                    }
            })
        })
        //下拉刷新
        self.tableView.addFooterWithCallback({
            self.params["page"] = ++self.currentPage
            self.tableView.scrollEnabled = false
            self.fundRecordService.loadDataGet(self.params,
                calback: {
                    data in
                    switch data {
                    case let d as String:
                        KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
                    case let d as FundMixModel:
                        if self.fmm.fundRecordData.count > 0 {
                            self.fmm.fundRecordData += d.fundRecordData
                        }else{
                            self.params["page"] = --self.currentPage
                        }
                        
                        let delayInSeconds:Int64 =  1000000000  * 0
                        let popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
                        dispatch_after(popTime, dispatch_get_main_queue(), {
                            self.tableView.reloadData()
                            self.tableView.footerEndRefreshing()
                            self.tableView.scrollEnabled = true
                        })
                    default:
                        break
                    }
            })
        })
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fmm.fundRecordData.count > 0 {
            return fmm.fundRecordData.count
        }else{
            return 1
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        // Configure the cell...
        if fmm.fundRecordData.count > 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("FundRecordCell", forIndexPath: indexPath) as! FundRecordTableViewCell
             tableView.rowHeight = 55
            //交易类型
            cell.fundflow.text = fmm.fundRecordData[indexPath.row].fundflow
            //资金余额
            cell.balance.text = fmm.fundRecordData[indexPath.row].balance
            //交易时间
            cell.record_time.text = fmm.fundRecordData[indexPath.row].record_time
            //净投值
            if let t = Int(fmm.fundRecordData[indexPath.row].type) {
                if t % 2 == 0 {
                    cell.fund.text = "-\(fmm.fundRecordData[indexPath.row].fund)"
                }else{
                    cell.fund.text = "+\(fmm.fundRecordData[indexPath.row].fund)"
                }
            }
            return cell
        }else{
            let cell = UITableViewCell(frame: CGRectMake(0, 0, view.width, view.height))
            let imageView = UIImageView(image: UIImage(named: "empty_states"))
            imageView.center = CGPointMake(tableView.centerx, tableView.height / 2 - imageView.height / 2 + 22)
            cell.addSubview(imageView)
            cell.backgroundColor = B.TABLEVIEW_BG
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
    }
    
}
