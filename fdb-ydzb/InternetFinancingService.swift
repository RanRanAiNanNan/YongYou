//
//  InternetFinancingService.swift
//  ydzbapp-hybrid
//
//  Created by qinxin on 15/5/27.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class InternetFinancingService: NSObject {
    
    func loadDataGet(calback: (data: AnyObject) -> ()) {
        
        let request = B.INTERNET_FINANCING.stringByAppendingString(userDefaultsUtil.getMobile()!)
        
        let financingModel = InternetFinancingModel()
        
        RestAPI.sendGETRequest(request, params:[:],
            success: {
                data in
                var json = JSON(data!)
                
                if let dayloan = json["dayloan"].string{
                    financingModel.dayloan = dayloan
                }
                
                if let deposit = json["deposit"].string{
                    financingModel.deposit = deposit
                }
                
                if let stable = json["stable"].string{
                    financingModel.stable = stable
                }
                
                if let transfer = json["transfer"].string{
                    financingModel.transfer = transfer
                }
                
                calback(data:financingModel)
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
    
    class func getInstance() -> InternetFinancingService{
        struct Singleton{
            static var predicate:dispatch_once_t = 0
            static var instance:InternetFinancingService? = nil
        }
        dispatch_once(&Singleton.predicate,{
            Singleton.instance = InternetFinancingService()
            }
        )
        return Singleton.instance!
    }
   
}
