//
//  UserSafetyInfoService.swift
//  ydzbapp-hybrid
//
//  Created by yinduo-zdy on 15/2/9.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import LocalAuthentication

class UserSafetyInfoService {
    /** 加载用户银行卡信息 **/
    func loadBankInfoGet(calback: (data: AnyObject) -> ()){
        RestAPI.sendGETRequest("Safety/getBankData", params: [ "mm" : userDefaultsUtil.getMobile()!],
            success: {
                data in
                var json = JSON(data!)
                let ubcm = UserBankCardModel()
                ubcm.bankCardNumber = json["bankCardNumber"].stringValue
                ubcm.bankName = json["bankName"].stringValue
                ubcm.bankProvince = json["bankProvince"].stringValue
                ubcm.bankCity = json["bankCity"].stringValue
                ubcm.openingBank = json["openingBank"].stringValue
//                ubcm.realName = json["realName"].stringValue
//                ubcm.cardId = json["cardId"].stringValue
                calback(data:ubcm)
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
    
    
    func loadUserSaftyInfo(calback: (data: AnyObject) -> ()){

        RestAPI.sendGETRequest(B.SAFECENTER_INDEX, params: ["mm":userDefaultsUtil.getMobile()!],
            success: {
                data in
                var subjson = JSON(data!)
                //print("安全中心:\(subjson)")
                var keylist:[String];
                var valulist:[String];
       
                //var password :String = "已设置并加密"
                var bankCardNumber :String = subjson["bank"].stringValue
                let realName = subjson["name"].stringValue
                
                if(bankCardNumber=="0"){
                    bankCardNumber = "未绑定"
                }else{
                    bankCardNumber = "已绑定"
                }
                var idCard :String = subjson["idCard"].stringValue;
                if(idCard=="0"){
                    idCard = "未认证"
                }else{
//                    let qian:String = (idCard as NSString).substringToIndex(3);
//                    let hou:String = (idCard as NSString).substringFromIndex(15);
//                    idCard = qian+"***"+hou;
                    idCard = realName
                }
                let payPassword_int = subjson["payPassword"].stringValue;
                var payPassword:String;
                
                if(payPassword_int == "0"){
                    payPassword = "未设置"
                }else{
                    payPassword = "已设置并加密"
                }
                //手势解锁
                let gp = KeychainWrapper.stringForKey(kSecValueData as String)
                var gpText = "未设置"
                if( gp == "" || gp == nil){
                    gpText = "未设置"
                }else{
                    gpText = "已设置"
                }
                
                //紧急联系人
                var emergencyContacts = subjson["emergencyContacts"].stringValue
                
                if(emergencyContacts == "0"){
                    emergencyContacts = "未设置"
                }else{
                    emergencyContacts = "已设置"
                }
                
                valulist = ["已设置并加密",bankCardNumber,idCard,payPassword,gpText,emergencyContacts];
                keylist = ["登录密码","银行卡","实名认证","交易密码","修改手势","紧急联系人"]
                
                let context = LAContext()
                var error: NSError?
                //判断设备是否可用指纹(如果用户没录指纹或没开启指纹密码也用不通过)
                if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
                   let fingerprint = userDefaultsUtil.getFingerprint() ? "开启" : "未开启"
                    valulist.append(fingerprint)
                    keylist.append("指纹解锁")
                }else{
                    //判断错误信息中是否不是指纹不可用
                    if error!.code != LAError.TouchIDNotAvailable.rawValue {
                        let fingerprint = userDefaultsUtil.getFingerprint() ? "开启" : "未开启"
                        valulist.append(fingerprint)
                        keylist.append("指纹解锁")
                    }
                }
                
                let datalist:Dictionary = ["keyl":keylist,"val":valulist];
                calback(data:datalist);
            
            }, error: {
                error in
                switch error {
                    case .ConnectionFailed:
                        calback(data:B.NETWORK_CONNECTION_ABNORMAL)
                    default:
                        calback(data:"其他错误")
                }
            })
        
    }
    
    
    //修改用户昵称
    func changeUsername(username:String,cab: (data: String) -> ()){

        RestAPI.sendPostRequest("Safety/username", params: ["mm":userDefaultsUtil.getMobile()!,"username":username],
            success:{
                data in
                var json = JSON(data!)
                let status = json["status"].intValue
                let msg:String = json["msg"].stringValue;
                if status == 1 {
                    //msg = ""
                    userDefaultsUtil.setUserName(username)
                }
                cab(data:"\(msg)");
               //userDefaults.setObject(username, forKey: "nick")
            },error:{
                error in
                switch error {
                case .ConnectionFailed:
                    cab(data:B.NETWORK_CONNECTION_ABNORMAL)
                default:
                    cab(data:"其他错误")
                }
            })
    }
    
    //mark:修改登录密码
    func changeLoginPassword(oldpsw:String,newpsw:String,calback: (data: AnyObject) -> ()){
        
        RestAPI.sendPostRequest("Safety/password", params: ["mm":userDefaultsUtil.getMobile()!,"old_password":oldpsw,"new_password":newpsw],
            
            success:{
                data in
                var json = JSON(data!)
                let status = json["status"].intValue
                let msg = json["msg"].stringValue
                let model = MsgModel(msg: msg, status: status)
                calback(data:model);
                
            },error:{
                error in
                switch error {
                case .ConnectionFailed:
                    calback(data:B.NETWORK_CONNECTION_ABNORMAL)
                default:
                    calback(data:"其他错误")
                }
        })
    }
    
    //判断交易密码状态
    func getPayPasswordStatus(calback: (data: AnyObject) -> ()){
        RestAPI.sendGETRequest("Safety/pay_password", params: ["mm":userDefaultsUtil.getMobile()!],
            success:{
                data in
                var json = JSON(data!)
                let status = json["status"].intValue
                calback(data:"\(status)");
                
            },error:{
                error in
                switch error {
                case .ConnectionFailed:
                    calback(data:B.NETWORK_CONNECTION_ABNORMAL)
                default:
                    calback(data:"其他错误")
                }
        })
    }
    
    //mark:修改/创建交易密码
    func changePayPassword(oldpsw:String,newpsw:String,calback: (data: AnyObject) -> ()){
        
        RestAPI.sendPostRequest("Safety/pay_password", params: ["mm":userDefaultsUtil.getMobile()!,"old_password":oldpsw,"new_password":newpsw],
            
            success:{
                data in
                var json = JSON(data!)
//                println("json = \(json)")
                let status = json["status"].intValue
                let msg: String = json["msg"].stringValue
                let model = MsgModel(msg: msg, status: status)
                calback(data:model)
                
            },error:{
                error in
                switch error {
                case .ConnectionFailed:
                    calback(data:B.NETWORK_CONNECTION_ABNORMAL)
                default:
                    calback(data:"其他错误")
                }
        })
    }
    //mark:实名认证
    func realNameVerify(realname:String,cardno:String,calback: (data: AnyObject) -> ()){

        RestAPI.sendPostRequest("Safety/verify", params: ["mm":userDefaultsUtil.getMobile()!,"real_name":realname,"id_card":cardno],
            
            success:{
                data in
                var json = JSON(data!)
                //println("实名认证:\(json)")
                let status = json["status"].intValue
                let msg = json["msg"].stringValue
                calback(data:MsgModel(msg: msg, status: status));
                
            },error:{
                error in
                switch error {
                case .ConnectionFailed:
                    calback(data:B.NETWORK_CONNECTION_ABNORMAL)
                default:
                    calback(data:"其他错误")
                }
        })
    }
    
    //mark:银行卡
    /********************
    *    神一样的方法     *
    *********************/
    func bindsBankinfo(bank_name:String,opening_bank:String,bank_card_number:String,bank_province:String,bank_city:String,calback: (data: AnyObject) -> ()){
        
        RestAPI.sendPostRequest("Safety/bank", params: ["mm":userDefaultsUtil.getMobile()!,"bank_name":bank_name,"opening_bank":opening_bank,"bank_card_number":bank_card_number,"bank_province":bank_province,"bank_city":bank_city],
            
            success:{
                data in
                var json = JSON(data!)
                _ = json["status"].intValue
                let msg :String = json["msg"].stringValue;
                calback(data:"\(msg)");
                
            },error:{
                error in
                switch error {
                case .ConnectionFailed:
                    calback(data:B.NETWORK_CONNECTION_ABNORMAL)
                default:
                    calback(data:"其他错误")
                }
        })
    }
    
    
    //MARK: 银行列表
    func getBanklist()-> Array<String>{
        let settingPath = NSBundle.mainBundle().pathForResource("banks", ofType: "plist");
        let bankDict:NSDictionary = NSDictionary(contentsOfFile: settingPath!)!;
        let banklist:Array<String> = bankDict["banks"] as! Array<String>;
        
        return banklist;
    
    }
    
    //mark:忘记密码
    func forgetTradePwd(calback: (data: String) -> ()){
        
        RestAPI.sendPostRequest(B.SAFECENTER_TRADEPWD_FORGET, params: ["mm":userDefaultsUtil.getMobile()!],
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
    
    //检查身份是否认证
    func checkRealName(calback: (data: AnyObject) -> ()){
        RestAPI.sendGETRequest("Safety/verify", params: ["mm" : userDefaultsUtil.getMobile()!],
            success: {
                data in
                var json = JSON(data!)
                //println("检查身份认证:\(json)")
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
    
    
    func loadEmergencyContactsGet(calback: (data: AnyObject) -> ()) {
        RestAPI.sendGETRequest(B.SAFECENTER_EMERGENCYCONTACTS, params: ["mm": userDefaultsUtil.getMobile()!],
            success: {
                data in
                var json = JSON(data!)
                //print("紧急联系人:\(json)")
                let ecm = EmergencyContactsModel()
                ecm.contact = json["urgent"].stringValue
                calback(data:ecm)
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
    
    
    //紧急联系人POST
    func emergencyContactsPost(ec:String, calback: (data: AnyObject) -> ()){
        RestAPI.sendPostRequest(B.SAFECENTER_EMERGENCYCONTACTS, params: ["mm": userDefaultsUtil.getMobile()!,"urgent": ec],
            success: {
                data in
                var json = JSON(data!)
                //print("紧急联系人POST:\(json)")
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
    
    
    
    class func getInstance() -> UserSafetyInfoService{
        struct Singleton{
            static var predicate:dispatch_once_t = 0
            static var instance:UserSafetyInfoService? = nil
        }
        dispatch_once(&Singleton.predicate,{
            Singleton.instance = UserSafetyInfoService()
            }
        )
        return Singleton.instance!
    }
}