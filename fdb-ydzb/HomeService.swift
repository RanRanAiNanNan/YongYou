//
//  HomeService.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/2/28.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomeService: NSObject {
    

    func main(userId: String, type: String,calback: (data: AnyObject) -> ()) {
      
        print(userDefaultsUtil.getUid()!)
        var hash = ""
        if userId == ""{
            let str = "type=" + type + "&" + "key=" + B.SING
            hash = str.sha256()
            print(hash)
        }else{
            let str = "userId=" + userDefaultsUtil.getUid()! + "&" + "type=" + type + "&" + "key=" + B.SING
            hash = str.sha256()
             print(userDefaultsUtil.getUid()!)
             print(hash)
        }
        
       
        RestAPI.sendPostRequest("/home/home", params: ["userId": userDefaultsUtil.getUid()!,"type":type,"sign":hash],
            success: {
                data in
                let hm = HomeModel()
                var json = JSON(data!)
                let bannerJson = json["errors"][0]
                let jsonStr = bannerJson.rawValue as! String
                let data = jsonStr.dataUsingEncoding(NSUTF8StringEncoding)
                let dataDic = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                
                let dd = JSON(dataDic)
                print(dd)
                var banners = [BannerModel]()
                
                //遍历banner
                for (_, subJson): (String, JSON) in dd["homeBanners"] {
                let bm = BannerModel()
                bm.actUrl = subJson["actUrl"].stringValue
                bm.photoUrl = subJson["photoUrl"].stringValue
                banners.append(bm)
                }
//                print(dd)
               var banners1 = [LieBiaoModel]()
                for (_, subJson): (String, JSON) in dd["homeProductInfos"] {
                    let bm1 = LieBiaoModel()
                    bm1.id = subJson["id"].stringValue
                    bm1.name = subJson["name"].stringValue
                    bm1.typeId = subJson["typeId"].stringValue
                    bm1.cylcles = subJson["cylcles"].stringValue
                    bm1.productClas = subJson["productClas"].stringValue
                    bm1.interestRate = subJson["interestRate"].stringValue
                    bm1.startupMoney = subJson["startupMoney"].stringValue
                    bm1.backInterest = subJson["backInterest"].stringValue
                    bm1.openDate = subJson["openDate"].stringValue
                    banners1.append(bm1)
                }
                hm.productType = NSArray()
                hm.productType = dd["productType"].arrayObject!
                hm.homeProductInfos = banners1
                hm.homeBanners = banners
                hm.messageStatus = dd["messageStatus"].stringValue
                calback(data:hm)
            },
            error: {
                error in
                switch error {
                case .ConnectionFailed:
                    calback(data:B.NETWORK_CONNECTION_ABNORMAL)
//                    KGXToast.showToastWithMessage(B.NETWORK_CONNECTION_ABNORMAL, duration: ToastDisplayDuration.LengthShort)
                default:
                    calback(data:"其他错误")
                    KGXToast.showToastWithMessage("其他错误", duration: ToastDisplayDuration.LengthShort)
                }
            }
        )
        
    }

    //我的
    func my(calback: (data: AnyObject) -> ()) {
        var hash = ""
        let str = "userId=" + userDefaultsUtil.getUid()! + "&" + "key=" + B.SING
        hash = str.sha256()

        RestAPI.sendPostRequest("/myInfo/myInfo", params: ["userId": userDefaultsUtil.getUid()!,"sign":hash],
            success: {
                data in
                
                let my = MyModel()
                var json = JSON(data!)
                let status = json["isSuccess"]
                let errors  = json["errors"][0].stringValue
                let data = errors.dataUsingEncoding(NSUTF8StringEncoding)
                let dataDic = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                let dd = JSON(dataDic)
                print("---------------errors:\(dd)")
                my.photoUrl = dd["photoUrl"].stringValue
                userDefaultsUtil.setAvatarLink(my.photoUrl)
                my.name = dd["name"].stringValue
                my.allIncome = dd["allIncome"].floatValue
                my.regMobile = dd["regMobile"].stringValue
                print(dd["allIncome"])
                calback(data:my)
                
            },
            error: {
                error in
                switch error {
                case .ConnectionFailed:
//                    calback(data:B.NETWORK_CONNECTION_ABNORMAL)
                    KGXToast.showToastWithMessage(B.NETWORK_CONNECTION_ABNORMAL, duration: ToastDisplayDuration.LengthShort)
                default:
//                    calback(data:"其他错误")
                    KGXToast.showToastWithMessage("其他错误", duration: ToastDisplayDuration.LengthShort)
                }
            }
        )

        
        
    }
    //修改用户名
    func fixName(name: String,calback: (data: AnyObject) -> ()) {
        var hash = ""
        let str = "userId=" + userDefaultsUtil.getUid()! + "&" + "name=" + name + "&" + "key=" + B.SING
        hash = str.sha256()
        
        RestAPI.sendPostRequest("/myInfo/modifyName", params: ["userId": userDefaultsUtil.getUid()!,"name": name,"sign":hash],
            success: {
                data in
                let json = JSON(data!)
                print(json)
                
                if json["errors"][0].stringValue == "0"{
                    KGXToast.showToastWithMessage("用户名修改成功", duration: ToastDisplayDuration.LengthShort)
                    
                    calback(data:"1")
                }else{
                    KGXToast.showToastWithMessage("用户名已存在", duration: ToastDisplayDuration.LengthShort)
                    calback(data:"2")
                }
                
            },
            error: {
                error in
                switch error {
                case .ConnectionFailed:
//                    calback(data:B.NETWORK_CONNECTION_ABNORMAL)
                    KGXToast.showToastWithMessage(B.NETWORK_CONNECTION_ABNORMAL, duration: ToastDisplayDuration.LengthShort)
                default:
//                    calback(data:"其他错误")
                    KGXToast.showToastWithMessage("其他错误", duration: ToastDisplayDuration.LengthShort)
                }
            }
        )
        
        
        
    }
    //站内信
    func zhanNeiXin(calback: (data: AnyObject) -> ()) {
        var hash = ""
        let str = "userId=" + userDefaultsUtil.getUid()! +  "&" + "key=" + B.SING
        hash = str.sha256()
        
        RestAPI.sendPostRequest("/home/searchMessage", params: ["userId": userDefaultsUtil.getUid()!,"sign":hash],
            success: {
                data in
                let json = JSON(data!)
                print(json)
//                if json["isSuccess"] == true{
//                    KGXToast.showToastWithMessage("用户名修改成功", duration: ToastDisplayDuration.LengthShort)
//                }else{
//                    KGXToast.showToastWithMessage("用户名修改失败", duration: ToastDisplayDuration.LengthShort)
//                }
                calback(data:"dd")
            },
            error: {
                error in
                switch error {
                case .ConnectionFailed:
//                    calback(data:B.NETWORK_CONNECTION_ABNORMAL)
                    KGXToast.showToastWithMessage(B.NETWORK_CONNECTION_ABNORMAL, duration: ToastDisplayDuration.LengthShort)
                default:
//                    calback(data:"其他错误")
                    KGXToast.showToastWithMessage("其他错误", duration: ToastDisplayDuration.LengthShort)
                }
            }
        )
        
        
        
    }

    //首页显示数据
    func loadDataGet(calback: (data: AnyObject) -> ()) {
        RestAPI.sendGETRequest(B.HOME_USER_DATA, params: [ "mm" : userDefaultsUtil.getMobile()!],
            success: {
                data in
                var json = JSON(data!)
                //print("home json:\(json)")
                let hm = HomeModel()
                let bannerJson = json["banner"]
                var banners = [BannerModel]()
                //遍历banner
//                for (_, subJson): (String, JSON) in bannerJson {
//                    let bm = BannerModel()
//                    bm.thumb = subJson["thumb"].stringValue
//                    bm.url = subJson["url"].stringValue
//                    bm.title = subJson["title"].stringValue
//                    banners.append(bm)
//                }
//                hm.banners = banners
//                hm.hot = json["hot"]
//                hm.peopleTotal = json["people_total"].stringValue
//                hm.avatar = json["avatar"].stringValue
//                hm.vip = json["vip"].stringValue
//                hm.username = json["username"].stringValue
//                hm.token = json["token"].stringValue
//                hm.moneyTotal = json["money_total"].stringValue
//                hm.revenueTotal = json["revenue_total"].stringValue
//                hm.financeKey = json["products_version"].stringValue
//                hm.discoverKey = json["activity_version"].stringValue
                
                //hm.vip = "2"
                calback(data:hm)
            },
            error: {
                error in
                switch error {
                case .ConnectionFailed:
//                   calback(data:B.NETWORK_CONNECTION_ABNORMAL)
                    KGXToast.showToastWithMessage(B.NETWORK_CONNECTION_ABNORMAL, duration: ToastDisplayDuration.LengthShort)
                default:
//                   calback(data:"其他错误")
                   KGXToast.showToastWithMessage("其他错误", duration: ToastDisplayDuration.LengthShort)
                }
            }
        )
    }
    
    
    //显示活动数据
    func loadActivityData(calback: (data: AnyObject) -> ()){
        RestAPI.sendGETRequest(B.ACTIVITY_LIST, params:[:],
            success: {
                data in
                var json = JSON(data!)
                let jsonArray: Array<JSON> = json["data"].arrayValue
                var tempArray = [ActivityModel]()
                
                for i in 0..<jsonArray.count {
                    let activity = ActivityModel()
                    activity.activityId = jsonArray[jsonArray.count-1-i]["id"].stringValue
                    activity.activityUrl = jsonArray[jsonArray.count-1-i]["url"].stringValue
                    activity.activityName = jsonArray[jsonArray.count-1-i]["name"].stringValue
                    activity.activityThumb = jsonArray[jsonArray.count-1-i]["thumb"].stringValue
                    tempArray.append(activity)
                }
                
                calback(data:tempArray)
                
            },
            error: {
                error in
                switch error {
                case .ConnectionFailed:
//                    calback(data:"连接不可用")
                    KGXToast.showToastWithMessage("连接不可用", duration: ToastDisplayDuration.LengthShort)
                default:
//                    calback(data:"其他错误")
                    KGXToast.showToastWithMessage("其他错误", duration: ToastDisplayDuration.LengthShort)
                }
            }
        )
    }
    
    //是否有未读站内信
    func queryMessage(calback: (data: AnyObject) -> ()) {
        RestAPI.sendGETRequest("Message/num", params: ["mobile" : userDefaultsUtil.getMobile()!],
            success: {
                data in
                var json = JSON(data!)
                calback(data:json.intValue)
            },
            error: {
                error in
                switch error {
                case .ConnectionFailed:
//                    calback(data:B.NETWORK_CONNECTION_ABNORMAL)
                    KGXToast.showToastWithMessage(B.NETWORK_CONNECTION_ABNORMAL, duration: ToastDisplayDuration.LengthShort)
                default:
//                    calback(data:"其他错误")
                    KGXToast.showToastWithMessage("其他错误", duration: ToastDisplayDuration.LengthShort)
                }
            }
        )
    }
    //充值检查
    func checkRecharge(params:[String : AnyObject], calback: (data: AnyObject) -> ()){
        RestAPI.sendGETRequest(B.RECHARGE_CHECK, params: params,
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
//                    calback(data:B.NETWORK_CONNECTION_ABNORMAL)
                    KGXToast.showToastWithMessage(B.NETWORK_CONNECTION_ABNORMAL, duration: ToastDisplayDuration.LengthLongLong)
                default:
//                    calback(data:"其他错误")
                    KGXToast.showToastWithMessage("其他错误", duration: ToastDisplayDuration.LengthLong)
                }
            }
        )
    }
    
    
    //下载远程头像
    func downloadAvatar(imageURL:String, calback: (img: AnyObject) -> ()) {
        let avatarImg = UIImage(named: "Avatar@2x(1)")
        Alamofire.request(.GET, imageURL).response() {
            (_, _, data, error) in
            if error == nil {
                let image = UIImage(data: data! )
                if image != nil {
                    //保存头像
                    PhotoUtils.saveImage(image!)
                    calback(img: image!)
                }else{
                    calback(img: avatarImg!)
                }
                
            }else{
                userDefaultsUtil.setAvatarLink("")
                KGXToast.showToastWithMessage("用户头像下载失败!", duration: ToastDisplayDuration.LengthShort)
            }
        }
    }
   
    

    
    //稳进宝期目条数的service
//    func loadStablePeriod(calback: (data: AnyObject) -> ()) {
//        RestAPI.sendGETRequest(B.STABLE_PERIOD_LIST, params: [ "mobile" : userDefaultsUtil.getMobile()!],
//            success: {
//                data in
//                let array: NSArray = data as! NSArray
//                let mArray: NSMutableArray = NSMutableArray()
//                for var i = 0 ; i < array.count; i++ {
//                    let stablePeriod = StablePeriod()
//                    let dic: NSDictionary = array[i] as! NSDictionary
//                    
//                    if let id = dic.valueForKeyPath("id") as? String {
//                        stablePeriod.id = id
//                    }
//                    
//                    if let name = dic.valueForKeyPath("name") as? String {
//                        stablePeriod.name = name
//                    }
//                    
//                    if let money = dic.valueForKeyPath("money") as? String {
//                        let str = "¥".stringByAppendingString(money)
//                        stablePeriod.money = str
//                    }
//                    
//                    mArray.addObject(stablePeriod)
//                }
//                
//                calback(data:mArray)
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

    //分享接口
    func fenXiang(proId: String,calback: (data: AnyObject) -> ()) {
        var hash = ""
        let str = "proId=" + proId + "&" + "key=" + B.SING
        hash = str.sha256()
        
        RestAPI.sendPostRequest("/home/share", params: ["proId": proId,"sign":hash],
            success: {
                data in
                
                let json = JSON(data!)
//                let status = json["isSuccess"]
                let errors  = json["errors"][0].stringValue
                let data = errors.dataUsingEncoding(NSUTF8StringEncoding)
                let dataDic = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                let dd = JSON(dataDic)

                print(dd)
                let my = FenXiangModel()
                my.title = dd["title"].stringValue
                my.content = dd["content"].stringValue
                my.proName = dd["proName"].stringValue
                my.url = dd["url"].stringValue
//                if json["isSuccess"] == true{
//                    KGXToast.showToastWithMessage("用户名修改成功", duration: ToastDisplayDuration.LengthShort)
//                    
                    calback(data:my)
//                }else{
//                    KGXToast.showToastWithMessage("用户名修改失败", duration: ToastDisplayDuration.LengthShort)
//                    calback(data:"2")
//                }
                
            },
            error: {
                error in
                switch error {
                case .ConnectionFailed:
//                    calback(data:B.NETWORK_CONNECTION_ABNORMAL)
                    KGXToast.showToastWithMessage(B.NETWORK_CONNECTION_ABNORMAL, duration: ToastDisplayDuration.LengthShort)
                default:
//                    calback(data:"其他错误")
                    KGXToast.showToastWithMessage("其他错误", duration: ToastDisplayDuration.LengthShort)
                }
            }
        )
        
        
        
    }
    //财富接口
    func caiFu(calback: (data: AnyObject) -> ()) {
        var hash = ""
        let str = "userId=" + userDefaultsUtil.getUid()! + "&" + "key=" + B.SING
        hash = str.sha256()
        
        RestAPI.sendPostRequest("/myAsset/myAsset", params: ["userId":userDefaultsUtil.getUid()!,"sign":hash],
            success: {
                data in
                
                let json = JSON(data!)
//                print(json)
                let errors  = json["errors"][0].stringValue

                calback(data:errors)

                
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
//我的分享
    func woDeFenXaing(regMobile: String,calback: (data: AnyObject) -> ()) {
        var hash = ""
        let str = "regMobile=" + regMobile + "&" + "key=" + B.SING
        hash = str.sha256()
        
        RestAPI.sendPostRequest("/home/userCenterShare", params: ["regMobile": regMobile,"sign":hash],
            success: {
                data in
                
                let json = JSON(data!)
                print(json)
                let errors  = json["errors"][0].stringValue
                let data = errors.dataUsingEncoding(NSUTF8StringEncoding)
                let dataDic = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                let dd = JSON(dataDic)
                
                print(dd)
                let my = MyFenXiangModel()
                my.title = dd["title"].stringValue
                my.content = dd["content"].stringValue
                my.url = dd["url"].stringValue
                calback(data:my)
                
            },
            error: {
                error in
                switch error {
                case .ConnectionFailed:
//                    calback(data:B.NETWORK_CONNECTION_ABNORMAL)
                    KGXToast.showToastWithMessage(B.NETWORK_CONNECTION_ABNORMAL, duration: ToastDisplayDuration.LengthShort)
                default:
//                    calback(data:"其他错误")
                    KGXToast.showToastWithMessage("其他错误", duration: ToastDisplayDuration.LengthShort)
                }
            }
        )
        
        
        
    }

    class func getInstance() -> HomeService{
        struct Singleton{
            static var predicate:dispatch_once_t = 0
            static var instance:HomeService? = nil
        }
        dispatch_once(&Singleton.predicate, {
            Singleton.instance = HomeService()
            }
        )
        return Singleton.instance!
    }
    
   
}
