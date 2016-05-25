//
//  AssestTableViewController.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/9/1.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit

class AssestTableViewController: BaseTableViewController {
    
    @IBOutlet weak var usableFundLab: UILabel!
    @IBOutlet weak var ableMoneyLab: UILabel!
    @IBOutlet weak var totalFundLab: UILabel!
    @IBOutlet weak var freezeFundLab: UILabel!
    
    let assestService = AssestService.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
                assestService.loadDataGet({
                    (data) -> () in
                    if let am = data as? AssestModel {
                        self.usableFundLab.text = am.usableFund
                        self.ableMoneyLab.text = am.ableMoney
                        self.totalFundLab.text = am.allInvest
                        self.freezeFundLab.text = am.freezeFund
                        //self.totalFundLab.text = "1"
                    }
                })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
            cell.separatorInset = UIEdgeInsetsMake(0, 65, 0, 0)
    }
    
    
    //列表跳转
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            gotoPage("Assest", pageName:"totalFundCtrl")
            
        case 1:
            gotoPage("UserCenter", pageName:"FundRecordVC")
            
        case 2:
            gotoPage("Assest", pageName: "DongJieRecordVC")
        case 3:
            
            gotoPage("Assest", pageName:"ExperienceFundTVC")
        default:
            break
        }
    }
}