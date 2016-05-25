//
//  YdFinancingService.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/3/2.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class HighFinancingService : NSObject {
    
    //加载股权众筹（聚募）列表
    func loadJumiData( calback: (data: String) -> ()) {
        RestAPI.sendGETRequest(B.ADVANCED_JUMU_LIST, params: [:],
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
    
    //加载股权众筹（聚募）详细
    func loadJumiDetail(params:[String : AnyObject], calback: (data: String) -> ()) {
        RestAPI.sendGETRequest(B.ADVANCED_JUMU_DETAIL, params: params,
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
    
    //提交股权众筹（聚募）购买数据
    func jumiBuy(params:[String : AnyObject], calback: (data: JSON) -> ()) {
        RestAPI.sendPostRequest(B.ADVANCED_JUMU_DETAIL, params: params,
            success: {
                data in
                var json = JSON(data!)
                _ = json["status"].intValue
                let msg = json["msg"].stringValue
                calback(data:JSON(["msg":msg]))
            },
            error: {
                error in
                switch error {
                case .ConnectionFailed:
                    calback(data:JSON(["error":B.NETWORK_CONNECTION_ABNORMAL]))
                    KGXToast.showToastWithMessage(B.NETWORK_CONNECTION_ABNORMAL, duration: ToastDisplayDuration.LengthShort)
                default:
                    calback(data:JSON(["error":B.NETWORK_CONNECTION_ABNORMAL]))
                    KGXToast.showToastWithMessage("其他错误", duration: ToastDisplayDuration.LengthShort)
                }
            }
        )
    }
    
    
    //加载债权转让列表
    func loadTransferData(calback: (data: String) -> ()) {
        RestAPI.sendGETRequest(B.ADVANCED_TRANSFER_LIST, params: [:],
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
    
    //加载债权转让详细
    func loadTransferDetail(params:[String : AnyObject], calback: (data: String) -> ()) {
        RestAPI.sendGETRequest(B.ADVANCED_TRANSFER_DETAIL, params: params,
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
    
    //提交债权转让购买数据
    func transferBuy(params:[String : AnyObject], calback: (data: JSON) -> ()) {
        RestAPI.sendPostRequest(B.ADVANCED_TRANSFER_DETAIL, params: params,
            success: {
                data in
                var json = JSON(data!)
                _ = json["status"].intValue
                let msg = json["msg"].stringValue
                calback(data:JSON(["msg":msg]))
            },
            error: {
                error in
                switch error {
                case .ConnectionFailed:
                    calback(data:JSON(["error":B.NETWORK_CONNECTION_ABNORMAL]))
                    KGXToast.showToastWithMessage(B.NETWORK_CONNECTION_ABNORMAL, duration: ToastDisplayDuration.LengthShort)
                default:
                    calback(data:JSON(["error":B.NETWORK_CONNECTION_ABNORMAL]))
                    KGXToast.showToastWithMessage("其他错误", duration: ToastDisplayDuration.LengthShort)
                }
            }
        )
    }
    
    
     
    
    class func getInstance() -> HighFinancingService{
        struct Singleton{
            static var predicate:dispatch_once_t = 0
            static var instance:HighFinancingService? = nil
        }
        dispatch_once(&Singleton.predicate,{
            Singleton.instance = HighFinancingService()
            }
        )
        return Singleton.instance!
    }
}