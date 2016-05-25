//
//  DepositeMixModel.swift
//  ydzbapp-hybrid
//  定存宝记录
//  Created by qinxin on 15/9/6.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class DepositeMixModel: NSObject {
    
    var screen:             Array<String> = [String]()                    //screen
    var buyFund:            String = ""                                         //已购份数
    var depositIncome:      String = ""                                         //累计收益
    var predictIncome:      String = ""                                         //预期收益
    var dealRecordList:     Array<DepositProductRecord> = [DepositProductRecord]()        //DealRecordModel list
   
}
