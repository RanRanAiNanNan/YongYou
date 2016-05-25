//
//  MessageRecordModel.swift
//  ydzbapp-hybrid
//  消息记录
//  Created by qinxin on 15/9/14.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class MessageRecordModel: NSObject {
    
    var id: String
    var title: String
    var content: String
    var createtime: String
    
    init(id newid: String, title newtitle: String, content newcontent: String, createtime newcreatetime: String) {
        self.id = newid
        self.title = newtitle
        self.content = newcontent
        self.createtime = newcreatetime
    }
}
