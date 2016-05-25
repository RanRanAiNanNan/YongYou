//
//  MessageRecordTableViewController.swift
//  ydzbapp-hybrid
//  消息记录
//  Created by qinxin on 15/9/12.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class MessageRecordTableViewController: BaseTableViewController, UIAlertViewDelegate {
    
    var headerView: UIView!                             //table header view
    var noticeButton: UIButton!                         //公告按钮
    var messageButton: UIButton!                        //消息按钮
    
    var lineView: UIView!                               //颜色线
    
    var service = AssestService.getInstance()
    var model = [MessageRecordModel]()
    var currentPage = 1
    var params = [String:AnyObject]()
    
    var longCellForRow: String = ""
    var tapCellForRow: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        initNav("消息")
        setupRefresh()
        
//        headerView = UIView(frame: CGRectMake(0, 0, B.SCREEN_WIDTH, 55))
//        headerView.backgroundColor = B.TABLEVIEW_BG
//        
//        noticeButton = UIButton(frame: CGRectMake(0, 0, headerView.width / 2, 55))
//        noticeButton.backgroundColor = UIColor.whiteColor()
//        noticeButton.setTitle("公告", forState: .Normal)
//        noticeButton.setTitleColor(B.LIST_GRAY_TEXT_COLOR, forState: .Normal)
//        noticeButton.setTitleColor(B.LIST_YELLOW_TEXT_COLOR, forState: .Selected)
//        noticeButton.addTarget(self, action: "noticeAction", forControlEvents: .TouchUpInside)
//        noticeButton.selected = true
//        headerView.addSubview(noticeButton)
//        
//        messageButton = UIButton(frame: CGRectMake(noticeButton.right + 1, 0, headerView.width / 2, 55))
//        messageButton.backgroundColor = UIColor.whiteColor()
//        messageButton.setTitle("消息", forState: .Normal)
//        messageButton.setTitleColor(B.LIST_GRAY_TEXT_COLOR, forState: .Normal)
//        messageButton.setTitleColor(B.LIST_YELLOW_TEXT_COLOR, forState: .Selected)
//        messageButton.addTarget(self, action: "messageAction", forControlEvents: .TouchUpInside)
//        headerView.addSubview(messageButton)
//        
//        lineView = UIView(frame: CGRectMake(0, 53, headerView.width / 2, 2))
//        lineView.backgroundColor = B.LIST_YELLOW_TEXT_COLOR
//        headerView.addSubview(lineView)
        
//        tableView.tableHeaderView = headerView
        
        //添加长按
//        let longTap = UILongPressGestureRecognizer(target: self, action: "longAction:")
//        longTap.minimumPressDuration = 1.0
//        tableView.addGestureRecognizer(longTap)
        
        loadData()
    }
    
    private func loadData() {
//        if noticeButton.selected == true {
            params["type"] = "1"
//        }else{
//            params["type"] = "0"
//        }
        params["mm"] = userDefaultsUtil.getMobile()!
        params["page"] = 1
        loadingShow()
        service.loadMessageRecord(self.params,
            calback: {
                data in
                self.model = data as! Array<MessageRecordModel>
                self.tableView.reloadData()
                self.loadingHidden()
        })
    }
    
    func setupRefresh(){
        //上拉刷新
        self.tableView.addHeaderWithCallback({
            self.currentPage = 1
            self.params["page"] = "\(self.currentPage)"
            self.tableView.scrollEnabled = false
            self.service.loadMessageRecord(self.params,
                calback: {
                    data in
                    switch data {
                    case let d as String:
                        KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
                        self.tableView.scrollEnabled = true
                    case let d as Array<MessageRecordModel>:
                        self.model = d
                        let delayInSeconds:Int64 =  1000000000  * 0
                        let popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
                        dispatch_after(popTime, dispatch_get_main_queue(), {
                            self.tableView.reloadData()
                            self.tableView.headerEndRefreshing()
                            self.tableView.scrollEnabled = true
                        })
                    default:
                        self.tableView.scrollEnabled = true
                        break
                    }
            })
        })
        //下拉刷新
        self.tableView.addFooterWithCallback({
            self.params["page"] = ++self.currentPage
            self.tableView.scrollEnabled = false
            self.service.loadMessageRecord(self.params,
                calback: {
                    data in
                    switch data {
                    case let d as String:
                        KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
                    case let d as Array<MessageRecordModel>:
                        if d.count > 0 {
                            self.model += d
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
      
            return model.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        if model.count > 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("MessageRecordCell", forIndexPath: indexPath)
            tableView.rowHeight = 60

            //时间
            let date = cell.viewWithTag(701) as! UILabel
            date.text = model[indexPath.row].createtime
            //内容
            let content = cell.viewWithTag(702) as! UILabel
            content.text = model[indexPath.row].title
            
            return cell
//        }else{
//            let cell = UITableViewCell(frame: CGRectMake(0, 0, view.width, view.height))
//            let imageView = UIImageView(image: UIImage(named: "empty_states"))
//            imageView.center = CGPointMake(tableView.centerx, tableView.height / 2 - imageView.height / 2)
//            cell.addSubview(imageView)
//            cell.backgroundColor = B.TABLEVIEW_BG
//            cell.selectionStyle = UITableViewCellSelectionStyle.None
//            return cell
//        }
    }
    
    
    //MARK: - table view delegate
    
//    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return headerView
//    }
    
//    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
//        tapCellForRow = indexPath.row
//        return indexPath
//    }
    
    
    //MARK: - Action
    
    func noticeAction() {
        noticeButton.selected = true
        messageButton.selected = false
        
        lineView.frame = CGRectMake(0, 53, headerView.width / 2, 2)
        
        params["type"] = "1"
        
        loadData()
    }
    
    func messageAction() {
        noticeButton.selected = false
        messageButton.selected = true
        
        lineView.frame = CGRectMake(headerView.width / 2, 53, headerView.width / 2, 2)
        
        params["type"] = "0"
        
        loadData()
    }
    
    func longAction(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Began {
            let point = sender.locationInView(tableView)
            let indexPath = tableView.indexPathForRowAtPoint(point)
            longCellForRow = model[indexPath!.row].id
            _ = tableView.cellForRowAtIndexPath(indexPath!)
            let av = UIAlertView(title: "提示", message: "是否删除消息", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "删除")
            av.show()
        }
    }
    
    
    //MARK: - UIAlertview delegate
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 {
        }else{
            params["msg_id"] = longCellForRow
            service.deleteMessageRecord(params, calback: { (data) -> () in
                let msg = data as! String
                KGXToast.showToastWithMessage(msg, duration: ToastDisplayDuration.LengthShort)
                self.loadData()
            })
        }
    }
    
    
    //MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMessageDetailSegue" {
            let mdvc:MessageDetailViewController = segue.destinationViewController as! MessageDetailViewController
            mdvc.mm  = model[tapCellForRow]
        }
    }

}
