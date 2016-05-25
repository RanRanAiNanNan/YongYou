//
//  AssestTableViewController.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/8/31.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit

class AssestViewController :BaseViewController {
    
    
    @IBOutlet weak var totalFundLab: UILabel!
    @IBOutlet weak var yesterdayIncomeLab: UILabel!
    @IBOutlet weak var allIncomeLab: UILabel!

    @IBOutlet weak var messageBtn: UIBarButtonItem!
    
    let assestService = AssestService.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView() {
        loadingShow()
        initNav("资产")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        assestService.loadDataGet({
            (data) -> () in
            if let am = data as? AssestModel {
                self.totalFundLab.text = am.totalFund
                self.yesterdayIncomeLab.text = am.yesterdayIncome
                self.allIncomeLab.text = am.allIncome
                self.loadingHidden()
            }
        })
    }
    
    @IBAction func rechargeClick(sender: AnyObject) {
        loadingShow()
        assestService.checkRecharge(["mm":userDefaultsUtil.getMobile()!],
            calback: {
                data in
                self.loadingHidden()
                if let mm = data as? MsgModel {
                    if !mm.msg.isEmpty {
                        KGXToast.showToastWithMessage(mm.msg, duration: ToastDisplayDuration.LengthShort)
                    }
                    if mm.status == 0 {
                        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "SafetyCenter", bundle: NSBundle.mainBundle())
                        let oneController:UIViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("safetystoryboard") 
                        self.navigationController?.pushViewController(oneController, animated: true)
                    }else if mm.status == 1 {
                        self.gotoPage("Assest", pageName: "rechargeFristCtrl")
                    }
                }
            }
        )
    }
    
    @IBAction func withdrawClick(sender: AnyObject) {
        loadingShow()
        assestService.checkWithdraw(["mm": userDefaultsUtil.getMobile()!],
            calback: {
                data in
                self.loadingHidden()
                if let mm = data as? MsgModel {
                    if !mm.msg.isEmpty {
                        KGXToast.showToastWithMessage(mm.msg, duration: ToastDisplayDuration.LengthShort)
                    }
                    if mm.status == 0 {
                        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "SafetyCenter", bundle: NSBundle.mainBundle())
                        let oneController:UIViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("safetystoryboard") 
                        self.navigationController?.pushViewController(oneController, animated: true)
                    }else if mm.status == 1 {
                        self.gotoPage("Assest", pageName: "withdrawCtrl")
                    }
                }
            }
        )
    }
    //累计收益
    @IBAction func revenueShareClick(sender: AnyObject) {
        if (allIncomeLab.text! as NSString).doubleValue > 0  {
            gotoPage("Assest", pageName: "totalIncomeCtrl")
        }
    }
    //总资产
    @IBAction func totalFundClick(sender: AnyObject) {
        if (totalFundLab.text! as NSString).doubleValue > 0  {
            gotoPage("Assest", pageName: "totalAssestCtrl")
        }
    }
    //消息
    @IBAction func messageClick(sender: AnyObject) {
        gotoPage("UserCenter", pageName: "MessageRecordTVC")
    }
    
    //昨日收益
    @IBAction func yesterdayIncomeClick(sender: AnyObject) {
        if (yesterdayIncomeLab.text! as NSString).doubleValue > 0  {
            gotoPage("Assest", pageName: "yesterdayIncomeCtrl")
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func showTabBar(){
//        if self.tabBarController?.tabBar.hidden == false {
//            return
//        }
//        var contentView = UIView();
//        if self.tabBarController!.view.subviews[0].isKindOfClass(UITabBar) {
//            contentView = self.tabBarController!.view.subviews[1] as! UIView
//        }else{
//            contentView = self.tabBarController!.view.subviews[0] as! UIView
//        }
//        contentView.frame = CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height - self.tabBarController!.tabBar.frame.size.height)
//        contentView.backgroundColor = UIColor.redColor()
        self.tabBarController?.tabBar.hidden = false
    }
}
