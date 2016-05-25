//
//  DepositePredictIncomeDetailTableViewController.swift
//  ydzbapp-hybrid
//  定存宝收益详情
//  Created by qinxin on 15/9/6.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class DepositeIncomeDetailTableViewController: BaseTableViewController {
    
    var productId: String = ""
    var dimlist = [DepositInterestModel]()
    var params = [String:AnyObject]()
    let service = YdFinancingService.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    private func initView() {
        initNav("收益详情")
    }
    
    private func loadData() {
        params["id"] = productId
        loadingShow()
        service.depositTradeRecord(params, calback: { (data) -> () in
            self.dimlist = data as! Array<DepositInterestModel>
            self.tableView.reloadData()
            self.loadingHidden()
        })
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dimlist.count > 0 {
            return dimlist.count
        }else{
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Configure the cell...
        if dimlist.count > 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("DepositeIntersetCell", forIndexPath: indexPath) as! DepositeInterestTableViewCell
            tableView.rowHeight = 44
            //收益金额
            cell.fundLabel.text = dimlist[indexPath.row].fund
            //返利日期
            cell.dateLabel.text = dimlist[indexPath.row].date
            //状态
            if dimlist[indexPath.row].status == "0" {
                cell.statusLabel.text = "未结算"
            }else{
                cell.statusLabel.text = "已结算"
            }
            
            return cell
        }else{
            let cell = UITableViewCell(frame: CGRectMake(0, 0, view.width, view.height))
            let imageView = UIImageView(image: UIImage(named: "empty_states"))
            imageView.center = CGPointMake(tableView.centerx, tableView.height / 2 - imageView.height / 2)
            cell.addSubview(imageView)
            cell.backgroundColor = B.TABLEVIEW_BG
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
    }
    
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRectMake(0, 0, B.SCREEN_WIDTH, 50))
        header.backgroundColor = UIColor.whiteColor()
        
        let fund = UILabel(frame: CGRectMake(view.centerx - 40, 3, 80, 44))
        fund.text = "收益金额"
        fund.textColor = B.LIST_YELLOW_TEXT_COLOR
        fund.textAlignment = NSTextAlignment.Center
        fund.font = UIFont.systemFontOfSize(16.0)
        header.addSubview(fund)
        
        let date = UILabel(frame: CGRectMake(8, 3, 80, 44))
        date.text = "返利日期"
        date.textColor = B.LIST_YELLOW_TEXT_COLOR
        date.textAlignment = NSTextAlignment.Center
        date.font = UIFont.systemFontOfSize(16.0)
        header.addSubview(date)
        
        let status = UILabel(frame: CGRectMake(B.SCREEN_WIDTH - 88, 3, 80, 44))
        status.text = "状态"
        status.textColor = B.LIST_YELLOW_TEXT_COLOR
        status.textAlignment = NSTextAlignment.Center
        status.font = UIFont.systemFontOfSize(16.0)
        header.addSubview(status)
        
        return header
    }
    
}
