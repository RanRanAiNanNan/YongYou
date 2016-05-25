//
//  YoYoAlertView.swift
//  AlertView_Swift
//
//  Created by YoYo on 16/5/6.
//  Copyright © 2016年 cn.yoyoy.mw. All rights reserved.
//

import UIKit

class YoYoAlertView: UIView {

    typealias clickAlertClosure = (index: Int) -> Void //声明闭包，点击按钮传值
    //把申明的闭包设置成属性
    var clickClosure: clickAlertClosure?
    //为闭包设置调用函数
    func clickIndexClosure(closure:clickAlertClosure?){
        //将函数指针赋值给myClosure闭包
        clickClosure = closure
    }
    let screen_width = UIScreen.mainScreen().bounds.size.width
    let screen_height = UIScreen.mainScreen().bounds.size.height
    let whiteView = UIView() //白色框
    let titleLabel = UILabel() //标题按钮
    let contentLabel = UILabel() //显示内容
    var title = "" //标题
    var content = "" //内容
    let cancelBtn = UIButton() //取消按钮
    let sureBtn = UIButton() //确定按钮
    let tap = UITapGestureRecognizer() //点击手势
    
    init(title: String?, message: String?, cancelButtonTitle: String?, sureButtonTitle: String?) {
        super.init(frame: CGRect(x: 0, y: 0, width: screen_width, height: screen_height))
        createAlertView()
        self.titleLabel.text = title
        self.contentLabel.text = message
        self.cancelBtn.setTitle(cancelButtonTitle, forState: .Normal)
        self.sureBtn.setTitle(sureButtonTitle, forState: .Normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:创建
    func createAlertView() {
        //布局
        self.frame = CGRect(x: 0, y: 0, width: screen_width, height: screen_height)
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
        tap.addTarget(self, action: Selector("dismiss"))
        self.addGestureRecognizer(tap)
        //白底
        whiteView.frame = CGRect(x: 30, y: screen_height/2 - 100, width: screen_width - 60, height: 200)
        whiteView.backgroundColor = UIColor.whiteColor()
        whiteView.layer.cornerRadius = 5
        whiteView.clipsToBounds = true
        self.addSubview(whiteView)
        let width = whiteView.frame.size.width
        //标题
        titleLabel.frame = CGRect(x: 0, y: 15, width: width, height: 25)
        titleLabel.textColor = RGB_Color(r: 66, g: 66, b: 66, a: 1)
        titleLabel.font = UIFont.systemFontOfSize(17)
        titleLabel.textAlignment = .Center
        whiteView.addSubview(titleLabel)
        
        
        //内容
        contentLabel.frame = CGRect(x: 24, y: 56, width: width - 48, height: 68)
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .Center
        contentLabel.textColor = RGB_Color(r: 84, g: 84, b: 84, a: 1)
        contentLabel.font = UIFont.systemFontOfSize(15)
        whiteView.addSubview(contentLabel)
        
        let view1 = UIView()
        view1.frame = CGRect(x: 0, y: 144, width: width, height: 1)
        view1.backgroundColor = UIColor(red: 1/255, green: 1/255, blue: 1/255, alpha: 0.2)
        whiteView.addSubview(view1)

        let view2 = UIView()
        view2.frame = CGRect(x: width / 2, y: 145, width: 1, height: 60)
        view2.backgroundColor = UIColor(red: 1/255, green: 1/255, blue: 1/255, alpha: 0.2)
        whiteView.addSubview(view2)

        //取消按钮
        let btnWith = (width - 30) / 2
        cancelBtn.frame = CGRect(x: 10, y: 145, width: btnWith, height: 45)
        cancelBtn.backgroundColor = UIColor.whiteColor()
        cancelBtn.setTitleColor(UIColor(red: 84/255, green: 84/255, blue: 84/255, alpha: 1) , forState: UIControlState.Normal)
        cancelBtn.titleLabel?.font = UIFont.systemFontOfSize(18)
        cancelBtn.layer.cornerRadius = 3
        cancelBtn.clipsToBounds = true
        cancelBtn.tag = 1
        cancelBtn.addTarget(self, action: Selector("clickBtnAction:"), forControlEvents: .TouchUpInside)
        whiteView.addSubview(cancelBtn)
        //确认按钮
        sureBtn.frame = CGRect(x: btnWith + 20 , y: 145, width: btnWith, height: 45)
        sureBtn.backgroundColor = UIColor.whiteColor()
        sureBtn.setTitleColor(B.NAV_TITLE_CORLOR, forState: UIControlState.Normal)
        sureBtn.titleLabel?.font = UIFont.systemFontOfSize(18)
        sureBtn.layer.cornerRadius = 3
        sureBtn.clipsToBounds = true
        sureBtn.tag = 2
        sureBtn.addTarget(self, action: Selector("clickBtnAction:"), forControlEvents: .TouchUpInside)
        whiteView.addSubview(sureBtn)
    }
    //MARK:按键的对应的方法
    func clickBtnAction(sender: UIButton) {
        if (clickClosure != nil) {
            clickClosure!(index: sender.tag)
        }
        dismiss()
    }
    //MARK:消失
    func dismiss() {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.whiteView.alpha = 0
            self.alpha = 0
        }) { (finish) -> Void in
            if finish {
                self.removeFromSuperview()
            }
        }
    }
    /** 指定视图实现方法 */
    func show() {
        let wind = UIApplication.sharedApplication().keyWindow
        self.alpha = 0
        wind?.addSubview(self)
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.alpha = 1
        })
    }
    //MARK: 转换颜色
    func RGB_Color(r r: CGFloat, g:CGFloat, b:CGFloat, a: CGFloat) -> UIColor {
        return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
}
