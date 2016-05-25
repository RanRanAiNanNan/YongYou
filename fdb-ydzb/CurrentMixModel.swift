//
//  CurrentMixModel.swift
//  ydzbapp-hybrid
//  活期宝记录
//  Created by qinxin on 15/9/10.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class CurrentMixModel: NSObject {
    
    var investDayloan: String = ""          //已购份数
    var yeterdayIncome: String = ""         //昨日收益
    var incomeDayload: String = ""          //累计收益
    
    var dataList = [CurrentRecordModel]()
   
}
