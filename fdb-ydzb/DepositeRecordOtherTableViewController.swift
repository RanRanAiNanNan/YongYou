//
//  DepositeRecordOtherTableViewController.swift
//  ydzbapp-hybrid
//  定存宝交易记录
//  Created by qinxin on 15/9/7.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class DepositeRecordOtherTableViewController: BaseTableViewController, PullDownMenuDelegate {
    
    //MARK: - Variable
    var depositMenu: PullDownMenuView!
    var dealRecordService = DealRecordService.getInstance()
    var array = [DepositRecordModel]()
    var currentPage = 1
    var params = [String:AnyObject]()
    
    //MARK: - Constant
    let depositMenuArray = [["产品类型", "定存宝一个月", "定存宝三个月", "定存宝六个月", "定存宝十二个月"], ["交易类型", "购买", "到期", "复投", "债权转让"], ["交易日期", "一个月", "三个月", "六个月","十二个月"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNav("定存宝交易记录")
        initData()
        setupRefresh()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        addMenu()
    }
    
    
    //MARK: - Private methods
    
    private func initData() {
        params["mm"] = userDefaultsUtil.getMobile()!
        params["days"] = "99"
        params["type"] = "99"
        params["month"] = "99"
        params["page"] = currentPage
    }
    
    private func addMenu() {
        if depositMenu == nil {
            depositMenu = PullDownMenuView(frame: CGRectMake(0, 0, B.SCREEN_WIDTH, B.MENU_FLITER_HIGHT))
            depositMenu.initWithArray(depositMenuArray, selectedColor: B.MENU_NORMAL_FONT_COLOR)
            depositMenu.delegate = self
            //            var currentTitle = depositMenu.titles[0] as? CATextLayer
            //            currentTitle?.foregroundColor = B.MENU_SELECTED_FONT_COLOR.CGColor
            //            var currentIndicator = depositMenu.indicators[0] as? CAShapeLayer
            //            currentIndicator?.fillColor = B.MENU_SELECTED_FONT_COLOR.CGColor
        }
        view.addSubview(depositMenu)
    }
    
    private func loadData() {
        loadingShow()
        self.dealRecordService.loadDataDepositeRecordGet(self.params,
            calback: {
                data in
                self.array = data as! Array<DepositRecordModel>
                self.tableView.reloadData()
                self.loadingHidden()
        })
    }
    
    func setupRefresh(){
        //上拉刷新
        self.tableView.addHeaderWithCallback({
            self.currentPage = 1
            self.params["page"] = self.currentPage
            self.tableView.scrollEnabled = false
            self.dealRecordService.loadDataDepositeRecordGet(self.params,
                calback: {
                    data in
                    self.loadingHidden()
                    switch data {
                    case let d as String:
                        KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
                    case let d as Array<DepositRecordModel>:
                        self.array = d
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
            self.dealRecordService.loadDataDepositeRecordGet(self.params,
                calback: {
                    data in
                    self.loadingHidden()
                    switch data {
                    case let d as String:
                        KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
                    case let d as Array<DepositRecordModel>:
                        if d.count == 0 {
                            self.params["page"] = --self.currentPage
                        }else{
                            self.array += d
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
        if array.count > 0 {
            return array.count
        }else{
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Configure the cell...
        if array.count > 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("DepositRecordOtherCell", forIndexPath: indexPath)
            tableView.rowHeight = 110
            //产品名称
            let name = cell.viewWithTag(101) as! UILabel
            name.text = array[indexPath.row].names
            //交易金额
            let fund = cell.viewWithTag(102) as! UILabel
            fund.text = array[indexPath.row].fund
            //交易时间
            let buyTime = cell.viewWithTag(103) as! UILabel
            buyTime.text = array[indexPath.row].buy_time
            //类型
            let status = cell.viewWithTag(104) as! UILabel
            switch array[indexPath.row].type {
            case "1":
                status.text = "购买"
            case "2":
                status.text = "到期"
            case "3":
                status.text = "复投"
            case "4":
                status.text = "债权转让"
            default:
                break
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
    
    //MARK: - table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "Finance", bundle: NSBundle.mainBundle())
        let ppVC:DepositInterestDetailViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("DepositInterestDetailVC") as! DepositInterestDetailViewController
        ppVC.params["id"] = self.array[indexPath.row].id
        ppVC.view.backgroundColor = UIColor.clearColor()
        ppVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        self.presentViewController(ppVC, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRectMake(0, 0, tableView.width, 60))
        header.backgroundColor = B.TABLEVIEW_BG
        return header
    }
    
    
    //MARK: - PullDownMenu Delegate
    
    func pullDownMenu(pullDownMenu: PullDownMenuView!, didSelectRowAtColumn column: NSInteger, didSelectRowAtRow row: NSInteger) {
        changeTitleColor(pullDownMenu, column: column)
        
        switch column {
        case 0:
            switch row {
            case 0:
                params["days"] = "99"
            case 1:
                params["days"] = "30"
            case 2:
                params["days"] = "90"
            case 3:
                params["days"] = "180"
            case 4:
                params["days"] = "365"
            default:
                break
            }
        case 1:
            switch row {
            case 0:
                params["type"] = "99"
            case 1:
                params["type"] = "1"
            case 2:
                params["type"] = "2"
            case 3:
                params["type"] = "3"
            case 4:
                params["type"] = "4"
            default:
                break
            }
        case 2:
            switch row {
            case 0:
                params["month"] = "99"
            case 1:
                params["month"] = "1"
            case 2:
                params["month"] = "3"
            case 3:
                params["month"] = "6"
            case 4:
                params["month"] = "12"
            default:
                break
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
