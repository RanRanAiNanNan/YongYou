//
//  CircleView.swift
//  ScrollView
//
//  Created by qinxin on 15/8/26.
//  Copyright (c) 2015年 qinxin. All rights reserved.
//

import UIKit

//@IBDesignable
class CircleView: UIView {
    
    
    var arcBounds = CGFloat() {
        didSet {
            setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let context = UIGraphicsGetCurrentContext();
        CGContextSetRGBStrokeColor(context, 30/255.0, 36/255.0, 50/255.0, 1);
        CGContextSetLineWidth(context, 3);
        CGContextAddArc(context, width / 2, height / 2, CGFloat(arcBounds), CGFloat(0.0), CGFloat(2.0 * M_PI), 0);
        CGContextDrawPath(context, CGPathDrawingMode.Stroke);
    }

}
