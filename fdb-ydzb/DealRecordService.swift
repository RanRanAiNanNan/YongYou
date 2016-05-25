//
//  DealRecordService.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/2/12.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DealRecordService: NSObject {
    
    //活期宝记录
    func loadDataDayloanGet(params:[String:String], calback: (data: Any) -> ()) {
        let model = CurrentMixModel()
        RestAPI.sendGETRequest(B.USERCENTER_FUNDRECORD_DAYLOAN, params: params,
            success: {
                data in
                var json = JSON(data!)
                model.investDayloan = json["investDayloan"].stringValue
                model.yeterdayIncome = json["yesterdayIncome"].stringValue
                model.incomeDayload = json["incomeDayloan"].stringValue
                for (_, subJson): (String, JSON) in json["dataList"] {
                    model.dataList.append(CurrentRecordModel(names: subJson["names"].stringValue, fund: subJson["fund"].stringValue, buy_time: subJson["buy_time"].stringValue))
                }
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
    
    //定存记录列表详情
    func loadDataDepositeRecordDetail(params:[String:AnyObject], calback: (data: Any) -> ()) {
        let model = DepositeInterestMixModel()
        RestAPI.sendGETRequest(B.YDLC_DEPOSIT_RECORD_DETAIL, params: params,
            success: {
                data in
                var json = JSON(data!)
                //println("json = \(json)")
                model.buyTime = json["buy_time"].stringValue
                model.buyFund = json["buy_fund"].stringValue
                model.experidTime = json["expire_time"].stringValue
                model.predictIncome = json["predict_income"].stringValue
                model.productName = json["product_name"].stringValue
                model.productIncome = json["interest_fund"].stringValue
                
                for (_, subJson): (String, JSON) in json["refund"] {
                    model.dataList.append(DepositInterestModel(fund: subJson["fund"].stringValue, status: subJson["state"].stringValue, name: subJson["account_id"].stringValue, date: subJson["refund_time"].stringValue))
                }
                
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

    
    //定存记录列表
    func loadDataDepositeRecordGet(params:[String:AnyObject], calback: (data: Any) -> ()) {
        var array = [DepositRecordModel]()
        RestAPI.sendGETRequest(B.YDLC_DEPOSIT_RECORD, params: params,
            success: {
                data in
                var json = JSON(data!)
                for (_, subJson): (String, JSON) in json["depositList"] {
                    array.append(DepositRecordModel(id: subJson["id"].stringValue, names: subJson["names"].stringValue, fund: subJson["fund"].stringValue, buy_time: subJson["buy_time"].stringValue, type: subJson["type"].stringValue))
                }
                calback(data:array)
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
    
    //定存宝已购产品列表
    func loadDataDepositeGet(currentPage:Int, calback: (data: Any) -> ()) {
        let depositeMixModel = DepositeMixModel()
        RestAPI.sendGETRequest(B.YDLC_DEPOSIT_LISTS, params: ["page" : currentPage, "mm" : userDefaultsUtil.getMobile()!],
            success: {
                data in
                var json = JSON(data!)
                //print("json = \(json)")
                depositeMixModel.buyFund = json["buyFund"].stringValue
                depositeMixModel.predictIncome = json["predictIncome"].stringValue
                depositeMixModel.depositIncome = json["depositIncome"].stringValue
                for (_, subJson): (String, JSON) in json["deposit_list"] {
                    depositeMixModel.dealRecordList.append(DepositProductRecord(surplusDays: subJson["surplusDays"].stringValue, isMode: subJson["isMode"].stringValue, status: subJson["status"].stringValue, id: subJson["id"].stringValue, productName: subJson["productName"].stringValue, buyFund: subJson["buyFund"].stringValue, predictIncome: subJson["predictIncome"].stringValue, interestFund: subJson["interestFund"].stringValue, buyTime: subJson["buyTime"].stringValue, expireTime: subJson["expireTime"].stringValue, transCount: subJson["transCount"].stringValue, apr: subJson["apr"].stringValue, vipApr: subJson["vip_apr"].stringValue, grandApr: subJson["grand_apr"].stringValue))
                }
                calback(data:depositeMixModel)
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
    
    //定存产品全部已购列表
    func loadDataDepositeBoughtProduct(currentPage:Int, calback: (data: Any) -> ()) {
        let depositeMixModel = DepositeMixModel()
        RestAPI.sendGETRequest(B.YDLC_DEPOSIT_WHOLE, params: ["page" : currentPage, "mm" : userDefaultsUtil.getMobile()!],
            success: {
                data in
                var json = JSON(data!)
                //print("定存宝已购:\(json)")
                depositeMixModel.buyFund = json["buyFund"].stringValue
                depositeMixModel.predictIncome = json["predictIncome"].stringValue
                depositeMixModel.depositIncome = json["depositIncome"].stringValue
                for (_, subJson): (String, JSON) in json["deposit_list"] {
                    depositeMixModel.dealRecordList.append(DepositProductRecord(surplusDays: subJson["surplusDays"].stringValue, isMode: subJson["isMode"].stringValue, status: subJson["status"].stringValue, id: subJson["id"].stringValue, productName: subJson["productName"].stringValue, buyFund: subJson["buyFund"].stringValue, predictIncome: subJson["predictIncome"].stringValue, interestFund: subJson["interestFund"].stringValue, buyTime: subJson["buyTime"].stringValue, expireTime: subJson["expireTime"].stringValue, transCount: subJson["transCount"].stringValue, apr: subJson["apr"].stringValue, vipApr: subJson["vip_apr"].stringValue, grandApr: subJson["grand_apr"].stringValue))
                }
                calback(data:depositeMixModel)
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
    
    //债权转让记录
    func loadDataTransferGet(params:[String:AnyObject], calback: (data: Any) -> ()) {
        var transferRecordData = [TransferRecordModel]()
        RestAPI.sendGETRequest(B.YDLC_TRANSFER_RECORD_LIST, params: params,
            success: {
                data in
                var json = JSON(data!)
                for (_, subJson): (String, JSON) in json["transferList"] {
                    transferRecordData.append(TransferRecordModel(name: subJson["name"].stringValue, fund: subJson["fund"].stringValue, newinterestFund: subJson["interestFund"].stringValue, buyTime: subJson["buyTime"].stringValue, transferTime: subJson["transferTime"].stringValue))
                }
                calback(data:transferRecordData)
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
    
    //稳进宝记录
    func loadDataStableGet(params:[String:AnyObject], calback: (data: Any) -> ()) {
        let model = StableMixModel()
        RestAPI.sendGETRequest(B.YDLC_STABLE_RECORD_LIST, params: params,
            success: {
                data in
                var json = JSON(data!)
                model.investmentFund = json["total"].stringValue
                model.buyCopies = json["income"].stringValue
                for (_, subJson): (String, JSON) in json["dataList"] {
                    model.stableList.append(StableRecordModel(productName: subJson["productName"].stringValue, status: subJson["status"].stringValue, fund: subJson["copies"].stringValue, btime: subJson["btime"].stringValue, closeDate: subJson["closeDate"].stringValue, apr: subJson["apr"].stringValue, income: subJson["income"].stringValue))
                }
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
    
    class func getInstance() -> DealRecordService{
        struct Singleton{
            static var predicate:dispatch_once_t = 0
            static var instance:DealRecordService? = nil
        }
        dispatch_once(&Singleton.predicate,{
            Singleton.instance=DealRecordService()
            }
        )
        return Singleton.instance!
    }
}