//
//  DepositInterestModel.swift
//  ydzbapp-hybrid
//  定存结息记录
//  Created by qinxin on 15/9/7.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class DepositInterestModel: NSObject {
    
    var fund: String = ""               //收益金额
    var status: String = ""             //状态
    var name: String = ""               //收益类型
    var date: String = ""               //返利日期
    
    init(fund newfund:String, status newstatus:String, name newname:String, date newdate:String){
        self.fund = newfund
        self.status = newstatus
        self.name = newname
        self.date = newdate
    }
    
}
