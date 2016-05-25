//
//  ShenFenViewController.swift
//  fdb-ydzb
//
//  Created by 123 on 16/4/15.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation
class ShenFenViewController:BaseViewController, UIImagePickerControllerDelegate ,UINavigationControllerDelegate ,UIActionSheetDelegate {
    @IBOutlet weak var tiJiaoBT: UIButton!
    let geRenService = GeRenService.getInstance()
    @IBOutlet weak var imageView: UIImageView!
    var picker:UIImagePickerController!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var allView: UIView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var hangYeTF: UITextField!
    var str : String = ""
    var renZheng : Int!
    
    @IBOutlet weak var kuangImage: UIImageView!
    @IBOutlet weak var jiaHaoImage: UIImageView!
    @IBOutlet weak var shenFenLB: UILabel!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initView()
        
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if renZheng == 3 {
        geRenService.jiGouRenZhengLieBiao(renZheng) { (data) -> () in
            if let ucm = data as? JiGouRenZhengLieBiaoModel{
                
                self.nameTF.text = ucm.realName
                self.phoneTF.text = ucm.mobile
                if ucm.picUrl != ""{
                self.imageView.sd_setImageWithURL(NSURL(string: ucm.picUrl), placeholderImage: UIImage(named: "Body"))
                }
                self.hangYeTF.text = ucm.tradetype
               }
            }
        }
        
    }
    
    func initView(){
        
        if renZheng == 3{
           tiJiaoBT.hidden = true
            kuangImage.hidden = true
            jiaHaoImage.hidden = true
            shenFenLB.hidden = true
            nameTF.userInteractionEnabled = false
            phoneTF.userInteractionEnabled = false
            hangYeTF.userInteractionEnabled = false
            imageView.alpha = 1
        }
        
        str = ""
        self.navigationController!.navigationBarHidden = true
        

        self.allView.layer.shadowOpacity = 0.8
        self.allView.layer.shadowColor = UIColor.blackColor().CGColor
        self.allView.layer.shadowOffset = CGSize(width: 1, height: 1)

        jiaHaoImage.userInteractionEnabled = true
        let tapGR1 = UITapGestureRecognizer(target: self, action: "headImage:")
        jiaHaoImage.addGestureRecognizer(tapGR1)
        
        phoneTF.delegate = self
        hangYeTF.delegate = self
        nameTF.delegate = self

    
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
        imageView.image = editedImage
        imageView.alpha = 1
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
//            print(str1)
            str = str1
            
            
        }
    }
    override func textFieldShouldReturn(textField: UITextField) -> Bool {
        phoneTF.resignFirstResponder()
        nameTF.resignFirstResponder()
        hangYeTF.resignFirstResponder()
        return true
    }
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
       
    @IBAction func tiJiao(sender: AnyObject) {
        phoneTF.resignFirstResponder()
        nameTF.resignFirstResponder()
        hangYeTF.resignFirstResponder()

//        print(str)

        if phoneTF.text == ""{
            KGXToast.showToastWithMessage("请输入手机号", duration: ToastDisplayDuration.LengthShort)
        }else if nameTF.text == ""{
            KGXToast.showToastWithMessage("请输入您的姓名", duration: ToastDisplayDuration.LengthShort)
        }else if hangYeTF.text == ""{
            KGXToast.showToastWithMessage("请输入所在行业", duration: ToastDisplayDuration.LengthShort)
            //^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$ 原先的
        }else if !RegexUtil("^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$").test(phoneTF.text!){
            KGXToast.showToastWithMessage("请输入真实手机号", duration: ToastDisplayDuration.LengthShort)
        }else if str == ""{
            KGXToast.showToastWithMessage("请添加认证照片", duration: ToastDisplayDuration.LengthShort)
        }else{
            self.loadingShow()
        geRenService.jiGouRenZheng(phoneTF.text!, realName: nameTF.text!, tradetype: hangYeTF.text!, photo: str ) { (data) -> () in
            self.loadingHidden()
            print("======\(data)")
            if data as! String == "成功"{
                self.navigationController?.popViewControllerAnimated(true)
            }else{
                
            }
            
           }
        }
    }
    
    
}
