//
//  CheckVersionService.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/3/21.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class PeiziService: NSObject {
    
    
    //查询随机配资数据
    func randomData(calback: (data: String) -> ()) {
        
        RestAPI.sendGETRequest(B.PEIZI_RANDOM_DATA,params: [:],
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
    
    //提交随机购买数据
    func commitData(params:[String : AnyObject], calback: (data: JSON) -> ()) {
        RestAPI.sendPostRequest(B.PEIZI_COMMIT_DATA, params: params,
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
    
    //提交按天购买数据
    func dayBuy(params:[String : AnyObject], calback: (data: JSON) -> ()) {
        RestAPI.sendPostRequest(B.PEIZI_DAY_BUY, params: params,
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
    
    //提交按月购买数据
    func monthBuy(params:[String : AnyObject], calback: (data: JSON) -> ()) {
        RestAPI.sendPostRequest(B.PEIZI_MONTH_BUY, params: params,
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
    
    
    //加截排行榜
    func topList(calback: (data: String) -> ()) {
        RestAPI.sendGETRequest(B.PEIZI_LIST_TOP, params: [:],
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
    
    //加载列表
    func loadList(currentPage:Int, calback: (data: Any) -> ()) {
        _ = [PeiziModel]()
        RestAPI.sendGETRequest(B.PEIZI_LIST_DATA, params: [ "mobile" : userDefaultsUtil.getMobile()!,"page" :currentPage],
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
    
    //已购产品详细
    func loadDetail(id:String, calback: (data: Any) -> ()) {
        _ = [PeiziModel]()
        RestAPI.sendGETRequest(B.PEIZI_LIST_DETAIL, params: [ "id" : id],
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
    
    
    
    
    class func getInstance() -> PeiziService{
        struct Singleton{
            static var predicate:dispatch_once_t = 0
            static var instance:PeiziService? = nil
        }
        dispatch_once(&Singleton.predicate,{
            Singleton.instance = PeiziService()
            }
        )
        return Singleton.instance!
    }
    
    
}