//
//  CurrentRecordViewController.swift
//  ydzbapp-hybrid
//  活期宝记录
//  Created by qinxin on 15/8/31.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class CurrentRecordViewController: BaseViewController, PullDownMenuDelegate {
    
    //MARK: - Outlet
    @IBOutlet weak var currentImageView: UIImageView!           //背景图片
    @IBOutlet weak var yesterdayIncome: UILabel!                //昨日收益
    @IBOutlet weak var incomeDayloan: UILabel!                  //累计收益
    @IBOutlet weak var investDayload: UILabel!                  //已购金额
    
    
    //MARK: - Variable
    var depositMenu: PullDownMenuView!
    var params = [String:String]()
    var model = CurrentMixModel()
    
    //MARK: - Constant
    let depositMenuArray = [["交易类型", "购买", "赎回"], ["交易日期", "一个月", "三个月", "六个月","十二个月"
        ]]
    let service = DealRecordService.getInstance()
    let ydFinancingService = YdFinancingService.getInstance()
    
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNav("活期宝")
        params["mm"] = userDefaultsUtil.getMobile()!
        params["type"] = "99"
        params["month"] = "99"
        params["page"] = "1"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        addMenu()
    }
    
    
    //MARK: - Private Methods
    
    private func loadData() {
        loadingShow()
        service.loadDataDayloanGet(params, calback: { (data) -> () in
            self.model = data as! CurrentMixModel
            self.yesterdayIncome.text = self.model.yeterdayIncome
            self.incomeDayloan.text = self.model.incomeDayload
            self.investDayload.text = self.model.investDayloan
            let center = NSNotificationCenter.defaultCenter()
            let notification = NSNotification(name: CURRENT_LIST.Notification, object: nil, userInfo: [CURRENT_LIST.Model:self.model, CURRENT_LIST.Params:self.params])
            center.postNotification(notification)
            self.loadingHidden()
        })
    }
    
    private func addMenu() {
        //添加过滤导航菜单 定存
        if depositMenu == nil {
            depositMenu = PullDownMenuView(frame: CGRectMake(0, currentImageView.frame.height, B.SCREEN_WIDTH, B.MENU_FLITER_HIGHT))
            depositMenu.initWithArray(depositMenuArray, selectedColor: B.MENU_NORMAL_FONT_COLOR)
            depositMenu.delegate = self
            //            var currentTitle = depositMenu.titles[0] as? CATextLayer
            //            currentTitle?.foregroundColor = B.MENU_SELECTED_FONT_COLOR.CGColor
            //            var currentIndicator = depositMenu.indicators[0] as? CAShapeLayer
            //            currentIndicator?.fillColor = B.MENU_SELECTED_FONT_COLOR.CGColor
            view.addSubview(depositMenu)
        }
    }
    
    
    
    //MARK: - PullDownMenu Delegate
    
    func pullDownMenu(pullDownMenu: PullDownMenuView!, didSelectRowAtColumn column: NSInteger, didSelectRowAtRow row: NSInteger) {
        //menu title 颜色改变
        changeTitleColor(pullDownMenu, column: column)
        
        if column == 0 {
            switch row {
            case 0:
                params["type"] = "99"
            case 1:
                params["type"] = "1"
            case 2:
                params["type"] = "2"
            default:
                break
            }
        }else{
            switch row {
            case 0:
                params["month"] = "99"
            case 1:
                params["month"] = "1"
            case 2:
                params["month"] = "3"
            case 3:
                params["month"] = "6"
            case 4:
                params["month"] = "12"
            default:
                break
            }
        }
        loadData()
        
    }
    
    func changeTitleColor(pullDownMenu:PullDownMenuView, column: NSInteger) {
        
        for title in pullDownMenu.titles {
            (title as? CATextLayer)?.foregroundColor = B.MENU_NORMAL_FONT_COLOR.CGColor
            if let currentTitle = pullDownMenu.titles[column] as? CATextLayer {
                if currentTitle == title as? CATextLayer {
                    currentTitle.foregroundColor = B.MENU_SELECTED_FONT_COLOR.CGColor
                }
            }
        }
        
        for indicator in pullDownMenu.indicators {
            (indicator as? CAShapeLayer)?.fillColor = B.MENU_NORMAL_FONT_COLOR.CGColor
            if let currentIndicator = pullDownMenu.indicators[column] as? CAShapeLayer {
                if currentIndicator == indicator as? CAShapeLayer {
                    currentIndicator.fillColor = B.MENU_SELECTED_FONT_COLOR.CGColor
                }
            }
        }
    }
    
    
    //MARK: - Action
    
    @IBAction func redeemButtonAction(sender: UIButton) {
        loadingShow()
        ydFinancingService.dayLoanRedeemPwd { (data) -> () in
            self.loadingHidden()
            if let dlrm = data as? DayLoanRedeemModel {
                if dlrm.pwdStatus == 0 {
                    //跳转到安全中心
                    KGXToast.showToastWithMessage("请先设置交易密码", duration: ToastDisplayDuration.LengthShort)
                    let oneStoryBoard:UIStoryboard = UIStoryboard(name: "SafetyCenter", bundle: NSBundle.mainBundle())
                    let oneController:UIViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("safetystoryboard")
                    self.navigationController?.pushViewController(oneController, animated: true)
                }else{
                    self.gotoPage("Finance", pageName: "dayLoanRedeemCtrl")
                }
            }
        }
    }
    
}
