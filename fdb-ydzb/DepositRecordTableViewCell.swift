//
//  DepositRecordTableViewCell.swift
//  ydzbapp-hybrid
//
//  Created by qinxin on 15/8/31.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class DepositRecordTableViewCell: UITableViewCell {

    @IBOutlet weak var productNameLabel: UILabel!                   //产品名称
    @IBOutlet weak var surplusLabel: UILabel!                       //年化收益率
    @IBOutlet weak var buyCopiesLabel: UILabel!                     //购买金额
    @IBOutlet weak var deadLineTipLabel: UILabel!                   //到期收益 or 预期收益
    @IBOutlet weak var deadLineEargingsLabel: UILabel!              //到期收益值
    @IBOutlet weak var buyTimeLabel: UILabel!                       //购买日期
    @IBOutlet weak var deadLineDateLabel: UILabel!                  //到期日期

}
