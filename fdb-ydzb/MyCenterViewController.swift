//
//  MyCenterViewController.swift
//  fdb-ydzb
//
//  Created by 123 on 16/4/9.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation
class MyCenterViewController: BaseViewController , UMSocialUIDelegate, UIImagePickerControllerDelegate ,UINavigationControllerDelegate ,UIActionSheetDelegate  {
    @IBOutlet weak var touXiang: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    let homeService = HomeService.getInstance()
    let geRenService = GeRenService.getInstance()
    var picker:UIImagePickerController!
    @IBOutlet weak var daoShouJinE: UIButton!
    @IBOutlet weak var changGuiSheZhi: UIButton!
    @IBOutlet weak var chanPinGongGao: UIButton!
    @IBOutlet weak var geRenZhongXin: UIButton!
    @IBOutlet weak var my_lable_money: UILabel!
    @IBOutlet weak var my_label_leiji: UILabel!
    @IBOutlet weak var my_label2_changgui: UILabel!
    @IBOutlet weak var my_label3_chanpin: UILabel!
    @IBOutlet weak var my_label4_geren: UILabel!
    @IBOutlet weak var my_leiji: UIImageView!
    @IBOutlet weak var my_shezhi: UIImageView!
    @IBOutlet weak var my_geren: UIImageView!
    
    var  phote : String!
    var  name11 : String!
    var  allIncome : String!
    var  regMobile : String!
    
    var fenXiang_title : String!
    var fenXiang_content : String!
    var fenXiang_url : String!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        initView()
        self.loadingShow()
        if !userDefaultsUtil.isLoggedIn(){
        self.loadingHidden()
        self.my_lable_money.text = "￥0.00"
        }else{
        
        homeService.my {
            (data) -> () in
            self.loadingHidden()
            if let hm = data as? MyModel {
                self.phote = hm.photoUrl
                self.name11 = hm.name
                self.allIncome = hm.allIncome
                self.regMobile = hm.regMobile
                print(self.name11)
                self.name.text = self.name11
                self.homeService.woDeFenXaing(self.regMobile) { (data) -> () in
                    if let hm = data as? MyFenXiangModel{
                      self.fenXiang_title = hm.title
                      self.fenXiang_content = hm.content
                      self.fenXiang_url = hm.url
                    }
                }

                if hm.allIncome == ""{
                   self.my_lable_money.text = "￥0.00"
                }else{
                self.my_lable_money.text = "￥\(hm.allIncome)"
                }
                if hm.photoUrl == ""{
                self.touXiang.image = UIImage(named: "Avatar@2x(1)")
                }else{
                self.touXiang.sd_setImageWithURL(NSURL(string: hm.photoUrl), placeholderImage: UIImage(named: "Avatar@2x(1)"))
                }
             }
            
           }
        }
        
        
        
    }
   
    func initView(){
        touXiang.layer.cornerRadius = 45
        touXiang.layer.masksToBounds = true
        
//        name.delegate = self
       self.navigationController!.navigationBarHidden = true
        if !userDefaultsUtil.isLoggedIn(){
            name.resignFirstResponder()
            name.userInteractionEnabled = false
            my_lable_money.textColor = UIColor(red: 94/255, green: 94/255, blue: 97/255, alpha: 1)
            my_label_leiji.textColor = UIColor(red: 94/255, green: 94/255, blue: 97/255, alpha: 1)
            my_leiji.image = UIImage(named: "leijiyongjin")
//            my_shezhi.image = UIImage(named: "changguishezhi")
            my_geren.image = UIImage(named: "gerenzhongxin")
//            my_label2_changgui.textColor = UIColor(red: 94/255, green: 94/255, blue: 97/255, alpha: 1)
            my_label4_geren.textColor = UIColor(red: 94/255, green: 94/255, blue: 97/255, alpha: 1)
            
            name.text = "未登录"
            name.userInteractionEnabled = true
            let tapGR1 = UITapGestureRecognizer(target: self, action: "name:")
            name.addGestureRecognizer(tapGR1)

            touXiang.image = UIImage(named: "Avatar@2x(1)")
            touXiang.userInteractionEnabled = true
            let tapGR = UITapGestureRecognizer(target: self, action: "touXiang:")
            touXiang.addGestureRecognizer(tapGR)

//            chanPinGongGao.addTarget(self,action:Selector("chanPinGongGao:"),forControlEvents:.TouchDown)
        }else{
//            name.resignFirstResponder()
            name.userInteractionEnabled = true
            let tapGR1 = UITapGestureRecognizer(target: self, action: "name:")
            name.addGestureRecognizer(tapGR1)
            
            touXiang.userInteractionEnabled = true
            let tapGR = UITapGestureRecognizer(target: self, action: "tapHandler:")
            touXiang.addGestureRecognizer(tapGR)
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool{
        if !userDefaultsUtil.isLoggedIn(){
            let twoStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let twoController:LoginViewController = twoStoryBoard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            twoController.hidesBottomBarWhenPushed = true
            //                self.navigationController?.pushViewController(twoController, animated: false)
            self.presentViewController(twoController, animated: true, completion: nil)
            return false
        }else{
            return true
        }
    }
    override func textFieldShouldReturn(textField: UITextField) -> Bool{
        
        name.resignFirstResponder()
        homeService.fixName(self.name.text!) { (data) -> () in
         
        }
        return true
    }

    func tapHandler(sender:UITapGestureRecognizer) {
       
        if !userDefaultsUtil.isLoggedIn(){
            let twoStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let twoController:LoginViewController = twoStoryBoard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            twoController.hidesBottomBarWhenPushed = true
            self.presentViewController(twoController, animated: true, completion: nil)
        }else{
            
           print("头像")
            let actionSheet:UIActionSheet = UIActionSheet()
            actionSheet.addButtonWithTitle("取消")
            actionSheet.addButtonWithTitle("拍照")
            actionSheet.addButtonWithTitle("从手机相册中选取")
            actionSheet.cancelButtonIndex = 0
            actionSheet.delegate = self
            actionSheet.showInView(self.view)

        }
        
    }
    //头像图片选择
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 1://相机
            picker = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.delegate = self
            picker.allowsEditing = true
            self.presentViewController(picker, animated: true, completion: nil)
        case 2://相册
            picker = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self.presentViewController(picker, animated: true, completion: nil)
        default:
            break
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let dic = info as NSDictionary
        //编辑过后的图片
        let editedImage = dic.objectForKey("UIImagePickerControllerEditedImage") as! UIImage
        touXiang.image = editedImage
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        let mediaType = dic.objectForKey(UIImagePickerControllerMediaType)
        let originalImage : UIImage
        let editedImage1 : UIImage
        let imageToSave : UIImage
        if ((mediaType?.isEqualToString("public.image")) != nil){
            editedImage1 = dic.objectForKey(UIImagePickerControllerEditedImage) as! UIImage
            originalImage = dic.objectForKey(UIImagePickerControllerOriginalImage) as! UIImage
            
            if editedImage1 != "" {
                imageToSave = editedImage1
            }else{
                imageToSave = originalImage
            }
            imageToSave.imageByScalingProportionallyToMinimumSize(CGSizeMake(100,100))
            print(imageToSave)
            let data : NSData = UIImageJPEGRepresentation(imageToSave, 0.1)!
            //            print(data)
            
            let str1 = data.base64EncodedString()as String
            print(str1)
            self.loadingShow()
            geRenService.touXiang(str1) { (data) -> () in
                self.loadingHidden()
                self.homeService.my {
                    (data) -> () in
                    self.loadingHidden()
                    if let hm = data as? MyModel {
                        self.phote = hm.photoUrl
                        self.name11 = hm.name
                        self.allIncome = hm.allIncome
                        print(self.name11)
                        self.name.text = self.name11
                        
                        if hm.allIncome == ""{
                            self.my_lable_money.text = "￥0.00"
                        }else{
                            self.my_lable_money.text = "￥\(hm.allIncome)"
                        }
                        if hm.photoUrl == ""{
                            self.touXiang.image = UIImage(named: "Avatar@2x(1)")
                        }else{
                            self.touXiang.sd_setImageWithURL(NSURL(string: hm.photoUrl), placeholderImage: UIImage(named: "Avatar@2x(1)"))
                        }
                    }
                    
                }

            }
            
        }

    }

    @IBAction func daoShouJinE(sender: AnyObject) {
        
        if !userDefaultsUtil.isLoggedIn(){
            KGXToast.showToastWithMessage("请登录账号", duration: ToastDisplayDuration.LengthShort)
        }else{
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.my_lable_money.textColor = B.NAV_TITLE_CORLOR
                self.my_label_leiji.textColor = B.NAV_TITLE_CORLOR
                self.daoShouJinE.backgroundColor = UIColor(red: 57/255, green: 59/255, blue: 63/255, alpha: 1)
                self.daoShouJinE.layer.shadowOffset =  CGSizeMake(0, 0)
                self.daoShouJinE.layer.shadowOpacity = 0.8
                self.daoShouJinE.layer.shadowColor = UIColor.blackColor().CGColor
                }, completion: { (Bool) -> Void in
                    self.my_lable_money.textColor = UIColor.whiteColor()
                    self.my_label_leiji.textColor = UIColor.whiteColor()
                    self.daoShouJinE.backgroundColor = UIColor(red: 49/255, green: 51/255, blue: 55/255, alpha: 1)
                    self.daoShouJinE.layer.shadowOffset =  CGSizeMake(0, 0)
                    self.daoShouJinE.layer.shadowOpacity = 0
                    self.daoShouJinE.layer.shadowColor = UIColor.blackColor().CGColor
                    let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
                    let rpvc:DaoShouMoneyViewcontroller = oneStoryBoard.instantiateViewControllerWithIdentifier("DaoShouMoneyViewcontroller") as! DaoShouMoneyViewcontroller
                    rpvc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(rpvc, animated: true)
                    
            })
        }
    }

    @IBAction func changGuiSheZhi(sender: AnyObject) {
        
//        if !userDefaultsUtil.isLoggedIn(){
//            KGXToast.showToastWithMessage("请登录账号", duration: ToastDisplayDuration.LengthShort)
//        }else{
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                print("qqq")
                self.my_label2_changgui.textColor = B.NAV_TITLE_CORLOR
                self.changGuiSheZhi.backgroundColor = UIColor(red: 57/255, green: 59/255, blue: 63/255, alpha: 1)
                self.changGuiSheZhi.layer.shadowOffset =  CGSizeMake(0, 0)
                self.changGuiSheZhi.layer.shadowOpacity = 0.8
                self.changGuiSheZhi.layer.shadowColor = UIColor.blackColor().CGColor
                }, completion: { (Bool) -> Void in
                 print("4444444")
                    self.my_label2_changgui.textColor = UIColor.whiteColor()
                    self.changGuiSheZhi.backgroundColor = UIColor(red: 49/255, green: 51/255, blue: 55/255, alpha: 1)
                    self.changGuiSheZhi.layer.shadowOffset =  CGSizeMake(0, 0)
                    self.changGuiSheZhi.layer.shadowOpacity = 0
                    self.changGuiSheZhi.layer.shadowColor = UIColor.blackColor().CGColor
                    let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
                    let rpvc:ChangGuiSheZhiViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ChangGuiSheZhiViewController") as! ChangGuiSheZhiViewController
                    rpvc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(rpvc, animated: true)
                    print("常规设置")

            })
            
//         }
    }


    
    
    @IBAction func chanPinGongGao(sender: AnyObject) {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.my_label3_chanpin.textColor = B.NAV_TITLE_CORLOR
            self.chanPinGongGao.backgroundColor = UIColor(red: 57/255, green: 59/255, blue: 63/255, alpha: 1)
            self.chanPinGongGao.layer.shadowOffset =  CGSizeMake(0, 0)
            self.chanPinGongGao.layer.shadowOpacity = 0.8
            self.chanPinGongGao.layer.shadowColor = UIColor.blackColor().CGColor
            }, completion: { (Bool) -> Void in
                self.my_label3_chanpin.textColor = UIColor.whiteColor()
                self.chanPinGongGao.backgroundColor = UIColor(red: 49/255, green: 51/255, blue: 55/255, alpha: 1)
                self.chanPinGongGao.layer.shadowOffset =  CGSizeMake(0, 0)
                self.chanPinGongGao.layer.shadowOpacity = 0
                self.chanPinGongGao.layer.shadowColor = UIColor.blackColor().CGColor
                let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
                let rpvc:ChanPinGongGaoViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ChanPinGongGaoViewController") as! ChanPinGongGaoViewController
                rpvc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(rpvc, animated: true)
                
        })
        print("产品公告")
        
    }

    @IBAction func geRenZhongXin(sender: AnyObject) {
        if !userDefaultsUtil.isLoggedIn(){
            KGXToast.showToastWithMessage("请登录账号", duration: ToastDisplayDuration.LengthShort)
        }else{
        print("个人中心")
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.my_label4_geren.textColor = B.NAV_TITLE_CORLOR
                self.geRenZhongXin.backgroundColor = UIColor(red: 57/255, green: 59/255, blue: 63/255, alpha: 1)
                self.geRenZhongXin.layer.shadowOffset =  CGSizeMake(0, 0)
                self.geRenZhongXin.layer.shadowOpacity = 0.8
                self.geRenZhongXin.layer.shadowColor = UIColor.blackColor().CGColor
                }, completion: { (Bool) -> Void in
                    self.my_label4_geren.textColor = UIColor.whiteColor()
                    self.geRenZhongXin.backgroundColor = UIColor(red: 49/255, green: 51/255, blue: 55/255, alpha: 1)
                    self.geRenZhongXin.layer.shadowOffset =  CGSizeMake(0, 0)
                    self.geRenZhongXin.layer.shadowOpacity = 0
                    self.geRenZhongXin.layer.shadowColor = UIColor.blackColor().CGColor
                    let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
                    let rpvc:GeRenCenterViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("GeRenCenterViewController") as! GeRenCenterViewController
                    if self.phote != nil{
                        rpvc.myPhote = self.phote
                        rpvc.name = self.name11
                    }
                    rpvc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(rpvc, animated: true)
            })

        }
    }

    func touXiang(sender:UITapGestureRecognizer) {
        let twoStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let twoController:LoginViewController = twoStoryBoard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        twoController.hidesBottomBarWhenPushed = true
        self.presentViewController(twoController, animated: true, completion: nil)
    }
    func name(sender:UITapGestureRecognizer){
        if !userDefaultsUtil.isLoggedIn(){
            let twoStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let twoController:LoginViewController = twoStoryBoard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            twoController.hidesBottomBarWhenPushed = true
            self.presentViewController(twoController, animated: true, completion: nil)

        }else{

                let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
                let rpvc:NameGengGaiViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("NameGengGaiViewController") as! NameGengGaiViewController
                rpvc.name = self.name11
                rpvc.regMobile = self.regMobile
                rpvc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(rpvc, animated: true)
        }
    }
    
    @IBAction func fenXiang(sender: AnyObject) {
        print("分享")
        if !userDefaultsUtil.isLoggedIn(){
            let twoStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let twoController:LoginViewController = twoStoryBoard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            twoController.hidesBottomBarWhenPushed = true
            self.presentViewController(twoController, animated: true, completion: nil)
        }else{
        UMSocialSnsService.presentSnsIconSheetView(self, appKey: B.UMENG_APP_KEY, shareText: "分享", shareImage: UIImage(named:"referral_share_icon"), shareToSnsNames: [UMShareToWechatSession, UMShareToWechatTimeline/*, UMShareToSina, UMShareToQQ, UMShareToQzone*/], delegate: self)
        
        //注册地址 + 推荐码
        let url = B.SOCIAL_REGISTER_ADDRESS //+ self.referralCodeLab.text!
        let title = "不知道要分享什么"
        let shareText = "还是不知道"
        let shareImage = UIImage(named: "referral_share_icon")
            
        print(self.fenXiang_url)
        //微信好友与朋友圈
        UMSocialData.defaultData().extConfig.wechatSessionData.url = self.fenXiang_url
        UMSocialData.defaultData().extConfig.wechatTimelineData.url = self.fenXiang_url
        UMSocialData.defaultData().extConfig.wechatSessionData.title = self.fenXiang_title
        UMSocialData.defaultData().extConfig.wechatTimelineData.title = self.fenXiang_title
        UMSocialData.defaultData().extConfig.wechatSessionData.shareText = self.fenXiang_content
        UMSocialData.defaultData().extConfig.wechatTimelineData.shareText = self.fenXiang_content
        UMSocialData.defaultData().extConfig.wechatTimelineData.shareImage = shareImage
        UMSocialData.defaultData().extConfig.wechatSessionData.shareImage = shareImage
        UMSocialData.defaultData().extConfig.wxMessageType = UMSocialWXMessageTypeWeb
        //新浪分享
        UMSocialData.defaultData().extConfig.sinaData.urlResource.setResourceType(UMSocialUrlResourceTypeDefault, url: url)
        UMSocialData.defaultData().extConfig.sinaData.shareText = "戳这里 秒变壕! 携手银多，跟我一起壕!" + url
        UMSocialData.defaultData().extConfig.sinaData.shareImage = UIImage(named: "referral_share_icon")
        UMSocialData.defaultData().extConfig.sinaData.snsName = "银多资本"
        //QQ与Qzone
        UMSocialData.defaultData().extConfig.qqData.url = url
        UMSocialData.defaultData().extConfig.qzoneData.url = url
        UMSocialData.defaultData().extConfig.qqData.title = title
        UMSocialData.defaultData().extConfig.qzoneData.title = title
        UMSocialData.defaultData().extConfig.qqData.shareText  = shareText
        UMSocialData.defaultData().extConfig.qzoneData.shareText  = shareText
        UMSocialData.defaultData().extConfig.qqData.shareImage  = shareImage
        UMSocialData.defaultData().extConfig.qzoneData.shareImage = shareImage

        }
    }
    
    
}