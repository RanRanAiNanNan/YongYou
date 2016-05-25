//
//  NetLoanDepositeTableViewCell.swift
//  ydzbapp-hybrid
//
//  Created by qinxin on 15/7/2.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class NetLoanDepositeTableViewCell: UITableViewCell {

    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var incomeYear: UILabel!
    @IBOutlet weak var cycleInvestment: UILabel!
    @IBOutlet weak var detailButton: UIButton! { didSet { detailButton.layer.cornerRadius = 5.0 } }
    
    

}
