//
//  TransferBuyTableViewController.swift
//  ydzbapp-hybrid
//  债权转让购买
//  Created by qinxin on 15/9/1.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit
import SwiftyJSON

class TransferBuyTableViewController: BaseTableViewController, PullDownMenuDelegate {
    
    let service = YdFinancingService()
    
    var depositMenu: PullDownMenuView!
    var keyArr = [String]()
    var valueArr = [String]()
    let dataArr = ["产品类型","定存宝三个月","定存宝六个月","定存宝十二个月"]
    var moneyArr = Dictionary<String, Array<AnyObject>>()
    var depositMenuArray = Array<Array<String>>()
    var tbmlist = [TransferBuyModel]()
    var currentPage = 1
    var params = [String:AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setupRefresh()
        addHelpCenter("transfer")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    
    //MARK: - Private methods
    
    private func initView() {
        initNav("债权转让")
        params["mm"] = userDefaultsUtil.getMobile()!
    }
    
    private func loadData() {
        loadingShow()
        //        print("params = \(params)")
        service.transferList(params, calback: { (data) -> () in
            self.tbmlist = (data as! TransferBuyMixModel).dataList
            self.moneyArr = (data as! TransferBuyMixModel).moneyArr
            
            //排序与字符数组内容判断
            let arr = self.moneyArr.sort({ $0.0 < $1.0 })
            self.valueArr.append("转让金额")
            for (key,value) in arr {
                self.keyArr.append(key)
                var valueStr = "\(value[0])元 ~ \(value[1])元"
                if "\(value[1])" == "-1" {
                    valueStr = "\(value[0])元以上"
                }
                if "\(value[0])" == "0" {
                    valueStr = "\(value[1])元以下"
                }
                self.valueArr.append(valueStr)
            }
            
            self.depositMenuArray.append(self.dataArr)
            self.depositMenuArray.append(self.valueArr)
            self.loadingHidden()
            self.tableView.reloadData()
            self.addMenu()
        })
    }
    
    func setupRefresh(){
        //上拉刷新
        self.tableView.addHeaderWithCallback({
            self.currentPage = 1
            self.params["page"] = self.currentPage
            self.tableView.scrollEnabled = false
            self.service.transferList(self.params,
                calback: {
                    data in
                    self.loadingHidden()
                    switch data {
                    case let d as String:
                        KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
                    case let d as TransferBuyMixModel:
                        self.tbmlist = d.dataList
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
            self.service.transferList(self.params,
                calback: {
                    data in
                    self.loadingHidden()
                    switch data {
                    case let d as String:
                        KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
                    case let d as TransferBuyMixModel:
                        self.tbmlist += d.dataList
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
    
    private func addMenu() {
        if depositMenu == nil {
            depositMenu = PullDownMenuView(frame: CGRectMake(0, 0, B.SCREEN_WIDTH, B.MENU_FLITER_HIGHT))
            depositMenu.initWithArray(depositMenuArray, selectedColor: B.MENU_NORMAL_FONT_COLOR)
            depositMenu.delegate = self
            view.addSubview(depositMenu)
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tbmlist.count > 0 {
            return self.tbmlist.count
        }else{
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.tbmlist.count > 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("TransferBuyCell", forIndexPath: indexPath) as! TransferBuyTableViewCell
            // Configure the cell...
            cell.name.text = self.tbmlist[indexPath.row].name
            cell.newApr.text = self.tbmlist[indexPath.row].newApr
            cell.buyFund.text = self.tbmlist[indexPath.row].buyFund
            cell.predictIncome.text = self.tbmlist[indexPath.row].predictIncome
            cell.buyTime.text = self.tbmlist[indexPath.row].buyTime
            cell.expireTime.text = self.tbmlist[indexPath.row].expireTime
            if self.tbmlist[indexPath.row].available == "0" {
                cell.buyButton.enabled = false
                cell.buyButton.backgroundColor = B.BUY_DISABLE_BUTTON_BG
            }else{
                cell.buyButton.enabled = true
                cell.buyButton.tag = Int(self.tbmlist[indexPath.row].id)!
                cell.buyButton.backgroundColor = B.BUY_ENABLE_BUTTON_BG
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
        let header = UIView(frame: CGRectMake(0, 0, tableView.width, 60))
        header.backgroundColor = B.TABLEVIEW_BG
        return header
    }
    
    
    //MARK: - Action
    
    @IBAction func buyAction(sender: UIButton) {
        let alertview = HHAlertView(title: "购买提示", detailText: "确认购买\(fetchName(sender.tag))？", addView: self.view, cancelButtonTitle: "取消", otherButtonTitles: ["确认"])
        alertview.frame = CGRectMake(0, alertview.frame.origin.y - tableView.contentOffset.y, tableView.bounds.width, CGFloat(MAXFLOAT))
        alertview.maskView?.backgroundColor = UIColor.blackColor()
        alertview.show()
        tableView.scrollEnabled = false
        alertview.showWithBlock({ (buttonIndex) -> Void in
            if buttonIndex == 0 {
                self.tableView.scrollEnabled = true
                return
            }else if buttonIndex == 1 {
                self.loadingShow()
                self.service.checkIdCard { (data) -> () in
                    self.tableView.scrollEnabled = true
                    let model = data as! MsgModel
                    if model.status == 1 {
                        self.service.transferListBuy("\(sender.tag)", calback: { (data) -> () in
                            let model = data as! MsgModel
                            if model.status == 1 {
                                self.loadData()
                            }
                            KGXToast.showToastWithMessage(model.msg, duration: ToastDisplayDuration.LengthShort)
                            self.loadingHidden()
                        })
                    }else{
                        //跳转到安全中心
                        self.tableView.scrollEnabled = true
                        KGXToast.showToastWithMessage(model.msg, duration: ToastDisplayDuration.LengthShort)
                        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "SafetyCenter", bundle: NSBundle.mainBundle())
                        let oneController:SafetyViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("safetystoryboard") as! SafetyViewController
                        self.navigationController?.pushViewController(oneController, animated: true)
                        self.loadingHidden()
                    }
                }
            }
        })
    }
    
    func fetchName(tag: Int) -> String {
        for var i = 0; i < tbmlist.count; i++ {
            if tag == Int(tbmlist[i].id)! {
                return tbmlist[i].name
            }
        }
        return ""
    }
    
    
    //MARK: - PullDownMenu Delegate
    
    func pullDownMenu(pullDownMenu: PullDownMenuView!, didSelectRowAtColumn column: NSInteger, didSelectRowAtRow row: NSInteger) {
        
        changeTitleColor(pullDownMenu, column: column)
        
        switch column {
        case 0:
            if row == 0 {
                params["month"] = "99"
            } else if row == 1 {
                params["month"] = "3"
            } else if row == 2 {
                params["month"] = "6"
            } else if row == 3 {
                params["month"] = "12"
            }
        case 1:
            if row == 0 {
                params["money"] = "0"
            } else {
                params["money"] = "\(self.keyArr[row - 1])"
            }
        default:
            break
        }
        
        loadData()
        
    }
    
    func changeTitleColor(pullDownMenu:PullDownMenuView, column: NSInteger) {
        
        for title in pullDownMenu.titles {
            (title as? CATextLayer)?.foregroundColor = B.MENU_NORMAL_FONT_COLOR.CGColor
            if let currentTitle = pullDownMenu.titles[column] as? CATextLayer {
                if currentTitle == title as? CATextLayer {
                    currentTitle.foregroundColor = B.MENU_SELECTED_FONT_COLOR.CGColor
                }
            }
        }
        
        for indicator in pullDownMenu.indicators {
            (indicator as? CAShapeLayer)?.fillColor = B.MENU_NORMAL_FONT_COLOR.CGColor
            if let currentIndicator = pullDownMenu.indicators[column] as? CAShapeLayer {
                if currentIndicator == indicator as? CAShapeLayer {
                    currentIndicator.fillColor = B.MENU_SELECTED_FONT_COLOR.CGColor
                }
            }
        }
    }
    
    
    //MARK: - Scrollview delegate
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        self.depositMenu.center = CGPointMake(B.SCREEN_WIDTH / 2 + scrollView.contentOffset.x,  scrollView.contentOffset.y + B.MENU_FLITER_HIGHT / 2)
        self.depositMenu.tableView.center = CGPointMake(B.SCREEN_WIDTH / 2 + scrollView.contentOffset.x,  depositMenu.height + depositMenu.tableView.frame.height / 2 + scrollView.contentOffset.y)
        self.depositMenu.backGroundView.frame.size.height += scrollView.contentOffset.y
        scrollView.bringSubviewToFront(depositMenu)
    }
    
}
