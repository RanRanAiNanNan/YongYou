//
//  UserCenterService.swift
//  ydzbapp-hybrid
//
//  Created by 刘超 on 15/2/4.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UserCenterService: NSObject {
    
    func loadDataGet(calback: (data: AnyObject) -> ()) {
        RestAPI.sendGETRequest(B.USERCENTER_MAIN, params: ["mm": userDefaultsUtil.getMobile()!],
            success: {
                data in
                var json = JSON(data!)
               // print("用户中心:\(json)")
                let ucm = UserCenterModel()
                ucm.msg = json["msg"].stringValue
                ucm.remind = json["lemind"].stringValue
                calback(data:ucm)
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
    
    /** 用户异常提醒 **/
    func uploadUserRemind(remind:String, calback: (data: String) -> ()){
        RestAPI.sendPostRequest(B.USERCENTER_REMIND, params: ["mm": userDefaultsUtil.getMobile()!,"lemind": remind],
            success: {
                data in
                var json = JSON(data!)
                //print("用户异常提醒:\(json)")
                let msg = json["msg"].stringValue
                calback(data:msg)
            },
            error: {
                error in
                switch error {
                case .ConnectionFailed:
                    calback(data:"连接不可用")
                    KGXToast.showToastWithMessage("连接不可用", duration: ToastDisplayDuration.LengthShort)
                default:
                    calback(data:"其他错误")
                    KGXToast.showToastWithMessage("其他错误", duration: ToastDisplayDuration.LengthShort)
                }
            }
        )
    }
    
    /** 用户上传头像 **/
    func uploadAvatar(){
        let imageData = UIImagePNGRepresentation(PhotoUtils.showAvatar())
        print("imageData====\(imageData)")
        let parameters = [
            "mm" : userDefaultsUtil.getMobile()!
        ]
        let url = B.BASE_URL + B.USERCENTER_AVATAR_UPLOAD
        RestAPI.sendPostUpload(url, params: parameters, fileData: imageData!,
            success: {
                data in
                var json = JSON(data!)
                //print("头像上传:\(json)")
                let status = json["status"].stringValue
                let msg = json["msg"].stringValue
                let avatar = json["avatar"].stringValue
                if status == "1" {
                    userDefaultsUtil.setAvatarLink(avatar)
                }
                if !msg.isEmpty{
                   KGXToast.showToastWithMessage(msg, duration: ToastDisplayDuration.LengthShort)
                }
                
            },
            error: {
                error in
                switch error {
                case .ConnectionFailed:
                    KGXToast.showToastWithMessage(B.NETWORK_CONNECTION_ABNORMAL, duration: ToastDisplayDuration.LengthShort)
                default:
                    KGXToast.showToastWithMessage("其他错误", duration: ToastDisplayDuration.LengthShort)
                }
        })
        
    }
    
    /** 聚募众筹数据列表 **/
    func jumuLoadDataGet(currentPage:Int, calback: (data: Any) -> ()) {
        var jumuRecordData = [JumuRecordModel]()
        RestAPI.sendGETRequest(B.USERCENTER_JUMURECORD, params: [ "mm" : userDefaultsUtil.getMobile()!,"page" :currentPage],
            success: {
                data in
                let json = JSON(data!)
                for (_, subJson): (String, JSON) in json {
                    jumuRecordData.append(JumuRecordModel(name: subJson["projectName"].stringValue, fund: subJson["tradeMoney"].stringValue, time: subJson["tradeDate"].stringValue, type: subJson["statusName"].stringValue))
                }
                calback(data:jumuRecordData)
            },
            error: {
                error in
                switch error {
                case .ConnectionFailed:
                    calback(data:"连接不可用")
                    KGXToast.showToastWithMessage(B.NETWORK_CONNECTION_ABNORMAL, duration: ToastDisplayDuration.LengthShort)
                default:
                    calback(data:"其他错误")
                    KGXToast.showToastWithMessage("其他错误", duration: ToastDisplayDuration.LengthShort)
                }
            }
        )
    }
    
//    /** 稳进宝数据列表 **/
//    func stableLoadDataGet(currentPage:Int, calback: (data: Any) -> ()) {
//        var stableRecordData = [StableRecordModel]()
//        RestAPI.sendGETRequest(B.USERCENTER_STABLERECORD, params: [ "mobile" : userDefaultsUtil.getMobile()!,"page" :currentPage],
//            success: {
//                data in
//                var json = JSON(data!)
//                for (index: String, subJson: JSON) in json {
//                    stableRecordData.append(StableRecordModel(name: subJson["project_name"].stringValue, type: subJson["project_status"].stringValue, fund: subJson["trade_money"].doubleValue, time: subJson["trade_time"].stringValue, expiredTime: subJson["project_expiredTime"].stringValue))
//                }
//                calback(data:stableRecordData)
//            },
//            error: {
//                error in
//                switch error {
//                case .ConnectionFailed:
//                    calback(data:"连接不可用")
//                    KGXToast.showToastWithMessage(B.NETWORK_CONNECTION_ABNORMAL, duration: ToastDisplayDuration.LengthShort)
//                default:
//                    calback(data:"其他错误")
//                    KGXToast.showToastWithMessage("其他错误", duration: ToastDisplayDuration.LengthShort)
//                }
//            }
//        )
//    }
    
//    /** 稳进宝数据列表2 **/
//    func stableLoadDataDetailGet(currentPage:Int, id:String, calback: (data: Any) -> ()) {
//        var stableRecordData = [StableRecordModel]()
//        RestAPI.sendGETRequest(B.STABLE_PERIOD_DETAIL, params: [ "mobile" : userDefaultsUtil.getMobile()!,"id": id,"page" :currentPage],
//            success: {
//                data in
//                var json = JSON(data!)
//                for (index: String, subJson: JSON) in json {
//                    stableRecordData.append(StableRecordModel(name: subJson["project_name"].stringValue, type: subJson["project_status"].stringValue, fund: subJson["trade_money"].doubleValue, time: subJson["trade_time"].stringValue, expiredTime: subJson["project_expiredTime"].stringValue))
//                }
//                calback(data:stableRecordData)
//            },
//            error: {
//                error in
//                switch error {
//                case .ConnectionFailed:
//                    calback(data:"连接不可用")
//                    KGXToast.showToastWithMessage(B.NETWORK_CONNECTION_ABNORMAL, duration: ToastDisplayDuration.LengthShort)
//                default:
//                    calback(data:"其他错误")
//                    KGXToast.showToastWithMessage("其他错误", duration: ToastDisplayDuration.LengthShort)
//                }
//            }
//        )
//    }
    
    /** 关注数据列表 **/
    func followLoadDataGet(lastId:String, calback: (data: Any) -> ()) {
        var followRecordData = [FollowRecordModel]()
        RestAPI.sendGETRequest(B.USERCENTER_FOLLOWRECORD, params: [ "mobile" : userDefaultsUtil.getMobile()!,"page" :lastId],
            success: {
                data in
                let json = JSON(data!)
                for (_, subJson): (String, JSON) in json {
                    let frm = FollowRecordModel()
                    frm.id = subJson["id"].stringValue
                    frm.userId = subJson["userId"].stringValue
                    frm.userName = subJson["useredName"].stringValue
                    frm.mobile = subJson["useredMobile"].stringValue
                    frm.avatarUrl = subJson["avatar"].stringValue
                    
                    followRecordData.append(frm)
                    
                }
                calback(data:followRecordData)
            },
            error: {
                error in
                switch error {
                case .ConnectionFailed:
                    calback(data:"连接不可用")
                    KGXToast.showToastWithMessage(B.NETWORK_CONNECTION_ABNORMAL, duration: ToastDisplayDuration.LengthShort)
                default:
                    calback(data:"其他错误")
                    KGXToast.showToastWithMessage("其他错误", duration: ToastDisplayDuration.LengthShort)
                }
            }
        )
    }
    
    /** 关注者数据列表 **/
    func invietLoadDataGet(currentPage:Int, calback: (data: Any) -> ()) {
        var followRecordData = [FollowRecordModel]()
        RestAPI.sendGETRequest(B.USERCENTER_INVIETRECORD, params: ["mobile" : userDefaultsUtil.getMobile()!, "page" :currentPage],
            success: {
                data in
                let json = JSON(data!)
                for (_, subJson): (String, JSON) in json {
                    let frm = FollowRecordModel()
                    frm.userId = subJson["userId"].stringValue
                    frm.userName = subJson["useredName"].stringValue
                    frm.mobile = subJson["useredMobile"].stringValue
                    frm.avatarUrl = subJson["avatar"].stringValue
                    frm.status = subJson["status"].intValue
                    followRecordData.append(frm)
                    
                }
                calback(data:followRecordData)
            },
            error: {
                error in
                switch error {
                case .ConnectionFailed:
                    calback(data:"连接不可用")
                    KGXToast.showToastWithMessage(B.NETWORK_CONNECTION_ABNORMAL, duration: ToastDisplayDuration.LengthShort)
                default:
                    calback(data:"其他错误")
                    KGXToast.showToastWithMessage("其他错误", duration: ToastDisplayDuration.LengthShort)
                }
            }
        )
    }
    
    
    func cancelFollow(userId:String, calback: (data: AnyObject) -> ()) {
        
        RestAPI.sendPostRequest(B.USERCENTER_FOLLOW, params: ["mobile": userDefaultsUtil.getMobile()!, "usered_id": userId],
            success: {
                data in
                var json = JSON(data!)
                let status = json["status"].intValue
                let msgstr = json["msg"].stringValue
                calback(data:MsgModel(msg: msgstr, status: status))
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
    
    
    
    
    
    /** 安全保障 债权列表 **/
    func loadSafeguardInvestData(params:[String : String], calback: (data: String) -> ()) {
        RestAPI.sendGETRequest(B.USERCENTER_SAFEGUARD_INVEST_LIST, params: params,
            success: {
                data in
                let json = JSON(data!)
                calback(data:"\(json)")
            },
            error: {
                error in
                switch error {
                case .ConnectionFailed:
                    calback(data:"连接不可用")
                    KGXToast.showToastWithMessage(B.NETWORK_CONNECTION_ABNORMAL, duration: ToastDisplayDuration.LengthShort)
                default:
                    calback(data:"其他错误")
                    KGXToast.showToastWithMessage("其他错误", duration: ToastDisplayDuration.LengthShort)
                }
            }
        )
    }
    
    /** 安全保障 平台列表 **/
    func loadSafeguardPlatformData(params:[String : String], calback: (data: String) -> ()) {
        RestAPI.sendGETRequest(B.USERCENTER_SAFEGUARD_PLATFORM_LIST, params: params,
            success: {
                data in
                let json = JSON(data!)
                calback(data:"\(json)")
            },
            error: {
                error in
                switch error {
                case .ConnectionFailed:
                    calback(data:"连接不可用")
                    KGXToast.showToastWithMessage(B.NETWORK_CONNECTION_ABNORMAL, duration: ToastDisplayDuration.LengthShort)
                default:
                    calback(data:"其他错误")
                    KGXToast.showToastWithMessage("其他错误", duration: ToastDisplayDuration.LengthShort)
                }
            }
        )
    }
    
    /** 安全保障 总数 **/
    func loadSafeguardTotalData(calback: (data: String) -> ()) {
        RestAPI.sendGETRequest(B.USERCENTER_SAFEGUARD_TOTAL, params: [:],
            success: {
                data in
                let json = JSON(data!)
                calback(data:"\(json)")
            },
            error: {
                error in
                switch error {
                case .ConnectionFailed:
                    calback(data:"连接不可用")
                    KGXToast.showToastWithMessage(B.NETWORK_CONNECTION_ABNORMAL, duration: ToastDisplayDuration.LengthShort)
                default:
                    calback(data:"其他错误")
                    KGXToast.showToastWithMessage("其他错误", duration: ToastDisplayDuration.LengthShort)
                }
            }
        )
    }
    
    
    //内部转账get提交
    func internalTransferGet(calback: (data: AnyObject) -> ()){
        RestAPI.sendGETRequest(B.USERCENTER_INTERIOR_TRANSFER, params:["mm": userDefaultsUtil.getMobile()!],
            success: {
                data in
                var json = JSON(data!)
                //print("内部转账get:\(json)")
                let model = InternalTransferModel()
                model.usableFund = json["usableFund"].stringValue
                model.usableFundShow = json["usableFundShow"].stringValue
                model.freezeFund = json["freezeFund"].stringValue
                model.allOutto = json["allOutto"].stringValue
                model.allInto = json["allInto"].stringValue
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
    
    
    //转账post提交
    func internalTransferPost(params:[String : AnyObject], calback: (data: AnyObject) -> ()){
        RestAPI.sendPostRequest(B.USERCENTER_INTERIOR_TRANSFER, params: params,
            success: {
                data in
                var json = JSON(data!)
                let mm = MsgModel(msg: json["msg"].stringValue, status: json["status"].intValue)
                calback(data:mm)
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
    
    /* 内部转账 转入记录 */
    func loadIntoTransferData(currentPage:Int, calback: (data: Any) -> ()) {
        var itrData = [IntoTransferRecordModel]()
        RestAPI.sendGETRequest(B.USERCENTER_INTO_TRANSFER_LIST, params: [ "mm" : userDefaultsUtil.getMobile()!,"page" :currentPage],
            success: {
                data in
                var json = JSON(data!)
                //print("转入记录:\(json)")
                for (_, subJson): (String, JSON) in json["dataList"] {
                    let itr = IntoTransferRecordModel()
                    itr.mobile = subJson["mobile"].stringValue
                    itr.optime = subJson["optime"].stringValue
                    itr.fund = subJson["fund"].stringValue
                    itr.usableFund = subJson["usableFund"].stringValue
                    itrData.append(itr)
                }
                calback(data:itrData)
            },
            error: {
                error in
                switch error {
                case .ConnectionFailed:
                    calback(data:"连接不可用")
                    KGXToast.showToastWithMessage(B.NETWORK_CONNECTION_ABNORMAL, duration: ToastDisplayDuration.LengthShort)
                default:
                    calback(data:"其他错误")
                    KGXToast.showToastWithMessage("其他错误", duration: ToastDisplayDuration.LengthShort)
                }
            }
        )
    }
    
    /* 内部转账 转出记录 */
    func loadOutTransferData(currentPage:Int, calback: (data: Any) -> ()) {
        var itrData = [IntoTransferRecordModel]()
        RestAPI.sendGETRequest(B.USERCENTER_OUT_TRANSFER_LIST, params: [ "mm" : userDefaultsUtil.getMobile()!,"page" :currentPage],
            success: {
                data in
                var json = JSON(data!)
                //print("转出记录:\(json)")
                for (_, subJson): (String, JSON) in json["dataList"] {
                    let itr = IntoTransferRecordModel()
                    itr.mobile = subJson["mobile"].stringValue
                    itr.optime = subJson["optime"].stringValue
                    itr.fund = subJson["fund"].stringValue
                    itr.usableFund = subJson["usableFund"].stringValue
                    itrData.append(itr)
                }
                calback(data:itrData)
            },
            error: {
                error in
                switch error {
                case .ConnectionFailed:
                    calback(data:"连接不可用")
                    KGXToast.showToastWithMessage(B.NETWORK_CONNECTION_ABNORMAL, duration: ToastDisplayDuration.LengthShort)
                default:
                    calback(data:"其他错误")
                    KGXToast.showToastWithMessage("其他错误", duration: ToastDisplayDuration.LengthShort)
                }
            }
        )
    }
    
    class func getInstance() -> UserCenterService{
        struct Singleton{
            static var predicate:dispatch_once_t = 0
            static var instance:UserCenterService? = nil
        }
        dispatch_once(&Singleton.predicate,{
            Singleton.instance = UserCenterService()
            }
        )
        return Singleton.instance!
    }
}
