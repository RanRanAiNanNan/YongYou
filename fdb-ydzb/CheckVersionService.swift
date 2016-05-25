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

class CheckVersionService: NSObject {
    
    
    //查询应用版本号
    func checkVersion(success: (data: Float) -> ()) {
        
        Alamofire.request(.GET, B.STORE_QUERY_ADDRESS + B.APP_ID)
            .responseJSON {  response in
                switch response.result {
                case .Success:
                    var json = JSON(response.result.value!)
                    let results = json["results"]
                    for (_, subJson): (String, JSON) in results {
                        let version = subJson["version"].floatValue
                        success(data:version)
                    }
                default:
                    break
                }
            }
    }
    
    /** 上传登录用户版本号 **/
    func uploadUserVersion(params:[String : String]){
        Alamofire.request(.POST, B.BASE_URL + B.OTHER_UPLOAD_USER_VERSION, parameters: params)
            .responseJSON { response in

                }
    }
    
    
    /** 检查用户是否允许登录 **/
    func checkLogin(calback: (data: AnyObject) -> ()) {
        RestAPI.sendPostRequest(B.CHECK_USER_LOGIN, params: ["mm": userDefaultsUtil.getMobile()!],
            success: {
                data in
                var json = JSON(data!)
                //print("检查用户登录:\(json)")
                calback(data:MsgModel(msg: json["msg"].stringValue, status: json["status"].intValue))
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
    
    
    class func getInstance() -> CheckVersionService{
        struct Singleton{
            static var predicate:dispatch_once_t = 0
            static var instance:CheckVersionService? = nil
        }
        dispatch_once(&Singleton.predicate,{
            Singleton.instance=CheckVersionService()
            }
        )
        return Singleton.instance!
    }
    
    
}