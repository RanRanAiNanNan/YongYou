//
//  DayLoanBuyModel.swift
//  ydzbapp-hybrid
//  活期宝购买二级界面
//  Created by 刘驰 on 15/3/6.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation

class DayLoanBuyModel {
    
    var dlMaxAmount:String = ""                         //最大可抢份额
    var dlUsableAmount:String = ""                      //可抢份额
    var usableFund:String = ""                          //可用余额
    var userExpmoney:String = ""                        //可用体验金
    var surplus: String = ""                            //可购份数
    var remainingCopies:Int = 0                         //剩余份数
    var userId:String = ""                              //用户ID
    var productId:String = ""                           //产品ID
    var dayloanApr = ""                                 //天标利率
    var redpacketStatus:Int = 0                         //红包状态 -1 已使用  0 没有可用 1 有可用
    var redpacketList:Array<SelectRedpacketModel> = []  //可用红包
    var remark: String = ""                             //备注
    var redMsg: String = ""                             //红包信息
    var quota: String = ""                              //可购限额
    var quotaShow: String = ""                          //可购限额显示

    
}