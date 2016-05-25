//
//  HomeModel.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/3/1.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import SwiftyJSON

class HomeModel {
    
//    var banners = [BannerModel]()                 //广告数组
//    var hot:JSON = ""                             //热门推荐
//    var avatar = ""                               //头像地址
//    var peopleTotal = ""                          //总人数
//    var vip = ""                                  //VIP
//    var username = ""                             //用户名
//    var token = ""                                //融云TOKEN
//    var moneyTotal = ""                           //交易总额
//    var revenueTotal = ""                         //收益总额
//    var financeKey = ""                           //tab bar item finnace 图标
//    var discoverKey = ""                          //tab bar item discover 图标
    
    var homeBanners = [BannerModel]()
    var productType = NSArray()
    var homeProductInfos = [LieBiaoModel]()
    var headUrl = ""
    var messageStatus = ""
    
}