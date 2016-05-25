//
//  ExperienceFundTableViewController.swift
//  ydzbapp-hybrid
//  我的体验金记录
//  Created by qinxin on 15/9/2.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class ExperienceFundTableViewController: BaseTableViewController {
    
    @IBOutlet weak var imageViewBg: UIImageView! {          //背景图片
        didSet {
            imageViewBg.userInteractionEnabled = true
            imageViewBg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "rightAction"))
        }
    }
    var tipExpfund: UILabel!                                //体验金
    var expfund: UILabel!                                   //体验金值
    var rightButton: UIButton!                              //体验金记录
    
    var headerView: UIView!                                 //table header view
    var totalButton: UIButton!                              //全部
    var undateButton: UIButton!                             //未到期
    var dateButton: UIButton!                               //已到期
    
    var lineView: UIView!                                   //底部颜色线
    
    var service = AssestService.getInstance()
    var model = MyExperienceFundMixModel()
    var array = [MyExperienceModel]()
    var currentPage = 1
    var params = [String:AnyObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        addHelpCenter("")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        addView()
    }
    
    private func initView() {
        initNav("我的体验金")
        setupRefresh()
        params["mm"] = userDefaultsUtil.getMobile()!
        params["status"] = "99"// 99,0,1
        params["page"] = currentPage
        
        headerView = UIView(frame: CGRectMake(0, 0, B.SCREEN_WIDTH, 55))
        headerView.backgroundColor = B.TABLEVIEW_BG
        
        lineView = UIView(frame: CGRectMake(0, 55, headerView.width / 3, 2))
        lineView.backgroundColor = B.LIST_YELLOW_TEXT_COLOR
        headerView.addSubview(lineView)
        
        totalButton = UIButton(frame: CGRectMake(0, 0, headerView.width / 3, 55))
        totalButton.backgroundColor = UIColor.whiteColor()
        totalButton.setTitle("全部", forState: .Normal)
        totalButton.setTitleColor(B.LIST_GRAY_TEXT_COLOR, forState: .Normal)
        totalButton.setTitleColor(B.LIST_YELLOW_TEXT_COLOR, forState: .Selected)
        totalButton.addTarget(self, action: "totalAction", forControlEvents: .TouchUpInside)
        totalButton.selected = true
        headerView.addSubview(totalButton)
        
        undateButton = UIButton(frame: CGRectMake(totalButton.right + 1, 0, headerView.width / 3, 55))
        undateButton.backgroundColor = UIColor.whiteColor()
        undateButton.setTitle("未到期", forState: .Normal)
        undateButton.setTitleColor(B.LIST_GRAY_TEXT_COLOR, forState: .Normal)
        undateButton.setTitleColor(B.LIST_YELLOW_TEXT_COLOR, forState: .Selected)
        undateButton.addTarget(self, action: "undateAction", forControlEvents: .TouchUpInside)
        headerView.addSubview(undateButton)
        
        dateButton = UIButton(frame: CGRectMake(undateButton.right + 1, 0, headerView.width / 3, 55))
        dateButton.backgroundColor = UIColor.whiteColor()
        dateButton.setTitle("已到期", forState: .Normal)
        dateButton.setTitleColor(B.LIST_GRAY_TEXT_COLOR, forState: .Normal)
        dateButton.setTitleColor(B.LIST_YELLOW_TEXT_COLOR, forState: .Selected)
        dateButton.addTarget(self, action: "dateAction", forControlEvents: .TouchUpInside)
        headerView.addSubview(dateButton)
    }
    
    private func loadData() {
        loadingShow()
        service.loadMyExperienceFund(self.params,
            calback: {
                data in
                self.loadingHidden()
                self.model = data as! MyExperienceFundMixModel
                self.array = self.model.expList
                self.tableView.reloadData()
        })
    }
    
    private func addView() {
        if tipExpfund == nil {
            tipExpfund = UILabel(frame: CGRectMake(8, 20, 200, 20))
            tipExpfund.text = "体验金余额(元)"
            tipExpfund.textColor = UIColor.whiteColor()
            tipExpfund.font = UIFont.systemFontOfSize(15)
            imageViewBg.addSubview(tipExpfund)
        }
        
        if expfund == nil {
            expfund = UILabel(frame: CGRectMake(8, tipExpfund.bottom, 200, 50))
            expfund.textColor = B.BUY_COFFEE_TEXT_COLOR
            expfund.font = UIFont.systemFontOfSize(35)
            imageViewBg.addSubview(expfund)
        }
        
        if model.ableMoney != "" {
            expfund.text = model.ableMoney
        }else{
            expfund.text = "0.00"
        }
        
        if rightButton == nil {
            rightButton = UIButton(frame: CGRectMake(imageViewBg.frame.width - 30, imageViewBg.frame.height - 50, 30, 30))
            rightButton.setBackgroundImage(UIImage(named: "right"), forState: .Normal)
            rightButton.addTarget(self, action: "rightAction", forControlEvents: .TouchUpInside)
            imageViewBg.addSubview(rightButton)
        }
        
    }
    
    func setupRefresh(){
        //上拉刷新
        self.tableView.addHeaderWithCallback({
            self.currentPage = 1
            self.params["page"] = self.currentPage
            self.service.loadMyExperienceFund(self.params,
                calback: {
                    data in
                    self.loadingHidden()
                    switch data {
                    case let d as String:
                        KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
                    case let d as MyExperienceFundMixModel:
                        self.array = d.expList
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
            self.service.loadMyExperienceFund(self.params,
                calback: {
                    data in
                    self.loadingHidden()
                    switch data {
                    case let d as String:
                        KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
                    case let d as MyExperienceFundMixModel:
                        if self.array.count > 0 {
                            self.array += d.expList
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
            let cell = tableView.dequeueReusableCellWithIdentifier("ExperienceFundCell", forIndexPath: indexPath) as! ExperienceFundTableViewCell
            tableView.rowHeight = 80
            
            //类型
            let type = cell.viewWithTag(401) as! UILabel
            type.text = array[indexPath.row].type
            
            //金额
            let fund = cell.viewWithTag(402) as! UILabel
            fund.text = "获得体验金：\(array[indexPath.row].fund)"
            
            //初始日期
            let startData = cell.viewWithTag(403) as! UILabel
            startData.text = "初始日期：\(array[indexPath.row].startData)"
            
            //状态
            let status = cell.viewWithTag(404) as! UILabel
            if array[indexPath.row].status == "0" {
                status.text = "未到期"
            }else{
                status.text = "已到期"
            }
            
            //有效期
            let days = cell.viewWithTag(405) as! UILabel
            days.text = "有效期\(array[indexPath.row].days)天"
            
            let closeData = cell.viewWithTag(406) as! UILabel
            closeData.text = array[indexPath.row].closeData
            
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
        return headerView
    }
    
    
    //MARK: - Action
    
    func totalAction() {
        totalButton.selected = true
        undateButton.selected = false
        dateButton.selected = false
        
        lineView.frame = CGRectMake(0, 55, headerView.width / 3, 2)
        
        params["status"] = "99"
        
        loadData()
    }
    
    func undateAction() {
        totalButton.selected = false
        undateButton.selected = true
        dateButton.selected = false
        
        lineView.frame = CGRectMake(headerView.width / 3, 55, headerView.width / 3, 2)
        
        params["status"] = "0"
        
        loadData()
    }
    
    func dateAction() {
        totalButton.selected = false
        undateButton.selected = false
        dateButton.selected = true
        
        lineView.frame = CGRectMake(headerView.width / 3 * 2, 55, headerView.width / 3, 2)
        
        params["status"] = "1"
        
        loadData()
    }
    
    func rightAction() {
        gotoPage("Assest", pageName: "ExperienceRecordTVC")
    }
    
}
