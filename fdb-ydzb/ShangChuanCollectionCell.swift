//
//  ShangChuanCollectionCell.swift
//  fdb-ydzb
//
//  Created by 123 on 16/4/25.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation
import UIKit
class ShangChuanCollectionCell: UICollectionViewCell {


    var imageView : UIImageView?
    var button : UIButton?
    
    var viwe : UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        imageView = UIImageView(frame: CGRectMake(0, 0, self.contentView.bounds.size.width  , self.contentView.bounds.size.height ))
        
        self.contentView.addSubview(imageView!)

        
        button = UIButton(frame: CGRectMake(self.contentView.bounds.size.width - 20 , 0 , 20,20 ))
        button!.setBackgroundImage(UIImage(named:"icon-xuanze-拷贝"),forState:.Normal)
    
        self.contentView.addSubview(button!)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }














}
