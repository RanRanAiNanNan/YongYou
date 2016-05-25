//
//  MenuEnumeration.swift
//  SwiftNavMenuSample
//
//  Created by Subodh Jena on 17/12/14.
//  Copyright (c) 2014 Owl. All rights reserved.
//

import Foundation


// Jobs Filter Enumeration
enum MenuEnumerations {
    case hb                 //我的红包
    case jxj                //加息券
    case xjhb               //现金红包
    
    // TODO : to be updated when a new enumeration value in added
    static let allValues = [hb, jxj, xjhb]
    
    // Gets the description of each enum value
    func getDescription() -> String{
        switch self {
        case .hb:
            return "我的红包"
        case .jxj:
            return "加息券"
        case .xjhb:
            return "现金红包"
        }
        
    }
    
    func getType() -> String {
        switch self {
        case .hb:
            return "99"
        case .jxj:
            return "2"
        case .xjhb:
            return "1"
        }
    }
}