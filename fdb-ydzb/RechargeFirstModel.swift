//
//  CheckRechargeModel.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/9/2.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation

class RechargeFirstModel {
    
    var order = ""                      //充值订单号
    var cardNo = ""                     //资金余额
    var bankName = ""                   //昨日收益
    var bankId = ""                     //银行ID
    var isCheck = ""                    //查检姓名身份证
    var isRecharge = ""                 //查检电话验证码
    var hideCheck = false               //是否隐藏姓名，身份证号
    var hideRecharge = false            //是否隐藏电话号，验证码
    var token = ""                      //充值令牌
    var bankCode = ""                   //银行代码
    var rechargeTotal = ""              //充值总额
    var rechargeQuota = ""              //可充值总额
    var rechargeQuotaShow = ""          //可充值总额（带千分符）
    
}