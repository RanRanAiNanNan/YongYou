//  银行卡模型
//  BandCarModel.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/9/2.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation

class BandCarModel {
     /** ID **/
    var id:String = ""
     /** 银行名称 **/
    var bankName:String = ""
     /** 开户行省份 **/
    var bankProvince:String = ""
     /** 开户行城市 **/
    var bankCity:String = ""
     /** 支行名称 **/
    var bankOpening:String = ""
     /** 银行卡号 **/
    var cardNo:String = ""
     /** 是否充值 **/
    var isRecharge = ""
     /** 用户ID **/
    var userId = ""
     /** 状态 **/
    var state = ""
     /** 类型 **/
    var type = ""
     /** 真实姓名 **/
    var realName = ""
     /** 订单号 **/
    var order = ""
    /** 身份证号 **/
    var idCard = ""
    /** 银行列表 **/
    var bankList = []
    /** 银行隐藏手机号与验证码列表 **/
    var hideList = []
    /** 令牌（现用于验证是否获得验证码） **/
    var token = ""
    
}