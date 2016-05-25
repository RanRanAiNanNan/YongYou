//
//  MyRecommendRecordTableViewController.swift
//  ydzbapp-hybrid
//  推荐记录
//  Created by qinxin on 15/9/11.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

struct RECOMMEND_LIST {
    static let Notification = "推荐记录列表广播"
    static let Params = "推荐记录参数"
}

class MyRecommendRecordTableViewController: BaseTableViewController {
    
    var service = RecommendRecordService.getInstance()
    var params = [String:AnyObject]()
    var recommandRecord = [RecommandRecordModel]()
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotification()
        setupRefresh()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        let center = NSNotificationCenter.defaultCenter()
        center.removeObserver(self)
    }
    
    private func loadData() {
        loadingShow()
        service.loadDataGet(params, calback: { (data) -> () in
            self.recommandRecord = data as! Array<RecommandRecordModel>
            self.tableView.reloadData()
            self.loadingHidden()
        })
    }
    
    private func registerNotification() {
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        center.addObserverForName(RECOMMEND_LIST.Notification, object: nil, queue: queue) { notification -> Void in
            if let p = notification.userInfo?[RECOMMEND_LIST.Params] as? [String:AnyObject] {
                self.params = p
                self.loadData()
            }
        }
    }
    
    private func setupRefresh(){
        //上拉刷新
        self.tableView.addHeaderWithCallback({
            self.currentPage = 1
            self.params["page"] = self.currentPage
            self.tableView.scrollEnabled = false
            self.service.loadDataGet(self.params,
                calback: {
                    data in
                    self.loadingHidden()
                    switch data {
                    case let d as String:
                        KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
                    case let d as Array<RecommandRecordModel>:
                        self.recommandRecord = d
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
            self.service.loadDataGet(self.params,
                calback: {
                    data in
                    self.loadingHidden()
                    switch data {
                    case let d as String:
                        KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
                    case let d as Array<RecommandRecordModel>:
                        if d.count > 0 {
                            self.recommandRecord += d
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
        if recommandRecord.count > 0 {
            return recommandRecord.count
        }else{
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if recommandRecord.count > 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("MyRecommendCell", forIndexPath: indexPath) 
            tableView.rowHeight = 70
            
            //头像
            let imageView = cell.viewWithTag(301) as! UIImageView
            if recommandRecord[indexPath.row].avatar != "" {
                imageView.sd_setImageWithURL((NSURL(string: recommandRecord[indexPath.row].avatar)))
            }else{
                imageView.image = UIImage(named: "home_user_avatar_icon")
            }
            imageView.layer.cornerRadius = 20
            
            //用户名
            let username = cell.viewWithTag(302) as! UILabel
            username.text = recommandRecord[indexPath.row].username
            
            //时间
            let invest = cell.viewWithTag(303) as! UILabel
            invest.text = recommandRecord[indexPath.row].created
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor.whiteColor()
            }else{
                cell.backgroundColor = B.RECOMMEND_CELL_COLOR
            }
            return cell
        }else{
            let cell = UITableViewCell(frame: CGRectMake(0, 0, view.width, view.height))
            let imageView = UIImageView(image: UIImage(named: "empty_states"))
            imageView.center = CGPointMake(tableView.centerx, tableView.height / 2 - imageView.height / 2)
            cell.addSubview(imageView)
            cell.backgroundColor = B.RECOMMEND_TABLEVIEW_BG
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
    }
    
}
