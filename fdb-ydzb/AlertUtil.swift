//
//  AlertUtil.swift
//  ydzbApp
//
//  Created by 刘驰 on 15/1/22.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit

class AlertUtil {
    //简单的提示框
    class func simpleAlert(title:String,msg:String,butTitle:String) {
        let alertView = UIAlertView()
        alertView.title = title
        alertView.message = msg
        alertView.addButtonWithTitle(butTitle)
        alertView.show()
    }
    
    //简单的提示框
    class func simpleAlert(sender:AnyObject,title:String,msg:String,okBtnTitle:String,cancelBtnTitle:String) {
        let alertView = UIAlertView()
        alertView.title = title
        alertView.message = msg
        alertView.addButtonWithTitle(okBtnTitle)
        alertView.addButtonWithTitle(cancelBtnTitle)
        alertView.delegate = sender
        alertView.show()
    }
}
