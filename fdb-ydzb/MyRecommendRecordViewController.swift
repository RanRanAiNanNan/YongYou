//
//  MyRecommendRecordViewController.swift
//  ydzbapp-hybrid
//  推荐记录
//  Created by qinxin on 15/9/11.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class MyRecommendRecordViewController: BaseViewController {
    
    @IBOutlet weak var uninvestmentLine: UIView!        //未投资
    @IBOutlet weak var investmentLine: UIView!          //已投资
    
    @IBOutlet weak var investmentButton: UIButton!      //已投资
    @IBOutlet weak var uninvestmentButton: UIButton!    //未投资
    
    var params = [String:AnyObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        initNav("推荐记录")
        params["mm"] = userDefaultsUtil.getMobile()!
        params["type"] = "1"
        params["page"] = 1
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    private func loadData() {
        let center = NSNotificationCenter.defaultCenter()
        let notification = NSNotification(name: RECOMMEND_LIST.Notification, object: nil, userInfo: [RECOMMEND_LIST.Params:params])
        center.postNotification(notification)
    }
    
    @IBAction func uninvestmentAction(sender: UIButton) {
        params["type"] = "0"
        
        uninvestmentButton.selected = true
        investmentButton.selected = false
        
        uninvestmentLine.hidden = false
        investmentLine.hidden = true
        
        loadData()
    }
    
    @IBAction func investmentAction(sender: UIButton) {
        params["type"] = "1"
        
        uninvestmentButton.selected = false
        investmentButton.selected = true
        
        uninvestmentLine.hidden = true
        investmentLine.hidden = false
        
        loadData()
    }

}
