//
//  StableRecordViewController.swift
//  ydzbapp-hybrid
//  稳进宝记录
//  Created by qinxin on 15/9/1.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class StableRecordViewController: BaseViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var stableImageBg: UIImageView!
    @IBOutlet weak var investmentFund: UILabel!
    @IBOutlet weak var buyCopies: UILabel!
    
    //MARK: - Constant
    let service = DealRecordService.getInstance()
    
    //MARK: - Variable
    var params = [String:AnyObject]()
    var model = StableMixModel()
    
    var headerView: UIView!
    var holdButton: UIButton!
    var datedButton: UIButton!
    var lineView: UIView!
    
    
    //MARK: - View Life Cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        initView()
    }
    
    
    //MARK: - Private Methods
    
    private func initView() {
        initNav("稳进宝")
        
        headerView = UIView(frame: CGRectMake(0, stableImageBg.bottom, B.SCREEN_WIDTH, 55))
        headerView.backgroundColor = B.TABLEVIEW_BG
        
        lineView = UIView(frame: CGRectMake(0, 55, headerView.width / 2, 2))
        lineView.backgroundColor = B.LIST_YELLOW_TEXT_COLOR
        headerView.addSubview(lineView)
        
        holdButton = UIButton(frame: CGRectMake(0, 0, headerView.width / 2, 55))
        holdButton.backgroundColor = UIColor.whiteColor()
        holdButton.setTitle("持有中", forState: .Normal)
        holdButton.setTitleColor(B.LIST_GRAY_TEXT_COLOR, forState: .Normal)
        holdButton.setTitleColor(B.LIST_YELLOW_TEXT_COLOR, forState: .Selected)
        holdButton.addTarget(self, action: "holdAction", forControlEvents: .TouchUpInside)
        holdButton.selected = true
        headerView.addSubview(holdButton)
        
        datedButton = UIButton(frame: CGRectMake(holdButton.right + 1, 0, headerView.width / 2, 55))
        datedButton.backgroundColor = UIColor.whiteColor()
        datedButton.setTitle("已到期", forState: .Normal)
        datedButton.setTitleColor(B.LIST_GRAY_TEXT_COLOR, forState: .Normal)
        datedButton.setTitleColor(B.LIST_YELLOW_TEXT_COLOR, forState: .Selected)
        datedButton.addTarget(self, action: "datedAction", forControlEvents: .TouchUpInside)
        headerView.addSubview(datedButton)
        
        view.addSubview(headerView)
    }
    
    private func loadData() {
        loadingShow()
        params["mm"] = userDefaultsUtil.getMobile()
        params["page"] = 1
        params["status"] = "0"
        service.loadDataStableGet(params, calback: { (data) -> () in
            self.model = data as! StableMixModel
            self.investmentFund.text = self.model.investmentFund
            self.buyCopies.text = self.model.buyCopies
            
            let center = NSNotificationCenter.defaultCenter()
            let notification = NSNotification(name: STABLE_RECORD_LIST.Notification, object: nil, userInfo: [STABLE_RECORD_LIST.Params:self.params])
            center.postNotification(notification)
            self.loadingHidden()
        })
    }
    
    
    //MARK: - Action
    
    func holdAction() {
        holdButton.selected = true
        datedButton.selected = false
        
        lineView.frame = CGRectMake(0, 55, headerView.width / 2, 2)
        
        params["status"] = "0"
        
        loadData()
    }
    
    func datedAction() {
        holdButton.selected = false
        datedButton.selected = true
        
        lineView.frame = CGRectMake(headerView.width / 2, 55, headerView.width / 2, 2)
        
        params["status"] = "1"
        
        loadData()
    }
    
    
}
