//
//  DepositeRecordViewController.swift
//  ydzbapp-hybrid
//  定存记录
//  Created by qinxin on 15/8/28.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class DepositeRecordViewController: BaseViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var depositeBg: UIImageView!             //背景图片
    @IBOutlet weak var predictIncomeLabel: UILabel!         //预期收益
    @IBOutlet weak var buyFundLabel: UILabel!               //已购进额
    @IBOutlet weak var totalFundLabel: UILabel!             //累计收益
    
    
    //MARK: - Variable
    var dealRecordService = DealRecordService.getInstance()
    var dmm = DepositeMixModel()
    var currentPage = 1
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    
    //MARK: - Private Methods
    
    private func initView() {
        initNav("定存宝")
        addDealRecord()
    }
    
    func addDealRecord(){
        let backBtn = UIButton()
        backBtn.frame = CGRectMake(0, 0, 100, 20);
        backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10)
        backBtn.contentHorizontalAlignment = .Right
        backBtn.contentVerticalAlignment = .Bottom
        //backBtn.backgroundColor = UIColor.redColor()
        backBtn.setTitle("交易记录", forState: UIControlState.Normal)
        backBtn.setTitleColor(B.NAV_TITLE_CORLOR, forState: UIControlState.Normal)
        backBtn.titleLabel?.font = UIFont.systemFontOfSize(12)
        backBtn.addTarget(self, action: "showDeal", forControlEvents: UIControlEvents.TouchUpInside)
        let backBtnItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.rightBarButtonItem = backBtnItem
    }
    
    func showDeal(){
        self.performSegueWithIdentifier("toDepositeRecordOtherSegue", sender: nil)
    }
    
    private func loadData() {
        loadingShow()
        self.dealRecordService.loadDataDepositeGet(self.currentPage,
            calback: {
                data in
                self.loadingHidden()
                self.dmm = data as! DepositeMixModel
                self.predictIncomeLabel.text = self.dmm.predictIncome
                self.buyFundLabel.text = self.dmm.buyFund
                self.totalFundLabel.text = self.dmm.depositIncome
                let center = NSNotificationCenter.defaultCenter()
                let notification = NSNotification(name: DEPOSIT_RECORD_LIST.Notification, object: nil, userInfo: [DEPOSIT_RECORD_LIST.Key:self.dmm])
                center.postNotification(notification)
        })
    }
    
    @IBAction func jump2BoughtProductTVC(sender: UIButton) {
        performSegueWithIdentifier("DepositRecord_BoughtProduct", sender: self)
    }
    
    
}
