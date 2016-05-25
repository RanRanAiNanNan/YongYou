//
//  BuyRedpacketTableViewController.swift
//  ydzbapp-hybrid
//  购买红包选择
//  Created by qinxin on 15/9/8.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class BuyRedpacketTableViewController: BaseTableViewController {
    
    var redpacketList = [BuyRedpacketModel]()
    var redId: String = ""
    var redName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNav("选择红包")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if redpacketList.count > 0 {
            return redpacketList.count
        }else{
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Configure the cell...
        if redpacketList.count > 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("BuyRedpacketCell", forIndexPath: indexPath) as! BuyRedpacketTableViewCell
            cell.redId = redpacketList[indexPath.row].id
            if cell.redId == redId {
                cell.rightButton.hidden = false
            }
            cell.productType.text = redpacketList[indexPath.row].productType
            cell.giveValue.text = redpacketList[indexPath.row].giveValue
            cell.getTime.text = redpacketList[indexPath.row].getTime
            cell.name.text = redpacketList[indexPath.row].name
            cell.useFinishTime.text = redpacketList[indexPath.row].useFinishTime
            return cell
        }else{
            let cell = UITableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier: "DEALDEPOSITRECORD_CELL_NODATA")
            tableView.rowHeight = self.view.frame.height
            cell.textLabel?.text = "暂无红包"
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.textLabel?.font = UIFont.systemFontOfSize(20)
            cell.textLabel?.textColor = UIColor.grayColor()
            cell.textLabel?.textAlignment = .Center
            cell.backgroundColor = B.TABLEVIEW_BG
            return cell
        }
        
    }
    
    
    //MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! BuyRedpacketTableViewCell
        let center = NSNotificationCenter.defaultCenter()
        redName = "\(redpacketList[indexPath.row].productType)\(redpacketList[indexPath.row].giveValue)%加息券"
        //发送广播
        let notification = NSNotification(name: REDPACKET.Notification, object: nil, userInfo: [REDPACKET.Name:redName,REDPACKET.RedId:redpacketList[indexPath.row].id,REDPACKET.RedApr:cell.giveValue.text!])
        center.postNotification(notification)
        navigationController?.popViewControllerAnimated(true)
    }
    
    
}
