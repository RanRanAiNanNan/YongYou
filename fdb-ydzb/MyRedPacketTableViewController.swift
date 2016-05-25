//
//  MyRedPacketTableViewController.swift
//  ydzbapp-hybrid
//  我的红包
//  Created by qinxin on 15/9/3.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

struct RED_LIST {
    static let Notification = "红包列表广播"
    static let Params = "红包参数"
}

class MyRedPacketTableViewController: BaseTableViewController {
    
    var redpacketService = RedpacketService.getInstance()
    var params = [String:AnyObject]()
    var redpacketData = [RedpacketModel]()
    var redName: String = ""
    var currentPage = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefresh()
        registerNotification()
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        let center = NSNotificationCenter.defaultCenter()
        center.removeObserver(self)
    }
    
    private func setupRefresh(){
        //上拉刷新
        self.tableView.addHeaderWithCallback({
            self.currentPage = 1
            self.params["page"] = self.currentPage
            self.tableView.scrollEnabled = false
            self.redpacketService.loadDataGet(self.params,
                calback: {
                    data in
                    switch data {
                    case let d as String:
                        KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
                    case let d as Array<RedpacketModel>:
                        self.redpacketData = d
                        let delayInSeconds:Int64 =  1000000000  * 0
                        let popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
                        dispatch_after(popTime, dispatch_get_main_queue(), {
                            self.tableView.reloadData()
                            self.tableView.headerEndRefreshing()
                            self.tableView.scrollEnabled = true
                        })
                    default:
                        break
                    }
            })
        })
        //下拉刷新
        self.tableView.addFooterWithCallback({
            self.params["page"] = ++self.currentPage
            self.tableView.scrollEnabled = false
            self.redpacketService.loadDataGet(self.params,
                calback: {
                    data in
                    switch data {
                    case let d as String:
                        KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
                    case let d as Array<RedpacketModel>:
                        if self.redpacketData.count > 0 {
                            self.redpacketData += d
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
    
    private func registerNotification() {
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        center.addObserverForName(RED_LIST.Notification, object: nil, queue: queue) { notification -> Void in
            if let p = notification.userInfo?[RED_LIST.Params] as? [String:AnyObject] {
                self.params = p
                self.loadData()
            }
        }
    }
    
    private func loadData() {
        loadingShow()
        redpacketService.loadDataGet(params, calback: { (data) -> () in
            self.redpacketData = data as! Array<RedpacketModel>
            self.tableView.reloadData()
            self.loadingHidden()
        })
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if redpacketData.count > 0 {
            return redpacketData.count
        }else{
            return 1
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if redpacketData.count > 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("MyRedPacketCell", forIndexPath: indexPath) as! MyRedPacketTableViewCell
            tableView.rowHeight = 90
            
            //清除newGiveValue与newPercent两个UILabel
            for subview in cell.subviews {
                if subview.tag == 101 || subview.tag == 102 {
                    subview.removeFromSuperview()
                } 
            }
            
            //红包类型
            switch redpacketData[indexPath.row].redpacketType {
                case "1" :
                    cell.percent.text = "元"
                    cell.addRates.hidden = true
                    cell.giveValue.hidden = true
                    cell.percent.hidden = true
                    let newGiveValue = UILabel(frame: CGRectMake(45, 22, 55, 26))
                    newGiveValue.tag = 101
                    newGiveValue.font = cell.giveValue.font
                    newGiveValue.adjustsFontSizeToFitWidth = true
                    newGiveValue.textAlignment = .Right
                    newGiveValue.textColor = cell.giveValue.textColor
                    newGiveValue.text = redpacketData[indexPath.row].giveValue
                    cell.addSubview(newGiveValue)
                    let newPercent = UILabel(frame: CGRectMake(newGiveValue.right, 30, 14, 14))
                    newPercent.tag = 102
                    newPercent.font = cell.percent.font
                    newPercent.textAlignment = .Right
                    newPercent.textColor = cell.percent.textColor
                    newPercent.text = cell.percent.text
                    cell.addSubview(newPercent)
                case "2":
                    cell.addRates.hidden = false
                    cell.giveValue.hidden = false
                    cell.percent.hidden = false
                    cell.addRates.text = "加息券"
                    cell.percent.text = "%"
                default:
                    break
            }
            
            //红包颜色
            if redpacketData[indexPath.row].status != "1" {
                cell.useButton.hidden = true
                cell.redpackLeftBg.image = UIImage(named: "redpack_item_used_left_bg")
                cell.redpackRightbg.image = UIImage(named: "redpack_item_used_right_bg")
            }else{
                cell.useButton.hidden = false
                cell.redpackLeftBg.image = UIImage(named: "redpack_item_unused_left_bg")
                cell.redpackRightbg.image = UIImage(named: "redpack_item_unused_right_bg")
            }
            
            //红包id
            if let id = Int(self.redpacketData[indexPath.row].id) {
                cell.useButton.tag = id
            }
            
            //领用点击
            switch redpacketData[indexPath.row].use {
                case "1":
                    cell.useButton.addTapAction("currentBuyAction:", target: self)
                case "2":
                    cell.useButton.addTapAction("dingcunBuyAction:", target: self)
                case "3":
                    cell.useButton.addTapAction("cashBuyAction:", target: self)
                case "4":
                    cell.useButton.backgroundColor = B.LIST_GRAY_BG_COLOR
                    cell.useButton.addTapAction("shareAfterAction", target: self)
                default:
                    break
            }
            
            //红包文字
            if params["status"]?.stringValue == "3" || params["status"]?.stringValue == "4" {
                cell.validTimeLabel.text = "到期时间: "
            }else{
                cell.validTimeLabel.text = "有效期至: "
            }
            
            cell.productType.text = redpacketData[indexPath.row].productType
            cell.giveValue.text = redpacketData[indexPath.row].giveValue
            cell.getTime.text = redpacketData[indexPath.row].getTime
            cell.useFinishTime.text = redpacketData[indexPath.row].useFinishTime
            cell.name.text = redpacketData[indexPath.row].name
            
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
    
    
    //MARK: - Action
    
    //活期宝红包
    func currentBuyAction(sender:UITapGestureRecognizer) {
        let alertview = HHAlertView(title: "红包提示", detailText: "是否领用该红包？", addView: self.view, cancelButtonTitle: "取消", otherButtonTitles: ["确认"])
        alertview.frame = CGRectMake(0, alertview.frame.origin.y - tableView.contentOffset.y, tableView.bounds.width, CGFloat(MAXFLOAT))
        alertview.layer.cornerRadius = 5
        alertview.show()
        alertview.showWithBlock({ (buttonIndex) -> Void in
            if buttonIndex == 0 {
                return
            }else if buttonIndex == 1 {
                self.loadingShow()
                if let tag = sender.view?.tag {
                    self.redpacketService.useCurrentRedpacket("\(tag)", calback: { (data) -> () in
                        self.loadingHidden()
                        let model = data as! MsgModel
                        KGXToast.showToastWithMessage(model.msg, duration: ToastDisplayDuration.LengthShort)
                        if model.status == 1 {
                            self.loadData()
                        }
                    })
                }else{
                    //println("红包id错误")
                    self.loadingHidden()
                }
            }
        })
    }
    
    //定存宝红包
    func dingcunBuyAction(sender:UITapGestureRecognizer) {
        let alertview = HHAlertView(title: "红包提示", detailText: "是否领用该红包？", addView: self.view, cancelButtonTitle: "取消", otherButtonTitles: ["确认"])
        alertview.frame = CGRectMake(0, alertview.frame.origin.y - tableView.contentOffset.y, tableView.bounds.width, CGFloat(MAXFLOAT))
        alertview.layer.cornerRadius = 5
        alertview.show()
        alertview.showWithBlock({ (buttonIndex) -> Void in
            if buttonIndex == 0 {
                return
            }else if buttonIndex == 1 {
                self.loadingShow()
                if let tag = sender.view?.tag {
                    let oneStoryBoard:UIStoryboard = UIStoryboard(name: "Finance", bundle: NSBundle.mainBundle())
                    let oneController:DepositFastBuyViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("depositMainCtrl") as! DepositFastBuyViewController
                    oneController.redpacket_id = "\(tag)"
                    oneController.redpacketName = self.red(tag)
                    self.navigationController?.pushViewController(oneController, animated: true)
                }else{
                    //println("红包id错误")
                    self.loadingHidden()
                }
            }
        })
    }
    
    func red(tag: Int) -> String {
        let t = "\(tag)"
        for var i = 0; i < redpacketData.count; i++ {
            if t == redpacketData[i].id {
                return "\(redpacketData[i].productType)\(redpacketData[i].giveValue)%加息券"
            }
        }
        return ""
    }
    
    //现金红包
    func cashBuyAction(sender: UITapGestureRecognizer) {
        let alertview = HHAlertView(title: "红包提示", detailText: "是否领用该红包？", addView: self.view, cancelButtonTitle: "取消", otherButtonTitles: ["确认"])
        alertview.frame = CGRectMake(0, alertview.frame.origin.y - tableView.contentOffset.y, tableView.bounds.width, CGFloat(MAXFLOAT))
        alertview.layer.cornerRadius = 5
        alertview.show()
        alertview.showWithBlock({ (buttonIndex) -> Void in
            if buttonIndex == 0 {
                return
            }else if buttonIndex == 1 {
                self.loadingShow()
                if let tag = sender.view?.tag {
                    self.redpacketService.useCashRedpacket("\(tag)", calback: { (data) -> () in
                        let model = data as! MsgModel
                        KGXToast.showToastWithMessage(model.msg, duration: ToastDisplayDuration.LengthShort)
                        if model.status == 1 {
                            self.loadData()
                        }
                    })
                }else{
                    //println("红包id错误")
                    self.loadingHidden()
                }
            }
        })
    }
    
    func shareAfterAction() {
        KGXToast.showToastWithMessage("需分享后才能领用", duration: ToastDisplayDuration.LengthShort)
    }
    
}
