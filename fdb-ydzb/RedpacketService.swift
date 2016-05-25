//
//  RedpacketService.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/2/11.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RedpacketService: NSObject {
    
    func loadDataGet(params: [String:AnyObject], calback: (data: AnyObject) -> ()) {
        var redpacketData = [RedpacketModel]()
        RestAPI.sendGETRequest(B.USERCENTER_REDPACKET_LIST, params: params,
            success: {
                data in
                let json = JSON(data!)
                //println("红包 = \(json)")
                for (_, subJson): (String, JSON) in json {
                    let rp:RedpacketModel = RedpacketModel(id: subJson["id"].stringValue, name: subJson["name"].stringValue, giveValue: subJson["giveValue"].stringValue, status: subJson["status"].stringValue, useFinishTime: subJson["useFinishTime"].stringValue, getTime: subJson["getTime"].stringValue, redpacketType: subJson["redpacketType"].stringValue, productType: subJson["productType"].stringValue, use: subJson["use"].stringValue)
                    redpacketData.append(rp)
                }
                calback(data:redpacketData)
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
    
    func useCurrentRedpacket(rpid:String, calback: (data: AnyObject) -> ()) {
        
        RestAPI.sendPostRequest(B.USERCENTER_REDPACKET_CURRENT_USE, params: ["mm": userDefaultsUtil.getMobile()!, "redpacket_id": rpid],
            success: {
                data in
                let json = JSON(data!)
                let status = json["status"].intValue
                let msg = json["msg"].stringValue
                let model = MsgModel(msg: msg, status: status)
                calback(data:model)
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
    
    func useCashRedpacket(rpid:String, calback: (data: AnyObject) -> ()) {
        
        RestAPI.sendPostRequest(B.USERCENTER_REDPACKET_CASH_USE, params: ["mm": userDefaultsUtil.getMobile()!, "redpacket_id": rpid],
            success: {
                data in
                let json = JSON(data!)
                let status = json["status"].intValue
                let msg = json["msg"].stringValue
                let model = MsgModel(msg: msg, status: status)
                calback(data:model)
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
    

    
    class func getInstance() -> RedpacketService{
        struct Singleton{
            static var predicate:dispatch_once_t = 0
            static var instance:RedpacketService? = nil
        }
        dispatch_once(&Singleton.predicate,
            {
                Singleton.instance = RedpacketService()
            }
        )
        return Singleton.instance!
    }
    
}