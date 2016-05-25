//
//  RecommendRecordService.swift
//  ydzbapp-hybrid
//
//  Created by qinxin on 15/9/11.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RecommendRecordService: NSObject {
    
    func loadDataGet(params:[String:AnyObject], calback: (data: Any) -> ()) {
        var recommandData = [RecommandRecordModel]()
        RestAPI.sendGETRequest(B.USERCENTER_RECOMMEND_LIST, params: params,
            success: {
                data in
                let json = JSON(data!)
                //print("json = \(json)")
                for (_, subJson): (String, JSON) in json {
                    recommandData.append(RecommandRecordModel(avatar: subJson["avatar"].stringValue, username: subJson["username"].stringValue, invest: subJson["invest"].stringValue, created: subJson["created"].stringValue))
                }
                calback(data:recommandData)
            },
            error: {
                error in
                switch error {
                case .ConnectionFailed:
                    calback(data:B.NETWORK_CONNECTION_ABNORMAL)
                    KGXToast.showToastWithMessage(B.NETWORK_CONNECTION_ABNORMAL, duration: ToastDisplayDuration.LengthShort)
                default:
                    calback(data:"其他错误")
                    KGXToast.showToastWithMessage("其他错误", duration: ToastDisplayDuration.LengthShort)
                }
            }
        )
    }
    
    class func getInstance() -> RecommendRecordService{
        struct Singleton{
            static var predicate:dispatch_once_t = 0
            static var instance:RecommendRecordService? = nil
        }
        dispatch_once(&Singleton.predicate,
            {
                Singleton.instance=RecommendRecordService()
            }
        )
        return Singleton.instance!
    }

   
}
