//
//  ProductMainService.swift
//  fdb-ydzb
//
//  Created by 123 on 16/5/6.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ProductMainService: NSObject {
    
  
    //分类首页
    func fenLei(calback: (data: AnyObject) -> ()) {
        var hash = ""
        let str = "userId=" + userDefaultsUtil.getUid()! + "&" + "key=" + B.SING
        hash = str.sha256()
        
        RestAPI.sendPostRequest("/order/orderNum", params: ["userId": userDefaultsUtil.getUid()!,"sign":hash],
            success: {
                data in
                let json = JSON(data!)
//                print(json)
                let hm = ProductMainModel()
                let bannerJson = json["errors"][0]
                let jsonStr = bannerJson.rawValue as! String
                let data = jsonStr.dataUsingEncoding(NSUTF8StringEncoding)
                let dataDic = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                let dd = JSON(dataDic)
                print(dataDic)
                var banners = [ProductModel]()
                //遍历
                for (_, subJson): (String, JSON) in dd["MyOrder"] {
                    let bm = ProductModel()
                    bm.addrId = subJson["addrId"].stringValue
                    bm.money = subJson["money"].stringValue
                    bm.orderDate = subJson["orderDate"].stringValue
                    bm.orderId = subJson["orderId"].stringValue
                    bm.proId = subJson["proId"].stringValue
                    bm.productName = subJson["productName"].stringValue
                    bm.status = subJson["status"].stringValue
                    banners.append(bm)
                }

                
                hm.allOrders = dd["allOrders"].intValue
                hm.successOrders = dd["successOrders"].intValue
                hm.unpaidOrders = dd["unpaidOrders"].intValue
                hm.MyOrder = banners
               

                calback(data:hm)
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
    //提交预约
    func tiJiaoYuYue(proId: String,name: String,mobile: String,remark: String,money: String,addrId: String,calback: (data: AnyObject) -> ()) {
        var hash = ""
        if remark == "请输入备注信息" || remark == ""{
           
            let str = "userId=" + userDefaultsUtil.getUid()! + "&" + "proId=" + proId + "&" + "name=" + name + "&" + "mobile=" + mobile  + "&" + "money=" + money + "&" + "addrId=" + addrId + "&" + "key=" + B.SING
            hash = str.sha256()
            print(userDefaultsUtil.getUid()!)
            print(hash)
            print(proId)
            print(name)
            print(mobile)
            print(remark)
            print(money)
            print(addrId)
            RestAPI.sendPostRequest("/order/saveOrderDetail", params: ["userId": userDefaultsUtil.getUid()!,"proId":proId,"name":name,"mobile":mobile,"money":money,"addrId":addrId,"sign":hash],
                success: {
                    data in
                    let json = JSON(data!)
                    print(json)
                    let errors = json["errors"][0].stringValue
                    if json["isSuccess"] == true{
                        KGXToast.showToastWithMessage("预约成功", duration: ToastDisplayDuration.LengthShort)
                        calback(data:errors)
                    }else{
                        KGXToast.showToastWithMessage("预约失败", duration: ToastDisplayDuration.LengthShort)
                        calback(data:"失败")
                    }
                    
                    
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
        }else{
            
            let str = "userId=" + userDefaultsUtil.getUid()! + "&" + "proId=" + proId + "&" + "name=" + name + "&" + "mobile=" + mobile + "&" + "remark=" + remark + "&" + "money=" + money + "&" + "addrId=" + addrId + "&" + "key=" + B.SING
            hash = str.sha256()
            print(userDefaultsUtil.getUid()!)
            print(hash)
            print(proId)
            print(name)
            print(mobile)
            print(remark)
            print(money)
            print(addrId)
            RestAPI.sendPostRequest("/order/saveOrderDetail", params: ["userId": userDefaultsUtil.getUid()!,"proId":proId,"name":name,"mobile":mobile,"remark":remark,"money":money,"addrId":addrId,"sign":hash],
                success: {
                    data in
                    let json = JSON(data!)
                    print(json)
                    let errors = json["errors"][0].stringValue
                    if json["isSuccess"] == true{
                        KGXToast.showToastWithMessage("预约成功", duration: ToastDisplayDuration.LengthShort)
                        calback(data:errors)
                    }else{
                        KGXToast.showToastWithMessage("预约失败", duration: ToastDisplayDuration.LengthShort)
                        calback(data:"失败")
                    }
                    
                    
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
        
        
        
        
    }
    func dingDanXiangQing(orderId: String,addrId: String,calback: (data: AnyObject) -> ()) {
        var hash = ""
        let str =  "orderId=" + orderId + "&" + "addrId=" + addrId + "&" + "key=" + B.SING
        hash = str.sha256()
        
        RestAPI.sendPostRequest("/order/orderDetail", params: ["orderId": orderId,"addrId":addrId,"sign":hash],
            success: {
                data in
                let json = JSON(data!)
                let hm = DingDanXiangQingModel()
                let errors = json["errors"][0].stringValue
                let data = errors.dataUsingEncoding(NSUTF8StringEncoding)
                let dataDic = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                let dd = JSON(dataDic)
                print(json)
                hm.money = dd["money"].stringValue
                hm.orderDate = dd["orderDate"].stringValue
                hm.orderNumb = dd["orderNumb"].stringValue
                hm.phoneNumb = dd["phoneNumb"].stringValue
                hm.proId = dd["proId"].stringValue
                hm.proName = dd["proName"].stringValue
                hm.realRame = dd["realRame"].stringValue
                hm.remark = dd["remark"].stringValue
                hm.status = dd["status"].stringValue
                hm.userAddrs_addr = dd["userAddrs"]["addr"].stringValue
                hm.userAddrs_areaName = dd["userAddrs"]["areaName"].stringValue
                hm.userAddrs_id = dd["userAddrs"]["id"].stringValue
                hm.userAddrs_isDef = dd["userAddrs"]["isDef"].stringValue
                hm.userAddrs_mobile = dd["userAddrs"]["mobile"].stringValue
                hm.userAddrs_postStatus = dd["userAddrs"]["postStatus"].stringValue
                hm.userAddrs_realName = dd["userAddrs"]["realName"].stringValue
                hm.userAddrs_status = dd["userAddrs"]["status"].stringValue
                hm.userAddrs_userId = dd["userAddrs"]["userId"].stringValue
                hm.postStaus = dd["postStatus"].stringValue
//                print(hm.status)
                calback(data:hm)
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
// 取消订单接口
    func quXiaoDingDan(id: String,calback: (data: AnyObject) -> ()) {
        var hash = ""
        let str =  "id=" + id +  "&" + "key=" + B.SING
        hash = str.sha256()
        print(hash)
        RestAPI.sendPostRequest("/order/cancelOrder", params: ["id":id,"sign":hash],
            success: {
                data in
                let json = JSON(data!)
//                let hm = DingDanXiangQingModel()
                if json["isSuccess"] == true{
                   KGXToast.showToastWithMessage("取消订单成功", duration: ToastDisplayDuration.LengthShort)
                    calback(data:"1")
                }else{
                   KGXToast.showToastWithMessage("取消订单失败", duration: ToastDisplayDuration.LengthShort)
                    calback(data:"2")
                }
//                print(json)
                
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
//上传前述照片
    func shangChuanQianShu(orderId: String,pic: String,calback: (data: AnyObject) -> ()) {
        var hash = ""
        let str =  "orderId=" + orderId + "&" + "pic=" + pic + "&" + "key=" + B.SING
        hash = str.sha256()
        print(hash)
        RestAPI.sendPostRequest("/order/uploadSignPic", params: ["orderId":orderId,"pic":pic,"sign":hash],
            success: {
                data in
                let json = JSON(data!)
                 print(json)
                if json["isSuccess"] == true{
                    KGXToast.showToastWithMessage("上传签署照片成功", duration: ToastDisplayDuration.LengthShort)
                    calback(data:"成功")
                }else{
                    KGXToast.showToastWithMessage("上传签署照片失败", duration: ToastDisplayDuration.LengthShort)
                    calback(data:"失败")
                }
                //                print(json)
                
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
//查询合同地址
    func chaXunDiZhi(addrId: String,calback: (data: AnyObject) -> ()) {
        var hash = ""
        let str =  "addrId=" + addrId + "&" + "key=" + B.SING
        hash = str.sha256()
        print(hash)
        RestAPI.sendPostRequest("/myInfo/searchAddr", params: ["addrId":addrId,"sign":hash],
            success: {
                data in
                let json = JSON(data!)
                let errors = json["errors"][0].stringValue
                let data = errors.dataUsingEncoding(NSUTF8StringEncoding)
                let dataDic = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                let dd = JSON(dataDic)

                print(dd)
                let hm = UserAddrsModel()
                hm.postStatus = dd["postStatus"].stringValue
                hm.isDef = dd["isDef"].stringValue
                hm.id = dd["id"].stringValue
                hm.userId = dd["userId"].stringValue
                hm.realName = dd["realName"].stringValue
                hm.areaName = dd["areaName"].stringValue
                hm.status = dd["status"].stringValue
                hm.mobile = dd["mobile"].stringValue
                hm.addr = dd["addr"].stringValue
                
                calback(data:hm)
                
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
//提交修改地址
    func tiJiaoXiuGaiDiZhi(mobile: String,addrId: String,realName: String,addr: String,areaName: String,calback: (data: AnyObject) -> ()) {
        var hash = ""
        let str = "mobile=" + mobile + "&" + "addrId=" + addrId + "&" + "realName=" + realName + "&" + "addr=" + addr + "&" + "areaName=" + areaName + "&" + "userId=" + userDefaultsUtil.getUid()! + "&" + "key=" + B.SING
        hash = str.sha256()
        
        RestAPI.sendPostRequest("/myInfo/updatePostAddr", params: ["mobile": mobile,"addrId":addrId,"realName":realName,"addr":addr,"areaName":areaName,"userId":userDefaultsUtil.getUid()!,"sign":hash],
            success: {
                data in
                let json = JSON(data!)
                print(json)
                if json["isSuccess"] == true{
                    KGXToast.showToastWithMessage("修改地址成功", duration: ToastDisplayDuration.LengthShort)
                    calback(data:"成功")
                }else{
                    KGXToast.showToastWithMessage("修改地址失败", duration: ToastDisplayDuration.LengthShort)
                    calback(data:"失败")
                }
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

    //跳转预约详情
    func yuYueXiangQingMoRen(calback: (data: AnyObject) -> ()) {
        var hash = ""
        let str = "userId=" + userDefaultsUtil.getUid()! +  "&" + "key=" + B.SING
        hash = str.sha256()
        
        RestAPI.sendPostRequest("/order/turnOrderDetail", params: ["userId": userDefaultsUtil.getUid()!,"sign":hash],
            success: {
                data in
                let json = JSON(data!)
                print(json)
                let errors = json["errors"][0].stringValue
                let data = errors.dataUsingEncoding(NSUTF8StringEncoding)
                let dataDic = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                let dd = JSON(dataDic)
                print(dd)
                let hm = moRenModel()
                hm.mobile = dd["mobile"].stringValue
                hm.addr = dd["addr"].stringValue
                hm.addrId = dd["addrId"].stringValue
                //                if json["isSuccess"] == true{
                //                    KGXToast.showToastWithMessage("用户名修改成功", duration: ToastDisplayDuration.LengthShort)
                //                }else{
                //                    KGXToast.showToastWithMessage("用户名修改失败", duration: ToastDisplayDuration.LengthShort)
                //                }
                calback(data:hm)
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

    
    class func getInstance() -> ProductMainService{
        struct Singleton{
            static var predicate:dispatch_once_t = 0
            static var instance:ProductMainService? = nil
        }
        dispatch_once(&Singleton.predicate,{
            Singleton.instance = ProductMainService()
            }
        )
        return Singleton.instance!
    }
    
    
}