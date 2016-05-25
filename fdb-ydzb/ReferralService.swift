//
//  ReferralService.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/2/9.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ReferralService {
    
    func queryUserReferralCode(calback: (data: String, status: Int) -> ()) {
        
        RestAPI.sendGETRequest("Recommend/index", params: ["mm": userDefaultsUtil.getMobile()!],
            success: {
                data in
                var json = JSON(data!)
                let code = json["referralCode"].stringValue
                calback(data:"\(code)", status:0)
            },
            error: {
                error in
                switch error {
                case .ConnectionFailed:
                    calback(data:B.NETWORK_CONNECTION_ABNORMAL,status:-1)
                default:
                    calback(data:"其他错误",status:-1)
                }
            }
        )
    }
    
    
    func loadDataGet(currentPage:Int, calback: (data: Any) -> ()) {
        var referralRecordData = [ReferralModel]()
        RestAPI.sendGETRequest("Record/recommend", params: [ "mobile" : userDefaultsUtil.getMobile()!,"page" :currentPage],
            success: {
                data in
                let json = JSON(data!)
                for (_, subJson): (String, JSON) in json {
                    referralRecordData.append(ReferralModel(name: subJson["username"].string!, fund: subJson["cbmoney"].double!, time: subJson["created"].string!, backFund: subJson["tmoney"].string!))
                }
                calback(data:referralRecordData)
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
    
    
    
    class func getInstance() -> ReferralService{
        struct Singleton{
            static var predicate:dispatch_once_t = 0
            static var instance:ReferralService? = nil
        }
        dispatch_once(&Singleton.predicate,{
            Singleton.instance=ReferralService()
            }
        )
        return Singleton.instance!
    }
    
}