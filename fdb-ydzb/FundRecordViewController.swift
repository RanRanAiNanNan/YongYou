//
//  FundRecordViewController.swift
//  ydzbapp-hybrid
//  资金记录
//  Created by qinxin on 15/9/2.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class FundRecordViewController: BaseViewController, PullDownMenuDelegate {
    
    @IBOutlet weak var fundImageBg: UIImageView!            //背景图
    @IBOutlet weak var totalLabel: UILabel!                 //显示数值
    @IBOutlet weak var tipFundLabel: UILabel!               //标题文字
    

    //MARK: - Variable
    var fundMenu: PullDownMenuView!
    var fundRecordService = FundRecordService.getInstance()
    var fmm = FundMixModel()
    var type: String = "99"
    var month: String = "99"
    var params = [String:AnyObject]()
    var freeze: Int = 0

    //MARK: - Constant
    let fundMenuArray = [["交易类型", "出账", "入账"],["交易日期","一个月","三个月","六个月","十二个月"]]
    
    
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
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
    
    private func initView() {
        initNav("资金记录")
    }
    
    private func addMenu() {
        //添加过滤导航菜单 资金记录
        if fundMenu == nil {
            fundMenu = PullDownMenuView(frame: CGRectMake(0, fundImageBg.frame.height, B.SCREEN_WIDTH, B.MENU_FLITER_HIGHT))
            fundMenu.initWithArray(fundMenuArray, selectedColor: B.MENU_NORMAL_FONT_COLOR)
            fundMenu.delegate = self
            view.addSubview(fundMenu)
        }
    }
    
    private func loadData(){
        params["mm"] = userDefaultsUtil.getMobile()!
        params["type"] = type
        params["month"] = month
        params["page"] = "1"
        loadingShow()
        fundRecordService.loadDataGet(params, calback: { (data) -> () in
            self.fmm = data as! FundMixModel
            self.totalLabel.text = self.fmm.total
            let center = NSNotificationCenter.defaultCenter()
            let notification = NSNotification(name: FUND_LIST.Notification, object: nil, userInfo: [FUND_LIST.Model:self.fmm, FUND_LIST.Params:self.params])
            center.postNotification(notification)
            self.loadingHidden()
        })
    }
    
    
    //MARK: - PullDownMenu Delegate
    
    func pullDownMenu(pullDownMenu: PullDownMenuView!, didSelectRowAtColumn column: NSInteger, didSelectRowAtRow row: NSInteger) {
        
        //menu title 颜色改变
        changeTitleColor(pullDownMenu, column: column)
        
        if column == 0 {
            switch row {
            case 0:
                type = "99"
                tipFundLabel.text = "账户余额(元)"
            case 1:
                type = "0"
                tipFundLabel.text = "出账合计(元)"
            case 2:
                type = "1"
                tipFundLabel.text = "入账合计(元)"
            case 3:
                type = "2"
                tipFundLabel.text = "冻结金额(元)"
            case 4:
                type = "3"
                tipFundLabel.text = "解冻合计(元)"
            default:
                break
            }
        }else{
            switch row {
            case 0:
                month = "99"
            case 1:
                month = "1"
            case 2:
                month = "3"
            case 3:
                month = "6"
            case 4:
                month = "12"
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

}
