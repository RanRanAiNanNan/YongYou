//
//  WealthService.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/7/10.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WealthService: NSObject {
    

    
    
    //实时交易信息
    func realTimeList(calback: (data: String) -> ()) {
        RestAPI.sendGETRequest(B.WEALTH_REALTIME_LIST, params: [:],
            success: {
                data in
                let json = JSON(data!)
                calback(data:"\(json)")
            },
            error: {
                error in
                switch error {
                case .ConnectionFailed:
                    let json = JSON(["error":"connectionFailed"])
                    calback(data:"\(json)")
                    KGXToast.showToastWithMessage(B.NETWORK_CONNECTION_ABNORMAL, duration: ToastDisplayDuration.LengthShort)
                default:
                    let json = JSON(["error":"connectionFailed"])
                    calback(data:"\(json)")
                    KGXToast.showToastWithMessage("其他错误", duration: ToastDisplayDuration.LengthShort)
                }
            }
        )
    }
    
    
    //投资排行榜
    func investList(calback: (data: String) -> ()) {
        RestAPI.sendGETRequest(B.WEALTH_INVEST_LIST, params: [:],
            success: {
                data in
                let json = JSON(data!)
                calback(data:"\(json)")
            },
            error: {
                error in
                switch error {
                case .ConnectionFailed:
                    let json = JSON(["error":"connectionFailed"])
                    calback(data:"\(json)")
                    KGXToast.showToastWithMessage(B.NETWORK_CONNECTION_ABNORMAL, duration: ToastDisplayDuration.LengthShort)
                default:
                    let json = JSON(["error":"connectionFailed"])
                    calback(data:"\(json)")
                    KGXToast.showToastWithMessage("其他错误", duration: ToastDisplayDuration.LengthShort)
                }
            }
        )
    }
    
    //投资排行榜
    func tarentDetailList(mobile:String, calback: (data: String) -> ()) {
        RestAPI.sendGETRequest(B.WEALTH_TARENTO_DETAIL, params: ["mobile": userDefaultsUtil.getMobile()!, "mobiled":mobile],
            success: {
                data in
                let json = JSON(data!)
                calback(data:"\(json)")
            },
            error: {
                error in
                switch error {
                case .ConnectionFailed:
                    let json = JSON(["error":"connectionFailed"])
                    calback(data:"\(json)")
                    KGXToast.showToastWithMessage(B.NETWORK_CONNECTION_ABNORMAL, duration: ToastDisplayDuration.LengthShort)
                default:
                    let json = JSON(["error":"connectionFailed"])
                    calback(data:"\(json)")
                    KGXToast.showToastWithMessage("其他错误", duration: ToastDisplayDuration.LengthShort)
                }
            }
        )
    }
    
    
    
    
    class func getInstance() -> WealthService {
        struct Singleton{
            static var predicate:dispatch_once_t = 0
            static var instance:WealthService? = nil
        }
        dispatch_once(&Singleton.predicate,{
            Singleton.instance = WealthService()
            }
        )
        return Singleton.instance!
    }
    
    
}
