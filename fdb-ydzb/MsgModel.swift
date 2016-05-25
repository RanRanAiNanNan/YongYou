//
//  MsgModel.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/3/11.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation

class MsgModel {
    var msg:String = ""         //信息
    var status:Int = 0          //状态(1为成功，0为不成功)
    
    init(msg newMsg:String, status newStatus:Int){
        self.msg = newMsg
        self.status = newStatus

    }
}
