//
//  MObileCell.swift
//  fdb-ydzb
//
//  Created by 123 on 16/3/29.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation
import UIKit
class MObileCell: UITableViewCell {
    //手机号
    var  mobileLabel : UILabel!
    //姓名
    var  nameLabel : UILabel!
    //对号
    var  duihaoImage : UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
        
        nameLabel = UILabel(frame: CGRectMake(15, 0, 100, 50))
        nameLabel.font = UIFont.systemFontOfSize(17)
        nameLabel.textColor = B.BTN_NO_SELECTED
        self.contentView.addSubview(nameLabel)
        
        mobileLabel = UILabel(frame: CGRectMake(120, 0, 200, 50))
        mobileLabel.font = UIFont.systemFontOfSize(16)
        mobileLabel.textColor = UIColor(red: 157/255, green: 160/255, blue: 169/255, alpha: 1)
        self.contentView.addSubview(mobileLabel)

//        duihaoImage = UIImageView(frame: CGRectMake(B.SCREEN_WIDTH - 30, 10, 20, 20))
////        duihaoImage.textColor = B.BTN_NO_SELECTED
//        self.contentView.addSubview(duihaoImage)
        
        
        
        

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
}