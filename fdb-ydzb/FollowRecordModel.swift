//
//  FollowRecordModel.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/7/3.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation


class FollowRecordModel {
    
    var id:String        = ""                       //记录ID
    var userId:String    = ""                       //用户ID
    var userName:String  = ""                       //用户名
    var mobile:String    = ""                       //手机
    var avatarUrl:String = ""                       //头像
    var status:Int       = 0                        //状态(0未关注，1关注)
    var row:Int          = 0                        //选中行号
    var avatarImg:UIImageView?
    
}