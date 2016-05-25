//
//  LoadingView.swift
//  ydzbApp
//
//  Created by 刘驰 on 15/1/26.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit

class LoadingView: UIView {
    
    @IBOutlet weak var loadingText: UILabel!
    @IBOutlet weak var lai: UIActivityIndicatorView!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        super.layer.cornerRadius = 10
        super.backgroundColor = UIColor.blackColor()
    }
    
}
