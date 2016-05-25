//
//  ShangChuanDaKuanViewController.swift
//  fdb-ydzb
//
//  Created by 123 on 16/4/25.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation

protocol ShangChuanDaKuanViewControllerDelegate{
    
    func sendValue33(orderId:String?,addrId:String?)
}



class ShangChuanDaKuanViewController:BaseViewController , UICollectionViewDelegate , UICollectionViewDataSource , UIActionSheetDelegate  , UIImagePickerControllerDelegate ,UINavigationControllerDelegate {
    var orderId :String!
    var photeArr : NSMutableArray!
    var photeBase : NSMutableArray!
    
    @IBOutlet weak var tiJIaoButton: UIButton!
    var picker:UIImagePickerController!
    var addrId : String!
    var collection : UICollectionView!
    let geRenService = GeRenService.getInstance()
    @IBOutlet weak var xingMIng: UITextField!
    @IBOutlet weak var shenFenZheng: UITextField!
    @IBOutlet weak var yinHangKa: UITextField!
    @IBOutlet weak var daKuan: UITextField!
    @IBOutlet weak var beiZhu: UITextField!
    
    var photeStr : String!
    var delegate:ShangChuanDaKuanViewControllerDelegate?
    @IBOutlet weak var myView: UIView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initView()
        photeArr = NSMutableArray()
        photeBase = NSMutableArray()
        
        xingMIng.delegate = self
        shenFenZheng.delegate = self
        shenFenZheng.tag = 1002
        yinHangKa.delegate = self
        yinHangKa.tag = 1001
        daKuan.delegate = self
        daKuan.tag = 1003
        beiZhu.delegate = self

    }
    override func textFieldShouldReturn(textField: UITextField) -> Bool {
        xingMIng.resignFirstResponder()
        shenFenZheng.resignFirstResponder()
        yinHangKa.resignFirstResponder()
        daKuan.resignFirstResponder()
        beiZhu.resignFirstResponder()
        
        return true
    }

    
    func initView(){
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake((B.SCREEN_WIDTH - 40 - 40 ) / 3  ,(B.SCREEN_WIDTH - 40 - 40 ) / 3)
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        collection = UICollectionView(frame: CGRectMake(0, 0, B.SCREEN_WIDTH - 40, B.SCREEN_HEIGHT / 2 - 40 ), collectionViewLayout: layout)
        collection?.backgroundColor = UIColor.clearColor()
        collection?.delegate = self
        collection?.dataSource = self
        collection?.registerClass(ShangChuanCollectionCell.self, forCellWithReuseIdentifier: "ShangChuanDaKuanViewController")
        collection?.registerClass(TianJiaPhoteCell.self, forCellWithReuseIdentifier: "TianJiaPhoteCell")

        self.myView.addSubview(collection!)
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if photeArr == nil{
            return 1
        }else if photeArr.count < 6 {
        return photeArr.count + 1
        }else{
            return photeArr.count
        }
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        if photeArr.count == 0{
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TianJiaPhoteCell", forIndexPath: indexPath) as! TianJiaPhoteCell
            cell.button?.addTarget(self,action:Selector("myButton:"),forControlEvents:.TouchUpInside)
            return cell
        }else if photeArr.count < 6{
            if indexPath.row < photeArr.count{
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ShangChuanDaKuanViewController", forIndexPath: indexPath) as! ShangChuanCollectionCell
//                cell.imageView!.image = UIImage(named:"phone-1")
                cell.imageView?.image = photeArr.objectAtIndex(indexPath.row) as? UIImage
                cell.button?.addTarget(self, action: Selector("shanChunButton:"), forControlEvents: .TouchUpInside)
                cell.button?.tag = indexPath.row
                return cell
            }else{
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TianJiaPhoteCell", forIndexPath: indexPath) as! TianJiaPhoteCell
                cell.button?.addTarget(self,action:Selector("myButton:"),forControlEvents:.TouchUpInside)
                return cell
            }
            
            
        }else {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ShangChuanDaKuanViewController", forIndexPath: indexPath) as! ShangChuanCollectionCell
                cell.imageView?.image = photeArr.objectAtIndex(indexPath.row) as? UIImage
            cell.button?.addTarget(self, action: Selector("shanChunButton:"), forControlEvents: .TouchUpInside)
            cell.button?.tag = indexPath.row
            return cell
        }
    }
    func shanChunButton(button: UIButton){
        xingMIng.resignFirstResponder()
        shenFenZheng.resignFirstResponder()
        yinHangKa.resignFirstResponder()
        daKuan.resignFirstResponder()
        beiZhu.resignFirstResponder()
        photeArr.removeObjectAtIndex(button.tag)
        photeBase.removeObjectAtIndex(button.tag)
        print(photeArr.count)
        print(photeBase.count)
        collection.reloadData()
        
    }

    func myButton(button:UIButton){
        xingMIng.resignFirstResponder()
        shenFenZheng.resignFirstResponder()
        yinHangKa.resignFirstResponder()
        daKuan.resignFirstResponder()
        beiZhu.resignFirstResponder()
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
//        print(dic)
        print(editedImage)
        photeArr.addObject(editedImage)
        collection.reloadData()
//        avatarBtn.setImage(editedImage, forState: UIControlState.Normal)
//        PhotoUtils.saveImage(editedImage)
//        uploadAvatar()
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
            photeBase.addObject(str1)
        
        }
    }
    
    func uploadAvatar(){
//        userCenterService.uploadAvatar()
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.tag == 1003{
            textField.keyboardType = UIKeyboardType.NumberPad
          
                        self.view.userInteractionEnabled = true
                        let tapGR = UITapGestureRecognizer(target: self, action: "touXiang:")
                        self.view.addGestureRecognizer(tapGR)

        }
    }
    func touXiang(sender:UITapGestureRecognizer){
        self.daKuan.resignFirstResponder()
    }

    
    
    
    @IBAction func tiJiao(sender: AnyObject) {
        xingMIng.resignFirstResponder()
        shenFenZheng.resignFirstResponder()
        yinHangKa.resignFirstResponder()
        daKuan.resignFirstResponder()
        beiZhu.resignFirstResponder()

        photeStr = ""
        for var i = 0; i < photeBase.count; ++i {
            let str = photeBase[i]
            photeStr =  photeStr  + (str as! String) + ","
            
//            print(photeStr)
//            print(photeBase.count)
        }
//        print(photeBase.count)
//        print(photeStr)
        if xingMIng.text == ""{
            KGXToast.showToastWithMessage("请输入客户姓名", duration: ToastDisplayDuration.LengthShort)
        }else if shenFenZheng.text == ""{
            KGXToast.showToastWithMessage("请输入身份证号", duration: ToastDisplayDuration.LengthShort)
        }else if yinHangKa.text == ""{
            KGXToast.showToastWithMessage("请输入银行卡号", duration: ToastDisplayDuration.LengthShort)
        }else if daKuan.text == ""{
            KGXToast.showToastWithMessage("请输入打款金额", duration: ToastDisplayDuration.LengthShort)
        }else if beiZhu.text == ""{
            KGXToast.showToastWithMessage("请输入备注信息", duration: ToastDisplayDuration.LengthShort)
        }else if !RegexUtil("^[0-9]*$").test(daKuan.text!){
            KGXToast.showToastWithMessage("请输入正确打款金额", duration: ToastDisplayDuration.LengthShort)
        }else if !RegexUtil("^[0-9]*$").test(yinHangKa.text!){
            KGXToast.showToastWithMessage("请输入正确银行卡号", duration: ToastDisplayDuration.LengthShort)
        }else if !RegexUtil("^[a-zA-Z0-9]{15}$").test(shenFenZheng.text!) && !RegexUtil("^[a-zA-Z0-9]{18}$").test(shenFenZheng.text!){
            KGXToast.showToastWithMessage("身份证号格式不正确", duration: ToastDisplayDuration.LengthShort)
        }else if photeStr == ""{
            KGXToast.showToastWithMessage("请添加凭证照片", duration: ToastDisplayDuration.LengthShort)
        }else{
            print(photeBase.count)
        tiJIaoButton.enabled = false
        geRenService.shangChun(orderId, pics: photeStr, realName: xingMIng.text!, cardNumb: shenFenZheng.text!, bankNumb: yinHangKa.text!, remitvalue: daKuan.text!, remark: beiZhu.text!) { (data) -> () in
            if data as! String == "成功"{
                self.delegate?.sendValue33(self.orderId, addrId: self.addrId)
                self.navigationController!.navigationBarHidden = false
                self.navigationController?.popViewControllerAnimated(true)
            }else{
                self.navigationController!.navigationBarHidden = false
                self.navigationController?.popViewControllerAnimated(true)
            }
            }
        }
        
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == 1001 {
            if range.location > 19 {
                return false
            }else{
                return true
            }
        }else if textField.tag == 1002 {
            if range.location > 17 {
                return false
            }else{
                return true
            }
        }

        
        return true
    }

    @IBAction func back(sender: AnyObject) {
        self.navigationController!.navigationBarHidden = false
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    
    
    
    
    
}

