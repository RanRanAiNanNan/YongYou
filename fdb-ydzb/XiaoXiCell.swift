//
//  XiaoXiCell.swift
//  fdb-ydzb
//
//  Created by 123 on 16/4/23.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation
import UIKit
class XiaoXiCell : UITableViewCell {
    //标题
    var  biaoTi : UILabel!
    //内容
    var  neiRong : UILabel!
    //日期
    var  dateLB : UILabel!
    //时间
    var  timeLB : UILabel!
    //预约
    var  yuYueLB: UILabel!
    //待打款
    var  daKuanLB: UILabel!
    //钱
    var  qianLB: UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        //
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
        //
        biaoTi = UILabel(frame: CGRectMake(10, 20, B.SCREEN_WIDTH - 20 , 30))
        biaoTi.font = UIFont.systemFontOfSize(15)
        biaoTi.textAlignment=NSTextAlignment.Left
        biaoTi.textColor = UIColor(red: 90/255, green: 94/255, blue: 109/255, alpha: 1)
        self.contentView.addSubview(biaoTi)
        
        neiRong = UILabel(frame: CGRectMake(10, 55, B.SCREEN_WIDTH - 20, 20))
        neiRong.font = UIFont.systemFontOfSize(13)
        neiRong.textColor = UIColor(red: 129/255, green: 144/255, blue: 167/255, alpha: 1)
        self.contentView.addSubview(neiRong)
        
        daKuanLB = UILabel(frame: CGRectMake(10, 85, B.SCREEN_WIDTH - 20, 20))
        daKuanLB.font = UIFont.systemFontOfSize(13)
        daKuanLB.textColor = UIColor(red: 129/255, green: 144/255, blue: 167/255, alpha: 1)
        self.contentView.addSubview(daKuanLB)
        
        qianLB = UILabel(frame: CGRectMake(80, 75, 50, 20))
        qianLB.font = UIFont.systemFontOfSize(13)
        qianLB.textColor = UIColor(red: 129/255, green: 144/255, blue: 167/255, alpha: 1)
        self.contentView.addSubview(qianLB)

        
        dateLB = UILabel(frame: CGRectMake(B.SCREEN_WIDTH - 90, 25, 80, 20))
        dateLB.font = UIFont.systemFontOfSize(12)
        dateLB.textAlignment=NSTextAlignment.Right
        dateLB.textColor = UIColor(red: 129/255, green: 144/255, blue: 167/255, alpha: 1)
        self.contentView.addSubview(dateLB)
        
        timeLB = UILabel(frame: CGRectMake(B.SCREEN_WIDTH - 90, 45, 80, 20))
        timeLB.font = UIFont.systemFontOfSize(12)
        timeLB.textAlignment=NSTextAlignment.Right
        timeLB.textColor = UIColor(red: 129/255, green: 144/255, blue: 167/255, alpha: 1)
        self.contentView.addSubview(timeLB)
        
        
        yuYueLB = UILabel(frame: CGRectMake(B.SCREEN_WIDTH - 90, 68, 80, 30))
        yuYueLB.font = UIFont.systemFontOfSize(15)
        yuYueLB.textAlignment=NSTextAlignment.Right
        yuYueLB.textColor = B.NAV_TITLE_CORLOR
        self.contentView.addSubview(yuYueLB)

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
