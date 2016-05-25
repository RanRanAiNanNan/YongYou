//
//  StableRecordModel.swift
//  ydzbapp-hybrid
//  稳进宝记录
//  Created by 刘驰 on 15/5/25.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation

class StableRecordModel {
    
    var productName:String                          //项目名称
    var status:String                               //项目状态
    var fund:String                                 //投资金额
    var btime:String                                //投资时间
    var closeDate:String                            //到期时间
    var apr: String                                 //利率
    var income: String                              //收益
    
    init(productName newproductName:String, status newstatus:String, fund newFund:String, btime newbtime:String, closeDate newcloseDate:String, apr newapr:String, income newIncome:String){
        self.productName = newproductName
        self.status = newstatus
        self.fund = newFund
        self.btime = newbtime
        self.closeDate = newcloseDate
        self.apr = newapr
        self.income = newIncome
    }
    
}