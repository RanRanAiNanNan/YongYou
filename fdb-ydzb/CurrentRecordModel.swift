//
//  CurrentRecordModel.swift
//  ydzbapp-hybrid
//  活期宝记录
//  Created by qinxin on 15/9/10.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class CurrentRecordModel: NSObject {
    
    var names: String = ""              //名称
    var fund: String = ""               //金额
    var buy_time: String = ""           //操作时间
   
    init(names newnames:String, fund newfund:String, buy_time newbuy_time:String){
        self.names = newnames
        self.fund = newfund
        self.buy_time = newbuy_time
    }
}
