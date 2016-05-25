//
//  DepositBoughtProductTableViewController.swift
//  ydzbapp-hybrid
//  定存宝已购
//  Created by qinxin on 15/11/3.
//  Copyright © 2015年 银多资本. All rights reserved.
//

import UIKit

class DepositBoughtProductTableViewController: BaseTableViewController {
    
    //MARK: - Variable
    var dealRecordService = DealRecordService.getInstance()
    var dmm = DepositeMixModel()
    var currentPage = 1
    
    var productId: String = ""
    var transCountId: String = ""                   //转让标识
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNav("定存宝已购")
        setupRefresh()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    private func loadData() {
        loadingShow()
        self.currentPage = 1
        self.dealRecordService.loadDataDepositeBoughtProduct(self.currentPage,
            calback: {
                data in
                self.loadingHidden()
                self.dmm = data as! DepositeMixModel
                self.tableView.reloadData()
        })
    }
    
    private func setupRefresh(){
        //上拉刷新
        self.tableView.addHeaderWithCallback({
            self.currentPage = 1
            self.dealRecordService.loadDataDepositeBoughtProduct(self.currentPage,
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
            self.dealRecordService.loadDataDepositeBoughtProduct(self.currentPage,
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
            let cell = tableView.dequeueReusableCellWithIdentifier("DepositBoughtProductCell", forIndexPath: indexPath)
            tableView.rowHeight = 160
            let dpr: DepositProductRecord = dmm.dealRecordList[indexPath.row]
            let productNameLabel = cell.viewWithTag(801) as! UILabel
            productNameLabel.text = dpr.productName
            
            /*  复投图标 [isMode] 0：不显示  1：显示
            转让图标 [transCount] 0：不显示  1：显示 _____ [status] 2：换成转让中图标
            */
            if dpr.isMode != "0" {
                let imageView = UIImageView(frame: CGRectMake(productNameLabel.right + 1, 4, 25, 11))
                imageView.image = UIImage(named: "futou")
                cell.addSubview(imageView)
            }else{
                let imageView = UIImageView(frame: CGRectMake(productNameLabel.right + 1, 4, 25, 11))
                imageView.backgroundColor = UIColor.whiteColor()
                cell.addSubview(imageView)
            }
            
            if dpr.transCount == "1" && dpr.isMode != "0"{
                let imageView = UIImageView(frame: CGRectMake(productNameLabel.right + 25 + 1, 4, 25, 11))
                imageView.image = UIImage(named: "trans_count")
                cell.addSubview(imageView)
            }else if dpr.transCount == "1" && dpr.isMode == "0" {
                let imageView = UIImageView(frame: CGRectMake(productNameLabel.right + 1, 4, 25, 11))
                imageView.image = UIImage(named: "trans_count")
                cell.addSubview(imageView)
            }
            
            if dpr.status == "2" && dpr.isMode != "0"{
                let imageView = UIImageView(frame: CGRectMake(productNameLabel.right + 25 + 1, 4, 25, 11))
                imageView.image = UIImage(named: "trans_ongoing")
                cell.addSubview(imageView)
            }else if dpr.status == "2" && dpr.isMode == "0" {
                let imageView = UIImageView(frame: CGRectMake(productNameLabel.right + 1, 4, 25, 11))
                imageView.image = UIImage(named: "trans_ongoing")
                cell.addSubview(imageView)
            }
            
            //转让状态
            let statusLabel = cell.viewWithTag(802) as! UILabel
            if dpr.status == "0" {
                statusLabel.text = "未到期"
            }else if dpr.status == "1" {
                statusLabel.text = "已到期"
            }else if dpr.status == "2" {
                statusLabel.text = "转让中"
            }else if dpr.status == "3" {
                statusLabel.text = "已转让"
            }
            
            //购买金额
            let buyCopiesLabel = cell.viewWithTag(803) as! UILabel
            buyCopiesLabel.text = dpr.buyFund
            
            //年化收益率
            let surplusLabel = cell.viewWithTag(804) as! UILabel
            surplusLabel.text = NSString(format: "%.02f", floor(((dpr.apr as NSString).floatValue + (dpr.vipApr as NSString).floatValue + (dpr.grandApr as NSString).floatValue) * 100) / 100) as String + "%"
            
            //购买时间
            let buyTimeLabel = cell.viewWithTag(805) as! UILabel
            buyTimeLabel.text = dpr.buyTime
            
            //到期时间
            let deadLineDateLabel = cell.viewWithTag(806) as! UILabel
            deadLineDateLabel.text = dpr.expireTime
            
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
        if segue.identifier == "DepositBoughtProduct_Detail" {
            let drdvc: DepositRecordDetailViewController = segue.destinationViewController as! DepositRecordDetailViewController
            drdvc.productId = productId
            drdvc.transCountId = transCountId
        }
    }
    
    
}
