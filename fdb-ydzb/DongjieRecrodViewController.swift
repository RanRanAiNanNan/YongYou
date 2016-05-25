//
//  DongjieRecrodViewController.swift
//  ydzbapp-hybrid
//  冻结记录
//  Created by qinxin on 15/10/8.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class DongjieRecrodViewController: BaseViewController {
    
    @IBOutlet weak var dongjieLabel: UILabel!               //冻结金额
    
    //MARK: - Variable
    var assestRecordService = AssestService.getInstance()
    var djmm = DongJieMixModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNav("冻结记录")
        initData()
    }
    
    private func initData() {
        loadData()
    }
    
    private func loadData(){
        loadingShow()
        assestRecordService.loadDongJieData({ (data) -> () in
            self.djmm = data as! DongJieMixModel
            self.dongjieLabel.text = self.djmm.total
            let center = NSNotificationCenter.defaultCenter()
            let notification = NSNotification(name: DONGJIE_LIST.Notification, object: nil, userInfo: [DONGJIE_LIST.Model:self.djmm])
            center.postNotification(notification)
            self.loadingHidden()
        })
    }

    

}
