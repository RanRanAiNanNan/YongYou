//
//  InvestmentListTableViewController.swift
//  ydzbapp-hybrid
//
//  Created by qinxin on 15/5/29.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class InvestmentListTableViewController: BaseTableViewController {
    
    @IBOutlet weak var yinduoInvestment: UILabel!
    @IBOutlet weak var guopiaoInvestment: UILabel!
    @IBOutlet weak var guquanInvestment: UILabel!
    @IBOutlet weak var jijinInvestment: UILabel!
    @IBOutlet weak var tradeCostLab: UILabel!
    
    let homeService = HomeService.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //删除table view中多余的分割线
        self.setExtraCellLineHidden()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //解决table view中分割线左边不对齐
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.tableView.layoutMargins = UIEdgeInsetsZero
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //        homeService.loadDataGet({
        //            (data) -> () in
        //            if let msg = data as? HomeModel {
        //                var homeModel = data as! HomeModel
        //                self.yinduoInvestment.text = "¥" + homeModel.yinduoCost
        //                //self.guopiaoInvestment.text = "¥" + homeModel.stockCost
        //                self.guquanInvestment.text = "¥" + homeModel.jumuCost
        //                self.jijinInvestment.text = "¥" + homeModel.jijinCost
        //                self.tradeCostLab.text = "¥" + homeModel.tradeCost
        //            }
        //        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Comman method
    
    private func setExtraCellLineHidden(){
        let view = UIView(frame: CGRectMake(0, 0, B.SCREEN_WIDTH, 55))
        view.backgroundColor = UIColor.clearColor()
        let lineView = UIView(frame:CGRectMake(0, 0, B.SCREEN_WIDTH, 0.5))
        lineView.backgroundColor = UIColor(red: 200 / 255.0, green: 200 / 255.0, blue: 200 / 255.0, alpha: 1)
        view.addSubview(lineView)
        self.tableView.tableFooterView = view
    }
    
    
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layoutMargins = UIEdgeInsetsZero
        cell.separatorInset = UIEdgeInsetsZero
    }
    
    //    case 1:
    //    gotoPage("HighFinance", pageName:"peiziRecordCtrl")
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let i = indexPath.row;
        switch i {
        case 0:
            gotoPage("Finance", pageName:"FinanceDistributionTVC")
        case 1:
            gotoPage("UserCenter", pageName:"jumuRecordCtrl")
        case 2:
            gotoPage("Finance", pageName:"stable_period_tvc")
        case 3:
            gotoPage("HighFinance", pageName:"autoInvestCtrl")
        default:
            break
        }
    }
    
}
