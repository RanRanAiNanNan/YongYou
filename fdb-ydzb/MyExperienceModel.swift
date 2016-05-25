//
//  MyExperienceModel.swift
//  ydzbapp-hybrid
//  我的体验金记录
//  Created by qinxin on 15/9/11.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class MyExperienceModel: NSObject {
    var type: String                    //体验金类型
    var created: String                 //
    var status: String                  //已到期、未到期状态
    var fund: String                    //获得体验进
    var startData: String               //初始日期
    var closeData: String               //有效期至
    var days: String                    //有效期
    
    init(type newtype: String,created newcreated: String, status newstatus: String, fund newfund: String, startData newStartData: String, closeData newCloseData: String, days newDays: String) {
        self.type = newtype
        self.created = newcreated
        self.status = newstatus
        self.fund = newfund
        self.startData = newStartData
        self.closeData = newCloseData
        self.days = newDays
    }
}
