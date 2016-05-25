//
//  CurrentRecordTableViewController.swift
//  ydzbapp-hybrid
//  活期宝记录
//  Created by qinxin on 15/8/31.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

struct CURRENT_LIST {
    static let Notification = "活期宝记录列表广播"
    static let Model = "活期宝Model"
    static let Params = "活期宝过滤参数"
}

class CurrentRecordTableViewController: BaseTableViewController {
    
    var model = CurrentMixModel()
    var params = [String:String]()
    var currentPage = 1
    
    let service = DealRecordService.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotification()
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
        center.addObserverForName(CURRENT_LIST.Notification, object: nil, queue: queue) { notification -> Void in
            if let m = notification.userInfo?[CURRENT_LIST.Model] as? CurrentMixModel {
                self.model = m
                self.tableView.reloadData()
            }
            if let param = notification.userInfo?[CURRENT_LIST.Params] as? [String:String] {
                self.params = param
            }
        }
    }
    
    private func setupRefresh(){
        //上拉刷新
        self.tableView.addHeaderWithCallback({
            self.currentPage = 1
            self.params["page"] = "\(self.currentPage)"
            self.service.loadDataDayloanGet(self.params,
                calback: {
                    data in
                    self.loadingHidden()
                    switch data {
                    case let d as String:
                        KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
                    case let d as CurrentMixModel:
                        self.model.dataList = d.dataList
                        let delayInSeconds:Int64 =  1000000000  * 0
                        let popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
                        dispatch_after(popTime, dispatch_get_main_queue(), {
                            self.tableView.reloadData()
                            self.tableView.headerEndRefreshing()
                        })
                    default:
                        break
                    }
            })
        })
        //下拉刷新
        self.tableView.addFooterWithCallback({
            self.params["page"] = "\(++self.currentPage)"
            self.service.loadDataDayloanGet(self.params,
                calback: {
                    data in
                    self.loadingHidden()
                    switch data {
                    case let d as String:
                        KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
                    case let d as CurrentMixModel:
                        if d.dataList.count > 0 {
                            self.model.dataList += d.dataList
                        }else{
                            self.params["page"] = "\(--self.currentPage)"
                        }
                        
                        let delayInSeconds:Int64 =  1000000000  * 0
                        let popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
                        dispatch_after(popTime, dispatch_get_main_queue(), {
                            self.tableView.reloadData()
                            self.tableView.footerEndRefreshing()
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
        if model.dataList.count > 0 {
            return model.dataList.count
        }else{
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Configure the cell...
        if model.dataList.count > 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("CurrentRecordCell", forIndexPath: indexPath) as! CurrentRecordTableViewCell
            tableView.rowHeight = 110
            //产品名称
            cell.name.text = model.dataList[indexPath.row].names
            //交易金额
            cell.fund.text = model.dataList[indexPath.row].fund
            //交易时间
            cell.date.text = model.dataList[indexPath.row].buy_time
            return cell
        }else{
            let cell = UITableViewCell(frame: CGRectMake(0, 0, view.width, view.height))
            let imageView = UIImageView(image: UIImage(named: "empty_states"))
            imageView.center = tableView.center
            cell.addSubview(imageView)
            cell.backgroundColor = B.TABLEVIEW_BG
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
    }
    
}
