//
//  GeRenService.swift
//  fdb-ydzb
//
//  Created by 123 on 16/5/3.
//  Copyright © 2016年 然. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class GeRenService: NSObject {
    
    func geRen(calback: (data: AnyObject) -> ()) {
        
        var hash = ""
        let str = "userId=" + userDefaultsUtil.getUid()! + "&" + "key=" + B.SING
        hash = str.sha256()
        RestAPI.sendPostRequest("/myInfo/userCenter", params: ["userId": userDefaultsUtil.getUid()!,"sign":hash],
            success: {
                data in
                let my = GeRenModel()
                let json = JSON(data!)
                print(json)
//                let status = json["isSuccess"]
                let errors  = json["errors"][0].stringValue
                let data = errors.dataUsingEncoding(NSUTF8StringEncoding)
                let dataDic = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                let dd = JSON(dataDic)
//                print("---------------errors:\(dd)")
                my.isIdentity = dd["isIdentity"].stringValue
                my.isPostAddr = dd["isPostAddr"].stringValue
                my.isBank = dd["isBank"].stringValue
                my.mobile = dd["mobile"].stringValue
                calback(data:my)
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
    func allPhone(calback: (data: AnyObject) -> ()) {
        
        var hash = ""
        let str = "userId=" + userDefaultsUtil.getUid()! + "&" + "key=" + B.SING
        hash = str.sha256()
        RestAPI.sendPostRequest("/myInfo/mobileList", params: ["userId": userDefaultsUtil.getUid()!,"sign":hash],
            success: {
                data in
//                let my = GeRenModel()
                let json = JSON(data!)
                print(json)
//                let status = json["isSuccess"]
                let errors  = json["errors"][0].stringValue
                let data = errors.dataUsingEncoding(NSUTF8StringEncoding)
                let dataDic = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                let dd = JSON(dataDic).arrayObject
                print(dd)
//                print("---------------errors:\(dd)")
//                my.isIdentity = dd["isIdentity"].stringValue
//                my.isPostAddr = dd["isPostAddr"].stringValue
//                my.isBank = dd["isBank"].stringValue
                if json["isSuccess"] == true{
                    calback(data:dd!)
                }else if json["isSuccess"] == false{
                    let arr = NSArray()
                    calback(data:arr)
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
    func jiGouRenZheng(mobile: String, realName: String, tradetype: String, photo: String,calback: (data: AnyObject) -> ()) {
        var hash = ""
        if photo == ""{
            hash = ""
            let str = "mobile=" + mobile + "&" + "userId=" + userDefaultsUtil.getUid()! + "&" + "realName=" + realName + "&" + "tradetype=" + tradetype + "&" + "key=" + B.SING
            hash = str.sha256()
            print(hash)

        }else{
            hash = ""
//            print(photo)
            let str = "mobile=" + mobile + "&" + "userId=" + userDefaultsUtil.getUid()! + "&" + "realName=" + realName + "&" + "tradetype=" + tradetype + "&" + "photo=" + photo + "&" + "key=" + B.SING
            hash = str.sha256()
            print(hash)

        }
            RestAPI.sendPostRequest("/myInfo/saveOrganization", params: ["mobile": mobile ,"userId":userDefaultsUtil.getUid()!,"realName": realName,"tradetype":tradetype,"photo":photo,"sign":hash],
            success: {
                data in
                let my = GeRenModel()
                let json = JSON(data!)
//                print(json)
                if json["isSuccess"] == true{
                KGXToast.showToastWithMessage("上传成功", duration: ToastDisplayDuration.LengthShort)
                    calback(data:"成功")
                }else{
                KGXToast.showToastWithMessage("上传失败", duration: ToastDisplayDuration.LengthShort)
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
    func xiuGaiMiMa(password1: String, password2: String, password3: String ,calback: (data: AnyObject) -> ()) {
        var hash = ""
        let str = "userId=" + userDefaultsUtil.getUid()! + "&" + "password1=" + password1 + "&" + "password2=" + password2 + "&" + "password3=" + password3 + "&" + "key=" + B.SING
            hash = str.sha256()
            print(hash)
            
    
        RestAPI.sendPostRequest("/myInfo/updatePwd", params: ["userId": userDefaultsUtil.getUid()! ,"password1": password1,"password2":password2,"password3":password3,"sign":hash],
            success: {
                data in
                let my = GeRenModel()
                let json = JSON(data!)
//                print(json["errors"][0])
                if json["errors"][0] == "0"{
                  KGXToast.showToastWithMessage("修改成功", duration: ToastDisplayDuration.LengthShort)
                  calback(data:"成功")
                }
                if json["errors"][0] == "1"{
                    KGXToast.showToastWithMessage("原密码错误", duration: ToastDisplayDuration.LengthShort)
                }
                if json["errors"][0] == "2"{
                    KGXToast.showToastWithMessage("两次输入密码不一致", duration: ToastDisplayDuration.LengthShort)
                }
                if json["errors"][0] == "3"{
                    KGXToast.showToastWithMessage("手机号不存在", duration: ToastDisplayDuration.LengthShort)
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

    func chanPinGongGao1( calback: (data: AnyObject) -> ()){
        RestAPI.sendGETRequest("/myInfo/bbs", params:[:],
            success: {
                data in
                let json = JSON(data!)
                let errors = json["errors"][0].stringValue
                if errors != "null"{
                 print(json)
                let data = errors.dataUsingEncoding(NSUTF8StringEncoding)
                let dataDic = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                let dd = JSON(dataDic)
                let arr = JSON(dataDic).arrayObject!
//                print(dd)
                calback(data: arr)
                }else{
                    let arrr = NSArray()
                   calback(data: arrr)
                }
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
    
    func myAddress(calback: (data: AnyObject) -> ()) {
        
        var hash = ""
        let str = "userId=" + userDefaultsUtil.getUid()! + "&" + "key=" + B.SING
        hash = str.sha256()
        RestAPI.sendPostRequest("/myInfo/myAddr", params: ["userId": userDefaultsUtil.getUid()!,"sign":hash],
            success: {
                data in
//                let my = GeRenModel()
                let json = JSON(data!)
                let errors = json["errors"][0].stringValue
                print(json)
                if errors == "null"{
                    
                }else{
                let data = errors.dataUsingEncoding(NSUTF8StringEncoding)
                let dataDic = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
//                let dd = JSON(dataDic)
                let arr = JSON(dataDic).arrayObject!
//                print(arr)
                    
                calback(data:arr)
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
    func deleteAddress(id: String,calback: (data: AnyObject) -> ()) {
        
        var hash = ""
        let str = "id=" + id + "&" + "key=" + B.SING
        hash = str.sha256()
        RestAPI.sendPostRequest("/myInfo/deleteAddr", params: ["id": id,"sign":hash],
            success: {
                data in
                //                let my = GeRenModel()
                let json = JSON(data!)
                let errors = json["isSuccess"]
//                print(json)
                if errors == true{
                    KGXToast.showToastWithMessage("删除成功", duration: ToastDisplayDuration.LengthShort)
                }else{
                    KGXToast.showToastWithMessage("删除失败", duration: ToastDisplayDuration.LengthShort)
                }
                calback(data:"aa")
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

    func addAddress(mobile: String,realName: String,addr: String,isDef: NSInteger,areaName: String,calback: (data: AnyObject) -> ()) {
        
        var hash = ""
        let str = "mobile=" + mobile + "&" + "realName=" + realName + "&" + "userId=" + userDefaultsUtil.getUid()! + "&" + "addr=" + addr + "&" + "isDef=" + "\(isDef)" + "&" + "areaName=" + areaName + "&" + "key=" + B.SING
        hash = str.sha256()
        print(mobile)
        print(realName)
        print(userDefaultsUtil.getUid()!)
        print(addr)
        print(isDef)
        print(areaName)
        print(hash)
        RestAPI.sendPostRequest("/myInfo/addPostAddr", params: ["mobile": mobile,"realName": realName,"userId": userDefaultsUtil.getUid()!,"addr": addr,"isDef": isDef,"areaName": areaName,"sign":hash],
            success: {
                data in
                //                let my = GeRenModel()
                let json = JSON(data!)
                print(json)
//                let errors = json["isSuccess"]
                if json["isSuccess"] == true{
                    KGXToast.showToastWithMessage("添加成功", duration: ToastDisplayDuration.LengthShort)
                    calback(data:"成功")
                }else{
                   KGXToast.showToastWithMessage("添加失败", duration: ToastDisplayDuration.LengthShort)
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
    func addBank(name: String,bank: String,bankNum: String,openBank: String,calback: (data: AnyObject) -> ()) {
        
        var hash = ""
        let str = "userId=" + userDefaultsUtil.getUid()! + "&" + "name=" + name + "&" + "bank=" + bank + "&" + "bankNum=" + bankNum + "&" + "openBank=" + openBank + "&" + "key=" + B.SING
        hash = str.sha256()
        print(userDefaultsUtil.getUid()!)
        print(name)
        print(bank)
        print(bankNum)
        print(openBank)
        print(hash)
        
        
        RestAPI.sendPostRequest("/myInfo/addBankCard", params: ["userId": userDefaultsUtil.getUid()!,"name": name,"bank": bank,"bankNum": bankNum,"openBank": openBank,"sign":hash],
            success: {
                data in
                //                let my = GeRenModel()
                let json = JSON(data!)
                let errors = json["isSuccess"]
                print(json)
                if errors == true{
                    calback(data:"成功")
                    KGXToast.showToastWithMessage("添加银行卡成功", duration: ToastDisplayDuration.LengthShort)
                }else{
                    calback(data:"失败")
                    KGXToast.showToastWithMessage("添加银行卡失败", duration: ToastDisplayDuration.LengthShort)
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
    func myBank(status: String,calback: (data: AnyObject) -> ()) {
        
        var hash = ""
        let str = "userId=" + userDefaultsUtil.getUid()! + "&" + "status=" + status + "&" + "key=" + B.SING
        hash = str.sha256()
        print(hash)
        RestAPI.sendPostRequest("/myInfo/turnBank", params: ["userId": userDefaultsUtil.getUid()!,"status": status,"sign":hash],
            success: {
                data in
                //                let my = GeRenModel()
                let json = JSON(data!)
                print(json)
                let errors = json["errors"][0].stringValue
                print(errors)
                if errors == ""{
                let dic = NSDictionary()
                calback(data:dic)
                }else{
                let data = errors.dataUsingEncoding(NSUTF8StringEncoding)
                let dataDic = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                print(dataDic)
                calback(data:dataDic)
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
    func jiGouRenZhengLieBiao(state: Int,calback: (data: AnyObject) -> ()) {
        
        var hash = ""
        let str = "mobile=" + userDefaultsUtil.getUid()! + "&" + "state=" + "\(state)" + "&" + "key=" + B.SING
        hash = str.sha256()
        print(hash)
        RestAPI.sendPostRequest("/myInfo/organizationPage", params: ["mobile": userDefaultsUtil.getUid()!,"state": state,"sign":hash],
            success: {
                data in
                let my = JiGouRenZhengLieBiaoModel()
                let json = JSON(data!)
                print(json)
                let errors = json["errors"][0].stringValue
//                let data = errors.dataUsingEncoding(NSUTF8StringEncoding)
//                let dataDic = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
//                my.mobile = JSON(dataDic)["mobile"].stringValue
//                my.picUrl = JSON(dataDic)["picUrl"].stringValue
//                my.realName = JSON(dataDic)["realName"].stringValue
//                my.tradetype = JSON(dataDic)["tradetype"].stringValue
//                
//                print(dataDic)
                calback(data:my)
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

    func yuE( calback: (data: AnyObject) -> ()){
        
        var hash = ""
        let str = "userId=" + userDefaultsUtil.getUid()! + "&" + "key=" + B.SING
        hash = str.sha256()
//        print(hash)

        RestAPI.sendPostRequest("/myInfo/balancePage", params:["userId": userDefaultsUtil.getUid()!,"sign":hash],
            success: {
                data in
                let json = JSON(data!)
                
                print(json)
                let errors = json["errors"][0].stringValue
                let data = errors.dataUsingEncoding(NSUTF8StringEncoding)
                let dataDic = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                let dd = JSON(dataDic)
//                let arr = JSON(dataDic).arrayObject!
                print(dd["allIncome"].floatValue)
                print(dd["balance"].floatValue)
                let arr : NSArray = [dd["allIncome"].floatValue,dd["balance"].floatValue]
                
                if json["isSuccess"] == true{

                   calback(data: arr)
                }else{
                    let arr = NSArray()
                    calback(data:arr)
                }

                
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
    func tiXian( calback: (data: AnyObject) -> ()){
        
        var hash = ""
        let str = "userId=" + userDefaultsUtil.getUid()! + "&" + "key=" + B.SING
        hash = str.sha256()
        print(hash)
        
        RestAPI.sendPostRequest("/myInfo/withdrawPage", params:["userId": userDefaultsUtil.getUid()!,"sign":hash],
            success: {
                data in
                let json = JSON(data!)
                
                print(json)
                let errors = json["errors"][0].stringValue
                print(errors)
                if errors == "null"{
                  calback(data: "11")
                }else{
                let data = errors.dataUsingEncoding(NSUTF8StringEncoding)
                let dataDic = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                let dd = JSON(dataDic)
//               let arr = JSON(dataDic).arrayObject!
                print(dd)
                let my = TiXianModel()
//                let arr : NSArray = [dd["allIncome"].stringValue,dd["balance"].stringValue]
                my.name = dd["name"].stringValue
                my.bankId = dd["bankId"].stringValue
                my.openBank = dd["openBank"].stringValue
                my.bankNum = dd["bankNum"].stringValue
                my.bank = dd["bank"].stringValue
                calback(data: my)
                }
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
//上传头像
    func touXiang(pic: String,calback: (data: AnyObject) -> ()) {
            var hash = ""
            let str = "userId=" + userDefaultsUtil.getUid()! + "&" + "pic=" + pic + "&" + "key=" + B.SING
            hash = str.sha256()
            print(hash)
            print(userDefaultsUtil.getUid()!)

            RestAPI.sendPostRequest("/myInfo/uploadHeadPic", params: ["userId": userDefaultsUtil.getUid()! ,"pic":pic,"sign":hash],
            success: {
                data in
                let my = GeRenModel()
                let json = JSON(data!)
                print(json)
                if json["isSuccess"] == true{
                    KGXToast.showToastWithMessage("上传成功", duration: ToastDisplayDuration.LengthShort)
                    calback(data:"成功")
                }else{
                    KGXToast.showToastWithMessage("上传失败", duration: ToastDisplayDuration.LengthShort)
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
    //提现接口
    func tiXianMoney(realName: String,bankId: String,cardNumber: String,openBank: String,cashvalue: String,calback: (data: AnyObject) -> ()) {
        
        var hash = ""
        let str = "userId=" + userDefaultsUtil.getUid()! + "&" + "realName=" + realName + "&" + "bankId=" + bankId + "&" + "cardNumber=" + cardNumber + "&" + "openBank=" + openBank + "&" + "cashvalue=" + cashvalue + "&" + "key=" + B.SING
        hash = str.sha256()
        RestAPI.sendPostRequest("/myInfo/withdraw", params: ["userId": userDefaultsUtil.getUid()!,"realName": realName,"bankId": bankId,"cardNumber": cardNumber,"openBank": openBank,"cashvalue": cashvalue,"sign":hash],
            success: {
                data in
                //                let my = GeRenModel()
                let json = JSON(data!)
                print(json)
                //                let errors = json["isSuccess"]
                if json["isSuccess"] == true{
                    KGXToast.showToastWithMessage("提现成功", duration: ToastDisplayDuration.LengthShort)
                     calback(data:"提现成功")
                }else{
                    KGXToast.showToastWithMessage("提现失败", duration: ToastDisplayDuration.LengthShort)
                    calback(data:"提现失败")
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
    //上传打款凭条
    func shangChun(orderId: String,pics: String,realName: String,cardNumb: String,bankNumb: String,remitvalue :String,remark : String,calback: (data: AnyObject) -> ()) {
        
        var hash = ""
        let str = "orderId=" + orderId + "&" + "pics=" + pics + "&" + "realName=" + realName + "&" + "cardNumb=" + cardNumb + "&" + "bankNumb=" + bankNumb + "&" + "remitvalue=" + remitvalue + "&" + "remark=" + remark + "&" + "key=" + B.SING
        hash = str.sha256()
        RestAPI.sendPostRequest("/order/uploadPaymentPic", params: ["orderId": orderId,"pics": pics,"realName": realName,"cardNumb": cardNumb,"bankNumb": bankNumb,"remitvalue": remitvalue,"remark":remark,"sign":hash],
            success: {
                data in
                //                let my = GeRenModel()
                let json = JSON(data!)
                print(json)
                //                let errors = json["isSuccess"]
                if json["isSuccess"] == true{
                    KGXToast.showToastWithMessage("提交成功", duration: ToastDisplayDuration.LengthShort)
                    calback(data:"成功")
                }else{
                    KGXToast.showToastWithMessage("提交失败", duration: ToastDisplayDuration.LengthShort)
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
    //常规设置
    func changGuiSheZhi( calback: (data: AnyObject) -> ()){
        RestAPI.sendGETRequest("/myInfo/normalSettings", params:[:],
            success: {
                data in
                let json = JSON(data!)
                let errors = json["errors"][0].stringValue
               print(json)
                    print(errors)
//                    let data = errors.dataUsingEncoding(NSUTF8StringEncoding)
//                    let dataDic = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
//                    let dd = JSON(dataDic).stringValue
                
                    calback(data: errors)
                
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
//选择手机号
    func xuanZeShouJiHao(mobile: String,calback: (data: AnyObject) -> ()) {
        
        var hash = ""
        let str = "userId=" + userDefaultsUtil.getUid()! + "&" + "mobile=" + mobile + "&" + "key=" + B.SING
        hash = str.sha256()
        RestAPI.sendPostRequest("/myInfo/chooseMobile", params: ["userId": userDefaultsUtil.getUid()!,"mobile":mobile,"sign":hash],
            success: {
                data in
                //                let my = GeRenModel()
                let json = JSON(data!)
                let errors = json["isSuccess"]
                print(json)
//                if errors == true{
//                    KGXToast.showToastWithMessage("删除成功", duration: ToastDisplayDuration.LengthShort)
//                }else{
//                    KGXToast.showToastWithMessage("删除失败", duration: ToastDisplayDuration.LengthShort)
//                }
                calback(data:"aa")
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

    class func getInstance() -> GeRenService{
        struct Singleton{
            static var predicate:dispatch_once_t = 0
            static var instance:GeRenService? = nil
        }
        dispatch_once(&Singleton.predicate, {
            Singleton.instance = GeRenService()
            }
        )
        return Singleton.instance!
    }
 
    
}