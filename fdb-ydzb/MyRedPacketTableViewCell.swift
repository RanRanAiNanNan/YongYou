//
//  MyRedPacketTableViewCell.swift
//  ydzbapp-hybrid
//
//  Created by qinxin on 15/9/3.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class MyRedPacketTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productType: UILabel!        //红包类型
    @IBOutlet weak var giveValue: UILabel!          //红包值
    @IBOutlet weak var name: UILabel!               //红包名称
    @IBOutlet weak var getTime: UILabel!            //获得时间
    @IBOutlet weak var useFinishTime: UILabel!      //有效期
    @IBOutlet weak var useButton: UIButton! {       //领用
        didSet {
            useButton.layer.cornerRadius = 5.0
        }
    }
    @IBOutlet weak var addRates: UILabel!           //加息券
    @IBOutlet weak var percent: UILabel!            //百分号
    @IBOutlet weak var redpackLeftBg: UIImageView!  //左侧背景图
    @IBOutlet weak var redpackRightbg: UIImageView! //右侧背景图
    @IBOutlet weak var validTimeLabel: UILabel!     //有效期至文字
    

}
