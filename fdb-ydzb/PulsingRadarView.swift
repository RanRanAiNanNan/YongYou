//
//  PulsingRadarView.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/7/7.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//


import UIKit
import QuartzCore

class PRButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.alpha = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if self.window != nil {
            UIView.animateWithDuration(1, animations: {
                self.alpha = 1
            })
        }
    }
    
    override func removeFromSuperview() {
        UIView.beginAnimations("", context: nil)
        UIView.setAnimationDuration(1)
        self.alpha = 0
        UIView.setAnimationDidStopSelector(Selector("callSuperRemoveFromSuperview"))
        UIView.commitAnimations()
    }
    
    private func callSuperRemoveFromSuperview() {
        super.removeFromSuperview()
    }
}


class PulsingRadarView: UIView {
    
    let itemSize = CGSizeMake(44, 44)
    var items = NSMutableArray()
    weak var animationLayer: CALayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: Selector("resume"),
            name: UIApplicationDidBecomeActiveNotification,
            object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func resume() {
        if let animationLayer = self.animationLayer {
            animationLayer.removeFromSuperlayer()
            self.setNeedsDisplay()
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func addOrReplaceItem() {
        let maxCount = 10
        
        let radarButton = PRButton(frame: CGRectMake(0, 0, itemSize.width, itemSize.height))
        radarButton.setImage(UIImage(named: "UK"), forState: UIControlState.Normal)
        radarButton.backgroundColor = UIColor.blueColor()
        
        repeat {
            let center = generateCenterPointInRadar()
            radarButton.center = CGPointMake(center.x, center.y)
        } while (itemFrameIntersectsInOtherItem(radarButton.frame))
        
        self.addSubview(radarButton)
        items.addObject(radarButton)
        
        if items.count > maxCount {
            let view = items.objectAtIndex(0) as! UIView
            view.removeFromSuperview()
            items.removeObject(view)
        }
    }
    
    private func itemFrameIntersectsInOtherItem (frame: CGRect) -> Bool {
        for item in items {
            if CGRectIntersectsRect(item.frame, frame) {
                return true
            }
        }
        return false
    }
    
    private func generateCenterPointInRadar() -> CGPoint{
        let angle = Double(arc4random()) % 360
        let radius = Double(arc4random()) % (Double)((self.bounds.size.width - itemSize.width)/2)
        let x = cos(angle) * radius
        let y = sin(angle) * radius
        return CGPointMake(CGFloat(x) + self.bounds.size.width / 2, CGFloat(y) + self.bounds.size.height / 2)
    }
    
    override func drawRect(rect: CGRect) {
         UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).setFill()
        UIRectFill(rect)
        
        let pulsingCount = 6
        let animationDuration: Double = 6
        
        let animationLayer = CALayer()
        for var i = 0; i < pulsingCount; i++ {
            let pulsingLayer = CALayer()
            pulsingLayer.frame = CGRectMake(-80, -80, 200, 200)
            pulsingLayer.borderColor = UIColor.grayColor().CGColor
            pulsingLayer.backgroundColor = UIColor(red: 113/255, green: 219/255, blue: 197/255, alpha: 0.8).CGColor
            //pulsingLayer.backgroundColor = UIColor.redColor().CGColor
            //pulsingLayer.borderWidth = 1
            pulsingLayer.cornerRadius = 200 / 2
            
            let defaultCurve = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
            
            let animationGroup = CAAnimationGroup()
            animationGroup.fillMode = kCAFillModeBackwards
            animationGroup.beginTime = CACurrentMediaTime() + Double(i) * animationDuration / Double(pulsingCount)
            animationGroup.duration = animationDuration
            animationGroup.repeatCount = HUGE
            animationGroup.timingFunction = defaultCurve
            
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.fromValue = Double(0)
            scaleAnimation.toValue = Double(1.2)
            
            let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
            opacityAnimation.values = [Double(1),Double(0.7),Double(0)]
            opacityAnimation.keyTimes = [Double(0),Double(0.5),Double(1)]
            
            animationGroup.animations = [scaleAnimation,opacityAnimation]
            
            pulsingLayer.addAnimation(animationGroup, forKey: "pulsing")
            animationLayer.addSublayer(pulsingLayer)
        }
        self.layer.addSublayer(animationLayer)
        self.animationLayer = animationLayer
    }
}
