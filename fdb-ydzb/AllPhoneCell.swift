//
//  AllPhoneCell.swift
//  fdb-ydzb
//
//  Created by 123 on 16/4/19.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation
import UIKit
class AllPhoneCell: UITableViewCell {
    
    //view
    var myView : UIView!
    
    //手机图片
    var phoneImage:UIImageView!
   
    //手机号
    var mobileLabel : UILabel!
    
    //选中图片
    var xuanButton : UIButton!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
        
        myView = UILabel(frame: CGRectMake(20 , 10, B.SCREEN_WIDTH - 40 , 60))
        myView.backgroundColor = UIColor.whiteColor()
        myView.layer.masksToBounds = true
        myView.layer.cornerRadius = 30
        self.contentView.addSubview(myView!)
        
        phoneImage = UIImageView(frame: CGRectMake(20, 20, 20 , 20))
        phoneImage.image = UIImage(named:"phone-1")
        self.myView.addSubview(phoneImage!)
        
        mobileLabel = UILabel(frame: CGRectMake(30 , 10, B.SCREEN_WIDTH - 60 - 60, 40))
        mobileLabel!.font = UIFont.systemFontOfSize(15)
        mobileLabel!.textAlignment = NSTextAlignment.Center
        mobileLabel!.textColor = UIColor(red: 106/255, green: 136/255, blue: 150/255, alpha: 1)
        self.myView.addSubview(mobileLabel!)

        xuanButton = UIButton(frame: CGRectMake(B.SCREEN_WIDTH - 60 ,25 , 30,30 ))
        xuanButton!.setBackgroundImage(UIImage(named:"circle"),forState:.Normal)
        self.contentView.addSubview(xuanButton!)
             
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
}

}


