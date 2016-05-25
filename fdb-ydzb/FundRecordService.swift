//
//  FundRecordService.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/2/6.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class FundRecordService: NSObject {
        
    func loadDataGet(params: [String:AnyObject], calback: (data: Any) -> ()) {
        let fmm = FundMixModel()
        RestAPI.sendGETRequest("Record/money", params: params,
            success: {
                data in
                var json = JSON(data!)
                fmm.total = json["total"].stringValue
                for (_, subJson): (String, JSON) in json["dataList"] {
                    fmm.fundRecordData.append(FundRecordModel(fundflow: subJson["fundflow"].stringValue, record_time: subJson["record_time"].stringValue, fund: subJson["fund"].stringValue, type: subJson["type"].stringValue, balance: subJson["balance"].stringValue))
                }
                calback(data:fmm)
            },
            error: {
                error in
                switch error {
                case .ConnectionFailed:
                    calback(data:"连接不可用")
                    KGXToast.showToastWithMessage(B.NETWORK_CONNECTION_ABNORMAL, duration: ToastDisplayDuration.LengthShort)
                default:
                    calback(data:"其他错误")
                    KGXToast.showToastWithMessage("其他错误", duration: ToastDisplayDuration.LengthShort)
                }
            }
        )
    }
    
    class func getInstance() -> FundRecordService{
        struct Singleton{
            static var predicate:dispatch_once_t = 0
            static var instance:FundRecordService? = nil
        }
        dispatch_once(&Singleton.predicate,{
            Singleton.instance=FundRecordService()
            }
        )
        return Singleton.instance!
    }
}
