//
//  PersonalDetailsViewController.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/9/9.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation

class PersonalDetailsViewController:BaseTableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate{
    
    
    @IBOutlet weak var usernameLab: UILabel!            //用户名称
    @IBOutlet weak var avatarImg: UIImageView!          //头像

    @IBOutlet weak var mobileLab: UILabel!
    
    var picker:UIImagePickerController!
    
    let userCenterService = UserCenterService.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //加载初始化视图
        initView()
        addHeadView()
        addFootView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        showAvatar()
        usernameLab.text = userDefaultsUtil.getUsername()!
    }
    
    func initView() {
        initNav("个人信息")
        mobileLab.text = userDefaultsUtil.showMobile()
    }
    
    func addHeadView(){
        let screenWidth = UIScreen.mainScreen().bounds.width
        let headView = UIView(frame: CGRectMake(0, 0, screenWidth, 15))
        headView.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        self.tableView.tableHeaderView = headView
    }
    
    //加入foot
    func addFootView(){
        let screenWidth = UIScreen.mainScreen().bounds.width
        let footView = UIView(frame: CGRectMake(0, 0, screenWidth, UIScreen.mainScreen().bounds.height - 300))
        let webView = UIWebView(frame: CGRectMake(5, 15, screenWidth - 10, UIScreen.mainScreen().bounds.height - 275))
        webView.layer.cornerRadius = 5
        webView.backgroundColor = B.VIEW_BG
        footView.addSubview(webView)
        let urlobj = NSURL(string: B.ROLE_VIP)
        let request = NSURLRequest(URL: urlobj!)
        webView.loadRequest(request)
        
        self.tableView.tableFooterView = footView
    }
    
    //显示头像
    func showAvatar(){
        self.avatarImg.image = PhotoUtils.showAvatar()
        avatarImg.layer.cornerRadius = 20
        avatarImg.layer.borderWidth = 2
        avatarImg.layer.masksToBounds = true
        avatarImg.layer.borderColor = UIColor(red: 190/255, green: 158/255, blue: 118/255, alpha: 0.5).CGColor
    }
    
    @IBAction func updateAvatarClick(sender: AnyObject) {
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let dic = info as NSDictionary
        //编辑过后的图片
        let editedImage = dic.objectForKey("UIImagePickerControllerEditedImage") as! UIImage
        //MediaType
        _ = dic.objectForKey("UIImagePickerControllerMediaType") as! String
        let oldImg:UIImage = avatarImg.image!
        let newImg:UIImage = PhotoUtils.thumbnailWithImageWithoutScale(editedImage, toSize: CGSize(width: 84, height: 84))
        avatarImg.image = newImg
        //更换头像动画
        avatarImg.rotate360WithDuration(2.0, repeatCount: 1, timingMode: i7Rotate360TimingModeLinear)
        avatarImg.animationDuration = 2.0
        avatarImg.animationImages = [newImg, oldImg, oldImg, oldImg, oldImg, newImg]
        avatarImg.animationRepeatCount = 1
        avatarImg.startAnimating()
        PhotoUtils.saveImage(avatarImg.image!)
        uploadAvatar()
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func uploadAvatar(){
        userCenterService.uploadAvatar()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){

//        if indexPath.row == 2 {
//            self.info_cid = B.ROLE_VIP
//            infoShow()
//        }

    }
    
    
}