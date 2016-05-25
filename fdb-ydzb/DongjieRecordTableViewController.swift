//
//  DongjieRecordTableViewController.swift
//  ydzbapp-hybrid
//  冻结记录
//  Created by qinxin on 15/10/8.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

struct DONGJIE_LIST {
    static let Notification = "冻结记录列表广播"
    static let Model = "冻结Model"
}

class DongjieRecordTableViewController: BaseTableViewController {

    var djmm = DongJieMixModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotification()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        let center = NSNotificationCenter.defaultCenter()
        center.removeObserver(self)
    }
    
    private func registerNotification() {
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        center.addObserverForName(DONGJIE_LIST.Notification, object: nil, queue: queue) { notification -> Void in
            if let dm = notification.userInfo?[DONGJIE_LIST.Model] as? DongJieMixModel {
                self.djmm = dm
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if djmm.dataList.count > 0 {
            return djmm.dataList.count
        }else{
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Configure the cell...
        if djmm.dataList.count > 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("FundRecordCell", forIndexPath: indexPath) as! FundRecordTableViewCell
            tableView.rowHeight = 110
            
            //名称
            let name = cell.viewWithTag(901) as! UILabel
            name.text = djmm.dataList[indexPath.row].name
            
            //金额
            let fund = cell.viewWithTag(902) as! UILabel
            fund.text = "¥ \(djmm.dataList[indexPath.row].fund)"
            
            //时间
            let time = cell.viewWithTag(903) as! UILabel
            time.text = djmm.dataList[indexPath.row].time
            
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
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

}
