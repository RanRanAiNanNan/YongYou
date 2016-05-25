//
//  AddressCell.swift
//  fdb-ydzb
//
//  Created by 123 on 16/3/31.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation
import UIKit
class AddressCell: UITableViewCell {
    
    //收件姓名
    var recieveLabel : UILabel?
    //名称
    var nameLabel : UILabel?
    //手机号
    var mobileLabel : UILabel?
    //线
    var lineLabel : UILabel?
    //默认
    var addLabel : UILabel?
    //详细
    var addressLabel : UILabel?
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
        
        recieveLabel = UILabel(frame: CGRectMake(10, 10, 80, 35))
        recieveLabel!.font = UIFont.systemFontOfSize(15)
        recieveLabel!.text = "收件姓名"
        recieveLabel!.textColor = B.BTN_NO_SELECTED
        self.contentView.addSubview(recieveLabel!)

        nameLabel = UILabel(frame: CGRectMake(90, 10, 80, 35))
        nameLabel!.font = UIFont.systemFontOfSize(15)
        nameLabel!.textColor = UIColor(red: 164/255, green: 168/255, blue: 179/255, alpha: 1)
        self.contentView.addSubview(nameLabel!)
        
        mobileLabel = UILabel(frame: CGRectMake(160, 10, B.SCREEN_WIDTH - 170, 35))
        mobileLabel!.font = UIFont.systemFontOfSize(15)
        mobileLabel!.textColor = B.BTN_NO_SELECTED
        self.contentView.addSubview(mobileLabel!)
        
//        lineLabel = UILabel(frame: CGRectMake(0, 55, B.SCREEN_WIDTH, 1))
//        lineLabel!.backgroundColor = UIColor.blackColor()
//        self.contentView.addSubview(lineLabel!)
        
        addLabel = UILabel(frame: CGRectMake(B.SCREEN_WIDTH - 40, 10, 30, 35))
        addLabel!.font = UIFont.systemFontOfSize(15)
        addLabel!.text = "默认"
        addLabel!.textColor = B.NAV_TITLE_CORLOR
        self.contentView.addSubview(addLabel!)

        addressLabel = UILabel(frame: CGRectMake(10, 55, B.SCREEN_WIDTH - 20, 45))
        addressLabel!.font = UIFont.systemFontOfSize(13)
        addressLabel!.textColor = B.BTN_NO_SELECTED
        addressLabel!.numberOfLines = 0
        self.contentView.addSubview(addressLabel!)


    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    
    
    
    
}