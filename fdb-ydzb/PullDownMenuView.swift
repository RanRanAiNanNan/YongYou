//
//  PullDownMenuView.swift
//  ydzbapp-hybrid
//
//  Created by qinxin on 15/5/21.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

public enum IndicatorStatus: Int {
    
    case  IndicatorStateShow = 0
    case  IndicatorStateHide
}

public enum BackGroundViewStatus: Int {
    case BackGroundViewStatusShow = 0
    case BackGroundViewStatusHide
}

protocol PullDownMenuDelegate{
    func pullDownMenu(pullDownMenu: PullDownMenuView!, didSelectRowAtColumn column: NSInteger, didSelectRowAtRow row: NSInteger)
}

extension CALayer{
    func addAnimationExtension(anim: CAAnimation, andValue value: NSValue, forKeyPath keyPath: String){
        self.addAnimation(anim, forKey: keyPath)
        self.setValue(value, forKeyPath: keyPath)
    }
}

class PullDownMenuView: UIView,  UITableViewDataSource, UITableViewDelegate{
    
    var delegate: PullDownMenuDelegate?
    
    var tableView = UITableView()
    
    
    private var menuColor = UIColor()
    var backGroundView = UIView()
    
    private var lineView = UIView()
    
    var titles = NSMutableArray()
    var indicators = NSMutableArray()
    private var currentSelectedMenuIndex = NSInteger()
    private var show = Bool()
    private var numOfMenu = NSInteger()
    
    private var array = NSArray()
    
    
    //MARK: - Init Methods
    
    func initWithArray(array: NSArray, selectedColor color: UIColor) -> PullDownMenuView{
        
        self.menuColor = B.MENU_BG_COLOR
        
        self.array = array
        
        self.numOfMenu = array.count
        
        let textLayerInterval = self.frame.size.width / CGFloat(numOfMenu * 2)
        let separatorLineInterval = self.frame.size.width / CGFloat(numOfMenu)
        
        self.titles = NSMutableArray(capacity: numOfMenu)
        indicators = NSMutableArray(capacity: numOfMenu)
        
        for var i = 0 ; i < numOfMenu ; i++ {
            let position = CGPointMake(CGFloat(i * 2 + 1) * textLayerInterval, self.frame.size.height / 2)
            let title = self.creatTextLayerWithNSString(self.array[i][0] as! String, withColor: B.MENU_NORMAL_FONT_COLOR, andPosition: position)
            self.layer.addSublayer(title)
            self.titles.addObject(title)
            
            let indicator  = self.creatIndicatorWithColor(B.MENU_NORMAL_FONT_COLOR, andPosition: CGPointMake(CGFloat(position.x + title.bounds.size.width / 2 + 8), self.frame.size.height / 2 + 8))
            self.layer .addSublayer(indicator)
            self.indicators .addObject(indicator)
            
            if (i != self.numOfMenu - 1){
                let separatorPosition = CGPointMake(CGFloat(i + 1) * separatorLineInterval, self.frame.size.height / 2)
                let separator = self.creatSeparatorLineWithColor(B.MENU_SEPRATOR_COLOR
                    , andPosition: separatorPosition)
                self.layer.addSublayer(separator)
            }
        }
        
        tableView = self.creatTableViewAtPosition(CGPointMake(0, self.frame.origin.y + self.frame.size.height))
        tableView.tintColor = color
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = self.menuColor
        
        lineView.frame = CGRectMake(0, frame.height - 1, frame.width, 1)
        lineView.backgroundColor = B.MENU_SELECTED_FONT_COLOR
        lineView.hidden = true
        addSubview(lineView)
        
        //设置menu
        self.backgroundColor = B.MENU_BG_COLOR
        let tapGesture = UITapGestureRecognizer(target: self, action:"tapMenu:")
        self.addGestureRecognizer(tapGesture)
        
        //创建透明背景
        backGroundView = UIView(frame: CGRectMake(0, 0, B.SCREEN_WIDTH, B.SCREEN_HEIGHT))
        backGroundView.backgroundColor = UIColor(white: 0, alpha: 0)
        backGroundView.opaque = false
        let gesture = UITapGestureRecognizer(target: self, action: "tapBackGround")
        backGroundView.addGestureRecognizer(gesture)
        
        currentSelectedMenuIndex = 0
        show = false

        return self
    }
    
    
    
    
    //MARK: - Animation
    
    private func animateIndicator(indicator: CAShapeLayer, forward: Bool, complete:() -> ()){
//        CATransaction.begin()
//        CATransaction.setAnimationDuration(0.25)
//        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0))
//        
//        let anim = CAKeyframeAnimation(keyPath: "transform.rotation")
//        anim.values = forward ? [0,M_PI] : [M_PI,0]
//        
//        if (anim.removedOnCompletion == false) {
//            indicator.addAnimation(anim, forKey: anim.keyPath)
//        }else{
//            indicator.addAnimationExtension(anim, andValue: anim.values.last as! NSValue, forKeyPath: anim.keyPath)
//        }
//        
//        CATransaction.commit()
        
        indicator.fillColor = forward ? B.MENU_SELECTED_FONT_COLOR.CGColor : B.MENU_NORMAL_FONT_COLOR.CGColor
        
        complete()
    }
    
    private func animateBackGroundView(view: UIView, show: Bool, complete:() -> ()){
        if show {
            self.superview?.addSubview(view)
            view.superview?.addSubview(self)
            
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                view.backgroundColor = UIColor(white: 0, alpha: 0)
            })
        }else{
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                view.backgroundColor = UIColor(white: 0, alpha: 0)
                }, completion: { (finished: Bool) -> Void in
                view.removeFromSuperview()
            })
        }
        
        complete()
    }
    
    private func animateTableView(_tableview: UITableView, show:Bool, complete:() -> ()){
        if show {
            _tableview.frame = CGRectMake(self.tableView.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0)
            self.superview?.addSubview(_tableview)
            let tableViewHeight = _tableview.numberOfRowsInSection(0) > 8 ? (CGFloat(8) * _tableview.rowHeight) : CGFloat(_tableview.numberOfRowsInSection(0)) * _tableview.rowHeight
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, tableViewHeight)
            })
            
        }else{
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0)
                }, completion: { (finished: Bool) -> Void in
                _tableview.removeFromSuperview()
            })
        }
        
        complete()
    }
    
    private func animateTitle(title: CATextLayer, show: Bool, complete:() -> ()){
        if show {
            title.foregroundColor = B.MENU_SELECTED_FONT_COLOR.CGColor
        }else{
            title.foregroundColor = B.MENU_NORMAL_FONT_COLOR.CGColor
        }
        
        let size = self.calculateTitleSizeWithString(title.string as! String)
        let sizeWidth = (size.width < (self.frame.size.width / CGFloat(self.numOfMenu)) - CGFloat(25)) ? size.width : self.frame.size.width / CGFloat(self.numOfMenu) - CGFloat(25)
        title.bounds = CGRectMake(0, 0, sizeWidth, size.height)
        
        complete()
    }
    
    private func animateIndicator(indicator: CAShapeLayer, background: UIView, tableView: UITableView, title: CATextLayer, forward: Bool, complete:() -> ()){
        self.animateIndicator(indicator, forward: forward) { () -> ()
            in
                self.animateTitle(title, show: forward, complete: { () -> () in
                    self.animateBackGroundView(background, show: forward, complete: { () -> () in
                        self.animateTableView(tableView, show: forward, complete: { () -> () in
                            
                        })
                    })
                })
        }
        
        complete()
    }
    
    
    
    
    //MARK: - Tap Event
    
    func tapMenu(paramSender: UITapGestureRecognizer){
        
        let touchPoint = paramSender.locationInView(self)
        
        //得到tapIndex
        let tapIndex = NSInteger(touchPoint.x / (self.frame.size.width / CGFloat(self.numOfMenu)))
        
//        print("tapIndex = \(tapIndex) self.currentSelectedMenuIndex = \(self.currentSelectedMenuIndex) self.show = \(self.show)")
        
        for var i = 0 ; i < self.numOfMenu ; i++ {
            if i != tapIndex {
            self.animateIndicator(self.indicators[i] as! CAShapeLayer, forward: false, complete: { () -> () in
                self.animateTitle(self.titles[i] as! CATextLayer, show: false, complete: { () -> () in
                })
            })
            }
        }
        
        if tapIndex == self.currentSelectedMenuIndex && self.show {
            self.animateIndicator(self.indicators[self.currentSelectedMenuIndex] as! CAShapeLayer, background: self.backGroundView, tableView: self.tableView, title: self.titles[self.currentSelectedMenuIndex] as! CATextLayer, forward: false, complete: { () -> () in
                self.currentSelectedMenuIndex = tapIndex
                self.show = false
                self.lineView.hidden = true
            })
        }else{
            self.currentSelectedMenuIndex = tapIndex
            self.tableView.reloadData()
            self.animateIndicator(self.indicators[tapIndex] as! CAShapeLayer, background: self.backGroundView, tableView: self.tableView, title: self.titles[tapIndex] as! CATextLayer, forward: true, complete: { () -> () in
                self.show = true
                self.lineView.hidden = false
            })
        }
        
    }
    
    func tapBackGround(){
        self.animateIndicator(self.indicators[self.currentSelectedMenuIndex] as! CAShapeLayer, background: self.backGroundView, tableView: self.tableView, title: self.titles[self.currentSelectedMenuIndex] as! CATextLayer, forward: false) { () -> () in
            self.show = false
            self.lineView.hidden = true
        }
    }
    
    
    
    
    //MARK: - Table view delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.confiMenuWithSelectRow(indexPath.row)
        self.delegate?.pullDownMenu(self, didSelectRowAtColumn: self.currentSelectedMenuIndex, didSelectRowAtRow: indexPath.row)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layoutMargins = UIEdgeInsetsZero
        cell.separatorInset = UIEdgeInsetsZero
    }
    
    
    
   //MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array[self.currentSelectedMenuIndex].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
        
        if !(cell != nil){
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
            cell?.textLabel?.font = UIFont.systemFontOfSize(14.0)
        }
        
        cell?.backgroundColor = self.menuColor
        
        cell?.textLabel?.textColor = B.MENU_NORMAL_FONT_COLOR
        cell?.accessoryType = UITableViewCellAccessoryType.None
        cell?.textLabel?.text = array[currentSelectedMenuIndex][indexPath.row] as? String
        
        if(cell?.textLabel?.text == self.titles .objectAtIndex(self.currentSelectedMenuIndex).string){
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
            cell?.tintColor = B.MENU_SELECTED_FONT_COLOR
            cell?.textLabel?.textColor = B.MENU_SELECTED_FONT_COLOR
        }
        
        return cell!
        
    }
    
    
    
    //MARK: - Common Methods
    
    private func creatTableViewAtPosition(point: CGPoint) -> UITableView{
        let tableView = UITableView()
        tableView.frame = CGRectMake(point.x, point.y, self.frame.size.width, 0)
        tableView.rowHeight = 44
        
        return tableView
    }
    
    private func creatSeparatorLineWithColor(color: UIColor, andPosition point: CGPoint) -> CAShapeLayer{
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(160, 0))
        path.addLineToPoint(CGPointMake(160, 20))
        
        layer.path = path.CGPath
        layer.lineWidth = 1.0
        layer.strokeColor = color.CGColor
        
        let bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, CGLineCap.Butt, CGLineJoin.Miter, layer.miterLimit);
        layer.bounds = CGPathGetBoundingBox(bound);
        
        layer.position = point;
        
        return layer;
    }
    
    private func creatIndicatorWithColor(color: UIColor, andPosition point: CGPoint) -> CAShapeLayer{
        let layer = CAShapeLayer()
        
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(0, 0))
        path.addLineToPoint(CGPointMake(5, 0))
        path.addLineToPoint(CGPointMake(5, -5))
        path.closePath()
        
        layer.path = path.CGPath
        layer.lineWidth = 1.0
        layer.fillColor = color.CGColor
        
        let bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, CGLineCap.Butt, CGLineJoin.Miter, layer.miterLimit)
        layer.bounds = CGPathGetBoundingBox(bound)
        layer.position = point
        
        return layer
    }
    
    private func creatTextLayerWithNSString(string: String, withColor color: UIColor, andPosition point: CGPoint) -> CATextLayer{
        let size = self.calculateTitleSizeWithString(string)
        let layer = CATextLayer()
        let sizeWidth = (size.width < self.frame.size.width / CGFloat(self.numOfMenu) - 25) ? size.width : self.frame.size.width / CGFloat(self.numOfMenu) - 25
        layer.bounds = CGRectMake(0, 0, sizeWidth, size.height)
        layer.string = string
        if self.numOfMenu > 2 {
            layer.fontSize = B.SCREEN_WIDTH / 30
        }else{
            layer.fontSize = B.SCREEN_WIDTH / 27
        }
        layer.alignmentMode = kCAAlignmentCenter
        layer.foregroundColor = color.CGColor
        layer.contentsScale = UIScreen.mainScreen().scale
        layer.position = point
        
        return layer
    }
    
    private func calculateTitleSizeWithString(string: String) -> CGSize{
        let dic: [String: AnyObject] = [NSFontAttributeName : UIFont.systemFontOfSize(14)]
        let options : NSStringDrawingOptions = [.TruncatesLastVisibleLine, .UsesLineFragmentOrigin, .UsesFontLeading]
        let size = (string as NSString).boundingRectWithSize(CGSizeMake(280, 0), options: options, attributes: dic, context: nil).size
        return size
    }

    private func confiMenuWithSelectRow(row: NSInteger){
        let title = self.titles[self.currentSelectedMenuIndex] as! CATextLayer
        title.string = self.array.objectAtIndex(self.currentSelectedMenuIndex).objectAtIndex(row)
        
        self.animateIndicator(self.indicators[self.currentSelectedMenuIndex] as! CAShapeLayer, background: self.backGroundView, tableView: self.tableView, title: self.titles[self.currentSelectedMenuIndex] as! CATextLayer, forward: false) { () -> () in
            self.show = false
            self.lineView.hidden = true
        }
        
        let indicator = self.indicators[self.currentSelectedMenuIndex] as! CAShapeLayer
        indicator.position = CGPointMake(title.position.x + title.frame.size.width / 2 + CGFloat(8), indicator.position.y)
    }
}
