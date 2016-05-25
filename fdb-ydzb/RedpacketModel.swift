//
//  RedpacketModel.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/2/11.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation

class RedpacketModel {
    var id:String                   //红包ID
    var name:String                 //名称
    var giveValue:String            //红包赠送值
    var status:String               //状态
    var useFinishTime:String        //用户使用时间
    var getTime:String              //用户领取时间
    var redpacketType:String        //红包类型
    var productType:String          //红包产品
    var use:String                  //
    
    
    init(id newId: String,
        name newName:String,
        giveValue newGiveVale:String,
        status newStatus:String,
        useFinishTime newUseFinishTime:String,
        getTime newGetTime:String,
        redpacketType newRedpacketType:String,
        productType newProductType:String,
        use newUse:String){
        self.id = newId
        self.name = newName
        self.giveValue = newGiveVale
        self.status = newStatus
        self.useFinishTime = newUseFinishTime
        self.getTime = newGetTime
        self.redpacketType = newRedpacketType
        self.productType = newProductType
        self.use = newUse
    }
    
}