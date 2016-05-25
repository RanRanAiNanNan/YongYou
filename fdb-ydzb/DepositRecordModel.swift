//
//  DepositRecordModel.swift
//  ydzbapp-hybrid
//  定存宝记录
//  Created by qinxin on 15/9/10.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class DepositRecordModel: NSObject {
    
    var id: String = "'"                    //id
    var names:  String = ""                 //名称
    var fund:   String = ""                 //金额
    var buy_time:   String = ""             //时间
    var type: String = ""                   //类型
    
    init(id newId:String, names newnames:String, fund newfund:String, buy_time newbuy_time:String, type newType: String){
        self.id = newId
        self.names = newnames
        self.fund = newfund
        self.buy_time = newbuy_time
        self.type = newType
    }
   
}
