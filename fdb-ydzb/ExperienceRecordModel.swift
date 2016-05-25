//
//  ExperienceRecordModel.swift
//  ydzbapp-hybrid
//  体验金记录
//  Created by qinxin on 15/9/11.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class ExperienceRecordModel: NSObject {
    var fundflow: String                    //体验金类型
    var fund: String                        //金额
    var record_time: String                 //时间
    
    init(fundflow newfundflow:String, fund newfund:String, record_time newrecord_time:String) {
        self.fundflow = newfundflow
        self.fund = newfund
        self.record_time = newrecord_time
    }
}
