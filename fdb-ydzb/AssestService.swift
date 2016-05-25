//  资产模块service
//  有一部分安全中心模块中添加银行卡功能在其中。
//  CheckVersionService.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/3/21.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AssestService: NSObject {
    
    //首页显示数据
    func loadDataGet(calback: (data: AnyObject) -> ()) {
        RestAPI.sendGETRequest(B.ASSEST_MAIN, params: [ "mm" : userDefaultsUtil.getMobile()!],
            success: {
                data in
                var json = JSON(data!)
                //println("资产首页 main:\(json)")
                let assestModel = AssestModel()
                assestModel.totalFund = json["totalFund"].stringValue
                assestModel.usableFund = json["usableFund"].stringValue
                assestModel.allIncome = json["allIncome"].stringValue
                assestModel.ableMoney = json["ableMoney"].stringValue
                assestModel.yesterdayIncome = json["yesterdayIncome"].stringValue
                assestModel.allInvest = json["allInvest"].stringValue
                assestModel.freezeFund = json["freezeFund"].stringValue
                assestModel.msg = json["msg"].intValue
           
                calback(data:assestModel)
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
    
    func rechargeGet(params:[String : String], calback: (data: AnyObject) -> ()){
        RestAPI.sendGETRequest(B.RECHARGE_HOME, params: params,
            success: {
                data in
                var json = JSON(data!)
                //cprint("充值get:\(json)")
                let rf = RechargeFirstModel()
                rf.order = json["order"].stringValue
                rf.cardNo = json["cardNo"].stringValue
                rf.bankName = json["bankName"].stringValue
                rf.bankId = json["bankId"].stringValue
                rf.isRecharge = json["is_recharge"].stringValue
                rf.isCheck = json["is_check"].stringValue
                rf.rechargeTotal = json["allRecharge"].stringValue
                rf.rechargeQuota = json["rechargeQuota"].stringValue
                rf.rechargeQuotaShow = json["rechargeQuotaShow"].stringValue
                
                //rf.isRecharge = "0"
                //rf.isCheck = "0"
                
                //rf.rechargeQuota = "2"
                
                if rf.isCheck == "1" {
                    rf.hideCheck = true
                }
                if rf.isRecharge == "1" {
                    rf.hideRecharge = true
                }
                calback(data:rf)
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
    
    //充值提交
    func rechargePost(params:[String : AnyObject], calback: (data: AnyObject) -> ()){
        RestAPI.sendPostRequest(B.RECHARGE_HOME, params: params,
            success: {
                data in
                var json = JSON(data!)
                //println("json:\(json)")
                let mm = MsgModel(msg: json["msg"].stringValue, status: json["status"].intValue)
                calback(data:mm)
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
    
    //获取订单号
    func getOrder(params:[String : AnyObject], calback: (data: AnyObject) -> ()){
        RestAPI.sendPostRequest(B.RECHARGE_ORDER, params: params,
            success: {
                data in
                var json = JSON(data!)
                //print("获取订单号:\(json)")
                let mm = MsgModel(msg: json["order"].stringValue, status: json["status"].intValue)
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
    
    
    func bankCardDataGet( calback: (data: Any) -> ()) {
        var bandCardRecordData = [BandCarModel]()
        RestAPI.sendGETRequest(B.ASSEST_RECHARGE_BANKCARD, params: [ "mm" : userDefaultsUtil.getMobile()!],
            success: {
                data in
                let json = JSON(data!)
                //println("json:\(json)")
                for (_, subJson): (String, JSON) in json {
                    let bcm = BandCarModel()
                    bcm.id = subJson["id"].stringValue
                    bcm.bankCity = subJson["bankCity"].stringValue
                    bcm.bankCity = subJson["bankCity"].stringValue
                    bcm.bankProvince = subJson["bank_province"].stringValue
                    bcm.bankName = subJson["bank_name"].stringValue
                    bcm.bankOpening = subJson["bank_opening"].stringValue
                    bcm.isRecharge = subJson["is_recharge"].stringValue
                    bcm.userId = subJson["user_id"].stringValue
                    bcm.type = subJson["type"].stringValue
                    bcm.cardNo = subJson["card_no"].stringValue
                    bcm.state = subJson["state"].stringValue
                    bcm.realName = subJson["real_name"].stringValue
                    if bcm.realName.isEmpty {
                        bcm.realName = "未认证"
                    }
                    bandCardRecordData.append(bcm)
                }
                calback(data:bandCardRecordData)
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
    
    //修改默认银行卡
    func updateDefaultBankCard(params:[String : String],calback: (data: AnyObject) -> ()) {
        RestAPI.sendPostRequest(B.BANKCARD_UPDATE_DEFAULT, params: params,
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
    
    //删除银行卡
    func deleteBankCard(params:[String : String],calback: (data: AnyObject) -> ()) {
        RestAPI.sendPostRequest(B.BANKCARD_DELETE, params: params,
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
    
    
    //添加银行卡GET方法
    func addBankCardGet(calback: (data: Any) -> ()) {
        
        RestAPI.sendGETRequest(B.BANKCARD_AUTH, params: [ "mm" : userDefaultsUtil.getMobile()!],
            success: {
                data in
                var json = JSON(data!)
                //print("添加银行卡:\(json)")
                let bc = BandCarModel()
                bc.order = json["order"].stringValue
                bc.idCard = json["idCard"].stringValue
                bc.realName = json["realName"].stringValue
                bc.bankList = json["bankList"].arrayObject!
                bc.hideList = json["hideList"].arrayObject!
                calback(data:bc)
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
    
    //添加银行卡获取订单号
    func bankCardGetOrder(calback: (data: AnyObject) -> ()){
        RestAPI.sendPostRequest(B.BANKCARD_ORDER, params: [:],
            success: {
                data in
                var json = JSON(data!)
                //print("获取订单号:\(json)")
                let mm = MsgModel(msg: json["order"].stringValue, status: json["status"].intValue)
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
    
    
    //添加银行卡
    func addBankCard(params:[String : String],calback: (data: AnyObject) -> ()) {
        RestAPI.sendPostRequest(B.BANKCARD_AUTH, params: params,
            success: {
                data in
                var json = JSON(data!)
                //print("添加银行卡:\(json)")
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
    
    //添加银行卡 获取验证码
    func bankCardGetAuthCode(params:[String : AnyObject], calback: (data: AnyObject) -> ()) {
        RestAPI.sendPostRequest(B.BANKCARD_AUTHCODE, params: params,
            success: {
                data in
                var json = JSON(data!)
                //print("添加银行卡 验证码:\(json)")
                let msg = json["msg"].stringValue
                let token = json["token"].stringValue
                let mm = MsgModel(msg: token, status: json["status"].intValue)
                if !mm.msg.isEmpty {
                    KGXToast.showToastWithMessage(msg, duration: ToastDisplayDuration.LengthShort)
                }
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
    
    //充值 获取验证码
    func getAuthCode(params:[String : AnyObject], calback: (data: AnyObject) -> ()) {
        RestAPI.sendPostRequest(B.RECHARGE_AUTHCODE, params: params,
            success: {
                data in
                var json = JSON(data!)
//                print("充值 验证码:\(json)")
                let status = json["status"].intValue
                let msg = json["msg"].stringValue
                KGXToast.showToastWithMessage(msg, duration: ToastDisplayDuration.LengthShort)
                if status == 1 {
                    let authAcm = RechargeFirstModel()
                    authAcm.token = json["token"].stringValue
                    authAcm.bankCode = json["bankCode"].stringValue
                    calback(data:authAcm)
                }else{
                  calback(data:"\(msg)")
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
    
    //充值检查
    func checkRecharge(params:[String : AnyObject], calback: (data: AnyObject) -> ()){
        RestAPI.sendPostRequest(B.RECHARGE_CHECK, params: params,
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
                    KGXToast.showToastWithMessage(B.NETWORK_CONNECTION_ABNORMAL, duration: ToastDisplayDuration.LengthLongLong)
                default:
                    calback(data:"其他错误")
                    KGXToast.showToastWithMessage("其他错误", duration: ToastDisplayDuration.LengthLong)
                }
            }
        )
    }
    
    
    //提现检查
    func checkWithdraw(params:[String : AnyObject], calback: (data: AnyObject) -> ()){
        RestAPI.sendPostRequest(B.WITHDRAW_CHECK, params: params,
            success: {
                data in
                var json = JSON(data!)
                let status = json["status"].intValue
                let msg = json["msg"].stringValue
                calback(data:MsgModel(msg: msg, status: status))
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
    
    //提现get提交
    func withdrawGet(params:[String : AnyObject], calback: (data: AnyObject) -> ()){
        RestAPI.sendGETRequest(B.HOME_WITHDRAW, params:params,
            success: {
                data in
                var json = JSON(data!)
                //print("提现get:\(json)")
                let model = WithrawModel()
                //model.status = json["kou"].intValue
                model.kou = json["kou"].doubleValue
                model.kouShow = json["kou_show"].stringValue
                model.usableFund = json["usableFund"].stringValue
                model.bankName = json["bankName"].stringValue
                model.bankId = json["bankId"].stringValue
                model.cardNo = json["cardNo"].stringValue
                model.money = json["money"].stringValue
                model.withdrawTotal = json["allWithdraw"].stringValue
//                if model.status == 0 {
//                    model.poundage = 0
//                }else{
//                    model.poundage = 2
//                }
                //dlrm.userId = json["userId"].string!
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
    
    
    //提现post提交
    func withdrawPost(params:[String : AnyObject], calback: (data: AnyObject) -> ()){
        RestAPI.sendPostRequest(B.HOME_WITHDRAW, params: params,
            success: {
                data in
                var json = JSON(data!)
                //print("提现post提交:\(json)")
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
    
    func getAccountMoney(withdrawMoney:String, calback: (data: AnyObject) -> ()){
        RestAPI.sendGETRequest(B.HOME_ACCOUNTMONEY, params:["mm": userDefaultsUtil.getMobile()!, "money": userDefaultsUtil.enTxt(withdrawMoney)],
            success: {
                data in
                var json = JSON(data!)
                //print("获取到账金额get:\(json)")
                let amm = AccountMoneyModel()
                amm.status = json["status"].intValue
                amm.money = json["money"].stringValue
                amm.msg = json["msg"].stringValue
                calback(data:amm)
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
    
    
    //资产分配get
    func totalFundGet(calback: (data: AnyObject) -> ()){
        RestAPI.sendGETRequest(B.ASSEST_TOTALFUNDS, params:["mm": userDefaultsUtil.getMobile()!],
            success: {
                data in
                var json = JSON(data!)
                //println("资产分配json:\(json)")
                let tfm = TotalFundModel()
                tfm.investDayloan = json["investDayloan"].stringValue
                tfm.investDeposit = json["investDeposit"].stringValue
                tfm.investTransfer = json["investTransfer"].stringValue
                tfm.investWjb = json["investWjb"].stringValue
                tfm.investSelf = json["investSelf"].stringValue
                tfm.investJumu = json["investJumu"].stringValue
                tfm.selfStatus = json["selfStatus"].intValue
                calback(data:tfm)
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
    
    
    /**  总资产 **/
    func loadTotalAssestData(calback: (data: String) -> ()) {
        RestAPI.sendGETRequest(B.ASSEST_TOTALFUND, params: ["mm": userDefaultsUtil.getMobile()!],
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
    
    /**  收益分享 **/
    func revenueShareData(calback: (data: String) -> ()) {
        RestAPI.sendGETRequest(B.ASSEST_REVENUE_SHARE, params: ["mm": userDefaultsUtil.getMobile()!],
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
    
    /**  昨日收益详情 **/
    func yesterdayTotalData(calback: (data: String) -> ()) {
        RestAPI.sendGETRequest(B.ASSEST_YESTERDAY_TOTAL, params: ["mm": userDefaultsUtil.getMobile()!],
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
    
    //我的体验金界面数据
    func loadMyExperienceFund(params:[String:AnyObject],calback: (data: AnyObject) -> ()){
        let model = MyExperienceFundMixModel()
        RestAPI.sendGETRequest(B.ASSEST_MY_EXPERIENCE_RECORD, params: params,
            success: {
                data in
                let json = JSON(data!)
//                print("json = \(json)")
                for (_, subJson): (String, JSON) in json["expList"] {
                    model.ableMoney = json["ableMoney"].stringValue
                    model.expList.append(MyExperienceModel(type: subJson["type"].stringValue, created: subJson["created"].stringValue, status: subJson["status"].stringValue, fund: subJson["fund"].stringValue, startData: subJson["startData"].stringValue, closeData: subJson["closeData"].stringValue, days: subJson["days"].stringValue))
                }
                calback(data:model)
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
    
    //体验金记录列表
    func loadExperienceFund(params:[String:AnyObject],calback: (data: AnyObject) -> ()){
        var model = [ExperienceRecordModel]()
        RestAPI.sendGETRequest(B.ASSEST_EXPERIENCE_RECORD, params: params,
            success: {
                data in
                var json = JSON(data!)
                for (_, subJson): (String, JSON) in json["expmoneyList"] {
                    model.append(ExperienceRecordModel(fundflow: subJson["fundflow"].stringValue, fund: subJson["fund"].stringValue, record_time: subJson["record_time"].stringValue))
                }
                calback(data:model)
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
    
    //我的消息记录
    func loadMessageRecord(params:[String:AnyObject],calback: (data: AnyObject) -> ()){
        var model = [MessageRecordModel]()
        RestAPI.sendGETRequest(B.ASSEST_MESSAGE_RECORD, params: params,
            success: {
                data in
                let json = JSON(data!)
                for (_, subJson): (String, JSON) in json {
                    model.append(MessageRecordModel(id: subJson["id"].stringValue, title: subJson["title"].stringValue, content: subJson["content"].stringValue, createtime: subJson["createtime"].stringValue))
                }
                calback(data:model)
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
    
    //消息删除 ASSEST_MESSAGE_DELETE
    func deleteMessageRecord(params:[String:AnyObject],calback: (data: AnyObject) -> ()){
        RestAPI.sendPostRequest(B.ASSEST_MESSAGE_DELETE, params: params,
            success: {
                data in
                var json = JSON(data!)
                let msg = json["msg"].stringValue
                calback(data:msg)
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
    
    /**  收益分享 **/
    func shareStatus(calback: (data: AnyObject) -> ()) {
        RestAPI.sendPostRequest(B.ASSEST_REVENUE_REDPACKET, params: ["mm": userDefaultsUtil.getMobile()!],
            success: {
                data in
                var json = JSON(data!)
                let status = json["status"].intValue
                let msg = json["msg"].stringValue
                calback(data:MsgModel(msg: msg, status: status))
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
    
    /** 自主投资 未确认列表 **/
    func loadAutoNoList(page:String, calback: (data: String) -> ()) {
        RestAPI.sendGETRequest(B.AUTOINVEST_NO_LIST, params: ["mm": userDefaultsUtil.getMobile()!, "page": page],
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
    
    /** 自主投资 已确认列表 **/
    func loadAutoYesList(page:String, calback: (data: String) -> ()) {
        RestAPI.sendGETRequest(B.AUTOINVEST_YES_LIST, params: ["mm": userDefaultsUtil.getMobile()!, "page": page],
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
    
    
    /** 自主投资 购买列表 **/
    func buyAutoInvest(pid:String, calback: (data: String) -> ()) {
        RestAPI.sendPostRequest(B.AUTOINVEST_BUY, params: ["mm": userDefaultsUtil.getMobile()!, "trade_id": pid],
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
    
    
    //加载昨日收益
    func loadYesterdayIncomeData(calback: (data: Any) -> ()) {
        var yirmData = [YesterdayIncomeRecordModel]()
        RestAPI.sendGETRequest(B.ASSEST_YESTERDAY_INCOME_RECORD, params: [ "mm" : userDefaultsUtil.getMobile()!],
            success: {
                data in
                let json = JSON(data!)
                //println("昨日收益:\(json)")
                for (_, subJson): (String, JSON) in json {
                    let fund = subJson["fund"].stringValue
                    if fund != "0.00" {
                        let yirm = YesterdayIncomeRecordModel()
                        yirm.name = subJson["name"].stringValue
                        yirm.fund = subJson["fund"].stringValue
                        yirm.time = subJson["time"].stringValue
                        yirmData.append(yirm)
                    }
                }
                calback(data:yirmData)
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
    
    //加载累计收益
    func loadTotalIncomeData(currentPage:Int, calback: (data: Any) -> ()) {
        var yirmData = [YesterdayIncomeRecordModel]()
        RestAPI.sendGETRequest(B.ASSEST_TOTAL_INCOME_RECORD, params: [ "mm" : userDefaultsUtil.getMobile()!,"page" :currentPage],
            success: {
                data in
                let json = JSON(data!)
                //println("累计收益:\(json)")
                for (_, subJson): (String, JSON) in json {
                    let yirm = YesterdayIncomeRecordModel()
                    yirm.name = subJson["name"].stringValue
                    yirm.fund = subJson["fund"].stringValue
                    yirm.time = subJson["time"].stringValue
                    yirmData.append(yirm)

                }
                calback(data:yirmData)
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
    
    //加载充值记录
    func loadRechargeData(currentPage:Int, calback: (data: Any) -> ()) {
        var rrmData = [RechargeRecordModel]()
        RestAPI.sendGETRequest(B.ASSEST_RECHARGE_RECORD, params: [ "mm" : userDefaultsUtil.getMobile()!,"page" :currentPage],
            success: {
                data in
                var json = JSON(data!)
                //println("充值记录:\(json)")
                for (_, subJson): (String, JSON) in json["dataList"] {
                    let rrm = RechargeRecordModel()
                    rrm.fund = subJson["fund"].stringValue
                    rrm.time = subJson["time"].stringValue
                    rrmData.append(rrm)
                }
                calback(data:rrmData)
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
    
    //加载提现记录
    func loadWithdrawData(currentPage:Int, calback: (data: Any) -> ()) {
        var wrmData = [WithdrawRecordModel]()
        RestAPI.sendGETRequest(B.ASSEST_WITHDRAW_RECORD, params: [ "mm" : userDefaultsUtil.getMobile()!,"page" :currentPage],
            success: {
                data in
                var json = JSON(data!)
                //println("提现记录:\(json)")
                for (_, subJson): (String, JSON) in json["dataList"] {
                    let wrm = WithdrawRecordModel()
                    wrm.fund = subJson["fund"].stringValue
                    wrm.time = subJson["time"].stringValue
                    wrm.fee = subJson["fee"].stringValue
                    wrm.bank = subJson["bank"].stringValue
                    wrmData.append(wrm)
                }
                calback(data:wrmData)
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
    
    //冻结记录
    func loadDongJieData(calback: (data: AnyObject) -> ()) {
        let dongjieMixModel = DongJieMixModel()
        RestAPI.sendGETRequest(B.ASSEST_DONGJIE_RECORD, params: [ "mm" : userDefaultsUtil.getMobile()!],
            success: {
                data in
                var json = JSON(data!)
                //println("冻结记录:\(json)")
                dongjieMixModel.total = json["total"].stringValue
                for (_, subJson): (String, JSON) in json["dataList"] {
                    dongjieMixModel.dataList.append(DongjieModel(name: subJson["name"].stringValue, fund: subJson["fund"].stringValue, time: subJson["time"].stringValue))
                }
                calback(data:dongjieMixModel)
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

    
    
    class func getInstance() -> AssestService{
        struct Singleton{
            static var predicate:dispatch_once_t = 0
            static var instance:AssestService? = nil
        }
        dispatch_once(&Singleton.predicate,{
            Singleton.instance=AssestService()
            }
        )
        return Singleton.instance!
    }
    
    
}