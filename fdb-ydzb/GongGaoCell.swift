//
//  GongGaoCell.swift
//  fdb-ydzb
//
//  Created by 123 on 16/4/23.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation
import UIKit
class GongGaoCell: UITableViewCell {
    //标题
    var  biaoTi : UILabel!
    //内容
    var  neiRong : UILabel!
    //日期
    var  dateLB : UILabel!
    //时间
    var  timeLB : UILabel!
  
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
//
        biaoTi = UILabel(frame: CGRectMake(10, 10, B.SCREEN_WIDTH - 20 , 20))
        biaoTi.font = UIFont.systemFontOfSize(15)
        biaoTi.textColor = UIColor(red: 90/255, green: 94/255, blue: 109/255, alpha: 1)
        self.contentView.addSubview(biaoTi)

        neiRong = UILabel(frame: CGRectMake(10, 40, B.SCREEN_WIDTH - 20, 20))
        neiRong.font = UIFont.systemFontOfSize(13)
        neiRong.textColor = UIColor(red: 129/255, green: 144/255, blue: 167/255, alpha: 1)
        self.contentView.addSubview(neiRong)
    
        dateLB = UILabel(frame: CGRectMake(10, 80, B.SCREEN_WIDTH - 20, 30))
        dateLB.font = UIFont.systemFontOfSize(12)
        dateLB.textColor = UIColor(red: 129/255, green: 144/255, blue: 167/255, alpha: 1)
        self.contentView.addSubview(dateLB)
        
        timeLB = UILabel(frame: CGRectMake(90, 80, 60, 30))
        timeLB.font = UIFont.systemFontOfSize(12)
        timeLB.textColor = UIColor(red: 129/255, green: 144/255, blue: 167/255, alpha: 1)
        self.contentView.addSubview(timeLB)

        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
