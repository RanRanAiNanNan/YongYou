//
//  GeRenCenterViewController.swift
//  fdb-ydzb
//
//  Created by 123 on 16/4/13.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation

class GeRenCenterViewController:BaseViewController, UIImagePickerControllerDelegate ,UINavigationControllerDelegate ,UIActionSheetDelegate  {
    let geRenService = GeRenService.getInstance()
    var gesturePasswordDelegate:GesturePasswordDelegate?
    var myPhote = ""
    
    var picker:UIImagePickerController!
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var jiGouLB: UILabel!
    @IBOutlet weak var bankLB: UILabel!
    @IBOutlet weak var addressLB: UILabel!
    @IBOutlet weak var myNameBT: UIButton!
    
    @IBOutlet weak var jiGouRenZhengBT: UIButton!
    var bankInt : Int!
    var renZheng : Int!
    var name : String!
    @IBOutlet weak var shouJiHaoLB: UILabel!
    @IBOutlet weak var zhuCeShouJiHaoLB: UILabel!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initView()
        
        
    }
    override func viewWillAppear(animated: Bool) {
        self.myNameBT.setTitle(name, forState: UIControlState.Normal)
        self.navigationController!.navigationBarHidden = true
        self.loadingShow()
        geRenService.geRen { (data) -> () in
         self.loadingHidden()
            if let hm = data as? GeRenModel{
                 self.zhuCeShouJiHaoLB.text = hm.mobile 
                if hm.isIdentity == "0"{
                    self.jiGouLB.text = "已认证"
//                    self.jiGouRenZhengBT.userInteractionEnabled = true
                    self.renZheng = 3
                }else{
                    self.jiGouLB.text = "未认证"
                    
                    self.renZheng = 0
                }
                if hm.isBank == "0"{
                    self.bankLB.text = "已添加"
                    self.bankInt = 0
                }else{
                    self.bankLB.text = "未添加"
                    self.bankInt = 1
                }
                if hm.isPostAddr == "0"{
                    self.addressLB.text = "已填写"
                }else{
                    self.addressLB.text = "未填写"
                }

                
                
            }
            
        }
        
    }
    
    func initView(){
        
        headImage.layer.cornerRadius = 40
        headImage.layer.masksToBounds = true
        if self.myPhote == ""{
        self.headImage.image = UIImage(named: "Avatar@2x(1)")
        }else{
        self.headImage.sd_setImageWithURL(NSURL(string: self.myPhote), placeholderImage: UIImage(named: "Avatar@2x(1)"))
        }
        self.navigationController!.navigationBarHidden = true
        myImage.userInteractionEnabled = true
        let tapGR = UITapGestureRecognizer(target: self, action: "tapHandler:")
        myImage.addGestureRecognizer(tapGR)

//        headImage.userInteractionEnabled = true
//        let tapGR1 = UITapGestureRecognizer(target: self, action: "headImage:")
//        headImage.addGestureRecognizer(tapGR1)

    }
    func headImage(sender:UITapGestureRecognizer){
        let actionSheet:UIActionSheet = UIActionSheet()
        actionSheet.addButtonWithTitle("取消")
        actionSheet.addButtonWithTitle("拍照")
        actionSheet.addButtonWithTitle("从手机相册中选取")
        actionSheet.cancelButtonIndex = 0
        actionSheet.delegate = self
        actionSheet.showInView(self.view)

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
        headImage.image = editedImage
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
            }

        }
        
    }

    func tapHandler(sender:UITapGestureRecognizer) {
        print("退出登录")
//        userDefaultsUtil.setForgetGesturePassword("aaa")
//        if(gesturePasswordDelegate != nil){
//            gesturePasswordDelegate!.forget()
//            
//        }
//        userDefaultsUtil.setMobile(my.photoUrl)
        
//        AlertUtil.simpleAlert(self, title: "退出提示", msg: "确定退出登录吗？", okBtnTitle: "取消", cancelBtnTitle: "确定")
        if self.bankLB.text == ""{
            KGXToast.showToastWithMessage("无网络连接", duration: ToastDisplayDuration.LengthShort)
        }else{
        let alertView = YoYoAlertView(title: "退出提示", message: "确定退出登录吗？", cancelButtonTitle: "取 消", sureButtonTitle: "确 定")
        alertView.show()
        //获取点击事件
        alertView.clickIndexClosure { (index) in
            print("点击了第" + "\(index)" + "个按钮")
            if index == 1 {
                return
            }else{
                userDefaultsUtil.setTiaoZhuan("")
                userDefaultsUtil.exitSetting()
                KeychainWrapper.removeObjectForKey(kSecValueData as String)
                let twoStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let twoController:LoginViewController = twoStoryBoard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                twoController.hidesBottomBarWhenPushed = true
                self.presentViewController(twoController, animated: true, completion: nil)
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
            
            
        }
        }
        
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 {
            return
        }else{
            userDefaultsUtil.exitSetting()
            KeychainWrapper.removeObjectForKey(kSecValueData as String)
            self.navigationController?.popToRootViewControllerAnimated(true)
            
        }
    }
    @IBAction func leftBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func shenFen(sender: AnyObject) {
        if self.bankLB.text == ""{
        }else{
        if self.renZheng == 3{
            
        }else{
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
        let rpvc:ShenFenViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ShenFenViewController") as! ShenFenViewController
        rpvc.hidesBottomBarWhenPushed = true
        rpvc.renZheng = self.renZheng
        self.navigationController?.pushViewController(rpvc, animated: true)
        }
        }
    }
    @IBAction func address(sender: AnyObject) {
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
        let rpvc:AddressViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("AddressViewController") as! AddressViewController
        rpvc.tiao = "11"
        rpvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(rpvc, animated: true)
    }
    
    @IBAction func fixMiMa(sender: AnyObject) {
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
        let rpvc:FixMiMaViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("FixMiMaViewController") as! FixMiMaViewController
        rpvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(rpvc, animated: true)

        
    }
    @IBAction func addBank(sender: AnyObject) {
        if self.bankLB.text == ""{
            
        }else{
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
        let rpvc:TianJiaBankViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("TianJiaBankViewController") as! TianJiaBankViewController
        rpvc.bankInt = self.bankInt
        rpvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(rpvc, animated: true)
        }
    }
    
    @IBAction func myNameButton(sender: AnyObject) {
//
//        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
//        let rpvc:NameGengGaiViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("NameGengGaiViewController") as! NameGengGaiViewController
//        rpvc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(rpvc, animated: true)
//
//        
//        
    }
    
    
    
}