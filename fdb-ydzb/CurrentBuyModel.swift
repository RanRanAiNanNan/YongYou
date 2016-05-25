//
//  CurrentBuyModel.swift
//  ydzbapp-hybrid
//  活期宝购买
//  Created by qinxin on 15/9/2.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class CurrentBuyModel: NSObject {
    
    var name: String = ""                       //名称
    var interest_rate: Float32 = 0.00           //利率
    var surplus: String = ""                    //当前份额
    var earnings: String = ""                   //万份收益
    var productId: String = ""                  //产品id
    var status: String = ""                     //产品状态
    var rushTime: String = ""                   //抢购时间
    var vipApr: String = ""                     //vip利率
    var compositeApr: Float32 = 0.00            //复合年化
   
}
