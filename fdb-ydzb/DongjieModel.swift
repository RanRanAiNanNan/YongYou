//
//  DongjieModel.swift
//  ydzbapp-hybrid
//  冻结记录
//  Created by qinxin on 15/10/8.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class DongjieModel: NSObject {
    
    var name: String                //名称
    var fund: String                //金额
    var time: String                //时间
    
    init(name newname: String,fund newfund: String, time newtime: String) {
        self.name = newname
        self.fund = newfund
        self.time = newtime
    }
   
}
