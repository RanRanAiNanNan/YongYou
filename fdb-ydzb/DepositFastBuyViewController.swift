//
//  DepositFastBuyViewController.swift
//  ydzbapp-hybrid
//  定存购买首页
//  Created by qinxin on 15/8/29.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class DepositFastBuyViewController: BaseViewController, UIScrollViewDelegate{
    
    //MARK: - Outlet
    
    //产品列表 scroll
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
        }
    }
    //产品1个月文字按钮
    @IBOutlet weak var button1: UIButton! {
        didSet {
            button1.selected = true
        }
    }
    //产品3个月文字按钮
    @IBOutlet weak var button3: UIButton!
    //产品6个月文字按钮
    @IBOutlet weak var button6: UIButton!
    //产品12个月文字按钮
    @IBOutlet weak var button12: UIButton!
    
    //产品1个月圆点按钮
    @IBOutlet weak var circleButton1: UIButton! {
        didSet {
            circleButton1.selected = true
        }
    }
    //产品3个月圆点按钮
    @IBOutlet weak var circleButton3: UIButton!
    //产品6个月圆点按钮
    @IBOutlet weak var circleButton6: UIButton!
    //产品12个月圆点按钮
    @IBOutlet weak var circleButton12: UIButton!
    
    //当前份额
    @IBOutlet weak var surplusLabel: UILabel!
    
    //立即投资按钮
    @IBOutlet weak var investmentButton: UIButton! {
        didSet {
            investmentButton.layer.cornerRadius = 10.0
        }
    }
    
    
    
    //MARK: - Variable
    
    //圆圈 view
    private var circleView1:            CircleView!
    private var circleView3:            CircleView!
    private var circleView6:            CircleView!
    private var circleView12:           CircleView!
    
    //水浪 view
    private var animateView1:           SXWaveView!
    private var animateView3:           SXWaveView!
    private var animateView6:           SXWaveView!
    private var animateView12:          SXWaveView!
    
    //产品中文名称
    private var monthLabel1 =           UILabel()
    private var monthLabel3 =           UILabel()
    private var monthLabel6 =           UILabel()
    private var monthLabel12 =          UILabel()
    
    //产品英文注脚
    private var monthLabelEng1 =        UILabel()
    private var monthLabelEng3 =        UILabel()
    private var monthLabelEng6 =        UILabel()
    private var monthLabelEng12 =       UILabel()
    
    //产品数组
    private var productList:[DepositProductModel] = []
    //产品id
    private var productId: String = ""
    
    //MARK: - Constant
    private let ydFinancingService = YdFinancingService.getInstance()
    
    /** float 类型 1  ～ 100 */
     //波浪幅度
    var progress:           Float32 = 30
    
    //vip标识图
    var vipApr1: UIImageView!
    var vipApr3: UIImageView!
    var vipApr6: UIImageView!
    var vipApr12: UIImageView!
    
    //收益值
    var yearIncomeTip1: UILabel!
    var yearIncomeTip3: UILabel!
    var yearIncomeTip6: UILabel!
    var yearIncomeTip12: UILabel!
    
    //红包
    var redpacket_id: String = ""
    var redpacketName: String = ""
    
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingShow()
        initConstraint()
        initNav("定存宝")
        addHelpCenter("deposit")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    func initConstraint(){
        switch Device.version() {
        case .iPhone4S, .iPhone4:
            constrain(circleButton1, circleButton3, circleButton6, circleButton12){
                circleButton1, circleButton3, circleButton6, circleButton12 in
                circleButton3.left == circleButton1.right + 65
                circleButton6.left == circleButton3.right + 65
                circleButton12.left == circleButton6.right + 65
            }
        case .iPhone5, .iPhone5C, .iPhone5S:
            constrain(circleButton1, circleButton3, circleButton6, circleButton12){
                circleButton1, circleButton3, circleButton6, circleButton12 in
                circleButton3.left == circleButton1.right + 65
                circleButton6.left == circleButton3.right + 65
                circleButton12.left == circleButton6.right + 65
            }
        case .iPhone6Plus, .iPhone6SPlus:
            constrain(circleButton1, circleButton3, circleButton6, circleButton12){
                circleButton1, circleButton3, circleButton6, circleButton12 in
                circleButton3.left == circleButton1.right + 100
                circleButton6.left == circleButton3.right + 90
            }
        default:
            break
        }
    }
    
    //MARK: - Private Methods
    
    private func initView() {
        switch scrollView.contentOffset.x {
        case 0 :
            circleButton1.selected = true
            circleButton3.selected = false
            circleButton6.selected = false
            circleButton12.selected = false
            
            button1.selected = true
            button3.selected = false
            button6.selected = false
            button12.selected = false
            
            self.surplusLabel.text = self.productList[0].surplus
            self.productId = self.productList[0].productId
            
        case B.SCREEN_WIDTH :
            circleButton1.selected = false
            circleButton3.selected = true
            circleButton6.selected = false
            circleButton12.selected = false
            
            button1.selected = false
            button3.selected = true
            button6.selected = false
            button12.selected = false
            
            self.surplusLabel.text = self.productList[1].surplus
            self.productId = self.productList[1].productId
        case B.SCREEN_WIDTH * 2 :
            circleButton1.selected = false
            circleButton3.selected = false
            circleButton6.selected = true
            circleButton12.selected = false
            
            button1.selected = false
            button3.selected = false
            button6.selected = true
            button12.selected = false
            
            self.surplusLabel.text = self.productList[2].surplus
            self.productId = self.productList[2].productId
        case B.SCREEN_WIDTH * 3 :
            circleButton3.selected = false
            circleButton3.selected = false
            circleButton6.selected = false
            circleButton12.selected = true
            
            button1.selected = false
            button3.selected = false
            button6.selected = false
            button12.selected = true
            
            self.surplusLabel.text = self.productList[3].surplus
            self.productId = self.productList[3].productId
        default:
            break
        }
    }
    
    private func loadData() {
        ydFinancingService.loadDepositData({
            (data) -> () in
            self.productList = data as! Array<DepositProductModel>
            self.loadingHidden()
            //配置 scroll view
            self.setUpScrollView()
            //init view
            self.initView()
        })
    }
    
    private struct CirViewConstant {
        static let W: CGFloat = 210
        static let H: CGFloat = 210
        static let TOP: CGFloat = 100
    }
    
    private func setUpScrollView() {
        scrollView.contentSize = CGSizeMake(scrollView.bounds.size.width * 4, 0)
        if circleView1 == nil {
            circleView1 = CircleView(frame: CGRectMake(scrollView.centerx - CirViewConstant.W / 2, B.SCREEN_WIDTH > 320 ? CirViewConstant.TOP : 55, CirViewConstant.W, CirViewConstant.H))
            circleView1.arcBounds = 100
            scrollView.addSubview(circleView1)
            
            if animateView1 == nil {
                animateView1 = SXWaveView(frame: CGRectMake(0, 2, circleView1.bounds.width, circleView1.bounds.height))
                animateView1.setPrecent(progress, avg:productList[0].interest_rate, textColor:B.BUY_COFFEE_TEXT_COLOR, bgColor: UIColor.clearColor(), alpha: 1.0, clips: false)
                animateView1.addAnimateWithType(0)
                circleView1.addSubview(animateView1)
                
                //重置利率位置
                animateView1.avgScoreLbl?.center = CGPointMake(animateView1.centerx, animateView1.centery - 20)
                
                //vip标识
                vipApr1 = UIImageView(image: UIImage(named: "vip_0.5"))
                vipApr1.center = CGPointMake(animateView1.avgScoreLbl!.centerx + vipApr1.width, animateView1.avgScoreLbl!.centery - 25)
                circleView1.addSubview(vipApr1)
                
                //年化收益率
                yearIncomeTip1 = UILabel(frame: CGRectMake(animateView1.centerx - 50, animateView1.avgScoreLbl!.bottom, 100, 20))
                yearIncomeTip1.text = "年化收益率"
                yearIncomeTip1.textColor = B.BUY_GRAY_TEXT_COLOR
                yearIncomeTip1.textAlignment = .Center
                yearIncomeTip1.font = UIFont.systemFontOfSize(7 * circleView1.bounds.width / 125)
                circleView1.addSubview(yearIncomeTip1)
                
                if (B.SCREEN_WIDTH > 320) {
                    monthLabel1.frame = CGRectMake(scrollView.centerx - 100, 40, 200, 24)
                    monthLabel1.textColor = B.BUY_COFFEE_TEXT_COLOR
                    monthLabel1.textAlignment = NSTextAlignment.Center
                    monthLabel1.font = UIFont.systemFontOfSize(24)
                    monthLabel1.text = productList[0].name
                    scrollView.addSubview(monthLabel1)
                    
                    monthLabelEng1.frame = CGRectMake(scrollView.centerx - 110, 64, 220, 15)
                    monthLabelEng1.textColor = B.BUY_COFFEE_TEXT_COLOR
                    monthLabelEng1.textAlignment = NSTextAlignment.Center
                    monthLabelEng1.font = UIFont.boldSystemFontOfSize(15)
                    monthLabelEng1.text = "DEPOSIT TREASURE"
                    scrollView.addSubview(monthLabelEng1)
                }else{
                    monthLabel1.frame = CGRectMake(scrollView.centerx - 100, 10, 200, 20)
                    monthLabel1.textColor = B.BUY_COFFEE_TEXT_COLOR
                    monthLabel1.textAlignment = NSTextAlignment.Center
                    monthLabel1.font = UIFont.systemFontOfSize(20)
                    monthLabel1.text = productList[0].name
                    scrollView.addSubview(monthLabel1)
                    
                    monthLabelEng1.frame = CGRectMake(scrollView.centerx - 110, 32, 220, 12)
                    monthLabelEng1.textColor = B.BUY_COFFEE_TEXT_COLOR
                    monthLabelEng1.textAlignment = NSTextAlignment.Center
                    monthLabelEng1.font = UIFont.boldSystemFontOfSize(12)
                    monthLabelEng1.text = "DEPOSIT TREASURE"
                    scrollView.addSubview(monthLabelEng1)
                }
            }
        }
        
        if circleView3 == nil {
            circleView3 = CircleView(frame: CGRectMake(B.SCREEN_WIDTH +  scrollView.centerx - CirViewConstant.W / 2, B.SCREEN_WIDTH > 320 ? CirViewConstant.TOP : 55, CirViewConstant.W, CirViewConstant.H))
            circleView3.arcBounds = 100
            circleView3.alpha = CGFloat(0.2)
            scrollView.addSubview(circleView3)
            
            if animateView3 == nil {
                animateView3 = SXWaveView(frame: CGRectMake(0, 2, circleView3.bounds.width, circleView3.bounds.height))
                animateView3.setPrecent(progress, avg: productList[1].interest_rate, textColor: B.BUY_COFFEE_TEXT_COLOR, bgColor: UIColor.clearColor(), alpha: 1.0, clips: false)
                animateView3.addAnimateWithType(0)
                circleView3.addSubview(animateView3)
                
                //重置利率位置
                animateView3.avgScoreLbl?.center = CGPointMake(animateView3.centerx, animateView3.centery - 20)
                
                vipApr3 = UIImageView(image: UIImage(named: "vip_0.5"))
                vipApr3.center = CGPointMake(animateView3.avgScoreLbl!.centerx + vipApr3.width, animateView3.avgScoreLbl!.centery - 25)
                circleView3.addSubview(vipApr3)
                
                //年化收益率
                yearIncomeTip3 = UILabel(frame: CGRectMake(animateView3.centerx - 50, animateView3.avgScoreLbl!.bottom, 100, 20))
                yearIncomeTip3.text = "年化收益率"
                yearIncomeTip3.textColor = B.BUY_GRAY_TEXT_COLOR
                yearIncomeTip3.textAlignment = .Center
                yearIncomeTip3.font = UIFont.systemFontOfSize(7 * circleView3.bounds.width / 125)
                circleView3.addSubview(yearIncomeTip3)
                
                if B.SCREEN_WIDTH > 320 {
                    monthLabel3.frame = CGRectMake(B.SCREEN_WIDTH + scrollView.centerx - 100, 40, 200, 20)
                    monthLabel3.textColor = B.BUY_COFFEE_TEXT_COLOR
                    monthLabel3.textAlignment = NSTextAlignment.Center
                    monthLabel3.font = UIFont.systemFontOfSize(24)
                    monthLabel3.text = productList[1].name
                    scrollView.addSubview(monthLabel3)
                    
                    monthLabelEng3.frame = CGRectMake(B.SCREEN_WIDTH + scrollView.centerx - 110, 64, 220, 15)
                    monthLabelEng3.textColor = B.BUY_COFFEE_TEXT_COLOR
                    monthLabelEng3.textAlignment = NSTextAlignment.Center
                    monthLabelEng3.font = UIFont.boldSystemFontOfSize(15)
                    monthLabelEng3.text = "DEPOSIT TREASURE"
                    scrollView.addSubview(monthLabelEng3)
                    
                }else{
                    monthLabel3.frame = CGRectMake(B.SCREEN_WIDTH + scrollView.centerx - 100, 10, 200, 20)
                    monthLabel3.textColor = B.BUY_COFFEE_TEXT_COLOR
                    monthLabel3.textAlignment = NSTextAlignment.Center
                    monthLabel3.font = UIFont.systemFontOfSize(20)
                    monthLabel3.text = productList[1].name
                    scrollView.addSubview(monthLabel3)
                    
                    monthLabelEng3.frame = CGRectMake(B.SCREEN_WIDTH + scrollView.centerx - 110, 32, 220, 12)
                    monthLabelEng3.textColor = B.BUY_COFFEE_TEXT_COLOR
                    monthLabelEng3.textAlignment = NSTextAlignment.Center
                    monthLabelEng3.font = UIFont.boldSystemFontOfSize(12)
                    monthLabelEng3.text = "DEPOSIT TREASURE"
                    scrollView.addSubview(monthLabelEng3)
                }
                
            }
            
        }
        if circleView6 == nil {
            circleView6 = CircleView(frame: CGRectMake(B.SCREEN_WIDTH * 2 + scrollView.centerx - CirViewConstant.W / 2, B.SCREEN_WIDTH > 320 ? CirViewConstant.TOP : 55, CirViewConstant.W, CirViewConstant.H))
            circleView6.arcBounds = 100
            circleView6.alpha = CGFloat(0.2)
            scrollView.addSubview(circleView6)
            
            if animateView6 == nil {
                animateView6 = SXWaveView(frame: CGRectMake(0, 2, circleView6.bounds.width, circleView6.bounds.height))
                animateView6.setPrecent(progress, avg: productList[2].interest_rate, textColor: B.BUY_COFFEE_TEXT_COLOR, bgColor: UIColor.clearColor(), alpha: 1.0, clips: false)
                animateView6.addAnimateWithType(0)
                circleView6.addSubview(animateView6)
                
                //重置利率位置
                animateView6.avgScoreLbl?.center = CGPointMake(animateView6.centerx, animateView6.centery - 20)
                
                vipApr6 = UIImageView(image: UIImage(named: "vip_0.5"))
                vipApr6.center = CGPointMake(animateView6.avgScoreLbl!.centerx + vipApr6.width, animateView6.avgScoreLbl!.centery - 25)
                circleView6.addSubview(vipApr6)
                
                //年化收益率
                yearIncomeTip6 = UILabel(frame: CGRectMake(animateView6.centerx - 50, animateView6.avgScoreLbl!.bottom, 100, 20))
                yearIncomeTip6.text = "年化收益率"
                yearIncomeTip6.textColor = B.BUY_GRAY_TEXT_COLOR
                yearIncomeTip6.textAlignment = .Center
                yearIncomeTip6.font = UIFont.systemFontOfSize(7 * circleView6.bounds.width / 125)
                circleView6.addSubview(yearIncomeTip6)
                
                if B.SCREEN_WIDTH > 320 {
                    monthLabel6.frame = CGRectMake(B.SCREEN_WIDTH * 2 + scrollView.centerx - 100, 40, 200, 20)
                    monthLabel6.textColor = B.BUY_COFFEE_TEXT_COLOR
                    monthLabel6.textAlignment = NSTextAlignment.Center
                    monthLabel6.font = UIFont.systemFontOfSize(24)
                    monthLabel6.text = productList[2].name
                    scrollView.addSubview(monthLabel6)
                    
                    monthLabelEng6.frame = CGRectMake(B.SCREEN_WIDTH * 2 + scrollView.centerx - 110, 64, 220, 15)
                    monthLabelEng6.textColor = B.BUY_COFFEE_TEXT_COLOR
                    monthLabelEng6.textAlignment = NSTextAlignment.Center
                    monthLabelEng6.font = UIFont.boldSystemFontOfSize(15)
                    monthLabelEng6.text = "DEPOSIT TREASURE"
                    scrollView.addSubview(monthLabelEng6)
                }else{
                    monthLabel6.frame = CGRectMake(B.SCREEN_WIDTH * 2 + scrollView.centerx - 100, 10, 200, 20)
                    monthLabel6.textColor = B.BUY_COFFEE_TEXT_COLOR
                    monthLabel6.textAlignment = NSTextAlignment.Center
                    monthLabel6.font = UIFont.systemFontOfSize(20)
                    monthLabel6.text = productList[2].name
                    scrollView.addSubview(monthLabel6)
                    
                    monthLabelEng6.frame = CGRectMake(B.SCREEN_WIDTH * 2 + scrollView.centerx - 110, 32, 220, 12)
                    monthLabelEng6.textColor = B.BUY_COFFEE_TEXT_COLOR
                    monthLabelEng6.textAlignment = NSTextAlignment.Center
                    monthLabelEng6.font = UIFont.boldSystemFontOfSize(12)
                    monthLabelEng6.text = "DEPOSIT TREASURE"
                    scrollView.addSubview(monthLabelEng6)
                }
            }
        }
        
        
        if circleView12 == nil {
            circleView12 = CircleView(frame: CGRectMake(B.SCREEN_WIDTH * 3 + scrollView.centerx - CirViewConstant.W / 2, B.SCREEN_WIDTH > 320 ? CirViewConstant.TOP : 55, CirViewConstant.W, CirViewConstant.H))
            circleView12.arcBounds = 100
            circleView12.alpha = CGFloat(0.2)
            scrollView.addSubview(circleView12)
            
            if animateView12 == nil {
                animateView12 = SXWaveView(frame: CGRectMake(0, 2, circleView12.bounds.width, circleView12.bounds.height))
                animateView12.setPrecent(progress, avg: productList[3].interest_rate, textColor: B.BUY_COFFEE_TEXT_COLOR, bgColor: UIColor.clearColor(), alpha: 1.0, clips: false)
                animateView12.addAnimateWithType(0)
                circleView12.addSubview(animateView12)
                
                //重置利率位置
                animateView12.avgScoreLbl?.center = CGPointMake(animateView12.centerx, animateView12.centery - 20)
                
                vipApr12 = UIImageView(image: UIImage(named: "vip_0.5"))
                vipApr12.center = CGPointMake(animateView12.avgScoreLbl!.centerx + vipApr12.width, animateView12.avgScoreLbl!.centery - 25)
                circleView12.addSubview(vipApr12)
                
                //年化收益率
                yearIncomeTip12 = UILabel(frame: CGRectMake(animateView12.centerx - 50, animateView12.avgScoreLbl!.bottom, 100, 20))
                yearIncomeTip12.text = "年化收益率"
                yearIncomeTip12.textColor = B.BUY_GRAY_TEXT_COLOR
                yearIncomeTip12.textAlignment = .Center
                yearIncomeTip12.font = UIFont.systemFontOfSize(7 * circleView12.bounds.width / 125)
                circleView12.addSubview(yearIncomeTip12)
                
                if B.SCREEN_WIDTH > 320 {
                    monthLabel12.frame = CGRectMake(B.SCREEN_WIDTH * 3 + scrollView.centerx - 100, 40, 200, 20)
                    monthLabel12.textColor = B.BUY_COFFEE_TEXT_COLOR
                    monthLabel12.textAlignment = NSTextAlignment.Center
                    monthLabel12.font = UIFont.systemFontOfSize(24)
                    monthLabel12.text = productList[3].name
                    scrollView.addSubview(monthLabel12)
                    
                    monthLabelEng12.frame = CGRectMake(B.SCREEN_WIDTH * 3 + scrollView.centerx - 110, 64, 220, 15)
                    monthLabelEng12.textColor = B.BUY_COFFEE_TEXT_COLOR
                    monthLabelEng12.textAlignment = NSTextAlignment.Center
                    monthLabelEng12.font = UIFont.boldSystemFontOfSize(15)
                    monthLabelEng12.text = "DEPOSIT TREASURE"
                    scrollView.addSubview(monthLabelEng12)
                }else{
                    monthLabel12.frame = CGRectMake(B.SCREEN_WIDTH * 3 + scrollView.centerx - 100, 10, 200, 20)
                    monthLabel12.textColor = B.BUY_COFFEE_TEXT_COLOR
                    monthLabel12.textAlignment = NSTextAlignment.Center
                    monthLabel12.font = UIFont.systemFontOfSize(20)
                    monthLabel12.text = productList[3].name
                    scrollView.addSubview(monthLabel12)
                    
                    monthLabelEng12.frame = CGRectMake(B.SCREEN_WIDTH * 3 + scrollView.centerx - 110, 32, 220, 12)
                    monthLabelEng12.textColor = B.BUY_COFFEE_TEXT_COLOR
                    monthLabelEng12.textAlignment = NSTextAlignment.Center
                    monthLabelEng12.font = UIFont.boldSystemFontOfSize(12)
                    monthLabelEng12.text = "DEPOSIT TREASURE"
                    scrollView.addSubview(monthLabelEng12)
                }
            }
        }
        
    }
    
    
    //MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        switch scrollView.contentOffset.x {
        case 0:
            circleView1.alpha = CGFloat(1.0)
            circleView3.alpha = CGFloat(0.2)
            circleView6.alpha = CGFloat(0.2)
            circleView12.alpha = CGFloat(0.2)
            
            button1.selected = true
            button3.selected = false
            button6.selected = false
            button12.selected = false
            
            circleButton1.selected = true
            circleButton3.selected = false
            circleButton6.selected = false
            circleButton12.selected = false
            
            surplusLabel.text = productList[0].surplus
            
            self.productId = self.productList[0].productId
            
        case view.bounds.width:
            circleView1.alpha = CGFloat(0.2)
            circleView3.alpha = CGFloat(1.0)
            circleView6.alpha = CGFloat(0.2)
            circleView12.alpha = CGFloat(0.2)
            
            button1.selected = false
            button3.selected = true
            button6.selected = false
            button12.selected = false
            
            circleButton1.selected = false
            circleButton3.selected = true
            circleButton6.selected = false
            circleButton12.selected = false
            
            surplusLabel.text = productList[1].surplus
            
            self.productId = self.productList[1].productId
            
        case view.bounds.width * 2:
            circleView1.alpha = CGFloat(0.2)
            circleView3.alpha = CGFloat(0.2)
            circleView6.alpha = CGFloat(1.0)
            circleView12.alpha = CGFloat(0.2)
            
            button1.selected = false
            button3.selected = false
            button6.selected = true
            button12.selected = false
            
            circleButton1.selected = false
            circleButton3.selected = false
            circleButton6.selected = true
            circleButton12.selected = false
            
            surplusLabel.text = productList[2].surplus
            
            self.productId = self.productList[2].productId
            
        case view.bounds.width * 3:
            circleView1.alpha = CGFloat(0.2)
            circleView3.alpha = CGFloat(0.2)
            circleView6.alpha = CGFloat(0.2)
            circleView12.alpha = CGFloat(1.0)
            
            button1.selected = false
            button3.selected = false
            button6.selected = false
            button12.selected = true
            
            circleButton1.selected = false
            circleButton3.selected = false
            circleButton6.selected = false
            circleButton12.selected = true
            
            surplusLabel.text = productList[3].surplus
            
            self.productId = self.productList[3].productId
            
        default:
            break
        }
    }
    
    private struct TransForm3DAnimate {
        static let SX: CGFloat = 0.8
        static let SY: CGFloat = 0.8
        static let SZ: CGFloat = 1.0
        
        static let Duration:        NSTimeInterval = 0.3
        static let Delay:           NSTimeInterval = 0.2
        static let SpringDamping:   CGFloat = 1.0
        static let SpringVelocity:  CGFloat = 0.0
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        let transform : CATransform3D = CATransform3DMakeScale(TransForm3DAnimate.SX, TransForm3DAnimate.SY, TransForm3DAnimate.SZ)
        circleView1.layer.transform = transform
        circleView3.layer.transform = transform
        circleView6.layer.transform = transform
        circleView12.layer.transform = transform
        
        circleView1.alpha = CGFloat(0.2)
        circleView3.alpha = CGFloat(0.2)
        circleView6.alpha = CGFloat(0.2)
        circleView12.alpha = CGFloat(0.2)
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        [UIView .animateWithDuration(TransForm3DAnimate.Duration, delay: TransForm3DAnimate.Delay, usingSpringWithDamping: TransForm3DAnimate.SpringDamping, initialSpringVelocity: TransForm3DAnimate.SpringVelocity, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.circleView1.layer.transform = CATransform3DIdentity
            self.circleView3.layer.transform = CATransform3DIdentity
            self.circleView6.layer.transform = CATransform3DIdentity
            self.circleView12.layer.transform = CATransform3DIdentity
            }, completion: nil)]
    }
    
    @IBAction func action1(sender: AnyObject) {
        scrollView.setContentOffset(CGPointMake(0, scrollView.contentOffset.y), animated: true)
        circleButton1.selected = true
        circleButton3.selected = false
        circleButton6.selected = false
        circleButton12.selected = false
        
        surplusLabel.text = productList[0].surplus
        
        self.productId = self.productList[0].productId
    }
    
    
    //MARK: - Action
    
    @IBAction func action3(sender: AnyObject) {
        scrollView.setContentOffset(CGPointMake(view.bounds.width, scrollView.contentOffset.y), animated: true)
        circleButton1.selected = false
        circleButton3.selected = true
        circleButton6.selected = false
        circleButton12.selected = false
        
        surplusLabel.text = productList[1].surplus
        
        self.productId = self.productList[1].productId
    }
    
    @IBAction func action6(sender: AnyObject) {
        scrollView.setContentOffset(CGPointMake(view.bounds.width * 2, scrollView.contentOffset.y), animated: true)
        circleButton1.selected = false
        circleButton3.selected = false
        circleButton6.selected = true
        circleButton12.selected = false
        
        surplusLabel.text = productList[2].surplus
        
        self.productId = self.productList[2].productId
    }
    
    
    
    @IBAction func action12(sender: UIButton) {
        scrollView.setContentOffset(CGPointMake(view.bounds.width * 3, scrollView.contentOffset.y), animated: true)
        circleButton1.selected = false
        circleButton3.selected = false
        circleButton6.selected = false
        circleButton12.selected = true
        
        surplusLabel.text = productList[3].surplus
        
        self.productId = self.productList[3].productId
    }
    
    //资产配置
    @IBAction func safeguardClick(sender: AnyObject) {
        gotoPage("UserCenter", pageName: "assetAllocationCtrl")
    }
    
    
    //MARK: - UINavigation segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "DepositBuyVC_Detail" {
            if segue.destinationViewController.isKindOfClass(DepositBuyDetailViewController) {
                let dbdv = segue.destinationViewController as! DepositBuyDetailViewController
                dbdv.productId = productId
                dbdv.redId = redpacket_id
                dbdv.redpacketName = redpacketName
            }
        }
    }
    
    
}
