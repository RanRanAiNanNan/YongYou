//
//  DayLoanRrepayModel.swift
//  ydzbapp-hybrid
//  活期宝预投
//  Created by 刘驰 on 15/3/9.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation


class DayLoanPrepayModel {
    
    var userId:String = ""                      //用户ID
    var productId:String = ""                   //产品ID
    var investFund:String = ""                  //可用体验金
    var dayloanData:Int = 0                     //可赎回份数
    var pwdStatus:Int = 0                       //交易密码状态(0没有交易密码，1有交易密码)
    var usableFund:String = ""                  //可用资金
    var totalScore:String = ""                  //总贡献值
    var usableScore:String = ""                 //可用贡献值
    
    var userExpmoney:String = ""                //可用体验金
    var remarks:String = ""                     //备注
    var quotaShow:String = ""                   //可购限额
    var quota: Int = 0                          //可购限额比较
    
    
}