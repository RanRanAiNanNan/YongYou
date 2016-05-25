//
//  ReferralModel.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/2/10.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation

class ReferralModel {
    
    var name:String                     //用户名
    var fund:Double = 0                 //投资金额
    var time:String                     //时间
    var backFund:String                 //返现金额
    
    init(name newName:String, fund newFund:Double, time newTime:String, backFund newBackFund:String){
        self.name = newName
        self.fund = newFund
        self.time = newTime
        self.backFund = newBackFund
    }
    
}