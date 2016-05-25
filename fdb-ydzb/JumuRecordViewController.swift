//
//  JumuRecordViewController.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/5/20.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit

class JumuRecordViewController: BaseTableViewController {
    
    var userCenterService = UserCenterService.getInstance()
    
    var jumuRecordData = Array<JumuRecordModel>()
    
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //加载初始化视图
        initView()
        //加载刷新
        setupRefresh()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //加载数据
        loadData()
    }
    
    func setupRefresh(){
        //上拉刷新
        self.tableView.addHeaderWithCallback({
            self.currentPage = 1
            self.userCenterService.jumuLoadDataGet(self.currentPage,
                calback: {
                    data in
                    self.loadingHidden()
                    switch data {
                    case let d as String:
                        KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
                    case let d as Array<JumuRecordModel>:
                        self.jumuRecordData = d
                        let delayInSeconds:Int64 =  1000000000  * 0
                        let popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
                        dispatch_after(popTime, dispatch_get_main_queue(), {
                            self.tableView.reloadData()
                            self.tableView.headerEndRefreshing()
                        })
                    default:
                        break
                    }
                }
            )
        })
        //下拉刷新
        self.tableView.addFooterWithCallback({
            self.currentPage += 1
            self.userCenterService.jumuLoadDataGet(self.currentPage,
                calback: {
                    data in
                    self.loadingHidden()
                    switch data {
                    case let d as String:
                        KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
                    case let d as Array<JumuRecordModel>:
                        self.jumuRecordData += d
                        let delayInSeconds:Int64 =  1000000000  * 0
                        let popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
                        dispatch_after(popTime, dispatch_get_main_queue(), {
                            self.tableView.reloadData()
                            self.tableView.footerEndRefreshing()
                        })
                    default:
                        break
                    }
                }
            )
        })
    }
    
    func loadData(){
        loadingShow()
        userCenterService.jumuLoadDataGet(1,
            calback: {
                data in
                self.loadingHidden()
                switch data {
                case let d as String:
                    KGXToast.showToastWithMessage(d, duration: ToastDisplayDuration.LengthShort)
                case let d as Array<JumuRecordModel>:
                    self.jumuRecordData = d
                    self.tableView.reloadData()
                default:
                    break
                }
            }
        )
    }
    
    func initView() {
        initNav("众筹记录")
        self.refreshControl?.tintColor = UIColor.whiteColor()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.jumuRecordData.count == 0 {
            return 1
        }else{
            return self.jumuRecordData.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if jumuRecordData.count > 0 {
            let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("JUMU_RECORD_CELL", forIndexPath: indexPath) 
            tableView.rowHeight = 66
            //标题
            let nameLable:UILabel = cell.viewWithTag(201) as! UILabel!
            nameLable.text = self.jumuRecordData[indexPath.row].name
            //类型
            let typeLable:UILabel = cell.viewWithTag(202) as! UILabel!
            typeLable.text = self.jumuRecordData[indexPath.row].type
            //用户余额
            let fundLable:UILabel = cell.viewWithTag(203) as! UILabel!
            fundLable.text = "￥\(self.jumuRecordData[indexPath.row].fund)"
            //时间
            let timeLable:UILabel = cell.viewWithTag(204) as! UILabel!
            timeLable.text = self.jumuRecordData[indexPath.row].time
            cell.backgroundColor = UIColor.clearColor()
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue is CustomSegue {
            (segue as! CustomSegue).animationType = .Push
        }
    }

}