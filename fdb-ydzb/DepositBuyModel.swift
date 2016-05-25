//
//  DepositBuyModel.swift
//  ydzbapp-hybrid
//  定存购买二级界面
//  Created by 刘驰 on 15/3/10.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation

class DepositBuyModel {
    
    var usableFund:String = ""                          //可用余额
    var productDaySettingId:String = ""                 //天标设置ID
    var productActivityApr = ""                         //产品活动利率
    var remainingCopies:String = ""                     //剩余份数
    var userId:String = ""                              //用户ID
    var productApr:String = ""                          //产品利率
    var days:String = ""                                //产品天数
    var redpacketStatus:Int = 0                         //红包状态 -1 已使用  0 没有可用 1 有可用
    var redpacketList:Array<BuyRedpacketModel> = []     //可用红包
    
    var productId:String = ""                           //产品id
    var remarks:String = ""                             //备注
    var deadline:String = ""                            //锁定期
    var msg:String = ""                                 //红包文字说明
    var vipApr:String = ""                              //vip利率
    var redpacketName: String = ""                      //红包跳转来的名字
    var redpacketApr: String = ""                       //红包利率
    
}