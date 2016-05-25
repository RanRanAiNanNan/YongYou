//
//  RadioButton.swift
//  ydzbapp-hybrid
//
//  Created by qinxin on 15/6/10.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class RadioButton: UIButton {

    private var circleLayer = CAShapeLayer()
    override var selected: Bool {
        didSet {
            toggleButton()
        }
    }
    
    var circleColor: UIColor = B.NAV_BG {
        didSet {
            circleLayer.strokeColor = circleColor.CGColor
            self.toggleButton()
        }
    }
    
    var circleRadius: CGFloat = 5.0
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    ////////////////////////////////////////////////////////////////////////
    
    override func drawRect(rect: CGRect) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    private func initialize() {
        circleLayer.frame = bounds
        circleLayer.lineWidth = 2
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.strokeColor = circleColor.CGColor
        layer.addSublayer(circleLayer)
        self.titleEdgeInsets = UIEdgeInsetsMake(0, (2 * circleRadius + 4 * circleLayer.lineWidth), 0, 0)
        self.toggleButton()
    }
    
    private func toggleButton() {
        if self.selected {
            circleLayer.fillColor = circleColor.CGColor
            self.tintColor = B.NAV_BG
        } else {
            circleLayer.fillColor = UIColor.clearColor().CGColor
        }
    }
    
    
    
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleLayer.frame = bounds
        circleLayer.path = circlePath().CGPath
    }
    
    private func circlePath() -> UIBezierPath {
        return UIBezierPath(ovalInRect: circleFrame())
    }
    
    private func circleFrame() -> CGRect {
        var circleFrame = CGRect(x: 0, y: 0, width: 2 * circleRadius, height: 2 * circleRadius)
        circleFrame.origin.x = 0 + circleLayer.lineWidth
        circleFrame.origin.y = bounds.height / 2 - circleFrame.height / 2
        
        return circleFrame
    }
    
    
    
    
    
    override func prepareForInterfaceBuilder() {
        initialize()
    }

}
