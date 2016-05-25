//
//  GesturePasswordView.swift
//  GesturePassword4Swift
//
//  Created by feiin on 14/11/22.
//  Copyright (c) 2014年 swiftmi. All rights reserved.
//

import UIKit

protocol GesturePasswordDelegate
{
    func forget()
    func change()
}
/** 手势密码外观 **/
struct GesturePasswordStyle {
    /** 按钮view大小 **/
    var gestureViewSize:CGFloat = 280
    /** 每个按钮之间的间距 **/
    var gestureViewMargin = 15
    /** 头像大小 **/
    var imgSize:CGFloat = 66
    /** 状态提示文字字体大小 **/
    var stateFont:CGFloat = 15
    /** 用户名上间距 **/
    var usernameMargin:CGFloat = 15
    /** 用户名字体大小 **/
    var usernameFont:CGFloat = 13
    /** 头像距屏项间距 **/
    var imgTopMargin:CGFloat = 30
}

class GesturePasswordView: UIView,TouchBeginDelegate {

    var tentacleView:TentacleView?
    
    var state:UILabel?
    
    var usernameLab:UILabel?
    
    var gesturePasswordDelegate:GesturePasswordDelegate?
    
    var imgView:UIImageView?
    
    var forgetButton:UIButton?
    
    var changeButton:UIButton?
    
    var style: GesturePasswordStyle!
    
   private var buttonArray:[GesturePasswordButton]=[]
    
    var versionLabel: UILabel!
    
   private var lineStartPoint:CGPoint?
   private var lineEndPoint:CGPoint?

    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        initView()
        // Initialization code
        let view = UIView(frame:CGRectMake(20, frame.size.height/2-80, 320, style.gestureViewSize))
        for i in 0..<9 {
            
            let row = Int(i/3)
            let col = Int(i%3)
            
            let distance = Int(style.gestureViewSize/3)
            let size:Int = Int(Float(distance)/1.5)
            //let margin = Int(size/4) + 20
            //print("row:\(row)...col:\(row)...distance:\(distance)...size:\(size)....margin:\(margin)")
            let gesturePasswordButton = GesturePasswordButton(frame: CGRectMake(CGFloat(col * distance + style.gestureViewMargin), CGFloat(row*distance), CGFloat(size), CGFloat(size)))
            
            gesturePasswordButton.tag = i
            
            view.addSubview(gesturePasswordButton)
            buttonArray.append(gesturePasswordButton)
            
        }
        
        self.addSubview(view)
        
        tentacleView = TentacleView(frame: view.frame)
  
        tentacleView!.buttonArray = buttonArray
        tentacleView!.touchBeginDelegate = self
        self.addSubview(tentacleView!)
        
        imgView = UIImageView(frame:CGRectMake(frame.size.width / 2 - (style.imgSize / 2), style.imgTopMargin, style.imgSize, style.imgSize))
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as NSString
        let imageFilePath = documentsDirectory.stringByAppendingPathComponent("Avatar@2x(1)")
        let saveAvatarImg = UIImage(contentsOfFile: imageFilePath)
//        print(userDefaultsUtil.getAvatarLink())
        if userDefaultsUtil.getAvatarLink() == "" {
            self.imgView!.image = UIImage(named: "Avatar@2x(1)")
        }else{
//            self.avatarBtn.setImageWithURL(NSURL(string: hm.photoUrl), forState: UIControlState.Normal)
//            self.imgView!.image = UIImage(named: "Avatar@2x(1)")
//            userDefaultsUtil.getAvatarLink()
//            self.imgView!.sd_imageURL()
            self.imgView!.sd_setImageWithURL(NSURL(string:userDefaultsUtil.getAvatarLink()!), placeholderImage: UIImage(named: "Avatar@2x(1)"))
        }
        imgView!.layer.masksToBounds = true
        imgView?.backgroundColor = UIColor.clearColor()
        imgView!.layer.cornerRadius = style.imgSize / 2
        imgView!.layer.borderColor = B.NAV_TITLE_CORLOR.CGColor
        imgView!.layer.borderWidth = 3
        self.addSubview(imgView!)
        
        
        usernameLab = UILabel(frame: CGRectMake(frame.size.width/2-100, imgView!.frame.origin.y + style.imgSize/2 + style.usernameMargin, 200, 60))
        usernameLab?.text = userDefaultsUtil.getUsername()
        usernameLab?.textColor = B.NAV_TITLE_CORLOR
        usernameLab!.textAlignment = NSTextAlignment.Center
        usernameLab!.font = UIFont.systemFontOfSize(style.usernameFont)
        self.addSubview(usernameLab!)
        
        state = UILabel(frame: CGRectMake(frame.size.width/2-170, usernameLab!.frame.origin.y + style.imgSize / 2 + 15, 340, 30))
        state!.textAlignment = NSTextAlignment.Center
        state!.font = UIFont.systemFontOfSize(style.stateFont)
        self.addSubview(state!)
        
        forgetButton = UIButton(frame:CGRectMake(frame.size.width/2 - 60, view.frame.origin.y + view.frame.height - 20, 120, 30))
        forgetButton!.titleLabel?.font = UIFont.systemFontOfSize(14)
        forgetButton!.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        forgetButton!.setTitle("忘记手势密码", forState: UIControlState.Normal)
        forgetButton!.addTarget(self, action: Selector("forget"), forControlEvents: UIControlEvents.TouchDown)
        self.addSubview(forgetButton!)
        
        if versionLabel == nil {
            versionLabel = UILabel(frame: CGRectMake(B.SCREEN_WIDTH / 2 - 100, B.SCREEN_HEIGHT - 38, 200, 30))
            versionLabel.font = UIFont.systemFontOfSize(13)
            versionLabel.textColor = UIColor.blackColor()
            versionLabel.textAlignment = NSTextAlignment.Center
            let infoDict:NSDictionary = NSBundle.mainBundle().infoDictionary!
            let version = infoDict.objectForKey("CFBundleShortVersionString") as! String
            let build = infoDict.objectForKey("CFBundleVersion") as! String
            versionLabel.text = "version:" + version + " build:" + build
            self.addSubview(versionLabel)
        }

        
        changeButton = UIButton(frame:CGRectMake(frame.size.width/2+30, frame.size.height/2+220, 120, 30))
        changeButton!.titleLabel?.font = UIFont.systemFontOfSize(14)
        changeButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        changeButton!.setTitle("修改手势密码", forState: UIControlState.Normal)
        changeButton!.addTarget(self, action: Selector("change"), forControlEvents: UIControlEvents.TouchDown)
        self.addSubview(changeButton!)
        
       self.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1) //B.GP_VIEW_BG
        
    }

    required init?(coder aDecoder: NSCoder) {
    
        super.init(coder: aDecoder)
    }
    
    func initView(){
        //print("version:\(Device.version())")
        switch Device.version() {
        case .iPhone4, .iPhone4S:
            self.style = GesturePasswordStyle(
                gestureViewSize: 280,
                gestureViewMargin: 15,
                imgSize: 66,
                stateFont: 15,
                usernameMargin: 15,
                usernameFont: 13,
                imgTopMargin: 30
            )
        case .iPhone5, .iPhone5C, .iPhone5S:
            self.style = GesturePasswordStyle(
                gestureViewSize: 280,
                gestureViewMargin: 15,
                imgSize: 70,
                stateFont: 17,
                usernameMargin: 20,
                usernameFont: 15,
                imgTopMargin: 50
            )
        case .iPhone6, .iPhone6S:
            if UIScreen.mainScreen().bounds.width < 375 {
                self.style = GesturePasswordStyle(
                    gestureViewSize: 280,
                    gestureViewMargin: 15,
                    imgSize: 70,
                    stateFont: 17,
                    usernameMargin: 20,
                    usernameFont: 15,
                    imgTopMargin: 50
                )
            } else {
                self.style = GesturePasswordStyle(
                    gestureViewSize: 340,
                    gestureViewMargin: 15,
                    imgSize: 90,
                    stateFont: 20,
                    usernameMargin: 35,
                    usernameFont: 18,
                    imgTopMargin: 60
                )
            }
        case .iPhone6Plus, .iPhone6SPlus:
            if UIScreen.mainScreen().bounds.width < 540 {
                self.style = GesturePasswordStyle(
                    gestureViewSize: 340,
                    gestureViewMargin: 15,
                    imgSize: 90,
                    stateFont: 20,
                    usernameMargin: 35,
                    usernameFont: 18,
                    imgTopMargin: 60
                )
            } else {
                self.style = GesturePasswordStyle(
                    gestureViewSize: 380,
                    gestureViewMargin: 15,
                    imgSize: 110,
                    stateFont: 22,
                    usernameMargin: 45,
                    usernameFont: 20,
                    imgTopMargin: 60
                )
            }
        default:
            self.style = GesturePasswordStyle()
        }
    }
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
//    override func drawRect(rect: CGRect) {
//        // Drawing code
//        
//        var context = UIGraphicsGetCurrentContext();
//
//        var rgb = CGColorSpaceCreateDeviceRGB();
//        var colors:[CGFloat] = [26/255,66/255,56/255,1.0,26/255,44/255,56/255,1.0]
//
//        var  nilUnsafePointer:UnsafePointer<CGFloat> = nil
//
//        var gradient = CGGradientCreateWithColorComponents(rgb, colors, nilUnsafePointer,2)
//
//        CGGradientDrawingOptions()
//
//        CGContextDrawLinearGradient(context, gradient, CGPointMake(0.0,0.0),CGPointMake(0.0,self.frame.size.height), 0)
//        
//        
//        
//    }
    
    
    func gestureTouchBegin(){
        
        self.state!.text = ""
    }
    
    
    func forget(){
        
        userDefaultsUtil.setForgetGesturePassword("aaa")
        if(gesturePasswordDelegate != nil){
            gesturePasswordDelegate!.forget()
            
        }
    }
    
    func change(){
        if(gesturePasswordDelegate != nil){
            gesturePasswordDelegate!.change()
        }
    }

}
