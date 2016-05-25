//
//  DepositeInterestTableViewCell.swift
//  ydzbapp-hybrid
//
//  Created by qinxin on 15/9/7.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class DepositeInterestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fundLabel: UILabel!          //收益金额
    @IBOutlet weak var dateLabel: UILabel!          //返利日期
    @IBOutlet weak var statusLabel: UILabel!        //收益状态
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
