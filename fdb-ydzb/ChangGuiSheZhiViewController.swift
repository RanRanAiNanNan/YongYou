//
//  ChangGuiSheZhiViewController.swift
//  fdb-ydzb
//
//  Created by 123 on 16/4/12.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation
class ChangGuiSheZhiViewController:BaseViewController {
    
    @IBOutlet weak var dianHua: UIButton!
    var alertView:UIAlertView?
    var alertPhone:UIAlertView?
    let geRenService = GeRenService.getInstance()
    @IBOutlet weak var keFuDianHua: UIButton!
    var number : String!
    
    @IBOutlet weak var mySwitch: UISwitch!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initView()
        geRenService.changGuiSheZhi { (data) -> () in
            
           self.dianHua.setTitle(data as? String, forState: .Normal)
            self.number = data as! String
        }
        
          //推送
        
        
        if userDefaultsUtil.getTuiSong()! == "开"{
            mySwitch.setOn(true, animated: true)
        }else{
            mySwitch.setOn(false, animated: true)
        }
        
    }
    
    func initView(){
        
        self.navigationController!.navigationBarHidden = true
        
    }
    
    @IBAction func leftBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func weiXinHao(sender: AnyObject) {
   
//        alertView = UIAlertView()
//        alertView!.title = "系统提示"
//        alertView!.message = "您确定要复制微信公众号？"
//        alertView!.addButtonWithTitle("取消")
//        alertView!.addButtonWithTitle("确定")
//        alertView!.tag = 0
//        alertView!.delegate = self;
//        alertView!.show()
        
    }
    
    
    @IBAction func DianHuaHao(sender: AnyObject) {
//        alertPhone = UIAlertView()
//        alertPhone!.title = "系统提示"
//        alertPhone!.message = "您确定要拨打客服热线？"
//        alertPhone!.addButtonWithTitle("取消")
//        alertPhone!.addButtonWithTitle("确定")
//        alertPhone!.tag = 1
//        alertPhone!.delegate=self;
//        alertPhone!.show()

        let alertView = YoYoAlertView(title: "", message: "\(self.number)", cancelButtonTitle: "取消", sureButtonTitle: "呼叫")
        alertView.show()
        //获取点击事件
        alertView.clickIndexClosure { (index) in
            print("点击了第" + "\(index)" + "个按钮")
            if index == 1 {
                return
            }else{
                let url1 = NSURL(string: "tel://\(self.number)")
                UIApplication.sharedApplication().openURL(url1!)
                print("拨打客服确认")

            }
            
            
        }

        
        
        
    }
    
    func alertView(alertView:UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        if alertView.tag == 0 {
            if(buttonIndex==0){
            print("微信号取消")
        }else{
            let copyString = "然然然然"
            let pasteBoard = UIPasteboard.generalPasteboard()
            pasteBoard.string = copyString
            print("微信号确认")
        }
        }else if alertView.tag == 1 {
          if(buttonIndex == 0){
            print("拨打客服取消")
            }else{
            let url1 = NSURL(string: "tel://10086")
            UIApplication.sharedApplication().openURL(url1!)
            print("拨打客服确认")
            }

        }
        
        
        
    }
    
    @IBAction func mySwiftch(sender: AnyObject) {
        
        if mySwitch.on{
           userDefaultsUtil.setTuiSong("开")
            mySwitch.setOn(true, animated:true)
        }else{
           userDefaultsUtil.setTuiSong("")
            mySwitch.setOn(false, animated:true)
        }

    }
    
}