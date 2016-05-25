//
//  StableMixModel.swift
//  ydzbapp-hybrid
//  稳进宝记录
//  Created by qinxin on 15/9/12.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class StableMixModel: NSObject {
    
    var investmentFund: String = ""             //投资总额
    var buyCopies: String = ""                  //累计受益
    
    var stableList = [StableRecordModel]()
}
