//
//  TarentoModel.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/7/10.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation

class TarentoModel {
    
    var id:String     = ""                //用户ID
    var name:String   = ""                //用户名
    var mobile:String = ""                //手机号
    
    init(id newId:String, name newName:String, mobile newMobile:String){
        self.id = newId
        self.name = newName
        self.mobile = newMobile
    }
    
}