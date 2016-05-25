//
//  JumuRecordModel.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/5/20.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation

class JumuRecordModel {
    
    var name:String                         //用户名
    var fund:String                         //金额
    var time:String                         //时间
    var type:String                         //可用余额
    
    
    init(name newName:String, fund newFund:String, time newTime:String, type newType:String){
        self.name = newName
        self.fund = newFund
        self.time = newTime
        self.type = newType
    }
    
}
