//
//  UserDefaultsUtil.swift
//  ydzbApp
//
//  Created by 刘驰 on 15/1/22.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation



let suiteName = "com.yinduoziben.app"
let KeyUsername = "username"
let KeyMobile = "mobile"
let KeyVip = "vip"
let KeyRcToken = "rcToken"
let KeyLoggedIn = "loggedIn"
let KeyFristLogin = "fristLogin"
let KeyAvatarLink = "avatarLink"
let KeyFinnaceIcon = "finnaceIcon"
let KeyDiscoverIcon = "dicoverIcon"
let KeyFingerprint = "fingerprint"                  //指纹解锁
let keyMessage = "message"
let KeyUid = "uid"
let keyZhangHao = "zhangHao"          //预存账号
let keyTiaoZhuan = "tiaoZhuan"
let userDefaults = NSUserDefaults(suiteName: suiteName)!
let keyTuiSong = "tuiSong"
let key_addrId = "key_addrId"
let ket_orderId = "ket_orderId"

class userDefaultsUtil:NSObject {
    
    //获取用户头像地址
    class func getAvatarLink() -> String? {
        if let al = userDefaults.objectForKey(KeyAvatarLink) as? String {
            return al
        }else{
            return ""
        }
    }
    class func setFingerprint(fingerprint:Bool) {
        userDefaults.setObject(fingerprint, forKey: KeyFingerprint)
    }
    
    class func setVip(vip:String) {
        userDefaults.setObject(vip, forKey: KeyVip)
    }
    //账号
    class func setZhangHao(ZhangHao:String) {
        userDefaults.setObject(ZhangHao, forKey: keyZhangHao)
    }
    //跳转
    class func setTiaoZhuan(ZhangHao:String) {
        userDefaults.setObject(ZhangHao, forKey: keyTiaoZhuan)
    }
    //推送
    class func setTuiSong(ZhangHao:String) {
        userDefaults.setObject(ZhangHao, forKey: keyTuiSong)
        
    }

    class func setAvatarLink(avatarLink:String) {
        userDefaults.setObject(avatarLink, forKey: KeyAvatarLink)
    }
    
    class func setUserName(userName:String) {
        userDefaults.setObject(userName, forKey: KeyUsername)
    }
    
    class func setMobile(mobile:String) {
        userDefaults.setObject(mobile, forKey: KeyMobile)
    }
    class func setUid(uid:String) {
        userDefaults.setObject(uid, forKey: KeyUid)
    }

    class func setRcToken(rcToken:String) {
        userDefaults.setObject(rcToken, forKey: KeyRcToken)
    }
    
    class func setFinnaceIconkey(financeIconKey: String) {
        userDefaults.setObject(financeIconKey, forKey: KeyFinnaceIcon)
    }
    
    class func setDiscoverIconKey(discoverIconKey: String) {
        userDefaults.setObject(discoverIconKey, forKey: KeyDiscoverIcon)
    }
    //推送
    class func setNotificationMessageKey(messageKey: String) {
        userDefaults.setObject(messageKey, forKey: keyMessage)
    }
    //忘记手势密码
    class func setForgetGesturePassword(Password: String) {
        userDefaults.setObject(Password, forKey: keyMessage)
    }
//ket_orderId
    class func setket_orderId(Password: String) {
        userDefaults.setObject(Password, forKey: ket_orderId)
    }
    class func setkey_addrId(Password: String) {
        userDefaults.setObject(Password, forKey: key_addrId)
    }
    class func enMobile(mobile:String) ->String {
        let mm = AESCrypt.encrypt(mobile, password: B.MOBILE_ENCRYPT_STR).base64Encoded()
        if mm.isEmpty {
            return ""
        }else{
            return mm
        }
    }
    
    //加密文本
    class func enTxt(txt:String) ->String {
        let enTxt = AESCrypt.encrypt(txt, password: B.MOBILE_ENCRYPT_STR).base64Encoded()
        if enTxt.isEmpty {
            return ""
        }else{
            return enTxt
        }
    }
    
    class func deMm(mm:String) ->String {
        let mobile = AESCrypt.decrypt(mm.base64Decoded(), password: B.MOBILE_ENCRYPT_STR)
        if mobile.isEmpty {
            return ""
        }else{
            return mobile
        }
    }
    
    class func showMobile() ->String {
        let mm = getMobile()!
        let mobile = deMm(mm)
        if mobile.isEmpty {
            return ""
        }else{
            return mobile
        }
    }
    //忘记手势密码
    class func getForgetGesturePassword() -> String? {
        return userDefaults.objectForKey(keyMessage) as? String
    }

    
    //获取用户名称
    class func getRcToken() -> String? {
        return userDefaults.objectForKey(KeyRcToken) as? String
    }
    //推送
    class func getMessage() -> String? {
        return userDefaults.objectForKey(keyMessage) as? String
    }
    //我的推送
    class func getTuiSong() -> String? {
//        return userDefaults.objectForKey(keyTuiSong) as? String
        if let al = userDefaults.objectForKey(keyTuiSong) as? String {
            return al
        }else{
            return ""
        }

    }
//ket_orderId
    class func getket_orderId() -> String? {
        //        return userDefaults.objectForKey(keyZhangHao) as? String
        if let al = userDefaults.objectForKey(ket_orderId) as? String {
            return al
        }else{
            return ""
        }
        
    }
    class func getkey_addrId() -> String? {
        //        return userDefaults.objectForKey(keyZhangHao) as? String
        if let al = userDefaults.objectForKey(key_addrId) as? String {
            return al
        }else{
            return ""
        }
        
    }

    //账号
    class func getZhangHao() -> String? {
//        return userDefaults.objectForKey(keyZhangHao) as? String
        if let al = userDefaults.objectForKey(keyZhangHao) as? String {
            return al
        }else{
            return ""
        }

    }

    //获取用户名称
    class func getMobile() -> String? {
        if let al = userDefaults.objectForKey(KeyMobile) as? String {
            return al
        }else{
            return ""
        }
    }
    //获取uid
    class func getUid() -> String? {
        if let al = userDefaults.objectForKey(KeyUid) as? String {
            return al
        }else{
            return ""
        }
    }

    
    //获取用户名称
    class func getUsername() -> String? {
        if let al = userDefaults.objectForKey(KeyUsername) as? String {
            return al
        }else{
            return ""
        }
    }
    //跳转
    class func getTiaoZhuan() -> String? {
        if let al = userDefaults.objectForKey(keyTiaoZhuan) as? String {
            return al
        }else{
            return ""
        }
    }

    /** vip 0为普通用户，1为vip,2为vip2 **/
    class func getVip() -> String {
        if let al = userDefaults.objectForKey(KeyVip) as? String {
            return al
        }else{
            return ""
        }
    }
    
    //获取用户 finnace key
    class func getFinnaceKey() -> String {
        if let key = userDefaults.objectForKey(KeyFinnaceIcon) as? String {
            return key
        } else {
            return ""
        }
    }
    
    //获取用户 discover key
    class func getDiscoverKey() -> String {
        if let key = userDefaults.objectForKey(KeyDiscoverIcon) as? String {
            return key
        } else {
            return ""
        }
    }
    
    //获取用户是否登录
    class func isLoggedIn() -> Bool {
        if let loggedIn = userDefaults.objectForKey(KeyLoggedIn) as? Bool {
            return loggedIn
        }
        return false
    }
    
    //获取用户是否登录
    class func isFirstLogged() -> Bool {
        if let fristLogin = userDefaults.objectForKey(KeyFristLogin) as? Bool {
            return fristLogin
        }
        return true
    }
    
    //获取用户是否开启指纹解锁
    class func getFingerprint() -> Bool {
        if let key = userDefaults.objectForKey(KeyFingerprint) as? Bool {
            return key
        } else {
            return false
        }
    }
    
    class func setFirstLogged() {
        userDefaults.setObject(false, forKey: KeyFristLogin)
    }
    
    //登录成功设置
    class func loginSuccessSetting(username:String, mobile:String, vip:Bool, rcToken:String, avatar:String){
        userDefaults.setObject(username, forKey: KeyUsername)
        userDefaults.setObject(mobile, forKey: KeyMobile)
        userDefaults.setObject(vip, forKey: KeyVip)
        userDefaults.setObject(rcToken, forKey: KeyRcToken)
        userDefaults.setObject(avatar, forKey: KeyAvatarLink)
        userDefaults.setObject(true, forKey: KeyLoggedIn)
    }
    //退出设置
    class func exitSetting(){
        userDefaults.setObject(nil, forKey: KeyUsername)
//        userDefaults.setObject(nil, forKey: KeyMobile)
        userDefaults.setObject(nil, forKey: KeyAvatarLink)
        userDefaults.setObject(false, forKey: KeyLoggedIn)
        userDefaults.setObject(false, forKey: KeyVip)
        userDefaults.setObject(nil, forKey: KeyRcToken)
        userDefaults.setObject(nil, forKey: KeyFinnaceIcon)
        userDefaults.setObject(nil, forKey: KeyDiscoverIcon)
        userDefaults.setObject(nil, forKey: KeyUid)
        //设置原始头像
        PhotoUtils.saveImage(UIImage(named:"Avatar@2x(1)")!)
    }
    
    class func deviceOS() -> Double {
        return (UIDevice.currentDevice().systemVersion as NSString).doubleValue
    }
    
}
