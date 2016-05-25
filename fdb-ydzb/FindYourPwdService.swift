//
//  FindYourPwdService.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/2/3.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class FindYourPwdService: NSObject {
    
    
    func getAuthCode(request: String, params:[String : AnyObject], calback: (data: String) -> ()) {
        RestAPI.sendPostRequest(request, params: params,
            success: {
                data in
                var json = JSON(data!)
                let status = json["status"].intValue
                var msg = json["msg"].stringValue
                if status == 1 {
                    msg = ""
                }
                calback(data:"\(msg)")
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
    
    func loadDataPost(request: String, params:[String : AnyObject], calback: (data: String) -> ()) {
        RestAPI.sendPostRequest(request, params: params,
            success: {
                data in
                var json = JSON(data!)
                let status = json["status"].intValue
                var msg = json["msg"].stringValue
                if status == 1 {
                    msg = ""
                }
                calback(data:"\(msg)")
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
    
    //注册提交
    func register(request: String, params:[String : AnyObject], calback: (data: String) -> ()) {
        RestAPI.sendPostRequest(request, params: params,
            success: {
                data in
                var json = JSON(data!)
                let status = json["status"].intValue
                var msg = json["msg"].stringValue
                if status == 1 {
                    msg = ""
                }
                calback(data:"\(msg)")
            },
            error: {
                error in
                switch error {
                case .ConnectionFailed:
                    calback(data:B.NETWORK_CONNECTION_ABNORMAL)
                    KGXToast.showToastWithMessage("该手机号未注册", duration: ToastDisplayDuration.LengthShort)
                default:
                    calback(data:"其他错误")
                    KGXToast.showToastWithMessage("其他错误", duration: ToastDisplayDuration.LengthShort)
                }
            }
        )
    }
    
    
    
    class func getInstance() -> FindYourPwdService{
        struct Singleton{
            static var predicate:dispatch_once_t = 0
            static var instance:FindYourPwdService? = nil
        }
        dispatch_once(&Singleton.predicate,{
            Singleton.instance=FindYourPwdService()
            }
        )
        return Singleton.instance!
    }
}
