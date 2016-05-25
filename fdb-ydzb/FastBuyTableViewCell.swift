//
//  FastBuyTableViewCell.swift
//  ydzbapp-hybrid
//
//  Created by qinxin on 15/6/11.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class FastBuyTableViewCell: UITableViewCell {

    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    
    var productDesLabel: UILabel = UILabel(frame: CGRectMake(80, 40, 200, 21))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        buyButton.backgroundColor = B.NAV_BG
        buyButton.layer.cornerRadius = 5.0
        
        productDesLabel.numberOfLines = 0
        productDesLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        productDesLabel.font = UIFont.systemFontOfSize(14.0)
        
        self.addSubview(productDesLabel)
    }
    
    @IBAction func buy(sender: UIButton) {
        let av = UIAlertView(title: "", message: "已购", delegate: nil, cancelButtonTitle: "确定")
        av.show()
    }

}
