//
//  DepositeInterestMixModel.swift
//  ydzbapp-hybrid
//  定存结息记录
//  Created by qinxin on 15/9/10.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class DepositeInterestMixModel: NSObject {
    
    var buyTime: String = ""            //购买时间
    var experidTime: String = ""        //赎回时间
    var buyFund: String = ""            //交易金额
    var predictIncome: String = ""      //预期收益
    var productName: String = ""        //产品名称
    var productIncome: String = ""      //产品收益
    
    var dataList = [DepositInterestModel]()
   
}
