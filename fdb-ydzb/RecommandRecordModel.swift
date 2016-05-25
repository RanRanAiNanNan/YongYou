//
//  RecommandRecordModel.swift
//  ydzbapp-hybrid
//
//  Created by qinxin on 15/9/11.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class RecommandRecordModel: NSObject {
    var avatar: String                  //头像url
    var username: String                //用户名
    var invest: String                  //
    var created:String                  //创建时间
    
    init(avatar newAvatar:String, username newUsername:String, invest newInvest:String, created newCreated:String) {
        self.avatar = newAvatar
        self.username = newUsername
        self.invest = newInvest
        self.created = newCreated
    }
}
