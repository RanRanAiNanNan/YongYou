//
//  RichesCell.swift
//  fdb-ydzb
//
//  Created by 123 on 16/3/30.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation
import UIKit
class RichesCell: UITableViewCell {
    
    //名称
    var nameLabel : UILabel?
    //日期
    var dateLabel : UILabel?
    //审核
    var auditorLabel : UILabel?
    //钱 
    var moneyLabel : UILabel?
    //取消
    var cancelButton : UIButton?
    //修改
    var modificationButton : UIButton?
    //上传
    var selectButton : UIButton?
    //第二个取消
    var cancelButton2 : UIButton?
    //第二个修改
    var modificationButton2 : UIButton?
    //上传合同签署页照片
    var shangchunButton : UIButton?
    
    var shangchunButton1 : UIButton?
    //重新预约
    var chongxin : UIButton?
    //返佣金额
    var fanyong : UILabel?
    //反
    var fan :UILabel?
    //人名
    var xingmingLabel :UILabel?
    //线
    var xian :UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)

        nameLabel = UILabel(frame: CGRectMake(10, 10, 200, 30))
        nameLabel!.font = UIFont.systemFontOfSize(15)
        nameLabel!.textAlignment=NSTextAlignment.Left
        nameLabel!.textColor = B.BTN_NO_SELECTED
        self.contentView.addSubview(nameLabel!)

        xingmingLabel = UILabel(frame: CGRectMake(110, 60, 80, 20))
        xingmingLabel!.font = UIFont.systemFontOfSize(13)
        xingmingLabel!.textAlignment=NSTextAlignment.Left
        xingmingLabel!.textColor = B.BTN_NO_SELECTED
        self.contentView.addSubview(xingmingLabel!)
        
        dateLabel = UILabel(frame: CGRectMake(10, 45, 200, 20))
        dateLabel!.font = UIFont.systemFontOfSize(13)
        dateLabel!.textAlignment=NSTextAlignment.Left
        dateLabel!.textColor = B.BTN_NO_SELECTED
        self.contentView.addSubview(dateLabel!)
        
        auditorLabel = UILabel(frame: CGRectMake(B.SCREEN_WIDTH - 210, 10, 205, 30))
        auditorLabel!.font = UIFont.systemFontOfSize(13)
        auditorLabel!.textAlignment=NSTextAlignment.Right
        auditorLabel!.textColor = B.NAV_TITLE_CORLOR
        self.contentView.addSubview(auditorLabel!)

        moneyLabel = UILabel(frame: CGRectMake(B.SCREEN_WIDTH - 140, 45, 90, 20))
        moneyLabel!.font = UIFont.systemFontOfSize(13)
        moneyLabel!.textAlignment=NSTextAlignment.Right
        moneyLabel!.textColor = B.BTN_NO_SELECTED
        self.contentView.addSubview(moneyLabel!)

        cancelButton = UIButton(type: .System)
        cancelButton!.frame = CGRectMake(10, 90, (B.SCREEN_WIDTH - 40) / 3 , 30)
        cancelButton!.titleLabel?.font = UIFont.systemFontOfSize(14)
        cancelButton!.setTitle("取消预约", forState: UIControlState.Normal)
        cancelButton!.setTitleColor(UIColor.grayColor(),forState: .Normal)
        cancelButton!.layer.masksToBounds = true
        cancelButton!.layer.borderWidth = 1
        cancelButton!.layer.cornerRadius = 5
        cancelButton!.layer.borderColor = UIColor.grayColor().CGColor
        self.contentView.addSubview(cancelButton!)

        modificationButton = UIButton(type: .System)
        modificationButton!.frame = CGRectMake((B.SCREEN_WIDTH - 40) / 3 + 20, 90, (B.SCREEN_WIDTH - 40) / 3, 30)
        modificationButton!.titleLabel?.font = UIFont.systemFontOfSize(14)
        modificationButton!.setTitle("修改合同地址", forState: UIControlState.Normal)
        modificationButton!.setTitleColor(B.NAV_TITLE_CORLOR,forState: .Normal)
        modificationButton!.layer.masksToBounds = true
        modificationButton!.layer.borderWidth = 1
        modificationButton!.layer.borderColor = B.NAV_TITLE_CORLOR.CGColor
        modificationButton!.layer.cornerRadius = 5
        self.contentView.addSubview(modificationButton!)

        selectButton = UIButton(type: .System)
        selectButton!.frame = CGRectMake((B.SCREEN_WIDTH - 40) / 3 * 2 + 30, 90, (B.SCREEN_WIDTH - 40) / 3 , 30 )
        selectButton!.titleLabel?.font = UIFont.systemFontOfSize(14)
        selectButton!.setTitle("上传打款凭证", forState: UIControlState.Normal)
        selectButton!.setTitleColor(B.NAV_TITLE_CORLOR,forState: .Normal)
        selectButton!.layer.masksToBounds = true
        selectButton!.layer.borderWidth = 1
        selectButton!.layer.borderColor = B.NAV_TITLE_CORLOR.CGColor
        selectButton!.layer.cornerRadius = 5
        self.contentView.addSubview(selectButton!)

        cancelButton2 = UIButton(type: .System)
        cancelButton2!.frame = CGRectMake((B.SCREEN_WIDTH - 40) / 3 + 20, 90, (B.SCREEN_WIDTH - 40) / 3, 30)
        cancelButton2!.titleLabel?.font = UIFont.systemFontOfSize(14)
        cancelButton2!.setTitle("取消预约", forState: UIControlState.Normal)
        cancelButton2!.setTitleColor(UIColor.grayColor(),forState: .Normal)
        cancelButton2!.layer.masksToBounds = true
        cancelButton2!.layer.borderWidth = 1
        cancelButton2!.layer.borderColor = UIColor.grayColor().CGColor
        cancelButton2!.layer.cornerRadius = 5
        self.contentView.addSubview(cancelButton2!)

        
        modificationButton2 = UIButton(type: .System)
        modificationButton2!.frame = CGRectMake((B.SCREEN_WIDTH - 40) / 3 * 2 + 30, 90, (B.SCREEN_WIDTH - 40) / 3 , 30 )
        modificationButton2!.titleLabel?.font = UIFont.systemFontOfSize(14)
        modificationButton2!.setTitle("修改合同地址", forState: UIControlState.Normal)
        modificationButton2!.setTitleColor(B.NAV_TITLE_CORLOR,forState: .Normal)
        modificationButton2!.layer.masksToBounds = true
        modificationButton2!.layer.borderWidth = 1
        modificationButton2!.layer.cornerRadius = 5
        modificationButton2!.layer.borderColor = B.NAV_TITLE_CORLOR.CGColor
        self.contentView.addSubview(modificationButton2!)
        
        shangchunButton = UIButton(type: .System)
        shangchunButton!.frame = CGRectMake(B.SCREEN_WIDTH - 200, 90, 180 , 30 )
        shangchunButton!.titleLabel?.font = UIFont.systemFontOfSize(14)
        shangchunButton!.setTitle("上传合同签署页照片", forState: UIControlState.Normal)
        shangchunButton!.setTitleColor(B.NAV_TITLE_CORLOR,forState: .Normal)
        shangchunButton!.layer.masksToBounds = true
        shangchunButton!.layer.borderWidth = 1
        shangchunButton!.layer.borderColor = B.NAV_TITLE_CORLOR.CGColor
        shangchunButton!.layer.cornerRadius = 5
        self.contentView.addSubview(shangchunButton!)
        
        shangchunButton1 = UIButton(type: .System)
        shangchunButton1!.frame = CGRectMake(B.SCREEN_WIDTH - 200, 90, 180 , 30 )
        shangchunButton1!.titleLabel?.font = UIFont.systemFontOfSize(14)
        shangchunButton1!.setTitle("上传合同签署页照片", forState: UIControlState.Normal)
        shangchunButton1!.setTitleColor(B.NAV_TITLE_CORLOR,forState: .Normal)
        shangchunButton1!.hidden = true
        shangchunButton1!.layer.masksToBounds = true
        shangchunButton1!.layer.borderWidth = 1
        shangchunButton1!.layer.borderColor = B.NAV_TITLE_CORLOR.CGColor
        shangchunButton1!.layer.cornerRadius = 5
        self.contentView.addSubview(shangchunButton1!)


        chongxin = UIButton(type: .System)
        chongxin!.frame = CGRectMake(B.SCREEN_WIDTH - 100, 90, 80 , 30 )
        chongxin!.titleLabel?.font = UIFont.systemFontOfSize(14)
        chongxin!.setTitle("重新预约", forState: UIControlState.Normal)
        chongxin!.setTitleColor(B.NAV_TITLE_CORLOR,forState: .Normal)
        chongxin!.layer.masksToBounds = true
        chongxin!.layer.borderWidth = 1
        chongxin!.layer.borderColor = B.NAV_TITLE_CORLOR.CGColor
        chongxin!.layer.cornerRadius = 5
        self.contentView.addSubview(chongxin!)

        
        
        
        
        
        
        fanyong = UILabel(frame: CGRectMake(B.SCREEN_WIDTH  - 80, 150 - 40, 60 , 30))
        fanyong!.font = UIFont.systemFontOfSize(13)
        fanyong!.textAlignment=NSTextAlignment.Right
        fanyong!.textColor = B.BTN_NO_SELECTED
        self.contentView.addSubview(fanyong!)

        fan = UILabel(frame: CGRectMake(B.SCREEN_WIDTH  - 150,150 - 40, 70 , 30))
        fan!.font = UIFont.systemFontOfSize(13)
        fan!.textAlignment=NSTextAlignment.Left
        fan!.textColor = B.BTN_NO_SELECTED
        self.contentView.addSubview(fan!)

        xian = UILabel(frame: CGRectMake(0, 80, B.SCREEN_WIDTH , 1))
        xian?.backgroundColor = UIColor(red: 235/255, green: 234/255, blue: 243/255, alpha: 1)
        self.contentView.addSubview(xian!)

    
    
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}