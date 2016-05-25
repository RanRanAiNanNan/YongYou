//
//  TransferBuyTableViewCell.swift
//  ydzbapp-hybrid
//
//  Created by qinxin on 15/9/1.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit



class TransferBuyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!               //产品名称
    @IBOutlet weak var newApr: UILabel!             //预期年化
    @IBOutlet weak var buyFund: UILabel!            //债权金额
    @IBOutlet weak var predictIncome: UILabel!      //预期收益
    @IBOutlet weak var buyTime: UILabel!            //购买日期
    @IBOutlet weak var expireTime: UILabel!         //到期日期
    @IBOutlet weak var buyButton: UIButton! {       //立刻购买
        didSet {
            buyButton.layer.cornerRadius = 5.0
        }
    }

}
