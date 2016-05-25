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

class TotalIncomeRecordController: BaseTableViewController{
    
    var assestService = AssestService.getInstance()
    
    var tirmData = Array<YesterdayIncomeRecordModel>()
    
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //加载初始化视图
        initView()
        //加载刷新
        setupRefresh()
        addShareIcon()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }
    
    func setupRefresh(){
        //上拉刷新
        self.tableView.addHeaderWithCallback({
            self.currentPage = 1
            self.assestService.loadTotalIncomeData(self.currentPage,
                calback: {
                    data in
                    self.loadingHidden()
                    switch data {
                    case let d as String:
                        KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
                    case let d as Array<YesterdayIncomeRecordModel>:
                        self.tirmData = d
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
            self.assestService.loadTotalIncomeData(self.currentPage,
                calback: {
                    data in
                    self.loadingHidden()
                    switch data {
                    case let d as String:
                        KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
                    case let d as Array<YesterdayIncomeRecordModel>:
                        self.tirmData += d
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
        assestService.loadTotalIncomeData(1, calback: {
            data in
            self.loadingHidden()
            switch data {
            case let d as String:
                KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
            case let d as Array<YesterdayIncomeRecordModel>:
                self.tirmData = d
                self.tableView.reloadData()
            default:
                break
            }
            }
        )
    }
    
    //添加规则按钮
    func addShareIcon(){
        let backBtn = UIButton()
        let backImage = UIImage(named: "assest_share_icon")
        backBtn.frame = CGRectMake(0, 0, backImage!.size.width, backImage!.size.height);
        backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        backBtn.setImage(backImage, forState: UIControlState.Normal)
        backBtn.addTarget(self, action: "gotoShare", forControlEvents: UIControlEvents.TouchUpInside)
        let backBtnItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.rightBarButtonItem = backBtnItem
    }
    
    func gotoShare(){
        gotoPage("Assest", pageName: "revenueShareCtrl")
    }
    
    
    func initView() {
        initNav("累计收益")
        self.refreshControl?.tintColor = UIColor.whiteColor()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tirmData.count == 0 {
            return 1
        }else{
            return self.tirmData.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.tirmData.count > 0 {
            tableView.rowHeight = 110
            let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("TOTAL_INCOME_RECORD_CELL", forIndexPath: indexPath) 
            //产品名称
            let productLable:UILabel = cell.viewWithTag(201) as! UILabel!
            productLable.text = self.tirmData[indexPath.row].name
            //收益
            let interestLable:UILabel = cell.viewWithTag(202) as! UILabel!
            interestLable.text = "￥\(self.tirmData[indexPath.row].fund)"
            //时间
            let timeLable:UILabel = cell.viewWithTag(203) as! UILabel!
            timeLable.text = self.tirmData[indexPath.row].time
            cell.backgroundColor = UIColor.clearColor()
            return cell
        }else{
            let cell = UITableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier: "TOTAL_INCOME_RECORD_CELLNODATA")
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