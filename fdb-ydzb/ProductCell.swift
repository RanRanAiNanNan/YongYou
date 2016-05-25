//
//  ProductCell.swift
//  fdb-ydzb
//
//  Created by 123 on 16/3/24.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation
import UIKit

class ProductCell: UITableViewCell {
    
    
    //标题
    var  titleLabel : UILabel!
    //预期收益
    var  yuqiLabel : UILabel!
    //预期收益 数
    var  yuqishuLabel : UILabel!
    //收益
    var  shouyiLabel : UILabel!
    //返佣
    var  fanyongLabel : UILabel!
    //产品形式
    var  chanpinLabel : UILabel!
    //产品
    var  chanLabel : UILabel!
    //期限
    var  qixianLabel : UILabel!
    //月
    var  yueLabel : UILabel!
    //起购金额
    var  qigouLabel : UILabel!
    //钱
    var  qianLabel : UILabel!
    //线
    var  xianLabel : UILabel!
    //百分号
    var  baifen : UILabel!
    
    
    // 初始化cell
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
        
        
        titleLabel = UILabel(frame: CGRectMake(16, 0, 200, 37))
        titleLabel.font = UIFont.systemFontOfSize(13)
        titleLabel.textAlignment=NSTextAlignment.Left
        titleLabel.textColor = B.YONGYOU_TEXT
        self.contentView.addSubview(titleLabel)
        
        yuqiLabel = UILabel(frame: CGRectMake(B.SCREEN_WIDTH - 105 , 0,55, 37))
//        yuqiLabel.backgroundColor = UIColor.redColor()
        yuqiLabel.font = UIFont.systemFontOfSize(13)
        yuqiLabel.textAlignment=NSTextAlignment.Right
        yuqiLabel.textColor = B.YONGYOU_TEXT
        self.contentView.addSubview(yuqiLabel)

        yuqishuLabel = UILabel(frame: CGRectMake(B.SCREEN_WIDTH - 50 , 0, 40, 37))
//        yuqishuLabel.backgroundColor = UIColor.yellowColor()
        yuqishuLabel.font = UIFont.systemFontOfSize(13)
        yuqishuLabel.textAlignment = NSTextAlignment.Right
        yuqishuLabel.textColor = B.NAV_TITLE_CORLOR
        self.contentView.addSubview(yuqishuLabel)
        
        shouyiLabel = UILabel(frame: CGRectMake(16 ,45, 55, 30))
//        shouyiLabel.backgroundColor = UIColor.yellowColor()
        shouyiLabel.font = UIFont.systemFontOfSize(24)
        shouyiLabel.textAlignment=NSTextAlignment.Right
        shouyiLabel.textColor = B.NAV_TITLE_CORLOR
        self.contentView.addSubview(shouyiLabel)
        
        baifen = UILabel(frame: CGRectMake(70 ,50, 20, 30))
        baifen.font = UIFont.systemFontOfSize(15)
        baifen.textColor = B.NAV_TITLE_CORLOR
        self.contentView.addSubview(baifen)

        fanyongLabel = UILabel(frame: CGRectMake(90 ,52, 28, 16))
        fanyongLabel.font = UIFont.systemFontOfSize(13)
//        fanyongLabel.layer.cornerRadius = 5
//        fanyongLabel.clipsToBounds = true
        fanyongLabel.textAlignment=NSTextAlignment.Center
        fanyongLabel.backgroundColor = B.NAV_TITLE_CORLOR
        fanyongLabel.textColor = UIColor.whiteColor()
        self.contentView.addSubview(fanyongLabel)

        xianLabel = UILabel(frame: CGRectMake(0 ,38, B.SCREEN_WIDTH , 0.5))
        xianLabel.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1)
        self.contentView.addSubview(xianLabel)

        chanpinLabel = UILabel(frame: CGRectMake(16,85, 60, 20))
        chanpinLabel.font = UIFont.systemFontOfSize(13)
        chanpinLabel.textColor = UIColor(red: 106.0/255, green: 136.0/255, blue: 150.0/255, alpha: 1)
        self.contentView.addSubview(chanpinLabel)

        chanLabel = UILabel(frame: CGRectMake(76 ,85, 80, 20))
        chanLabel.font = UIFont.systemFontOfSize(13)
        chanLabel.textColor = UIColor(red: 106.0/255, green: 136.0/255, blue: 150.0/255, alpha: 1)
        self.contentView.addSubview(chanLabel)

        qixianLabel = UILabel(frame: CGRectMake(B.SCREEN_WIDTH - 100 ,52, 84, 16))
        qixianLabel.font = UIFont.systemFontOfSize(13)
        qixianLabel.textAlignment=NSTextAlignment.Right
        qixianLabel.textColor = B.MENU_NORMAL_FONT_COLOR
        self.contentView.addSubview(qixianLabel)
        
        yueLabel = UILabel(frame: CGRectMake(B.SCREEN_WIDTH / 2 + 45 ,80, 100, 20))
        yueLabel.font = UIFont.systemFontOfSize(14)
        yueLabel.textColor = B.LIST_GRAY_TEXT_COLOR
        self.contentView.addSubview(yueLabel)
        
        qigouLabel = UILabel(frame: CGRectMake(160 ,85, B.SCREEN_WIDTH - 170, 20))
        qigouLabel.font = UIFont.systemFontOfSize(13)
        qigouLabel.textAlignment=NSTextAlignment.Right
        qigouLabel.textColor = UIColor(red: 106.0/255, green: 136.0/255, blue: 150.0/255, alpha: 1)
        self.contentView.addSubview(qigouLabel)

        qianLabel = UILabel(frame: CGRectMake(B.SCREEN_WIDTH / 2 + 78 ,113, 80, 20))
        qianLabel.font = UIFont.systemFontOfSize(14)
        qianLabel.textColor = B.LIST_GRAY_TEXT_COLOR
        self.contentView.addSubview(qianLabel)


    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  }