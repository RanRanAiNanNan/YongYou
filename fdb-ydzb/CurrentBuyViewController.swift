//
//  CurrentBuyViewController.swift
//  ydzbapp-hybrid
//  活期宝购买首页
//  Created by qinxin on 15/8/31.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class CurrentBuyViewController: BaseViewController {
    
    @IBOutlet weak var currentPeriodLabel: UILabel!     //产品名称中文
    @IBOutlet weak var currentEngLabel: UILabel!        //产品名称英文
    @IBOutlet weak var circleView: CircleView!          //产品图
    @IBOutlet weak var surplusLabel: UILabel!           //当前份额
    @IBOutlet weak var rushTimeLabel: UILabel!          //开抢时间
    @IBOutlet weak var investmentButton: UIButton! {    //立即投资
        didSet {
            investmentButton.layer.cornerRadius = 10.0
        }
    }
    
    let ydFinancingService = YdFinancingService.getInstance()
    
    var animateView: SXWaveView!                        //动画view
    var cbm: CurrentBuyModel?
    var progress:           Float32 = 30.00             //动画view水浪值：越大幅度越大
    var avg:                Float32 = 0.00              //年化值
    var earningsLabel: UILabel!                         //万份收益
    var earnings: UILabel!                              //收益值
    var vipImageView: UIImageView!                      //vip图标
    var yearPercentToday: UILabel!                      //今日复合年化文字label
    var yearPercentTodayButton: UIButton!               //今日复合年化按钮
    
    
    //MARK: - Life view cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        addHelpCenter("dayloan")
    }
    
    private func initView() {
        loadingShow()
        initNav("活期宝")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    
    //MARK: - Private methods
    
    private func loadData() {
        ydFinancingService.loadDayloanData({
            (data) -> () in
            self.cbm = data as? CurrentBuyModel
            if let name = self.cbm?.name {
                self.currentPeriodLabel.text = name
            }
            if let surplus = self.cbm?.surplus {
                self.surplusLabel.text = surplus
            }
            if let compositeApr = self.cbm?.compositeApr {
                self.avg = compositeApr
            }
            
            //根据status做判断 1:立即投资 2:立即预投 3:等待投资
            if let status = self.cbm?.status {
                switch status {
                case "1":
                    self.investmentButton.setTitle("立即投资", forState: .Normal)
                    if userDefaultsUtil.getVip() == "0" {
                        self.investmentButton.addTarget(self, action: Selector("gotoCommonBuy"), forControlEvents: UIControlEvents.TouchUpInside)
                    }else{
                        self.investmentButton.addTarget(self, action: Selector("gotoVipBuy"), forControlEvents: UIControlEvents.TouchUpInside)
                    }
                case "2":
                    self.investmentButton.setTitle("立即预投", forState: .Normal)
                    if userDefaultsUtil.getVip() == "0" {
                        self.investmentButton.addTarget(self, action: Selector("gotoCommonPrepay"), forControlEvents: UIControlEvents.TouchUpInside)
                    }else{
                        self.investmentButton.addTarget(self, action: Selector("gotoVipPrepay"), forControlEvents: UIControlEvents.TouchUpInside)
                    }
                case "3":
                    self.investmentButton.setTitle("等待投资", forState: .Disabled)
                    self.investmentButton.setTitleColor(UIColor.whiteColor(), forState: .Disabled)
                    self.investmentButton.enabled = false
                    self.investmentButton.backgroundColor = UIColor.lightGrayColor()
                default:
                    break
                }
            }
            //添加动画view
            self.addCircleView()
            self.loadingHidden()
        })
    }
    
    private func addCircleView() {
        circleView.arcBounds = circleView.bounds.width / 2 - 10
        
        //动画view
        if animateView == nil {
            animateView = SXWaveView(frame: CGRectMake(0, 0, circleView.bounds.width, circleView.bounds.height))
            animateView.setPrecent(progress, avg:avg, textColor:B.BUY_COFFEE_TEXT_COLOR, bgColor: UIColor.clearColor(), alpha: 1.0, clips: false)
            animateView.addAnimateWithType(0)
            circleView.addSubview(animateView)
            
            //今日复合年化
            yearPercentToday = UILabel(frame: CGRectMake(animateView.centerx - 60, circleView.bounds.height * 1 / 3 - 20, 102, 17))
            yearPercentToday.text = "今日复合年化"
            yearPercentToday.textColor = B.BUY_COFFEE_TEXT_COLOR
            yearPercentToday.textAlignment = .Center
            yearPercentToday.font = UIFont.systemFontOfSize(17)
            circleView.addSubview(yearPercentToday)
            
            //按钮
            yearPercentTodayButton = UIButton(frame: CGRectMake(yearPercentToday.right + 1, yearPercentToday.top, 17, 17))
            yearPercentTodayButton.setImage(UIImage(named: "huoqibao_buy_tip"), forState: .Normal)
            yearPercentTodayButton.addTarget(self, action: "comeOutTip", forControlEvents: UIControlEvents.TouchUpInside)
            circleView.addSubview(yearPercentTodayButton)
            
            //vip标识
            let image = UIImage(named: "vip_0.5")
            vipImageView = UIImageView(image: image)
            vipImageView.frame.origin = CGPointMake(circleView.bounds.width * 2 / 3, circleView.bounds.height * 1 / 3)
            circleView.addSubview(vipImageView)
            
            //万份收益
            earningsLabel = UILabel(frame: CGRectMake(animateView.centerx - 85, animateView.avgScoreLbl!.bottom, 100, 20))
            earningsLabel.text = "万份收益:"
            earningsLabel.textColor = B.BUY_GRAY_TEXT_COLOR
            earningsLabel.textAlignment = .Right
            earningsLabel.font = UIFont.systemFontOfSize(7 * circleView.bounds.width / 125)
            circleView.addSubview(earningsLabel)
            
            //收益值
            if let earning = self.cbm?.earnings {
                earnings = UILabel(frame: CGRectMake(earningsLabel.right + 1, earningsLabel.top, 60, 20))
                earnings.text = earning
                earnings.textColor = B.BUY_GRAY_TEXT_COLOR
                earnings.textAlignment = .Left
                earnings.font = UIFont.systemFontOfSize(7 * circleView.bounds.width / 125)
                circleView.addSubview(earnings)
            }
        }
    }
    
    
    //MARK: - UINavigation segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "dayloanBuySegue":
                if segue.destinationViewController.isKindOfClass(CurrentBuyDetailViewController) {
                    let cbdvc = segue.destinationViewController as! CurrentBuyDetailViewController
                    if let productId = self.cbm?.productId {
                        cbdvc.productId = productId
                    }
                }
            case "dayloanCommonBuySegue":
                if segue.destinationViewController.isKindOfClass(CurrentCommonBuyViewController) {
                    let cbdvc = segue.destinationViewController as! CurrentCommonBuyViewController
                    if let productId = self.cbm?.productId {
                        cbdvc.productId = productId
                    }
                }
            default:
                break
            }
        }
    }
    
    //MARK: - Action
    
    //跳转到天标vip购买界面
    func gotoCommonBuy() {
        self.performSegueWithIdentifier("dayloanCommonBuySegue", sender: nil)
    }
    
    //跳转到天标vip购买界面
    func gotoVipBuy() {
        self.performSegueWithIdentifier("dayloanBuySegue", sender: nil)
    }
    
    //跳转到天标普通用户预投界面
    func gotoCommonPrepay(){
        self.performSegueWithIdentifier("dayloanCommonPrepaySegue", sender: nil)
    }
    
    //跳转到天标VIP预投界面
    func gotoVipPrepay(){
        self.performSegueWithIdentifier("dayloanPerpaySegue", sender: nil)
    }
    
    @IBAction func seeBeforeClick(sender: AnyObject) {
        self.gotoPage("Finance",pageName:"dayloanSeeBeforeCtrl")
    }
    
    @IBAction func currentPeriodClick(sender: AnyObject) {
        self.gotoPage("Finance",pageName:"dayloanCurrentPeriodCtrl")
    }
    
    //弹出提示框
    func comeOutTip() {
        let alertview = HHAlertView(title: "复合年化", detailText: "复合年化指活期宝收益复投后的年化收益，由于活期宝采取收益复投方式，复合年化收益会高于单日年化收益。", addView: self.view, tipText: "今日年化收益率为：\(self.cbm!.interest_rate)%")
        alertview.center = CGPointMake(self.view.centerx, self.view.centery - 100)
        alertview.layer.cornerRadius = 5
        alertview.maskView?.backgroundColor = UIColor.blackColor()
        alertview.show()
        alertview.showWithBlock({ (buttonIndex) -> Void in
            if buttonIndex == 0 {
                return
            }
        })
    }
    
    //资产配置
    @IBAction func safeguardClick(sender: AnyObject) {
        gotoPage("UserCenter", pageName: "assetAllocationCtrl")
    }
    
    
}
