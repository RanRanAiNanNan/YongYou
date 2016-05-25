//
//  TransferRecordTableViewController.swift
//  ydzbapp-hybrid
//  债权转让记录 
//  Created by qinxin on 15/9/1.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class TransferRecordTableViewController: BaseTableViewController, PullDownMenuDelegate {
    
    //MARK: - Variable
    var transferMenu: PullDownMenuView!
    var array = [TransferRecordModel]()
    var params = [String:AnyObject]()
    var currentPage: Int = 1
    var headerView = UIView()
    
    //MARK: - Constant
    let service = DealRecordService.getInstance()
    let transferMenuArray = [["产品类型", "定存宝一个月", "定存宝三个月", "定存宝六个月", "定存宝十二个月"], ["交易日期", "一个月", "三个月", "六个月","十二个月"]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        setupRefresh()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    
    //MARK: - Private methods
    
    private func initData() {
        initNav("债权转让")
        params["mm"] = userDefaultsUtil.getMobile()!
        params["days"] = "99"
        params["month"] = "99"
        params["page"] = currentPage
    }
    
    private func addMenu() {
        if transferMenu == nil {
            transferMenu = PullDownMenuView(frame: CGRectMake(0, 0, B.SCREEN_WIDTH, B.MENU_FLITER_HIGHT))
            transferMenu.initWithArray(transferMenuArray, selectedColor: B.MENU_NORMAL_FONT_COLOR)
            transferMenu.delegate = self
            //            var currentTitle = transferMenu.titles[0] as? CATextLayer
            //            currentTitle?.foregroundColor = B.MENU_SELECTED_FONT_COLOR.CGColor
            //            var currentIndicator = transferMenu.indicators[0] as? CAShapeLayer
            //            currentIndicator?.fillColor = B.MENU_SELECTED_FONT_COLOR.CGColor
        }
        view.addSubview(transferMenu)
    }
    
    private func loadData() {
        loadingShow()
        service.loadDataTransferGet(params, calback: { (data) -> () in
            self.array = data as! Array<TransferRecordModel>
            self.tableView.reloadData()
            self.loadingHidden()
        })
    }
    
    func setupRefresh(){
        //上拉刷新
        self.tableView.addHeaderWithCallback({
            self.currentPage = 1
            self.params["page"] = self.currentPage
            self.service.loadDataTransferGet(self.params,
                calback: {
                    data in
                    self.loadingHidden()
                    switch data {
                    case let d as String:
                        KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
                    case let d as Array<TransferRecordModel>:
                        self.array = d
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
            self.params["page"] = ++self.currentPage
            self.service.loadDataTransferGet(self.params,
                calback: {
                    data in
                    self.loadingHidden()
                    switch data {
                    case let d as String:
                        KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
                    case let d as Array<TransferRecordModel>:
                        self.array += d
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
        if array.count > 0 {
            return array.count
        }else{
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Configure the cell...
        if array.count > 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("TransferRecordCell", forIndexPath: indexPath)
            tableView.rowHeight = 160
            //产品名称
            let name: UILabel = cell.viewWithTag(201) as! UILabel
            name.text = array[indexPath.row].name
            //购买金额
            let fund: UILabel = cell.viewWithTag(202) as! UILabel
            fund.text = array[indexPath.row].fund
            //转让收益
            let interestFund: UILabel = cell.viewWithTag(203) as! UILabel
            interestFund.text = array[indexPath.row].interestFund
            //购买时间
            let buyTime: UILabel = cell.viewWithTag(204) as! UILabel
            buyTime.text = array[indexPath.row].buyTime
            //转让时间
            let transferTime: UILabel = cell.viewWithTag(205) as! UILabel
            transferTime.text = array[indexPath.row].transferTime
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
    
    
    //MARK: - table view delegate
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        addMenu()
        return 65
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
        self.transferMenu.center = CGPointMake(B.SCREEN_WIDTH / 2 + scrollView.contentOffset.x,  scrollView.contentOffset.y + B.MENU_FLITER_HIGHT / 2)
        self.transferMenu.tableView.center = CGPointMake(B.SCREEN_WIDTH / 2 + scrollView.contentOffset.x,  transferMenu.height + transferMenu.tableView.frame.height / 2 + scrollView.contentOffset.y)
        self.transferMenu.backGroundView.frame.size.height += scrollView.contentOffset.y
        scrollView.bringSubviewToFront(transferMenu)
    }
}
