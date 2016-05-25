//
//  DepositProduct.swift
//  ydzbapp-hybrid
//  定存购买
//  Created by 刘驰 on 15/3/2.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation

class DepositProductModel{
    
    var name:String = ""                        //产品名称
    var apr:String = ""                         //利率
    var activityApr:String = ""                 //活动利率
    var remainingCopies:String = ""             //发行份数
    var days:String = ""                        //天数
    var productId:String = ""                   //产品id
    var surplus:String = ""                     //当前份额
    var interest_rate:Float32 = 0.00            //年化收益率
    var vipApr: String = ""                     //vip利率
    
}