//
//  DepositInterestDetailViewController.swift
//  ydzbapp-hybrid
//  定存宝交易记录结息详情
//  Created by qinxin on 15/9/10.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class DepositInterestDetailViewController: BaseViewController {
    
    @IBOutlet weak var productName: UILabel!        //产品名称
    @IBOutlet weak var buyTime: UILabel!            //购买时间
    @IBOutlet weak var expireTime: UILabel!         //到期时间
    @IBOutlet weak var buyFund: UILabel!            //交易金额
    @IBOutlet weak var predictIncome: UILabel!      //产品收益
    @IBOutlet weak var closeButton: UIButton! {     //关闭按钮
        didSet {
            closeButton.layer.cornerRadius = 10.0
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!    //滚动列表
    @IBOutlet weak var popView: UIView! {           //结息弹窗
        didSet {
            popView.layer.cornerRadius = 10.0
        }
    }
    
    @IBOutlet weak var showView: UIView!            //滚动列表背景view
    
    
    var service = DealRecordService.getInstance()
    var params = [String:String]()
    var model = DepositeInterestMixModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAutoLayout()
        loadData()
    }
    
    private func loadData() {
        loadingShow()
        service.loadDataDepositeRecordDetail(params, calback: { (data) -> () in
            self.model = data as! DepositeInterestMixModel
            self.productName.text = self.model.productName
            self.buyTime.text = "购买时间: \(self.model.buyTime)"
            self.expireTime.text = "到期时间: \(self.model.experidTime)"
            self.buyFund.text = "交易金额: \(self.model.buyFund)"
            if self.model.predictIncome == "0.00" {
                self.predictIncome.text = "产品收益: \(self.model.productIncome)"
            }else{
                self.predictIncome.text = "预期收益: \(self.model.predictIncome)"
            }
            self.loadingHidden()
            self.setUpDataToScrollView()
        })
    }
    
    private func setUpDataToScrollView() {
        scrollView.contentSize = CGSizeMake(0, CGFloat(30 * model.dataList.count))
        for i in 0..<model.dataList.count {
            //返利日期
            let exDate: UILabel = UILabel(frame: CGRectMake(0, CGFloat(i * 30), scrollView.width / 3, 30))
            exDate.text = model.dataList[i].date
            exDate.textAlignment = .Left
            exDate.font = UIFont.systemFontOfSize(14)
            exDate.textColor = B.LIST_GRAY_TEXT_COLOR
            scrollView.addSubview(exDate)
            
            //收益金额
            let fund: UILabel = UILabel(frame: CGRectMake(scrollView.width / 3, CGFloat(i * 30), scrollView.width / 3, 30))
            fund.text = model.dataList[i].fund
            fund.textAlignment = .Center
            fund.font = UIFont.systemFontOfSize(14)
            fund.textColor = B.LIST_GRAY_TEXT_COLOR
            scrollView.addSubview(fund)
            
            //状态
            let status: UILabel = UILabel(frame: CGRectMake(B.SCREEN_WIDTH > 320 ?  scrollView.width / 3 * 2 + 10 : scrollView.width / 3 * 2, CGFloat(i * 30), scrollView.width / 3, 30))
            if model.dataList[i].status == "1" {
                status.text = "已结算"
            }else{
                status.text = "未结算"
            }
            status.textAlignment = .Center
            status.font = UIFont.systemFontOfSize(14)
            status.textColor = B.LIST_GRAY_TEXT_COLOR
            scrollView.addSubview(status)
        }
    }
    
    
    //MARK: - Action
    
    @IBAction func close(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //iPhone4适配
    func initAutoLayout(){
        switch Device.version() {
        case .iPhone4, .iPhone4S:
            //兼容4s高度都减30
            constrain(popView,showView,scrollView){
                popView,showView,scrollView in
                popView.height == 385
                showView.height == 200
                scrollView.height == 148
            }
        default:
            break
        }
    }
    
}
