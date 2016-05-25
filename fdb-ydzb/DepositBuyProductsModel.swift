//
//  DepositBuyProductsModel.swift
//  ydzbapp-hybrid
//  定存已购产品记录详情
//  Created by 刘驰 on 15/3/9.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation

class DepositBuyProductsModel {
    
    var productName:String = ""                 //产品名称
    var buyFund:String = ""                     //投资金额
    var isMode:String = ""                      //0不复投，1复投
    var expireTime:String = ""                  //到期日期
    var status = ""                             //状态0未到期,1已到期,2转让中 如果为0转让上传状态2，如果为2转让上传状态1
    var predictIncome: String = ""              //预期收益
    var buyTime: String = ""                    //购买时间
    var income_mode: String = ""                //利息复投
    var allMoney: String = ""                   //债权金额
    var feeMoney: String = ""                   //手续费
    var redpacket: String = "'"                 //是否红包购买来的可否转让
    var grandApr:String = ""                    //红包利率
    var apr:String = ""                         //利率
    var vipApr:String = ""                      //vip利率
    var interest_fund: String = ""              //到期收益
    var refundAble: String = ""                 //折合利率
    var formulaAdd: String = ""                 //
    var formulaDiv: String = ""                 //
    var max: String = ""                        //最大值
    var applyFund: String = ""                  //装让金额 当按钮为 取消转账与转让中时显示
    var overMoney: String = ""                  //折损利息
    var money: String = ""                      //到账金额
}