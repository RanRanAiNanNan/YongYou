//
//  FundRecordModel.swift
//  ydzbapp-hybrid
//  资金记录
//  Created by 刘驰 on 15/2/6.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation

class FundRecordModel {
    
    var fundflow:String                         //名称
    var record_time:String                      //时间
    var fund:String                             //金额
    var type:String                             //正负（偶数负，奇数正）
    var balance:String                          //资金余额
    
    init(fundflow newFundflow:String, record_time newRecord_time:String, fund newFund:String, type newType:String, balance newBalance:String){
        self.fundflow = newFundflow
        self.record_time = newRecord_time
        self.fund = newFund
        self.type = newType
        self.balance = newBalance
    }
    
}