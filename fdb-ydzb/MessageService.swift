//
//  MessageService.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/2/10.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class MessageService:NSObject {

//    func loadDataGet(id: String, calback: (data: Any) -> ()) {
//        RestAPI.sendGETRequest(B.USERCENTER_NOTICE_SHOW, params: ["id": id],
//            success: {
//                data in
//                let json = JSON(data!)
////                print("json = \(json)")
//                let messageData = MessageModel(time: "", content: json["content"].stringValue)
//                calback(data:messageData)
//            },
//            error: {
//                error in
//                switch error {
//                case .ConnectionFailed:
//                    calback(data:B.NETWORK_CONNECTION_ABNORMAL)
//                    KGXToast.showToastWithMessage(B.NETWORK_CONNECTION_ABNORMAL, duration: ToastDisplayDuration.LengthShort)
//                default:
//                    calback(data:"其他错误")
//                    KGXToast.showToastWithMessage("其他错误", duration: ToastDisplayDuration.LengthShort)
//                }
//            }
//        )
//    }
    func GongGao(calback: (data: AnyObject) -> ()){
        RestAPI.sendGETRequest("/home/searchAnnouncement", params:[:],
            success: {
                data in
//                let hm = MessageModel()
                let json = JSON(data!)
                let errors = json["errors"][0].stringValue
                print(json)
                if errors != "null"{
                    let data = errors.dataUsingEncoding(NSUTF8StringEncoding)
                    let dataDic = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                    let dd = JSON(dataDic).arrayObject
                    
                    calback(data:dd!)

                }else{
                    let arr = NSArray()
                    calback(data: arr)
  
                }
                
            },
            error: {
                error in
                switch error {
                case .ConnectionFailed:
//                    calback(data:B.NETWORK_CONNECTION_ABNORMAL)
                    KGXToast.showToastWithMessage(B.NETWORK_CONNECTION_ABNORMAL, duration: ToastDisplayDuration.LengthLongLong)
                default:
//                    calback(data:"其他错误")
                    KGXToast.showToastWithMessage("其他错误", duration: ToastDisplayDuration.LengthLong)
                }
            }
        )
    }
    func xiaoXi(calback: (data: AnyObject) -> ()){
        var hash = ""
        let str = "userId=" + userDefaultsUtil.getUid()! + "&" + "key=" + B.SING
        hash = str.sha256()
        print(hash)
        RestAPI.sendPostRequest("/home/searchMessage", params:["userId":userDefaultsUtil.getUid()! ,"sign":hash],
            success: {
                data in
                let json = JSON(data!)
                let errors = json["errors"][0].stringValue
                print(errors)
                if errors != "null"{
                let data = errors.dataUsingEncoding(NSUTF8StringEncoding)
                let dataDic = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                let dd : NSArray = JSON(dataDic).arrayObject!
                print(dd)
                calback(data: dd)
                }else{
                let arr = NSArray()
                calback(data: arr)
                }
            },
            error: {
                error in
                switch error {
                case .ConnectionFailed:
//                    calback(data:B.NETWORK_CONNECTION_ABNORMAL)
                    KGXToast.showToastWithMessage(B.NETWORK_CONNECTION_ABNORMAL, duration: ToastDisplayDuration.LengthLongLong)
                default:
//                    calback(data:"其他错误")
                    KGXToast.showToastWithMessage("其他错误", duration: ToastDisplayDuration.LengthLong)
                }
            }
        )
    }
    //读取站内信接口
    func duQu(messageId: String,calback: (data: AnyObject) -> ()){
        var hash = ""
        let str = "messageId=" + messageId + "&" + "key=" + B.SING
        hash = str.sha256()
        RestAPI.sendPostRequest("/home/readMessage", params:["messageId":messageId ,"sign":hash],
            success: {
                data in
                let json = JSON(data!)
                let errors = json["errors"][0].stringValue
                print(json)
//                if errors != "null"{
//                    let data = errors.dataUsingEncoding(NSUTF8StringEncoding)
//                    let dataDic = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
//                    let dd = JSON(dataDic).arrayObject!
//                    print(dd)
//                    calback(data: dd)
//                }else{
//                    let arr = NSArray()
                    calback(data: "")
//                }
            },
            error: {
                error in
                switch error {
                case .ConnectionFailed:
                    calback(data:B.NETWORK_CONNECTION_ABNORMAL)
                    KGXToast.showToastWithMessage(B.NETWORK_CONNECTION_ABNORMAL, duration: ToastDisplayDuration.LengthLongLong)
                default:
                    calback(data:"其他错误")
                    KGXToast.showToastWithMessage("其他错误", duration: ToastDisplayDuration.LengthLong)
                }
            }
        )
    }

    
    

    class func getInstance() -> MessageService{
        struct Singleton{
            static var predicate:dispatch_once_t = 0
            static var instance:MessageService? = nil
        }
        dispatch_once(&Singleton.predicate,
            {
                Singleton.instance=MessageService()
            }
        )
        return Singleton.instance!
    }
}