//
//  StableRecordTableViewController.swift
//  ydzbapp-hybrid
//  稳进宝记录
//  Created by qinxin on 15/9/1.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

struct STABLE_RECORD_LIST {
    static let Notification = "定存宝记录广播"
    static let Params = "定存宝记录参数"
}

class StableRecordTableViewController: BaseTableViewController {
    
    var service = DealRecordService.getInstance()
    var model = StableMixModel()
    var array = [StableRecordModel]()
    var currentPage = 1
    var params = [String:AnyObject]()
    
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
        center.addObserverForName(STABLE_RECORD_LIST.Notification, object: nil, queue: queue) { notification -> Void in
            if let m = notification.userInfo?[STABLE_RECORD_LIST.Params] as? [String:AnyObject] {
                self.params = m
                self.loadData()
            }
        }
    }
    
    private func loadData() {
        service.loadDataStableGet(self.params,
            calback: {
                data in
                self.model = data as! StableMixModel
                self.array = self.model.stableList
                self.tableView.reloadData()
        })
    }
    
    func setupRefresh(){
        //上拉刷新
        self.tableView.addHeaderWithCallback({
            self.currentPage = 1
            self.params["page"] = self.currentPage
            self.service.loadDataStableGet(self.params,
                calback: {
                    data in
                    switch data {
                    case let d as String:
                        KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
                    case let d as Array<StableRecordModel>:
                        self.array = d
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
            self.params["page"] = ++self.currentPage
            self.service.loadDataStableGet(self.params,
                calback: {
                    data in
                    switch data {
                    case let d as String:
                        KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
                    case let d as Array<StableRecordModel>:
                        self.array += d
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
        if array.count > 0 {
            return array.count
        }else{
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if array.count > 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("StableRecordCell", forIndexPath: indexPath)
            tableView.rowHeight = 115
            // Configure the cell...
            let name = cell.viewWithTag(601) as! UILabel
            name.text = array[indexPath.row].productName
            let apr = cell.viewWithTag(602) as! UILabel
            apr.text = array[indexPath.row].apr
            let buy = cell.viewWithTag(603) as! UILabel
            buy.text = array[indexPath.row].fund
            let date = cell.viewWithTag(604) as! UILabel
            let temp = cell.viewWithTag(605) as! UILabel
            if array[indexPath.row].status == "0" {
                date.text = "封闭日期"
                temp.text = array[indexPath.row].closeDate
            }else{
                date.text = "到期收益"
                temp.text = array[indexPath.row].income
            }
            
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
