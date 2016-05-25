//
//  TransferRecordModel.swift
//  ydzbapp-hybrid
//  债权转让记录
//  Created by qinxin on 15/9/11.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class TransferRecordModel: NSObject {
    var name: String                    //产品名称
    var fund: String                    //购买金额
    var interestFund:String             //转让收益
    var buyTime:String                  //购买时间
    var transferTime:String             //转让时间
    
    init(name newname:String, fund newfund:String, newinterestFund:String,buyTime newbuytTime:String, transferTime newtransferTime:String){
        self.name = newname
        self.fund = newfund
        self.interestFund = newinterestFund
        self.buyTime = newbuytTime
        self.transferTime = newtransferTime
    }
}
