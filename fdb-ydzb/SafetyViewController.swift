//
//  SafetyViewController.swift
//  ydzbapp-hybrid
//
//  Created by yinduo-zdy on 15/2/5.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class SafetyViewController: BaseTableViewController{
    
    
    var datalist = Array<String>();
    var keylist = Array<String>();
    let userSafetyService =  UserSafetyInfoService.getInstance();
   // @IBOutlet var tbview:UITableView!;
    
    override func loadView() {
        super.loadView();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewinit()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        super.viewWillAppear(true)
        loadData()
    }
    
    func loadData(){
        loadingShow()
        userSafetyService.loadUserSaftyInfo({
            data in
            self.loadingHidden()
            if let d = data as? NSDictionary {
                self.keylist = d["keyl"] as! [String];
                self.datalist = d["val"] as! [String];
                self.tableView.reloadData();
            }
        });
    }
    
    func viewinit(){
        initNav("安全中心")
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datalist.count;
    }
    

    // 添加tableview的cell内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
         let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("SAFETY_CELL", forIndexPath: indexPath) 
        //名称
        let tile:UILabel = cell.viewWithTag(10) as! UILabel!
        tile.text = self.keylist[indexPath.row];
        //已添
        let valu:UILabel = cell.viewWithTag(20) as! UILabel!
        valu.text = self.datalist[indexPath.row];

//        //标题图片
//        var timg:UIImageView = cell.viewWithTag(30) as! UIImageView;
//        
//        switch indexPath.row {
//        case 0:
//             timg.image = UIImage(named: "login_password_icon");
//        case 1:
//             timg.image = UIImage(named: "safeCenter_bankCard_icon");
//        case 2:
//             timg.image = UIImage(named: "safeCenter_sm_icon");
//        case 3:
//             timg.image = UIImage(named: "fyp_pwd");
//        case 4:
//            timg.image = UIImage(named: "safeCenter_gesturePassword_icon");
//        default:
//            break
//        }
//     
        
        //cell被点击后的透明背景
        let xxview:UIView = UIView(frame: CGRect(x: 0,y: 0,width: cell.bounds.width,height: cell.bounds.height));
        xxview.backgroundColor = UIColor.clearColor();
        cell.selectedBackgroundView = xxview;
        
        return cell
        
    }
    
    //每个分组间距高度，隐藏的分组为0
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    //处理cell选中的事件
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "SafetyCenter", bundle: NSBundle.mainBundle())
            let oneController:UIViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("editpassword") 
            self.navigationController?.pushViewController(oneController, animated: true)
        case 1:
            _ = self.datalist[indexPath.row]
            gotoPage("SafetyCenter", pageName:"safeCenterBankCardCtrl")
        case 2:
            let vv:String = self.datalist[indexPath.row]
            
            if "未认证" == vv {
                self.loadingShow()
                userSafetyService.checkRealName({
                    data in
                    self.loadingHidden()
                    if let mm = data as? MsgModel {
                        if !mm.msg.isEmpty {
                            KGXToast.showToastWithMessage(mm.msg, duration: ToastDisplayDuration.LengthShort)
                        }
                        if mm.status == 0 {
//                            var oneStoryBoard:UIStoryboard = UIStoryboard(name: "SafetyCenter", bundle: NSBundle.mainBundle())
//                            let oneController:UIViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("realname") as! UIViewController
//                            self.navigationController?.pushViewController(oneController, animated: true)
                            self.gotoPage("SafetyCenter", pageName: "realname")
                        }
                    }
                });
            }else{
                KGXToast.showToastWithMessage("已实名认证，不可修改", duration: ToastDisplayDuration.LengthShort)
            }
            
        case 3:
            loadingShow()
            userSafetyService.getPayPasswordStatus({ (data) -> () in
                self.loadingHidden()
                let s = data as! String
                if s == "1" {
                    let oneStoryBoard:UIStoryboard = UIStoryboard(name: "SafetyCenter", bundle: NSBundle.mainBundle())
                    let oneController:UIViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("edittradepsw") 
                    self.navigationController?.pushViewController(oneController, animated: true)
                }else{
                    let oneStoryBoard:UIStoryboard = UIStoryboard(name: "SafetyCenter", bundle: NSBundle.mainBundle())
                    let oneController:UIViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("addtradepw") 
                    self.navigationController?.pushViewController(oneController, animated: true)
                }
            })

        case 4:
            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let cpctrl:GesturePasswordControllerViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("gesturePassword") as! GesturePasswordControllerViewController
                cpctrl.toWhere = "safetycenter"
                //cpctrl.navigationController?.setNavigationBarHidden(true, animated: false)
                //清除手势密码
                KeychainWrapper.removeObjectForKey(kSecValueData as String)
                self.navigationController?.pushViewController(cpctrl, animated: true)
            
            
        case 5:
            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "SafetyCenter", bundle: NSBundle.mainBundle())
            let oneController:UIViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("editEcCtrl")
            self.navigationController?.pushViewController(oneController, animated: true)

        case 6:
            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "SafetyCenter", bundle: NSBundle.mainBundle())
            let oneController:UIViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("editFingerprintCtrl")
            self.navigationController?.pushViewController(oneController, animated: true)
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
