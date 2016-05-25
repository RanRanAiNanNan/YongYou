//  交易记录模型
//  DealRecordModel.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/2/12.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation

class DealRecordModel {
    
    var surplusDays:String                     //还有多少天到期
    var isMode:String                       //是否复投 0 or 1
    var status:String                       //交易类型 1,3 interestFund else predictIncome
    var id:String                           //产品id
    var productName:String                  //产品名称
    var buyFund:String                      //购买份数
    var predictIncome:String                //预期收益
    var interestFund:String                 //预期收益 1,3
    var buyTime:String                      //购买日期
    var expireTime:String                   //到期日期
    var transCount:String                   //是否转让 0 or 1
    
    init(surplusDays: String, isMode: String, status: String, id: String, productName: String, buyFund: String, predictIncome: String, interestFund: String, buyTime: String, expireTime: String, transCount newTransCount: String){
        self.surplusDays = surplusDays
        self.isMode = isMode
        self.status = status
        self.id = id
        self.productName = productName
        self.buyFund = buyFund
        self.predictIncome = predictIncome
        self.interestFund = interestFund
        self.buyTime = buyTime
        self.expireTime = expireTime
        self.transCount = newTransCount
    }
    
}