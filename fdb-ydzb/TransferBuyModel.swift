//
//  TransferBuyModel.swift
//  ydzbapp-hybrid
//  债权转让购买
//  Created by qinxin on 15/9/7.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class TransferBuyModel: NSObject {
    var id: String = ""                 //产品id
    var name: String = ""               //产品名称
    var newApr: String = ""             //折合年化
    var buyFund: String = ""            //债权份额
    var predictIncome: String = ""      //预期收益
    var buyTime: String = ""            //购买日期
    var expireTime: String = ""         //到期日期
    var available: String = ""          //状态
}
