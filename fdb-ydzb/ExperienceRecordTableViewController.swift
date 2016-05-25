//
//  ExperienceRecordTableViewController.swift
//  ydzbapp-hybrid
//  体验金记录
//  Created by qinxin on 15/9/11.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class ExperienceRecordTableViewController: BaseTableViewController, PullDownMenuDelegate {

    //MARK: - Variable
    var experienceMenu: PullDownMenuView!
    var service = AssestService.getInstance()
    var array = [ExperienceRecordModel]()
    var currentPage = 1
    var params = [String:AnyObject]()
    
    //MARK: - Constant
    let experienceMenuArray = [["交易类型", "出账", "入账", "冻结", "解冻"], ["交易日期", "一个月", "三个月", "六个月","十二个月"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNav("体验金记录")
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
    
    private func initData() {
        params["mm"] = userDefaultsUtil.getMobile()!
        params["type"] = "99"
        params["month"] = "99"
        params["page"] = currentPage
    }
    
    private func addMenu() {
        if experienceMenu == nil {
            experienceMenu = PullDownMenuView(frame: CGRectMake(0, 0, B.SCREEN_WIDTH, B.MENU_FLITER_HIGHT))
            experienceMenu.initWithArray(experienceMenuArray, selectedColor: B.MENU_NORMAL_FONT_COLOR)
            experienceMenu.delegate = self
//            var currentTitle = experienceMenu.titles[0] as? CATextLayer
//            currentTitle?.foregroundColor = B.MENU_SELECTED_FONT_COLOR.CGColor
//            var currentIndicator = experienceMenu.indicators[0] as? CAShapeLayer
//            currentIndicator?.fillColor = B.MENU_SELECTED_FONT_COLOR.CGColor
        }
        view.addSubview(experienceMenu)
    }
    
    private func loadData() {
        loadingShow()
        service.loadExperienceFund(self.params,
            calback: {
                data in
                self.loadingHidden()
                self.array = data as! Array<ExperienceRecordModel>
                self.tableView.reloadData()
        })
    }
    
    func setupRefresh(){
        //上拉刷新
        self.tableView.addHeaderWithCallback({
            self.currentPage = 1
            self.params["page"] = self.currentPage
            self.service.loadExperienceFund(self.params,
                calback: {
                    data in
                    self.loadingHidden()
                    switch data {
                    case let d as String:
                        KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
                    case let d as Array<ExperienceRecordModel>:
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
            self.service.loadExperienceFund(self.params,
                calback: {
                    data in
                    self.loadingHidden()
                    switch data {
                    case let d as String:
                        KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
                    case let d as Array<ExperienceRecordModel>:
                        if self.array.count > 0 {
                            self.array += d
                        }else{
                           self.params["page"] = --self.currentPage
                        }
                        
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
        
        if array.count > 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ExperienceRecordCell", forIndexPath: indexPath) 
            tableView.rowHeight = 100
            
            //名称
            let name = cell.viewWithTag(501) as! UILabel
            name.text = array[indexPath.row].fundflow
            //金额
            let fund = cell.viewWithTag(502) as! UILabel
            fund.text = array[indexPath.row].fund
            //购买时间
            let buyTime = cell.viewWithTag(503) as! UILabel
            buyTime.text = array[indexPath.row].record_time
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
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRectMake(0, 0, tableView.width, 50))
        header.backgroundColor = B.TABLEVIEW_BG
        return header
    }
    
    
    //MARK: - PullDownMenu Delegate
    
    func pullDownMenu(pullDownMenu: PullDownMenuView!, didSelectRowAtColumn column: NSInteger, didSelectRowAtRow row: NSInteger) {
        changeTitleColor(pullDownMenu, column: column)
        
        switch column {
        case 0:
            if row == 0 {
                params["type"] = "99"
            }else if row == 1 {
                params["type"] = "0"
            }else if row == 2 {
                params["type"] = "1"
            }else if row == 3 {
                params["type"] = "2"
            }else if row == 4 {
                params["type"] = "3"
            }
        case 1:
            if row == 0 {
                params["month"] = "99"
            }else if row == 1 {
                params["month"] = "1"
            }else if row == 2 {
                params["month"] = "3"
            }else if row == 3 {
                params["month"] = "6"
            }else if row == 4 {
                params["month"] = "12"
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
        self.experienceMenu.center = CGPointMake(B.SCREEN_WIDTH / 2 + scrollView.contentOffset.x,  scrollView.contentOffset.y + B.MENU_FLITER_HIGHT / 2)
        self.experienceMenu.tableView.center = CGPointMake(B.SCREEN_WIDTH / 2 + scrollView.contentOffset.x,  experienceMenu.height + experienceMenu.tableView.frame.height / 2 + scrollView.contentOffset.y)
        self.experienceMenu.backGroundView.frame.size.height += scrollView.contentOffset.y
        scrollView.bringSubviewToFront(experienceMenu)
    }

}
