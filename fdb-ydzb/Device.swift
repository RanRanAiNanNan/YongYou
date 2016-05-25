//
//  Device.swift
//  Device
//
//  Created by Lucas Ortis on 30/10/2015.
//  Copyright © 2015 Ekhoo. All rights reserved.
//

import UIKit

public class Device {
    static private func getVersionCode() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let versionCode: String = String(UTF8String: NSString(bytes: &systemInfo.machine, length: Int(_SYS_NAMELEN), encoding: NSASCIIStringEncoding)!.UTF8String)!
        
        return versionCode
    }
    
    static private func getVersion(code code: String) -> Device_Version {
        switch code {
            /*** iPhone ***/
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":      return Device_Version.iPhone4
        case "iPhone4,1", "iPhone4,2", "iPhone4,3":      return Device_Version.iPhone4S
        case "iPhone5,1", "iPhone5,2":                   return Device_Version.iPhone5
        case "iPhone5,3", "iPhone5,4":                   return Device_Version.iPhone5C
        case "iPhone6,1", "iPhone6,2":                   return Device_Version.iPhone5S
        case "iPhone7,2":                                return Device_Version.iPhone6
        case "iPhone7,1":                                return Device_Version.iPhone6Plus
        case "iPhone8,1":                                return Device_Version.iPhone6S
        case "iPhone8,2":                                return Device_Version.iPhone6SPlus
            
            /*** iPad ***/
        case "iPad1,1":                                  return Device_Version.iPad1
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return Device_Version.iPad2
        case "iPad3,1", "iPad3,2", "iPad3,3":            return Device_Version.iPad3
        case "iPad3,4", "iPad3,5", "iPad3,6":            return Device_Version.iPad4
        case "iPad4,1", "iPad4,2", "iPad4,3":            return Device_Version.iPadAir
        case "iPad5,3", "iPad5,4":                       return Device_Version.iPadAir2
        case "iPad2,5", "iPad2,6", "iPad2,7":            return Device_Version.iPadMini
        case "iPad4,4", "iPad4,5", "iPad4,6":            return Device_Version.iPadMini2
        case "iPad4,7", "iPad4,8", "iPad4,9":            return Device_Version.iPadMini3
        case "iPad5,1", "iPad5,2":                       return Device_Version.iPadMini4
        case "iPad6,7", "iPad6,8":                       return Device_Version.iPadPro
            
            /*** iPod ***/
        case "iPod1,1":                                  return Device_Version.iPodTouch1Gen
        case "iPod2,1":                                  return Device_Version.iPodTouch2Gen
        case "iPod3,1":                                  return Device_Version.iPodTouch3Gen
        case "iPod4,1":                                  return Device_Version.iPodTouch4Gen
        case "iPod5,1":                                  return Device_Version.iPodTouch5Gen
        case "iPod7,1":                                  return Device_Version.iPodTouch6Gen
            
            /*** Simulator ***/
        case "i386", "x86_64":                           return Device_Version.Simulator
            
        default:                                         return Device_Version.Unknown
        }
    }
    
    static private func getType(code code: String) -> Device_Type {
        let versionCode = Device.getVersionCode()
        
        switch versionCode {
        case "iPhone3,1", "iPhone3,2", "iPhone3,3",
        "iPhone4,1", "iPhone4,2", "iPhone4,3",
        "iPhone5,1", "iPhone5,2",
        "iPhone5,3", "iPhone5,4",
        "iPhone6,1", "iPhone6,2",
        "iPhone7,2",
        "iPhone7,1",
        "iPhone8,1",
        "iPhone8,2":                                    return Device_Type.iPhone
            
        case "iPad1,1",
        "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4",
        "iPad3,1", "iPad3,2", "iPad3,3",
        "iPad3,4", "iPad3,5", "iPad3,6",
        "iPad4,1", "iPad4,2", "iPad4,3",
        "iPad5,3", "iPad5,4",
        "iPad2,5", "iPad2,6", "iPad2,7",
        "iPad4,4", "iPad4,5", "iPad4,6",
        "iPad4,7", "iPad4,8", "iPad4,9",
        "iPad5,1", "iPad5,2",
        "iPad6,7", "iPad6,8":                           return Device_Type.iPad
            
        case "iPod1,1",
        "iPod2,1",
        "iPod3,1",
        "iPod4,1",
        "iPod5,1",
        "iPod7,1":
            return Device_Type.iPod
        case "i386", "x86_64":                          return Device_Type.Simulator
        default:                                        return Device_Type.Unknown
        }
    }
    
    
    static public func version() -> Device_Version {
        let versionName = Device.getVersionCode()
        
        return Device.getVersion(code: versionName)
    }
    
    static public func size() -> Device_Size {
        let w: Double = Double(UIScreen.mainScreen().bounds.size.width)
        let h: Double = Double(UIScreen.mainScreen().bounds.size.height)
        let screenHeight: Double = max(w, h)
        
        switch screenHeight {
        case 480:
            return Device_Size.Screen3_5Inch
        case 568:
            return Device_Size.Screen4Inch
        case 667:
            return UIScreen.mainScreen().scale == 3.0 ? Device_Size.Screen5_5Inch : Device_Size.Screen4_7Inch
        case 736:
            return Device_Size.Screen5_5Inch
        default:
            return Device_Size.UnknownSize
        }
    }
    
    static public func type() -> Device_Type {
        let versionName = Device.getVersionCode()
        
        return Device.getType(code: versionName)
    }
    
    static public func isEqualToScreenSize(size: Device_Size) -> Bool {
        return size == Device.size() ? true : false;
    }
    
    static public func isLargerThanScreenSize(size: Device_Size) -> Bool {
        return size.rawValue < Device.size().rawValue ? true : false;
    }
    
    static public func isSmallerThanScreenSize(size: Device_Size) -> Bool {
        return size.rawValue > Device.size().rawValue ? true : false;
    }
}
