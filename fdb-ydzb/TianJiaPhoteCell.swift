//
//  TianJiaPhoteCell.swift
//  fdb-ydzb
//
//  Created by 123 on 16/4/25.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation
import UIKit
class TianJiaPhoteCell: UICollectionViewCell {
    
    
    var imageView : UIImageView?
    var button : UIButton?
    
    var viwe : UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        button = UIButton(frame: CGRectMake(0 , 0 , self.contentView.bounds.size.width,self.contentView.bounds.size.height ))
//        button!.setImage(UIImage(named:"body+phote"), forState: .Normal)
        self.contentView.addSubview(button!)
        
        imageView = UIImageView(frame: CGRectMake(0, 0, (B.SCREEN_WIDTH - 40 - 40 ) / 3 , (B.SCREEN_WIDTH - 40 - 40 ) / 3))
        imageView!.image = UIImage(named:"body+phote")
        self.contentView.addSubview(imageView!)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

