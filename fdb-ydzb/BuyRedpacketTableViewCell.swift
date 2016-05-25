//
//  BuyRedpacketTableViewCell.swift
//  ydzbapp-hybrid
//
//  Created by qinxin on 15/9/7.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class BuyRedpacketTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productType: UILabel!        //红包类型
    @IBOutlet weak var giveValue: UILabel!          //红包值
    @IBOutlet weak var getTime: UILabel!            //得到时间
    @IBOutlet weak var name: UILabel!               //红包名称
    @IBOutlet weak var useFinishTime: UILabel!      //有效期至
    @IBOutlet weak var rightButton: UIButton! {     //选中按钮
        didSet {
            rightButton.hidden = true
        }
    }
    var redId: String = ""                          //红包id

}
