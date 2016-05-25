//
//  LoginService.swift
//  ydzbApp
//
//  Created by 刘驰 on 15/1/21.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CryptoSwift



class LoginService: NSObject {
    
    //登录判断
    func login(mobile: String, password: String,calback: (data: String) -> ()) {

        let str = "userName=" + mobile + "&" + "passwd=" + password + "&" + "key=" + "3e9bb86c6980c3b79e5b936ce10b9b96"
        let hash = str.sha256()
        RestAPI.sendPostRequest("/login/login", params: ["userName": mobile,"passwd":password,"sign":hash],
            success: {
                data in
                var json = JSON(data!)
                let status = json["isSuccess"]
                var errors  = json["errors"]
                if status == true {
                    userDefaultsUtil.setZhangHao(mobile)
                    userDefaultsUtil.setUid(errors.object.objectAtIndex(0) as! String)
//                    errors = ""
                    userDefaults.setObject(true, forKey: KeyLoggedIn)
                    userDefaultsUtil.setMobile(mobile)
                    
                    print("%%%%%%%%%%%%%%%%\(userDefaultsUtil.getMobile())")
                    calback(data:"aa")
                }else{
                    calback(data:"adddddddd")
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
    //注册
    func regist(mobile: String, password: String,referMobile:String,verifyCode:String,calback: (data: String) -> ()){
        print(referMobile)
        if referMobile != ""{
            if !RegexUtil("^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$").test(referMobile){
            KGXToast.showToastWithMessage("推荐人手机号格式错误", duration: ToastDisplayDuration.LengthShort)
            }else{
            let str = "mobile=" + mobile + "&" + "passwd=" + password + "&" + "referMobile=" + referMobile + "&" + "verifyCode=" + verifyCode + "&" + "key=" + "3e9bb86c6980c3b79e5b936ce10b9b96"
            let hash = str.sha256()
            print(hash)
            RestAPI.sendPostRequest("/login/regist", params: ["mobile": mobile,"passwd":password,"referMobile":referMobile,"verifyCode":verifyCode,"sign":hash],
                success: {
                    data in
                    var json = JSON(data!)
                    print(json)
                    let status = json["isSuccess"]
                    let errors  = json["errors"]
                    if status == false {
                        KGXToast.showToastWithMessage(errors[0].stringValue, duration: ToastDisplayDuration.LengthShort)
                        calback(data:"失败")
                    }else{
                        KGXToast.showToastWithMessage("注册成功", duration: ToastDisplayDuration.LengthShort)
                        userDefaultsUtil.setUid(errors.object.objectAtIndex(0) as! String)
                        userDefaults.setObject(true, forKey: KeyLoggedIn)
                        userDefaultsUtil.setMobile(mobile)
                        userDefaultsUtil.setZhangHao(mobile)
                        print("%%%%%%%%%%%%%%%%\(userDefaultsUtil.getMobile())")
                        calback(data:"成功")
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
        }else{
        
        
        let str = "mobile=" + mobile + "&" + "passwd=" + password + "&" + "verifyCode=" + verifyCode + "&" + "key=" + "3e9bb86c6980c3b79e5b936ce10b9b96"
        let hash = str.sha256()
        print(hash)
        RestAPI.sendPostRequest("/login/regist", params: ["mobile": mobile,"passwd":password,"verifyCode":verifyCode,"sign":hash],
            success: {
                data in
                var json = JSON(data!)
                print(json)
                let status = json["isSuccess"]
                let errors  = json["errors"]
                if status == false {
                    KGXToast.showToastWithMessage(json["errors"][0].stringValue, duration: ToastDisplayDuration.LengthShort)
                    calback(data:"失败")
                }else{
                    KGXToast.showToastWithMessage("注册成功", duration: ToastDisplayDuration.LengthShort)
                        userDefaultsUtil.setUid(errors.object.objectAtIndex(0) as! String)
                        userDefaults.setObject(true, forKey: KeyLoggedIn)
                        userDefaultsUtil.setMobile(mobile)
                        userDefaultsUtil.setZhangHao(mobile)
                        print("%%%%%%%%%%%%%%%%\(userDefaultsUtil.getMobile())")
              
                    calback(data:"成功")
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
    
    //获取验证码
    func huoQuYanZhengMa(mobile: String, flag: String,codeType: String,calback: (data: String) -> ()) {

        let str = "mobile=" + mobile + "&" + "flag=" + flag + "&" + "codeType=" + codeType + "&" + "key=" + "3e9bb86c6980c3b79e5b936ce10b9b96"
        let hash = str.sha256()

        RestAPI.sendPostRequest("/login/sendVerifyCode", params: ["mobile": mobile,"flag":flag,"codeType":codeType,"sign":hash],
            success: {
                data in
                var json = JSON(data!)
                let status = json["isSuccess"]
                print(json)
//                KGXToast.showToastWithMessage(json["errors"][0].stringValue, duration: ToastDisplayDuration.LengthShort)
                if status == true{
               
                    if json["errors"][0].stringValue == "error"{
                    KGXToast.showToastWithMessage("手机号已存在", duration: ToastDisplayDuration.LengthShort)
                         calback(data:"失败")
                    }else{
                    KGXToast.showToastWithMessage(json["errors"][0].stringValue, duration: ToastDisplayDuration.LengthShort)
                         calback(data:"成功")
                    }
                }else{
//                   KGXToast.showToastWithMessage(json["errors"][0].stringValue, duration: ToastDisplayDuration.LengthShort)
                    calback(data:"失败")
                }
                print(json)
                
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
    //忘记密码获取验证码
    func wanghuoQuYanZhengMa(mobile: String, flag: String,codeType: String,calback: (data: String) -> ()) {
        
        let str = "mobile=" + mobile + "&" + "flag=" + flag + "&" + "codeType=" + codeType + "&" + "key=" + "3e9bb86c6980c3b79e5b936ce10b9b96"
        let hash = str.sha256()
        
        RestAPI.sendPostRequest("/login/sendVerifyCode", params: ["mobile": mobile,"flag":flag,"codeType":codeType,"sign":hash],
            success: {
                data in
                var json = JSON(data!)
                let status = json["isSuccess"]
                print(json)
                //                KGXToast.showToastWithMessage(json["errors"][0].stringValue, duration: ToastDisplayDuration.LengthShort)
                if status == true{
                    
                    if json["errors"][0].stringValue == "error"{
                        KGXToast.showToastWithMessage("手机号不存在", duration: ToastDisplayDuration.LengthShort)
                        calback(data:"失败")
                    }else{
                        KGXToast.showToastWithMessage(json["errors"][0].stringValue, duration: ToastDisplayDuration.LengthShort)
                        calback(data:"成功")
                    }
                }else{
                    //                   KGXToast.showToastWithMessage(json["errors"][0].stringValue, duration: ToastDisplayDuration.LengthShort)
                    calback(data:"失败")
                }
                print(json)
                
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

//忘记密码
    func wangJiMiMa(mobile: String, verifyCode: String,passwd: String,calback: (data: String) -> ()) {
        
        let str = "mobile=" + mobile + "&" + "verifyCode=" + verifyCode + "&" + "passwd=" + passwd + "&" + "key=" + "3e9bb86c6980c3b79e5b936ce10b9b96"
        let hash = str.sha256()
        print(mobile)
        print(verifyCode)
        print(passwd)
        print(hash)
        RestAPI.sendPostRequest("/login/resetPwd", params: ["mobile": mobile,"verifyCode":verifyCode,"passwd":passwd,"sign":hash],
            success: {
                data in
                var json = JSON(data!)
                print(json)
                KGXToast.showToastWithMessage(json["errors"][0].stringValue, duration: ToastDisplayDuration.LengthShort)
                calback(data:json["errors"][0].stringValue)
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

    
    
    class func getInstance() -> LoginService{
        struct Singleton{
            static var predicate:dispatch_once_t = 0
            static var instance:LoginService? = nil
        }
        dispatch_once(&Singleton.predicate,{
            Singleton.instance = LoginService()
            }
        )
        return Singleton.instance!
    }
    
//    func sha256(stringpass : NSString) ->NSString{
    
//        const char *cstr = [stringpass UTF8String];
//        NSData *data = [NSData dataWithBytes:cstr length:stringpass.length];
//        
//        uint8_t digest[CC_SHA256_DIGEST_LENGTH];
//        
//        CC_SHA256(data.bytes,data.length, digest);
//        
//        NSData *da=[[NSData alloc]initWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
//        
//        NSData *str=[GTMBase64 encodeData:da];
//        NSString *output=[[NSString alloc]initWithData:str  encoding:NSUTF8StringEncoding];
//        return output;
        
        
       
        
//    }
    
    
    
    
    
}
