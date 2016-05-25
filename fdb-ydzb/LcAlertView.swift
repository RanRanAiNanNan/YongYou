//
//  LcAlertView.swift
//  beautySalonsApp
//  对话框基础类
//  Created by 刘驰 on 15/12/29.
//  Copyright © 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit
/**对话框样式**/
public enum LcAlertViewStyle {
    case Alert, Confirmation, WithdrawPwd
}
/**对话框动画**/
public enum LcAlertViewAnim {
    case Fade, FlyFromBottom
}
/**按钮回调**/
typealias alertBtnClick = (alertView: LcAlertView, tag: String) -> Void

public class LcAlertView: UIViewController {
    /**背景透明度**/
    let kDefaultShadowOpacity: CGFloat = 0.7
    /**对话框宽度**/
    let kAlertWidth:CGFloat = B.SCREEN_WIDTH - 40
    /**对话框初始高度**/
    let kAlertHeight:CGFloat = 65
    /**对话框圆角**/
    let kCornerRadius:CGFloat = 4
    /**对话框按钮间距**/
    let kButtonMargin:CGFloat = 5
    /**对话框按钮圆角**/
    let kButtonCornerRadius:CGFloat = 5
    /**对话框屏幕顶间距**/
    let kScreenTopMargin:CGFloat = 60
    /**对话框组件上间距**/
    let KTopMargin: CGFloat = 8
    /**对话框组件水平间距**/
    let kWidthMargin: CGFloat = 15
    /**对话框标题高度**/
    let kTitleHeight:CGFloat = 30.0
    /**对话框行间距**/
    let kHeightMargin: CGFloat = 10.0
    /**对话框按钮高度**/
    let kButtonHeight:CGFloat = 35.0
    /**对话框按钮字体大小**/
    let kButtonFontSize:CGFloat = 14
    /**对话框消息高度**/
    let kMessageViewHeight: CGFloat = 60.0
    /**对话框输入框高度**/
    let kInputViewHeight: CGFloat = 35.0
    /**对话框动画执行时间**/
    let kDuration:Double = 0.3
    /**确定按钮默认文字*/
    let kOkTitle = "确定"
    /**对话框背景颜色*/
    let kAlertBgColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
    /**确定按钮背景颜色*/
    let kOkBtnBgColor = UIColor(red: 241/255, green: 146/255, blue: 146/255, alpha: 1)
    /**取消按钮背景颜色*/
    let kCancelBtnBgColor = UIColor(red: 251/255, green: 251/255, blue: 251/255, alpha: 1)
    /**取消按钮字体颜色*/
    let kCancelTextBgColor = UIColor(red: 139/255, green: 139/255, blue: 139/255, alpha: 1)
    /**取消按钮边框颜色*/
    let kCancelBtnBorderColor = UIColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1)
    /**标题颜色*/
    let kTitleColor: UIColor? = UIColor(red:0.5, green:0.55, blue:0.55, alpha:1.0)
    /**标题边框颜色*/
    let kTitleBorderColor: UIColor? = UIColor(red:233/255, green:232/255, blue:234/255, alpha:1.0)
    /**标题颜色*/
    let kMessageColor: UIColor? = UIColor(red:0.5, green:0.55, blue:0.55, alpha:1.0)
    /**输入框颜色**/
    let inputBgColor: UIColor? = UIColor(red: 25/255, green: 255/255, blue: 255/255, alpha: 1)
    /**输入框边框颜色**/
    let inputBorderColor: UIColor? = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1)

    
    public var alertTitle:String?
    public var message:String?
    public var okTitle: String?
    public var cancelTitle: String?
    
    var btnClick: alertBtnClick?
    
    var alertView:LcAlertView?
    var baseView = UIView()
    var contentView = UIView()
    
    var titleLab = UILabel()
    var titleborderLab = UILabel()
    var messageLab = UILabel()
    
    var inputTf = UITextField()
    
    var animStyle:LcAlertViewAnim?
    
    
    /** 自定义提现交易密码**/
    let kWithdrawTitle = "提现金额:"
    let kAccountTitle = "到账金额:"
    let kWithdrawMsgTitle = "扣费提示:"
    let kWithdrawTitleHeight:CGFloat = 20
    let kWithdrawTitleColor = UIColor.blackColor()
    let kWithdrawMsgTitleColor = UIColor(red: 146/255, green: 146/255, blue: 146/255, alpha: 1)
    var withdrawLab:UILabel?                 //提现金额文字
    var accountLab:UILabel?                  //到账金额文字
    var withdrawNumLab:UILabel?              //提现金额数字
    var accountNumLab:UILabel?               //到账金额数字
    var withdrawMsgLab:UILabel?              //扣费提示
    var withdrawMsgContentLab:UILabel?       //扣费提示内容
    var withdrawMsgContent:String?
    
    /** 按钮 **/
    var okBtn = LcAlertButton(id: "okBtn")
    var cancelBtn = LcAlertButton(id: "cancelBtn")
    
    
    
    let mainScreenBounds = UIScreen.mainScreen().bounds
    var x:CGFloat = 0
    var y:CGFloat = 0
    var width:CGFloat = 0
    var btnWidth:CGFloat = 0
    
    init() {
        x = kWidthMargin
        y = KTopMargin
        width = kAlertWidth - (kWidthMargin * 2)
        btnWidth = (kAlertWidth - (kWidthMargin * 2) - kButtonMargin) / 2
        super.init(nibName: nil, bundle: nil)
        let window: UIWindow = UIApplication.sharedApplication().keyWindow!
        window.addSubview(view)
        window.bringSubviewToFront(view)
        view.frame = window.bounds
        self.view.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        self.view.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:kDefaultShadowOpacity)
        self.view.alpha = 0
        baseView.frame = view.frame
        //let tapGesture = UITapGestureRecognizer(target: self, action: Selector("dismiss"))
        //self.baseView.addGestureRecognizer(tapGesture)
        self.view.addSubview(baseView)
        
        alertView = self
    }
    
    /**显示对话框基础方法**/
    func showTitle(title: String?, message: String?, style: LcAlertViewStyle, animStyle: LcAlertViewAnim?, okTitle: String, cancelTitle: String?, btnAction: ((alertView: LcAlertView, tag: String) -> Void)? = nil) {
        self.alertTitle = title
        self.message = message
        self.okTitle = okTitle
        self.cancelTitle = cancelTitle
        self.animStyle = animStyle
        self.setupTitleViews()
        switch style {
        case .Alert:
            self.setupTitleViews()
            self.setupMessageView()
        case .Confirmation:
            self.setupTitleViews()
            self.setupTextFields()
        case .WithdrawPwd:
            self.setupWithdrawTitleViews()
            self.setupTextFields()
        }
        self.setupButtons()
    }
    
    /**简单的只一个确定按钮的对话框**/
    func showShortMsg(title:String, message:String, animStyle: LcAlertViewAnim, okTitle:String) {
        showTitle(title, message: message, style: .Alert,animStyle: animStyle, okTitle: okTitle, cancelTitle: nil)
    }
    /**消息对话框**/
    func showMsg(title:String, message:String, animStyle: LcAlertViewAnim, okTitle:String, cancelTitle: String?, btnAction: ((alertView: LcAlertView, tag: String) -> Void)? = nil){
        showTitle(title, message: message, style: .Alert, animStyle: animStyle, okTitle: okTitle, cancelTitle: cancelTitle)
        self.btnClick = btnAction
    }
    /**输入对话框**/
    func showConfirmation(title:String, animStyle: LcAlertViewAnim, okTitle:String, cancelTitle:String, placeHolder:String, isSecured:Bool, btnAction: ((alertView: LcAlertView, tag: String) -> Void)? = nil){
        showTitle(title, message: nil, style: LcAlertViewStyle.Confirmation, animStyle: animStyle, okTitle: okTitle, cancelTitle: cancelTitle)
        self.btnClick = btnAction
        self.inputTf.placeholder = placeHolder
        if isSecured {
            self.inputTf.secureTextEntry = true
        }
        
    }
    /**交易密码输入对话框（项目需求）**/
    func showWithdrawConfirmation(withdraw:String, account:String,rule:String, animStyle: LcAlertViewAnim, okTitle:String, cancelTitle:String, placeHolder:String, isSecured:Bool, btnAction: ((alertView: LcAlertView, tag: String) -> Void)? = nil){
        self.withdrawMsgContent = rule
        showTitle(nil, message: nil, style: LcAlertViewStyle.WithdrawPwd, animStyle: animStyle, okTitle: okTitle, cancelTitle: cancelTitle)
        self.btnClick = btnAction
        self.inputTf.placeholder = placeHolder
        self.withdrawNumLab?.text = withdraw
        self.accountNumLab?.text = account
        self.inputTf.secureTextEntry = isSecured
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName:nibNameOrNil, bundle:nibBundleOrNil)
    }
    
    /**初始化标题**/
    func setupTitleViews(){
        //contentView.frame = CGRect(x: (UIScreen.mainScreen().bounds.size.width - 300) / 2.0, y: (UIScreen.mainScreen().bounds.size.height - 150) / 2.0, width: 280, height: 65)
        contentView.backgroundColor = kAlertBgColor
        contentView.layer.cornerRadius = kCornerRadius
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 0.5
        baseView.addSubview(contentView)
        // Setup title
        self.titleLab.textAlignment = NSTextAlignment.Center
        //self.titleLab.textColor = kTitleColor
        self.titleLab.font = UIFont.boldSystemFontOfSize(14)
        if alertTitle != nil {
            self.titleLab.text = alertTitle
            titleLab.frame = CGRect(x: x, y: y, width: width, height: kTitleHeight)
            self.y += kTitleHeight + kHeightMargin - 5
            let titleBorderWidth = width / 4 * 3
            titleborderLab = UILabel(frame: CGRect(x:(kAlertWidth - titleBorderWidth) / 2, y: y, width: titleBorderWidth, height: 1))
            titleborderLab.backgroundColor = kTitleBorderColor
            self.y += kHeightMargin * 2
            self.contentView.addSubview(titleLab)
            self.contentView.addSubview(titleborderLab)
        }
    }
    
    /**提现自定义标题**/
    func setupWithdrawTitleViews(){
        //contentView.frame = CGRect(x: (UIScreen.mainScreen().bounds.size.width - 300) / 2.0, y: (UIScreen.mainScreen().bounds.size.height - 150) / 2.0, width: 280, height: 65)
        y += KTopMargin
        contentView.backgroundColor = kAlertBgColor
        contentView.layer.cornerRadius = kCornerRadius
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 0.5
        baseView.addSubview(contentView)
        //提现金额
        self.withdrawLab = UILabel()
        self.withdrawLab!.textAlignment = NSTextAlignment.Left
        self.withdrawLab!.textColor = kWithdrawTitleColor
        self.withdrawLab!.text = kWithdrawTitle
        self.withdrawLab!.font = UIFont.boldSystemFontOfSize(15)
        withdrawLab!.frame = CGRect(x: x, y: y, width: 70, height: kWithdrawTitleHeight)
        self.withdrawNumLab = UILabel()
        self.withdrawNumLab!.textAlignment = NSTextAlignment.Left
        self.withdrawNumLab!.textColor = kWithdrawTitleColor
        self.withdrawNumLab!.font = UIFont.boldSystemFontOfSize(15)
        //self.withdrawNumLab!.text = "3000元"
        self.withdrawNumLab!.frame = CGRect(x: x + 70, y: y, width: width - 70, height: kWithdrawTitleHeight)
        self.contentView.addSubview(withdrawLab!)
        self.contentView.addSubview(withdrawNumLab!)
        self.y += kWithdrawTitleHeight + kHeightMargin - 5
        //到账金额
        self.accountLab = UILabel()
        self.accountLab!.textAlignment = NSTextAlignment.Left
        self.accountLab!.textColor = kWithdrawTitleColor
        self.accountLab!.text = kAccountTitle
        self.accountLab!.font = UIFont.boldSystemFontOfSize(15)
        self.accountLab!.frame = CGRect(x: x, y: y, width: 70, height: kWithdrawTitleHeight)
        self.accountNumLab = UILabel()
        self.accountNumLab!.textAlignment = NSTextAlignment.Left
        self.accountNumLab!.text = "3,000.00元"
        self.accountNumLab!.textColor = kWithdrawTitleColor
        self.accountNumLab!.font = UIFont.boldSystemFontOfSize(15)
        self.accountNumLab!.frame = CGRect(x: x + 70, y: y, width: width - 70, height: kWithdrawTitleHeight)
        self.contentView.addSubview(accountLab!)
        self.contentView.addSubview(accountNumLab!)
        self.y += kWithdrawTitleHeight + kHeightMargin
        //横线
        titleborderLab = UILabel(frame: CGRect(x:kWidthMargin, y: y, width: width, height: 1))
        titleborderLab.backgroundColor = kTitleBorderColor
        self.contentView.addSubview(titleborderLab)
        self.y += kHeightMargin + kHeightMargin - 5
        //扣费提示
        self.withdrawMsgLab = UILabel()
        self.withdrawMsgLab!.textAlignment = NSTextAlignment.Left
        self.withdrawMsgLab!.textColor = kWithdrawMsgTitleColor
        self.withdrawMsgLab!.text = kWithdrawMsgTitle
        self.withdrawMsgLab!.font = UIFont.boldSystemFontOfSize(14)
        self.withdrawMsgLab!.frame = CGRect(x: x, y: y, width: width, height: kWithdrawTitleHeight)
        self.y += kWithdrawTitleHeight + kHeightMargin - 5
        //扣费提示内容
        self.withdrawMsgContentLab = UILabel()
        self.withdrawMsgContentLab!.textAlignment = NSTextAlignment.Left
        self.withdrawMsgContentLab!.textColor = kWithdrawMsgTitleColor
        self.withdrawMsgContentLab!.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.withdrawMsgContentLab!.numberOfLines = 0
        self.withdrawMsgContentLab!.text = withdrawMsgContent
        let statusLabelText: NSString = withdrawMsgContentLab!.text!
        self.withdrawMsgContentLab!.font = UIFont.boldSystemFontOfSize(14)
        let options:NSStringDrawingOptions = [NSStringDrawingOptions.UsesLineFragmentOrigin, NSStringDrawingOptions.UsesFontLeading]
        let boundingRect = statusLabelText.boundingRectWithSize(CGSizeMake(width, 0), options: options, attributes: [NSFontAttributeName:withdrawMsgContentLab!.font], context: nil)
        self.withdrawMsgContentLab!.frame = CGRect(x: x, y: y, width: width, height: boundingRect.size.height)
        self.contentView.addSubview(withdrawMsgLab!)
        self.contentView.addSubview(withdrawMsgContentLab!)
        self.y += boundingRect.size.height + kHeightMargin
    }
    
    /**初始化信息内容**/
    func setupMessageView(){
        self.messageLab.textAlignment = NSTextAlignment.Center
        self.messageLab.numberOfLines = 0
        self.messageLab.textAlignment = NSTextAlignment.Left
        self.messageLab.textColor = kMessageColor
        self.messageLab.font = UIFont.systemFontOfSize(14)
        if message != nil {
            self.messageLab.text = message
            messageLab.frame = CGRect(x: x + 5, y: y, width: width - 5, height: kMessageViewHeight)
            self.contentView.addSubview(messageLab)
            self.y += kMessageViewHeight + kHeightMargin
        }
    }
    
    /**初始化输入框**/
    func setupTextFields(){
        inputTf.leftView = UIView(frame: CGRectMake(0, 0, 10, kInputViewHeight))
        inputTf.rightView = UIView(frame: CGRectMake(0, 0, 10, kInputViewHeight))
        inputTf.leftViewMode = UITextFieldViewMode.Always
        inputTf.rightViewMode = UITextFieldViewMode.Always
        inputTf.layer.cornerRadius = 5
        inputTf.layer.borderWidth = 0.7
        inputTf.backgroundColor = UIColor.whiteColor()
        inputTf.font = UIFont.systemFontOfSize(14)
        inputTf.layer.borderColor = inputBorderColor?.CGColor
        inputTf.frame = CGRect(x: x, y: y, width: width, height: kInputViewHeight)
        self.contentView.addSubview(inputTf)
        self.y += kInputViewHeight + kHeightMargin * 2
    }
    
    /**初始化按钮**/
    func setupButtons(){
        if okTitle == nil {
            okTitle = kOkTitle
        }
        okBtn.setTitle(okTitle, forState: UIControlState.Normal)
        okBtn.layer.cornerRadius = kButtonCornerRadius
        okBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(kButtonFontSize)
        okBtn.addTarget(self, action: "okBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        okBtn.backgroundColor = kOkBtnBgColor
        if cancelTitle != nil {
            cancelBtn.frame = CGRect(x: x, y: y, width: btnWidth, height: kButtonHeight)
            cancelBtn.setTitle(cancelTitle, forState: UIControlState.Normal)
            cancelBtn.backgroundColor = kCancelBtnBgColor
            cancelBtn.layer.borderWidth = 1
            cancelBtn.layer.borderColor = kCancelBtnBorderColor.CGColor
            cancelBtn.layer.cornerRadius = kButtonCornerRadius
            cancelBtn.setTitleColor(kCancelTextBgColor, forState: UIControlState.Normal)
            cancelBtn.addTarget(self, action: "cancelBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
            cancelBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(kButtonFontSize)
            contentView.addSubview(cancelBtn)
            okBtn.frame = CGRect(x: x + btnWidth + kButtonMargin, y: y, width: btnWidth, height: kButtonHeight)
        }else{
            //btnWidth = width
            okBtn.frame = CGRect(x: x, y: y, width: width, height: kButtonHeight)
        }
        
        contentView.addSubview(okBtn)
        y += kButtonHeight + kHeightMargin
        contentView.frame = CGRect(x: (mainScreenBounds.size.width - kAlertWidth) / 2.0, y: (mainScreenBounds.size.height - y) / 2.0, width: kAlertWidth, height: y)
        contentView.clipsToBounds = true
        showWithDuration()
    }
    
    /**对话框显示动画**/
    func showWithDuration(){
        switch animStyle! {
        case .Fade:
            self.view.alpha = 0
            UIView.animateWithDuration(kDuration) { () -> Void in
                self.view.alpha = 1
            }
        case .FlyFromBottom:
            self.view.alpha = 1
            self.contentView.frame.origin.y = B.SCREEN_HEIGHT
            UIView.animateWithDuration(kDuration) {
                () -> Void in
                self.contentView.frame.origin.y = self.kScreenTopMargin
            }
            
        }
    }
    
    func okBtnClick(){
        btnClick?(alertView: self, tag: okBtn.identifier)
        dismissWithDuration()
    }
    
    func cancelBtnClick(){
        btnClick?(alertView: self, tag: cancelBtn.identifier)
        dismissWithDuration()
    }
    
    /**对话框消失动画**/
    func dismissWithDuration(){
        switch animStyle! {
        case .Fade:
            self.view.alpha = 1
            UIView.animateWithDuration(kDuration,
                animations: { () -> Void in
                    self.view.alpha = 0
                }, completion: {
                    Void in
                    self.view.removeFromSuperview()
            })
        case .FlyFromBottom:
            self.contentView.frame.origin.y = kScreenTopMargin
            UIView.animateWithDuration(kDuration,
                animations: { () -> Void in
                self.contentView.frame.origin.y = -self.contentView.frame.height
                }, completion: {
                    Void in
                    self.view.removeFromSuperview()
            })
        }
        
    }
    /**自定义按钮**/
    class LcAlertButton: UIButton {
        var identifier: String!
        
        init(id:String) {
            super.init(frame: CGRectZero)
            identifier = id
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    }
}