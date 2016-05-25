//
//  IntoTransferTableViewController.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 16/1/29.
//  Copyright © 2016年 银多资本. All rights reserved.
//

import Foundation
import UIKit

class IntoTransferRecordTableViewController: BaseTableViewController {
    
    var usreCenterService = UserCenterService.getInstance()
    var intoRecordData = Array<IntoTransferRecordModel>()
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
            self.usreCenterService.loadIntoTransferData(self.currentPage,
                calback: {
                    data in
                    self.loadingHidden()
                    switch data {
                    case let d as String:
                        KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
                    case let d as Array<IntoTransferRecordModel>:
                        self.intoRecordData = d
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
            self.usreCenterService.loadIntoTransferData(self.currentPage,
                calback: {
                    data in
                    self.loadingHidden()
                    switch data {
                    case let d as String:
                        KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
                    case let d as Array<IntoTransferRecordModel>:
                        self.intoRecordData += d
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
        usreCenterService.loadIntoTransferData(1, calback: {
            data in
            self.loadingHidden()
            switch data {
            case let d as String:
                KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
            case let d as Array<IntoTransferRecordModel>:
                self.intoRecordData = d
                self.tableView.reloadData()
            default:
                break
            }
            }
        )
    }
    
    func initView() {
        initNav("转入记录")
        self.refreshControl?.tintColor = UIColor.whiteColor()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.intoRecordData.count == 0 {
            return 1
        }else{
            return self.intoRecordData.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.intoRecordData.count > 0 {
            tableView.rowHeight = 80
            let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("INTOTRANSFER_RECORD_CELL", forIndexPath: indexPath)
            //转出帐户
            let mobileLable:UILabel = cell.viewWithTag(201) as! UILabel!
            mobileLable.text = "转出帐户:\(self.intoRecordData[indexPath.row].mobile)"
            //时间            
            let optimeLable:UILabel = cell.viewWithTag(202) as! UILabel!
            optimeLable.text = self.intoRecordData[indexPath.row].optime
            //金额
            let fundLable:UILabel = cell.viewWithTag(203) as! UILabel!
            fundLable.text = "￥\(self.intoRecordData[indexPath.row].fund)"
            //余额
            let usableFundLable:UILabel = cell.viewWithTag(204) as! UILabel!
            usableFundLable.text = "￥\(self.intoRecordData[indexPath.row].usableFund)"
            cell.backgroundColor = UIColor.whiteColor()
            return cell
        }else{
            let cell = UITableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier: "INTOTRANSFER_RECORD_CELL_NODATA")
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