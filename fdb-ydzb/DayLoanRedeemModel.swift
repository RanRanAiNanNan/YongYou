//
//  DayLoanRedeemModel.swift
//  ydzbapp-hybrid
//  活期宝赎回
//  Created by 刘驰 on 15/3/9.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation


class DayLoanRedeemModel {
    
    var userId:String = ""                      //用户ID
    var productId:String = ""                   //产品ID
    var dayloanData:String = ""                 //可赎回份数
    var pwdStatus:Int = 0                       //交易密码状态(0没有交易密码，1有交易密码)
    var remarks:String = ""                     //备注
    var dayloan_money: String = ""              //比较
    
}