//
//  YdFinancingService.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/3/2.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class YdFinancingService : NSObject {
    
    //实名认证
    func checkIdCard(calback: (data: AnyObject) -> ()) {
        RestAPI.sendPostRequest(B.CHECK_ID_CARD, params: ["mm":userDefaultsUtil.getMobile()!],
            success: {
                data in
                let json = JSON(data!)
                //println("json = \(json)")
                let status = json["status"].intValue
                let m = json["msg"].stringValue
                let model = MsgModel(msg: m, status: status)
                calback(data:model)
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
    
    //加载天标购买首页数据
    func loadDayloanData(calback: (data: AnyObject) -> ()) {
        RestAPI.sendGETRequest(B.YDLC_DAYLOAN_MAIN, params: [ "mm" : userDefaultsUtil.getMobile()!],
            success: {
                data in
                var json = JSON(data!)
//                print("json = \(json)")
                let cbm = CurrentBuyModel()
                cbm.name = json["name"].stringValue
                cbm.interest_rate = json["interest_rate"].floatValue
                cbm.surplus = json["statusName"].stringValue
                cbm.earnings = json["earnings"].stringValue
                cbm.productId = json["productId"].stringValue
                cbm.status = json["status"].stringValue
                cbm.vipApr = json["vipApr"].stringValue
                cbm.compositeApr = json["compositeApr"].floatValue
                calback(data:cbm)
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
    
    //加载定存购买首页数据
    func loadDepositData(calback: (data: AnyObject) -> ()) {
        RestAPI.sendGETRequest(B.YDLC_DEPOSIT_MAIN, params: [ "mm" : userDefaultsUtil.getMobile()!],
            success: {
                data in
                let json = JSON(data!)
                //print("定存:\(json)")
                var plist = [DepositProductModel]()
                let productList: Array<JSON> = json.arrayValue
                for i in 0..<productList.count {
                    let dpm = DepositProductModel()
                    dpm.name = productList[i]["name"].stringValue
                    dpm.productId = productList[i]["prodcutId"].stringValue
                    dpm.surplus = productList[i]["surplus"].stringValue
                    dpm.interest_rate = productList[i]["interest_rate"].floatValue
                    dpm.vipApr = productList[i]["vipApr"].stringValue
                    plist.append(dpm)
                }
                calback(data:plist)
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
    
    //加载天标购买页面数据
    func dayloanBuy(productId: String,calback: (data: AnyObject) -> ()){
        RestAPI.sendGETRequest(B.YDLC_DAYLOAN_BUY, params: [ "mm" : userDefaultsUtil.getMobile()!,"product_id" : productId],
            success: {
                data in
                var json = JSON(data!)
                //println("json = \(json)")
                let dlbm = DayLoanBuyModel()
                dlbm.userExpmoney = json["userExpmoney"].stringValue
                dlbm.usableFund = json["usableFund"].stringValue
                dlbm.surplus = json["surplus"].stringValue
                dlbm.productId = json["productId"].stringValue
                dlbm.redpacketStatus = json["redpacket"].intValue
                dlbm.redMsg = json["msg"].stringValue
                dlbm.remark = json["remarks"].stringValue
                dlbm.quota = json["quota"].stringValue
                dlbm.quotaShow = json["quotaShow"].stringValue
                
                var redpacketlist: [SelectRedpacketModel] = []
                let rpList: Array<JSON> = json["redpacketList"].arrayValue
                for i in 0..<rpList.count {
                    let srp = SelectRedpacketModel()
                    srp.id = rpList[i]["id"].stringValue
                    srp.giveValue = rpList[i]["value"].stringValue
                    srp.typeName = rpList[i]["typeName"].stringValue
                    srp.days = rpList[i]["days"].stringValue
                    redpacketlist.append(srp)
                }
                dlbm.redpacketList = redpacketlist
                calback(data:dlbm)
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
    
    //天标购买提交
    func dayLoanBuyPost(params:[String : AnyObject], calback: (data: AnyObject) -> ()){
        RestAPI.sendPostRequest(B.YDLC_DAYLOAN_BUY, params: params,
            success: {
                data in
                let json = JSON(data!)
                let status = json["status"].intValue
                let m = json["msg"].stringValue
                let model = MsgModel(msg: m, status: status)
                calback(data:model)
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
    
    //天标赎回交易密码判断
    func dayLoanRedeemPwd(calback: (data: AnyObject) -> ()){
        RestAPI.sendPostRequest(B.YDLC_DAYLOAN_REDEEM, params: [ "mm" : userDefaultsUtil.getMobile()!],
            success: {
                data in
                var json = JSON(data!)
                let dlrm = DayLoanRedeemModel()
                dlrm.pwdStatus = json["status"].intValue
                calback(data:dlrm)
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
    
   //天标赎回数据
   func dayLoanRedeemData(calback: (data: AnyObject) -> ()){
        RestAPI.sendGETRequest(B.YDLC_DAYLOAN_OVER, params: [ "mm" : userDefaultsUtil.getMobile()!],
            success: {
                data in
                var json = JSON(data!)
                //println("json = \(json)")
                let dlrm = DayLoanRedeemModel()
                dlrm.remarks = json["remarks"].stringValue
                dlrm.dayloanData = json["dayloan_data"].stringValue
                dlrm.dayloan_money = json["dayloan_money"].stringValue
                calback(data:dlrm)
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
    
    //天标赎回提交
    func dayLoanRedeemPost(params:[String : AnyObject], calback: (data: String) -> ()){
        RestAPI.sendPostRequest(B.YDLC_DAYLOAN_OVER, params: params,
            success: {
                data in
                var json = JSON(data!)
                _ = json["status"].intValue
                let msg = json["msg"].stringValue
                calback(data:"\(msg)")
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
    
    
    //天标预投数据
    func dayLoanPrepayData(calback: (data: AnyObject) -> ()){
        RestAPI.sendGETRequest(B.YDLC_DAYLOAN_PREPAY, params: [ "mm" : userDefaultsUtil.getMobile()!],
            success: {
                data in
                var json = JSON(data!)
                //print("json = \(json)")
                let dlrm = DayLoanPrepayModel()
                dlrm.usableFund = json["usableFund"].stringValue
                dlrm.userExpmoney = json["userExpmoney"].stringValue
                dlrm.remarks = json["remarks"].stringValue
                dlrm.quotaShow = json["quotaShow"].stringValue
                dlrm.quota = json["quota"].intValue
                calback(data:dlrm)
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
    
    
    //天标预投提交
    func dayLoanPrepayPost(params:[String : AnyObject], calback: (data: String) -> ()){
        RestAPI.sendPostRequest(B.YDLC_DAYLOAN_PREPAY, params: params,
            success: {
                data in
                var json = JSON(data!)
                _ = json["status"].intValue
                let msg = json["msg"].stringValue
                calback(data:"\(msg)")
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
    
    
    //定存已购产品详情
    func depositBuyProductDetail(id:String, calback: (data: AnyObject) -> ()){
        RestAPI.sendGETRequest(B.YDLC_DEPOSIT_BUY_PRODUCT_DETAIL, params: ["mm" : userDefaultsUtil.getMobile()! , "id" : id],
            success: {
                data in
                var json = JSON(data!)
//                print("json = \(json)")
                let dbpm = DepositBuyProductsModel()
                dbpm.productName = json["productName"].stringValue
                dbpm.expireTime = json["expireTime"].stringValue
                dbpm.status = json["status"].stringValue
                dbpm.isMode = json["expireMode"].stringValue
                dbpm.buyFund = json["buyFund"].stringValue
                dbpm.buyTime = json["buyTime"].stringValue
                dbpm.predictIncome = json["predictIncome"].stringValue
                dbpm.income_mode = json["incomeMode"].stringValue
                dbpm.allMoney = json["allMoney"].stringValue
                dbpm.feeMoney = json["feeMoney"].stringValue
                dbpm.redpacket = json["redpacket"].stringValue
                dbpm.apr = json["apr"].stringValue
                dbpm.grandApr = json["grand_apr"].stringValue
                dbpm.vipApr = json["vip_apr"].stringValue
                dbpm.interest_fund = json["interest_fund"].stringValue
                dbpm.overMoney = json["overMoney"].stringValue
                dbpm.money = json["money"].stringValue
                
                //手填金额加入的字段
//                dbpm.refundAble = json["refundAble"].stringValue
//                dbpm.formulaAdd = json["formulaAdd"].stringValue
//                dbpm.formulaDiv = json["formulaDiv"].stringValue
//                dbpm.max = json["max"].stringValue
//                dbpm.applyFund = json["applyFund"].stringValue
                
                calback(data:dbpm)
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
    
    //定存结息列表接口
    func depositTradeRecord(params:[String:AnyObject], calback: (data: AnyObject) -> ()) {
        RestAPI.sendGETRequest(B.YDLC_DEPOSIT_TRADE_RECORD, params: params,
            success: {
                data in
                var dimlist = [DepositInterestModel]()
                let json = JSON(data!)
                for (_, subJson): (String, JSON) in json {
                    dimlist.append(DepositInterestModel(fund: subJson["fund"].stringValue, status: subJson["status"].stringValue, name: subJson["name"].stringValue, date: subJson["date"].stringValue))
                }
                calback(data:dimlist)
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
    
    //定存已购产品本金复投
    func depositBuyProductExpireMode(params:[String : AnyObject], calback: (data: String) -> ()){
        RestAPI.sendPostRequest(B.YDLC_DEPOSIT_BUY_PRODUCT_EXPIREMODE, params: params,
            success: {
                data in
                var json = JSON(data!)
                _ = json["status"].intValue
                let msg = json["msg"].stringValue
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
    
    //定存已购产品利息复投
    func depositBuyProductIncomeMode(params:[String : AnyObject], calback: (data: String) -> ()){
        RestAPI.sendPostRequest(B.YDLC_DEPOSIT_BUY_PRODUCT_INCOMEMODE, params: params,
            success: {
                data in
                var json = JSON(data!)
                _ = json["status"].intValue
                let msg = json["msg"].stringValue
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
    
    //定存债权转让
    func depositTransfer(params:[String : AnyObject], calback: (data: AnyObject) -> ()){
        RestAPI.sendPostRequest(B.YDLC_DEPOSIT_TRANSFER, params: params,
            success: {
                data in
                var json = JSON(data!)
                let status = json["status"].intValue
                let msg = json["msg"].stringValue
                let model = MsgModel(msg: msg, status: status)
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
    
    //债权转让列表
    func transferList(params: [String:AnyObject],calback: (data: AnyObject) -> ()) {
        RestAPI.sendGETRequest(B.YDLC_DEPOSIT_OVER, params: params,
            success: {
                data in
                let modelMix = TransferBuyMixModel()
                let json = JSON(data!)
//                print("\(json)")
                
                //moneyArr
                let moneyJson = json["moneyArr"].dictionaryValue
                for (key,value) in moneyJson {
                    let valueArr = value.arrayObject!
                    modelMix.moneyArr[key] = valueArr
                }
                
                //datalist
                for (_, subJson): (String, JSON) in json["dataList"] {
                    let tbm = TransferBuyModel()
                    tbm.id = subJson["id"].stringValue
                    tbm.name = subJson["name"].stringValue
                    tbm.buyTime = subJson["buyTime"].stringValue
                    tbm.newApr = subJson["newApr"].stringValue
                    tbm.buyFund = subJson["buyFund"].stringValue
                    tbm.predictIncome = subJson["predictIncome"].stringValue
                    tbm.expireTime = subJson["expireTime"].stringValue
                    tbm.available = subJson["available"].stringValue
                    modelMix.dataList.append(tbm)
                }
                calback(data:modelMix)
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
    
    //债权转让列表购买
    func transferListBuy(id: String,calback: (data: AnyObject) -> ()) {
        RestAPI.sendPostRequest(B.YDLC_DEPOSIT_TRANSFER_BUY, params: [ "mm" : userDefaultsUtil.getMobile()!,"account_id":id],
            success: {
                data in
                let json = JSON(data!)
                let status = json["status"].intValue
                let m = json["msg"].stringValue
                let model = MsgModel(msg: m, status: status)
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
    
    //加载定存购买页面数据
    func depositBuy(params:[String : AnyObject], calback: (data: AnyObject) -> ()){
//        print("\(params)")
        RestAPI.sendGETRequest(B.YDLC_DEPOSIT_BUY, params: params,
            success: {
                data in
                var json = JSON(data!)
//                print("json = \(json)")
                let dbm = DepositBuyModel()
                dbm.usableFund = json["usableFund"].stringValue
                dbm.productId = json["productId"].stringValue
                dbm.redpacketStatus = json["redpacket"].intValue
                dbm.productApr = json["apr"].stringValue
                dbm.remainingCopies = json["surplus"].stringValue
                dbm.days = json["days"].stringValue
                dbm.remarks = json["remarks"].stringValue
                dbm.deadline = json["deadline"].stringValue
                dbm.msg = json["msg"].stringValue
                dbm.vipApr = json["vipApr"].stringValue
                dbm.redpacketName = json["redpacketName"].stringValue
                dbm.redpacketApr = json["redpacketApr"].stringValue
                
                var redpacketlist: [BuyRedpacketModel] = []
                let rpList: Array<JSON> = json["redpacket"].arrayValue
                for i in 0..<rpList.count {
                    let srp = BuyRedpacketModel()
                    srp.id = rpList[i]["id"].stringValue
                    srp.getTime = rpList[i]["getTime"].stringValue
                    srp.useFinishTime = rpList[i]["useFinishTime"].stringValue
                    srp.name = rpList[i]["name"].stringValue
                    srp.giveValue = rpList[i]["giveValue"].stringValue
                    srp.productType = rpList[i]["productType"].stringValue
                    redpacketlist.append(srp)
                }
                dbm.redpacketList = redpacketlist
                calback(data:dbm)
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
    
    
    //定存购买提交
    func depositBuyPost(params:[String : AnyObject], calback: (data: AnyObject) -> ()){
        RestAPI.sendPostRequest(B.YDLC_DEPOSIT_BUY, params: params,
            success: {
                data in
                let json = JSON(data!)
                let status = json["status"].intValue
                let msg = json["msg"].stringValue
                let model = MsgModel(msg: msg, status: status)
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
    
    //活期查看往期
    func loadDayLoanSeeBefore(params:[String : String], calback: (data: String) -> ()) {
        RestAPI.sendGETRequest(B.YDZLC_DAYLOAN_SEEBEFORE, params: params,
            success: {
                data in
                let json = JSON(data!)
                //println("json:\(json)")
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
    
    //上期记录
    func loadCurrentPeriod(params:[String : String], calback: (data: String) -> ()) {
        RestAPI.sendGETRequest(B.YDZLC_DAYLOAN_CURRENTPERIOD, params: params,
            success: {
                data in
                let json = JSON(data!)
                //println("json:\(json)")
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
    
    class func getInstance() -> YdFinancingService {
        struct Singleton{
            static var predicate:dispatch_once_t = 0
            static var instance:YdFinancingService? = nil
        }
        dispatch_once(&Singleton.predicate,{
            Singleton.instance=YdFinancingService()
            }
        )
        return Singleton.instance!
    }
}