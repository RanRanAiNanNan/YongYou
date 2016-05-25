//
//  DingDanXiangQingNewViewController.swift
//  fdb-ydzb
//
//  Created by 123 on 16/5/15.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation
class DingDanXiangQingNewViewController:BaseViewController ,FixAddressViewControllerDelegate,ShangChuanQianShuViewControllerDelegate ,ShangChuanDaKuanViewControllerDelegate{
    //预约待审核lb
    @IBOutlet weak var yuYueDaiShenHeLB: UILabel!
    //订单编号
    @IBOutlet weak var dingDanBianHaoLB: UILabel!
    //预约时间
    @IBOutlet weak var yuYueShiJianLB: UILabel!
    //产品名称
    @IBOutlet weak var chanPinMingChengLB: UILabel!
    //预约姓名
    @IBOutlet weak var yuYueXingMingLB: UILabel!
    //预约金额
    @IBOutlet weak var yuYueJinELB: UILabel!
    //手机号码
    @IBOutlet weak var shouJiHaoMaLB: UILabel!
    //备注信息
    @IBOutlet weak var beiZhuXinXiTV: UITextView!
    //邮寄状态
    @IBOutlet weak var youJiZhuangTaiLB: UILabel!
    //收件姓名
    @IBOutlet weak var shouJianXingMingLB: UILabel!
    //手机号码
    @IBOutlet weak var shouJiHaoMa2: UILabel!
    //详细地址
    @IBOutlet weak var xiangXiDiZhiTV: UITextView!
    
    //修改合同
    @IBOutlet weak var xiuGaiHeTong: UIButton!
    //取消2
    @IBOutlet weak var quXiao2: UIButton!
    //上传签署
    @IBOutlet weak var shangChuanHeTongQianShu: UIButton!
    //重新预约
    @IBOutlet weak var chongXinYuYue: UIButton!
    //上传打款
    @IBOutlet weak var shangChuanDaKuan: UIButton!
    //修改合同中间的
    @IBOutlet weak var xiuGaiBT: UIButton!
    //取消预约最外面的
    @IBOutlet weak var quXiao: UIButton!
    var orderId: String!
    var addrId : String!
    var proId : String!
    var messageBtn: UIBarButtonItem!
    let fenLei = ProductMainService.getInstance()
    
      override func viewDidLoad() {
        
        super.viewDidLoad()
        initView()
//        self.view.backgroundColor = B.NAV_TITLE_CORLOR
//        initNav("订单详情111")
    }
    override func viewWillDisappear(animated: Bool) {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: ""), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
    }
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "first_dingDan"), forBarMetrics: UIBarMetrics.Default)
        
        let msgBtn = UIButton()
        let backImage = UIImage(named: "peizi_return_icon")
        msgBtn.frame = CGRectMake(0, 0, backImage!.size.width, backImage!.size.height)
        msgBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        msgBtn.setImage(backImage, forState: UIControlState.Normal)
        msgBtn.addTarget(self, action: "messageClick", forControlEvents: UIControlEvents.TouchUpInside)
        //var backBtnItem = UIBarButtonItem(customView: backBtn)
        messageBtn = UIBarButtonItem(customView: msgBtn)
        self.navigationItem.leftBarButtonItem = messageBtn
        
        self.navigationController?.navigationBar.tintColor = B.NAV_TITLE_CORLOR
        
        print(orderId)
        print(addrId)
        self.loadingShow()
        
        fenLei.dingDanXiangQing(orderId, addrId: addrId) { (data) -> () in
            if let hm = data as? DingDanXiangQingModel{
                //                print(hm.proId)
                self.view.backgroundColor = UIColor(red: 37/255, green:41/255, blue: 42/255, alpha: 1)
                self.xiuGaiHeTong.hidden = true
                self.quXiao2.hidden = true
                self.shangChuanHeTongQianShu.hidden = true
                self.chongXinYuYue.hidden = true
                self.shangChuanDaKuan.hidden = true
                self.xiuGaiBT.hidden = true
                self.quXiao.hidden = true
                self.loadingHidden()
                if hm.status == "2"{
                    self.yuYueDaiShenHeLB.text = "预约待审核"
//                    self.youJiZhuangTaiLB.text = "未寄送"
                    self.xiuGaiHeTong.hidden = false
                    self.quXiao2.hidden = false
                    self.view.backgroundColor = UIColor.whiteColor()
                }else if hm.status == "3"{
                    self.yuYueDaiShenHeLB.text = "预约成功"
                    self.quXiao.hidden = false
                    self.xiuGaiBT.hidden = false
//                    self.youJiZhuangTaiLB.text = "未寄送"
                    self.shangChuanDaKuan.hidden = false
                    self.view.backgroundColor = UIColor.whiteColor()
                }else if hm.status == "4"{
                    self.yuYueDaiShenHeLB.text = "重新上传打款凭证"
                    self.shangChuanDaKuan.hidden = false
//                    self.youJiZhuangTaiLB.text = "已寄送"
                    self.view.backgroundColor = UIColor.whiteColor()
                }else if hm.status == "5"{
                    self.yuYueDaiShenHeLB.text = "打款凭证审核"
//                    self.youJiZhuangTaiLB.text = "已寄送"
//                    self.view.backgroundColor = UIColor(red: 37/255, green:41/255, blue: 42/255, alpha: 1)
                }else if hm.status == "6"{
                    self.yuYueDaiShenHeLB.text = "客户完成交易"
//                    self.youJiZhuangTaiLB.text = "已寄送"
                    self.shangChuanHeTongQianShu.hidden = false
                    self.view.backgroundColor = UIColor.whiteColor()
                }else if hm.status == "7"{
                    self.yuYueDaiShenHeLB.text = "重新上传合同"
//                    self.youJiZhuangTaiLB.text = "已寄送"
                    self.shangChuanHeTongQianShu.hidden = false
                    self.view.backgroundColor = UIColor.whiteColor()
                }else if hm.status == "8"{
                    self.yuYueDaiShenHeLB.text = "合同签署页审核"
//                    self.youJiZhuangTaiLB.text = "已寄送"
//                    self.view.backgroundColor = UIColor(red: 37/255, green:41/255, blue: 42/255, alpha: 1)
                }else if hm.status == "9"{
                    self.yuYueDaiShenHeLB.text = "首次返佣"
//                    self.youJiZhuangTaiLB.text = "已寄送"
//                    self.view.backgroundColor = UIColor(red: 37/255, green:41/255, blue: 42/255, alpha: 1)
                }else if hm.status == "10"{
                    self.yuYueDaiShenHeLB.text = "回收合同"
//                    self.youJiZhuangTaiLB.text = "已查收"
//                    self.view.backgroundColor = UIColor(red: 37/255, green:41/255, blue: 42/255, alpha: 1)
                }else if hm.status == "11"{
                    self.yuYueDaiShenHeLB.text = "交易结束，并存入计量"
//                    self.youJiZhuangTaiLB.text = "已查收"
//                    self.view.backgroundColor = UIColor(red: 37/255, green:41/255, blue: 42/255, alpha: 1)
                }else if hm.status == "12"{
                    self.yuYueDaiShenHeLB.text = "订单关闭"
//                    self.youJiZhuangTaiLB.text = "未寄送"
//                    self.view.backgroundColor = UIColor(red: 37/255, green:41/255, blue: 42/255, alpha: 1)
                }else if hm.status == "13"{
                    self.yuYueDaiShenHeLB.text = "预约失败"
//                    self.youJiZhuangTaiLB.text = "未寄送"
                    self.view.backgroundColor = UIColor.whiteColor()
                    self.chongXinYuYue.hidden = false
                }
                
                print(hm.postStaus)
                if hm.postStaus == "1"{
                    self.youJiZhuangTaiLB.text = "未寄送"
                }else if hm.postStaus == "2"{
                    self.youJiZhuangTaiLB.text = "已寄送"
                }else if hm.postStaus == "3"{
                    self.youJiZhuangTaiLB.text = "已接受"
                }else{
                    self.youJiZhuangTaiLB.text = ""
                }
                
              
                self.yuYueJinELB.text = "\(hm.money)元"
                let string = NSString(string: hm.orderDate)
                
                let timeSta:NSTimeInterval = string.doubleValue
                let dfmatter = NSDateFormatter()
                dfmatter.dateFormat="yyyy年MM月dd日 HH:mm:ss"
                
                let date = NSDate(timeIntervalSince1970: timeSta)
                //                print(dfmatter.stringFromDate(date))
                self.yuYueShiJianLB.text = dfmatter.stringFromDate(date)
                self.chanPinMingChengLB.text = hm.proName
                self.yuYueXingMingLB.text = hm.realRame
                self.dingDanBianHaoLB.text = hm.orderNumb
                self.shouJiHaoMaLB.text = hm.phoneNumb
                self.beiZhuXinXiTV.text = hm.remark
//                if hm.userAddrs_postStatus == ""{
//                   self.youJiZhuangTaiLB.text = "未寄送"
//                }else{
//                self.youJiZhuangTaiLB.text = hm.userAddrs_postStatus
//                }
                self.shouJianXingMingLB.text = hm.userAddrs_realName
                self.shouJiHaoMa2.text = hm.userAddrs_mobile
                self.xiangXiDiZhiTV.text = hm.userAddrs_addr
            }
        }
        
    }
    func messageClick(){
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func initView(){
        
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.backItem?.title = ""
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.tintColor = B.NAV_TITLE_CORLOR
        let lab = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        lab.text = "订单详情"
        lab.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = lab
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "first_dingDan"), forBarMetrics: UIBarMetrics.Default)
        
//        self.view.backgroundColor = UIColor.whiteColor()
        
        
        quXiao!.layer.borderColor = UIColor(red: 43/255, green: 44/255, blue: 45/255, alpha: 1).CGColor
        quXiao2!.layer.borderColor = UIColor(red: 43/255, green: 44/255, blue: 45/255, alpha: 1).CGColor
        xiuGaiBT!.layer.borderColor = B.NAV_TITLE_CORLOR.CGColor
        shangChuanDaKuan!.layer.borderColor = B.NAV_TITLE_CORLOR.CGColor
        chongXinYuYue.layer.borderColor = B.NAV_TITLE_CORLOR.CGColor
        xiuGaiHeTong.layer.borderColor = B.NAV_TITLE_CORLOR.CGColor
        shangChuanHeTongQianShu.layer.borderColor = B.NAV_TITLE_CORLOR.CGColor
        
        beiZhuXinXiTV.editable = false
        xiangXiDiZhiTV.editable = false
    }

    //修改合同
    @IBAction func xiuGaiHeTong(sender: AnyObject) {
        print("修改合同")
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
        let rpvc:FixAddressViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("FixAddressViewController") as! FixAddressViewController
        rpvc.addrId = addrId
        rpvc.orderId = orderId
        rpvc.delegate = self
        rpvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(rpvc, animated: true)

    }
    func sendValue(addrId: String?, orderId: String?) {
        self.orderId = orderId
        self.addrId = addrId
        print(orderId)
        print(addrId)
    }
    //取消预约
    @IBAction func quXiaoYuYue(sender: AnyObject) {
        print("取消订单")
        fenLei.quXiaoDingDan(orderId) { (data) -> () in
            
            //            self.productTableView.reloadData()
            if data as! String == "1"{
                self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
            
        }

    }
    //上传合同签署页照片
    @IBAction func shangChuanHeTongQianShu(sender: AnyObject) {
        print("上传签署页面")
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
        let rpvc:ShangChuanQianShuViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ShangChuanQianShuViewController") as! ShangChuanQianShuViewController
        rpvc.orderId = orderId
        rpvc.addrId = addrId
        rpvc.delegate = self
        rpvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(rpvc, animated: true)

    }
    func sendValue1(orderId:String?,addrId:String?) {
        self.orderId = orderId
        self.addrId = addrId
        print(orderId)
        print(addrId)
    }

    
    //重新预约
    @IBAction func chongXinYuYue(sender: AnyObject) {
        print("重新预约")
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let rpvc:ImmediatelyViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ImmediatelyViewController") as! ImmediatelyViewController
        rpvc.str = proId
        rpvc.orderId = orderId
        rpvc.addrId = addrId
        rpvc.chongXinYuYue = "重新预约"
   
        rpvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(rpvc, animated: true)

    }
    //上传打款
    @IBAction func shangChuanDaKuan(sender: AnyObject) {
        print("上传打款凭证")
        self.navigationController!.navigationBarHidden = true
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
        let rpvc:ShangChuanDaKuanViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ShangChuanDaKuanViewController") as! ShangChuanDaKuanViewController
        rpvc.orderId = orderId
        rpvc.addrId = addrId
        rpvc.delegate = self
        rpvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(rpvc, animated: true)

    }
    func sendValue33(orderId:String?,addrId:String?) {
        self.orderId = orderId
        self.addrId = addrId
        print(orderId)
        print(addrId)
    }

    //修改合同中间的
    @IBAction func xiuGaiBT(sender: AnyObject) {
        print("修改合同")
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
        let rpvc:FixAddressViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("FixAddressViewController") as! FixAddressViewController
        rpvc.addrId = addrId
        rpvc.orderId = orderId
        rpvc.delegate = self
        rpvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(rpvc, animated: true)
    }
    //取消预约最外面的
    @IBAction func quXiaoYuYueWai(sender: AnyObject) {
        print("取消订单")
        fenLei.quXiaoDingDan(orderId) { (data) -> () in
            
            //            self.productTableView.reloadData()
            if data as! String == "1"{
                self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
            
        }

    }
    //预约待审核
    @IBAction func yuYueDaiShenHe(sender: AnyObject) {
        if self.yuYueDaiShenHeLB.text == "预约成功"{
            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
            let rpvc:ImageViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ImageViewController") as! ImageViewController
            rpvc.myInt = 1
            rpvc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(rpvc, animated: true)
        }else if self.yuYueDaiShenHeLB.text == "重新上传打款凭证"{
            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
            let rpvc:ImageViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ImageViewController") as! ImageViewController
            rpvc.myInt = 2
            rpvc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(rpvc, animated: true)
        }else if self.yuYueDaiShenHeLB.text == "打款凭证审核"{
            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
            let rpvc:ImageViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ImageViewController") as! ImageViewController
            rpvc.myInt = 3
            rpvc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(rpvc, animated: true)
        }else if self.yuYueDaiShenHeLB.text == "客户完成交易"{
            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
            let rpvc:ImageViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ImageViewController") as! ImageViewController
            rpvc.myInt = 4
            rpvc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(rpvc, animated: true)
        }else if self.yuYueDaiShenHeLB.text == "重新上传合同"{
            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
            let rpvc:ImageViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ImageViewController") as! ImageViewController
            rpvc.myInt = 5
            rpvc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(rpvc, animated: true)
        }else if self.yuYueDaiShenHeLB.text == "合同签署页审核"{
            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
            let rpvc:ImageViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ImageViewController") as! ImageViewController
            rpvc.myInt = 6
            rpvc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(rpvc, animated: true)
        }else if self.yuYueDaiShenHeLB.text == "首次返佣"{
            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
            let rpvc:ImageViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ImageViewController") as! ImageViewController
            rpvc.myInt = 7
            rpvc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(rpvc, animated: true)
        }else if self.yuYueDaiShenHeLB.text == "回收合同"{
            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
            let rpvc:ImageViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ImageViewController") as! ImageViewController
            rpvc.myInt = 8
            rpvc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(rpvc, animated: true)
        }else if self.yuYueDaiShenHeLB.text == "交易结束，并存入计量"{
            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
            let rpvc:ImageViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ImageViewController") as! ImageViewController
            rpvc.myInt = 9
            rpvc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(rpvc, animated: true)
        }else if self.yuYueDaiShenHeLB.text == "订单关闭"{
//            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
//            let rpvc:ImageViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ImageViewController") as! ImageViewController
//            rpvc.myInt = 9
//            rpvc.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(rpvc, animated: true)
        }else if self.yuYueDaiShenHeLB.text == "预约待审核"{
            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
            let rpvc:ImageViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ImageViewController") as! ImageViewController
            rpvc.myInt = 10
            rpvc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(rpvc, animated: true)
        }else if self.yuYueDaiShenHeLB.text == "预约失败"{
//            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
//            let rpvc:ImageViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ImageViewController") as! ImageViewController
//            rpvc.myInt = 10
//            rpvc.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(rpvc, animated: true)
        }


    }
}
