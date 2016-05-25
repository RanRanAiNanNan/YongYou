//
//  DepositeRecordTableViewController.swift
//  ydzbapp-hybrid
//  定存记录
//  Created by qinxin on 15/8/31.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

struct DEPOSIT_RECORD_LIST {
    static let Notification = "DMM Radio Station"
    static let Key = "DMM Key"
}

class DepositeRecordTableViewController: BaseTableViewController {
    
    var dealRecordService = DealRecordService.getInstance()
    var dmm = DepositeMixModel()
    
    var currentPage = 1
    
    var productId: String = ""                              //产品id
    var transCountId: String = ""                           //转让标识
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //add notification
        addNotification()
        //add refresh
        setupRefresh()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        let center = NSNotificationCenter.defaultCenter()
        center.removeObserver(self)
    }
    
    
    //MARK: - Private Methods
    
    private func addNotification() {
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        center.addObserverForName(DEPOSIT_RECORD_LIST.Notification, object: nil, queue: queue) { notification -> Void in
            if let d = notification.userInfo?[DEPOSIT_RECORD_LIST.Key] as? DepositeMixModel {
                self.dmm = d
                self.tableView.reloadData()
            }
        }
    }
    
    private func setupRefresh(){
        //上拉刷新
        self.tableView.addHeaderWithCallback({
            self.currentPage = 1
            self.dealRecordService.loadDataDepositeGet(self.currentPage,
                calback: {
                    data in
                    self.loadingHidden()
                    switch data {
                    case let d as String:
                        KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
                    case let d as DepositeMixModel:
                        self.dmm.dealRecordList = d.dealRecordList
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
            self.currentPage += 1
            self.dealRecordService.loadDataDepositeGet(self.currentPage,
                calback: {
                    data in
                    self.loadingHidden()
                    switch data {
                    case let d as String:
                        KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
                    case let d as DepositeMixModel:
                        self.dmm.dealRecordList += d.dealRecordList
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
        if dmm.dealRecordList.count > 0 {
            return dmm.dealRecordList.count
        }else{
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Configure the cell...
        if dmm.dealRecordList.count > 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("DepositRecordCell", forIndexPath: indexPath) as! DepositRecordTableViewCell
            tableView.rowHeight = 160
            let dpr: DepositProductRecord = dmm.dealRecordList[indexPath.row]
            cell.productNameLabel.text = dpr.productName
            
            /*  复投图标 [isMode] 0：不显示  1：显示
            转让图标 [transCount] 0：不显示  1：显示 _____ [status] 2：换成转让中图标
            */
            if dpr.isMode != "0" {
                let imageView = UIImageView(frame: CGRectMake(cell.productNameLabel.right + 1, 4, 25, 11))
                imageView.image = UIImage(named: "futou")
                cell.addSubview(imageView)
            }else{
                let imageView = UIImageView(frame: CGRectMake(cell.productNameLabel.right + 1, 4, 25, 11))
                imageView.backgroundColor = UIColor.whiteColor()
                cell.addSubview(imageView)
            }
            
            if dpr.transCount == "1" && dpr.isMode != "0"{
                let imageView = UIImageView(frame: CGRectMake(cell.productNameLabel.right + 25 + 1, 4, 25, 11))
                imageView.image = UIImage(named: "trans_count")
                cell.addSubview(imageView)
            }else if dpr.transCount == "1" && dpr.isMode == "0" {
                let imageView = UIImageView(frame: CGRectMake(cell.productNameLabel.right + 1, 4, 25, 11))
                imageView.image = UIImage(named: "trans_count")
                cell.addSubview(imageView)
            }
            
            if dpr.status == "2" && dpr.isMode != "0"{
                let imageView = UIImageView(frame: CGRectMake(cell.productNameLabel.right + 25 + 1, 4, 25, 11))
                imageView.image = UIImage(named: "trans_ongoing")
                cell.addSubview(imageView)
            }else if dpr.status == "2" && dpr.isMode == "0" {
                let imageView = UIImageView(frame: CGRectMake(cell.productNameLabel.right + 1, 4, 25, 11))
                imageView.image = UIImage(named: "trans_ongoing")
                cell.addSubview(imageView)
            }
            
            //年化收益率
            cell.surplusLabel.text = NSString(format: "%.02f", floor(((dpr.apr as NSString).floatValue + (dpr.vipApr as NSString).floatValue + (dpr.grandApr as NSString).floatValue) * 100) / 100) as String + "%"
            //购买金额
            cell.buyCopiesLabel.text = dpr.buyFund
            
            //到期收益
            if dpr.status == "1" || dpr.status == "3" {
                cell.deadLineTipLabel.text = "到期收益"
                cell.deadLineEargingsLabel.text = dpr.interestFund
            }else{
                cell.deadLineTipLabel.text = "预期收益"
                cell.deadLineEargingsLabel.text = dpr.predictIncome
            }
            
            //购买日期
            cell.buyTimeLabel.text = dpr.buyTime
            //到期日期
            cell.deadLineDateLabel.text = dpr.expireTime
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
    
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if self.dmm.dealRecordList.count > 0 {
            productId = self.dmm.dealRecordList[indexPath.row].id
            transCountId = self.dmm.dealRecordList[indexPath.row].transCount
            return indexPath
        }else{
            return nil
        }
        
    }
    
    //删除重载的cell图片
    override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        for imageView in cell.subviews {
            if imageView.isKindOfClass(UIImageView) {
                imageView.removeFromSuperview()
            }
        }
    }
    
    
    //MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DepositeRecord_Detail" {
            let drdvc: DepositRecordDetailViewController = segue.destinationViewController as! DepositRecordDetailViewController
            drdvc.productId = productId
            drdvc.transCountId = transCountId
        }
    }
    
    
}