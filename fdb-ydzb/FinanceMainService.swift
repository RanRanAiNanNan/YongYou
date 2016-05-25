//
//  FinanceMainService.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/5/19.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class FinanceMainService: NSObject {

    //加载列表
    func loadList(calback: (data: Any) -> ()) {
        //var flm = [FinanceListModel]()
        RestAPI.sendGETRequest(B.ADVANCED_PRODCUT_LIST, params: [:],
            success: {
                data in
                let json = JSON(data!)
                //print("理财:\(json)")
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
    
    class func getInstance() -> FinanceMainService{
        struct Singleton{
            static var predicate:dispatch_once_t = 0
            static var instance:FinanceMainService? = nil
        }
        dispatch_once(&Singleton.predicate,{
            Singleton.instance = FinanceMainService()
            }
        )
        return Singleton.instance!
    }
    
    
}
