//
//  TotalFundTableViewController.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/9/7.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit

class TotalFundTableViewController: BaseTableViewController {
    
    @IBOutlet weak var investDayloanCell: UITableViewCell!
    @IBOutlet weak var investDepositCell: UITableViewCell!
//    @IBOutlet weak var investTransferCell: UITableViewCell!
    @IBOutlet weak var investWjbCell: UITableViewCell!
    @IBOutlet weak var investSelfCell: UITableViewCell!
    @IBOutlet weak var investJumuCell: UITableViewCell!
    
    @IBOutlet weak var investDayLoanNumLab: UILabel!
    @IBOutlet weak var investDepositNumLab: UILabel!
//    @IBOutlet weak var investTransferNumLab: UILabel!
    @IBOutlet weak var investWjbNumLab: UILabel!
    @IBOutlet weak var investSelfNumLab: UILabel!
    @IBOutlet weak var investJumuNumLab: UILabel!
    
    
    var assestService = AssestService.getInstance()
    
    var tfm = TotalFundModel()
    
    //var cellArrs = [CGFloat(0.0), 0.0, 0.0, 0.0, 0.0, 0.0]
    
    var lastRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //加载初始化视图
        initView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }
    
    
    func loadData(){
        assestService.totalFundGet({
            data in
            if let tfm = data as? TotalFundModel {
                self.tfm = tfm
                //显示活期列
//                if(tfm.investDayloan as NSString).doubleValue > 0 {
//                    self.cellArrs[0] = 55
//                    self.lastRow = 0
//                    self.investDayloanCell.hidden = false
                    self.investDayLoanNumLab.text = tfm.investDayloan
//                }
                //显示定期列
//                if (tfm.investDeposit as NSString).doubleValue > 0 {
//                    self.cellArrs[1] = 55
//                    self.lastRow = 1
//                    self.investDepositCell.hidden = false
                    self.investDepositNumLab.text = tfm.investDeposit
//                }
                //显示债权转让列
//                if (tfm.investTransfer as NSString).doubleValue > 0  {
//                    self.cellArrs[2] = 55
//                    self.lastRow = 2
//                    self.investTransferCell.hidden = false
//                    self.investTransferNumLab.text = tfm.investTransfer
//                }
                //显示基金投资列
//                if (tfm.investWjb as NSString).doubleValue > 0  {
//                    self.cellArrs[3] = 55
//                    self.lastRow = 3
//                    self.investWjbCell.hidden = false
                    self.investWjbNumLab.text = tfm.investWjb
//                }
                //显示私人定制列
//                println("tfm.investSelf:\(tfm.selfStatus)")
//                if tfm.selfStatus == 1 {
//                    self.cellArrs[4] = 55
//                    self.lastRow = 4
//                    self.investSelfCell.hidden = false
                    //self.investSelfNumLab.text = tfm.investSelf
                    self.investSelfNumLab.text = tfm.investSelf
//                }
                //显示股权投资列
//                if (tfm.investJumu as NSString).doubleValue > 0 {
//                    self.cellArrs[5] = 55
//                    self.lastRow = 5
//                    self.investJumuCell.hidden = false
                    self.investJumuNumLab.text = tfm.investJumu
//                }
                //self.tableView.reloadData()
                self.loadingHidden()
            }
        })
    }
    
    func initView() {
        loadingShow()
        initNav("资产分配")
        
        //addHeadView()
        
//        self.investDayloanCell.hidden = true
//        self.investDepositCell.hidden = true
//        self.investTransferCell.hidden = true
//        self.investWjbCell.hidden = true
//        self.investSelfCell.hidden = true
//        self.investJumuCell.hidden = true
        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "assest_withdraw_icon"), style: UIBarButtonItemStyle.Done, target: self, action: "showInfo")
    }
    
    func showInfo(){
        let view = ModalView.instantiateFromNib()
        let window = UIApplication.sharedApplication().delegate?.window
        let modal = PathDynamicModal()
        modal.showMagnitude = 200.0
        modal.closeMagnitude = 130.0
        view.closeButtonHandler = {[weak modal] in
            modal?.closeWithLeansRandom()
            return
        }
        view.bottomButtonHandler = {[weak modal] in
            modal?.closeWithLeansRandom()
            return
        }
        modal.show(modalView: view, inView: window!!)
    }
    
    func addHeadView(){
        let screenWidth = UIScreen.mainScreen().bounds.width
        let headView = UIView(frame: CGRectMake(0, 0, screenWidth, 15))
        headView.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        let lineView = UIView(frame: CGRectMake(0, 14, screenWidth, 1))
        lineView.backgroundColor = UIColor(red: 228/255, green: 228/255, blue: 228/255, alpha: 1)
        headView.addSubview(lineView)
        self.tableView.tableHeaderView = headView
    }
    
    //活期宝
    @IBAction func dayLoanClick(sender: AnyObject) {
        gotoPage("Finance", pageName: "CurrentRecordVC")
    }
    //定存宝
    @IBAction func depositClick(sender: AnyObject) {
        gotoPage("Finance", pageName: "DepositeRecordVC")
    }
//    //债权转让
//    @IBAction func transferClick(sender: AnyObject) {
//        gotoPage("Finance", pageName: "TransferRecordTVC")
//    }
    //基金投资
    @IBAction func wjbClick(sender: AnyObject) {
        gotoPage("Finance", pageName: "StableRecordVC")
    }
    //私人定制
    @IBAction func investSelfClick(sender: AnyObject) {
        gotoPage("Assest", pageName: "autoInvestCtrl")
    }
    //股权投资
    @IBAction func jumuClick(sender: AnyObject) {
        gotoPage("Assest", pageName: "jumuRecordCtrl")
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        println("row:\(indexPath.row)")
        //如果最后一行，分隔线到头
        if indexPath.row == 4 {
            //cell.layoutMargins = UIEdgeInsetsZero
            cell.separatorInset = UIEdgeInsetsZero
        }else{
            cell.separatorInset = UIEdgeInsetsMake(0, 65, 0, 0)
        }
        
    }
    
    
    //每个分组间距高度，隐藏的分组为0
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //return cellArrs[indexPath.row]
        return 55
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}