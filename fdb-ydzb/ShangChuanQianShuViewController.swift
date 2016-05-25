//
//  ShangChuanQianShuViewController.swift
//  fdb-ydzb
//
//  Created by 123 on 16/5/9.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation

protocol ShangChuanQianShuViewControllerDelegate{
    
    func sendValue1(orderId:String?,addrId:String?)
}


class ShangChuanQianShuViewController:BaseViewController , UIImagePickerControllerDelegate,UINavigationControllerDelegate ,UIActionSheetDelegate{
    var delegate:ShangChuanQianShuViewControllerDelegate?
    var orderId : String!
    var addrId : String!
    let fenLei = ProductMainService.getInstance()
    @IBOutlet weak var myImage: UIImageView!
    var picker:UIImagePickerController!
    var str11 = ""
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initView()
        
        
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.navigationBarHidden = true
    }
    func initView(){
        
        
    }
    
    @IBAction func tiJiaoButton(sender: AnyObject) {
        if str11 == ""{
          KGXToast.showToastWithMessage("请上传签署照片", duration: ToastDisplayDuration.LengthShort)
        }else{
            print(orderId)
          fenLei.shangChuanQianShu(orderId, pic: str11, calback: { (data) -> () in
            if data as! String == "成功"{
                
                self.delegate?.sendValue1(self.orderId, addrId: self.addrId)
                self.navigationController!.navigationBarHidden = false
                self.navigationController?.popViewControllerAnimated(true)
            }else{
                
            }
          })
            
        }
        
    }
    @IBAction func shangChuanButton(sender: AnyObject) {
        let actionSheet:UIActionSheet = UIActionSheet()
        actionSheet.addButtonWithTitle("取消")
        actionSheet.addButtonWithTitle("拍照")
        actionSheet.addButtonWithTitle("从手机相册中选取")
        
//        let label = UILabel(frame: CGRectMake(actionSheet.bounds.size.width / 2 , 10, B.SCREEN_WIDTH - 60 - 60, 40))
//        label.text = "拍照"
//        label.font = UIFont.systemFontOfSize(15)
//        label.textAlignment = NSTextAlignment.Center
//        label.textColor = UIColor(red: 106/255, green: 136/255, blue: 150/255, alpha: 1)
//        actionSheet.addSubview(label)

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
        myImage.image = editedImage
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
            
            str11 = data.base64EncodedString()as String
//            print(str1)
            
            
        }
        
    }

    @IBAction func back(sender: AnyObject) {
       self.navigationController!.navigationBarHidden = false
       self.navigationController?.popViewControllerAnimated(true)
    }
    
    
}