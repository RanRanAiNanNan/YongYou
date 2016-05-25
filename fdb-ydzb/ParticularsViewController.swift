//
//  ParticularsViewController.swift
//  fdb-ydzb
//
//  Created by 123 on 16/3/30.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation
class ParticularsViewController: BaseTableViewController {
    
    @IBOutlet weak var quXiaoBT: UIButton!
    @IBOutlet weak var xiuGaiBT: UIButton!
    @IBOutlet weak var shangChuanBT: UIButton!
    
    
    @IBOutlet weak var chongXinYuYue: UIButton!
    
    @IBOutlet weak var shangChuanQianShu: UIButton!
    
    @IBOutlet weak var xiuGaiHeTong: UIButton!
    @IBOutlet weak var quXiao2: UIButton!
    
    
    @IBOutlet weak var beiZhuXinXiTV: UITextView!
    
    @IBOutlet weak var xiangXiDiZhiTV: UITextView!
    let fenLei = ProductMainService.getInstance()
    
    @IBOutlet var myTableView: UITableView!
    
    var orderId: String!
    var addrId : String!
    var proId : String!
    @IBOutlet weak var yuYueLB: UILabel!
    @IBOutlet weak var dingDanBianHao: UILabel!
    @IBOutlet weak var yuYueShiJian: UILabel!
    @IBOutlet weak var chanPinMingCheng: UILabel!
    @IBOutlet weak var yuYueXingMing: UILabel!
    @IBOutlet weak var yuYueJinE: UILabel!
    @IBOutlet weak var shouJiHaoMa: UILabel!
    @IBOutlet weak var beiZhuXinXi: UITextView!
    @IBOutlet weak var youJiZhuangTai: UILabel!
    @IBOutlet weak var shouJianXingMing: UILabel!
    @IBOutlet weak var ShouJiHaoMaDiEr: UILabel!
    @IBOutlet weak var xiangXiDiZhi: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = B.NAV_TITLE_CORLOR
         initView()
        
    }
    override func viewWillDisappear(animated: Bool) {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: ""), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
    }

    override func viewWillAppear(animated: Bool) {
        
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "first_dingDan"), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.tintColor = B.NAV_TITLE_CORLOR
        
        print(orderId)
        print(addrId)
        fenLei.dingDanXiangQing(orderId, addrId: addrId) { (data) -> () in
            if let hm = data as? DingDanXiangQingModel{
                
//                print(hm.proId)
                if hm.status == "2"{
                   self.yuYueLB.text = "预约待审核"
                   self.xiuGaiHeTong.hidden = false
                   self.quXiao2.hidden = false
                }else if hm.status == "3"{
                    self.yuYueLB.text = "预约成功"
                    self.quXiaoBT.hidden = false
                    self.xiuGaiBT.hidden = false
                    self.shangChuanBT.hidden = false
                }else if hm.status == "4"{
                    self.yuYueLB.text = "重新上传打款凭证"
                    self.shangChuanQianShu.hidden = false
                }else if hm.status == "5"{
                    self.yuYueLB.text = "打款凭证审核"
                }else if hm.status == "6"{
                    self.yuYueLB.text = "客户完成交易"
                    self.xiuGaiHeTong.hidden = false
                }else if hm.status == "7"{
                    self.yuYueLB.text = "重新上传合同"
                    self.xiuGaiHeTong.hidden = false
                }else if hm.status == "8"{
                    self.yuYueLB.text = "合同签署页审核"
                }else if hm.status == "9"{
                    self.yuYueLB.text = "首次返佣"
                }else if hm.status == "10"{
                    self.yuYueLB.text = "回收合同"
                }else if hm.status == "11"{
                    self.yuYueLB.text = "订单完成"
                }else if hm.status == "12"{
                    self.yuYueLB.text = "订单关闭"
                }else if hm.status == "13"{
                    self.yuYueLB.text = "预约失败"
                    self.chongXinYuYue.hidden = false
                }
                self.yuYueJinE.text = "\(hm.money)万元"
                let string = NSString(string: hm.orderDate)
                
                let timeSta:NSTimeInterval = string.doubleValue
                let dfmatter = NSDateFormatter()
                dfmatter.dateFormat="yyyy年MM月dd日 HH:mm:ss"
                
                let date = NSDate(timeIntervalSince1970: timeSta)
//                print(dfmatter.stringFromDate(date))
                self.yuYueShiJian.text = dfmatter.stringFromDate(date)
                self.chanPinMingCheng.text = hm.proName
                self.yuYueXingMing.text = hm.realRame
                self.dingDanBianHao.text = hm.orderNumb
                self.shouJiHaoMa.text = hm.phoneNumb
                self.beiZhuXinXi.text = hm.remark
                self.youJiZhuangTai.text = hm.userAddrs_postStatus
                self.shouJianXingMing.text = hm.userAddrs_realName
                self.ShouJiHaoMaDiEr.text = hm.userAddrs_mobile
                self.xiangXiDiZhi.text = hm.userAddrs_addr
            }
        }
        
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
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        
        self.view.backgroundColor = UIColor.redColor()
        var myView = UIView()
        myView = UIView(frame: CGRectMake(0, B.SCREEN_HEIGHT - 244, B.SCREEN_WIDTH, 244))
        myView.backgroundColor = UIColor.realgarColor()
        super.view.addSubview(myView)

        
        quXiaoBT!.layer.borderColor = UIColor(red: 43/255, green: 44/255, blue: 45/255, alpha: 1).CGColor
        quXiao2!.layer.borderColor = UIColor(red: 43/255, green: 44/255, blue: 45/255, alpha: 1).CGColor
        xiuGaiBT!.layer.borderColor = B.NAV_TITLE_CORLOR.CGColor
        shangChuanBT!.layer.borderColor = B.NAV_TITLE_CORLOR.CGColor
        chongXinYuYue.layer.borderColor = B.NAV_TITLE_CORLOR.CGColor
        xiuGaiHeTong.layer.borderColor = B.NAV_TITLE_CORLOR.CGColor
        shangChuanQianShu.layer.borderColor = B.NAV_TITLE_CORLOR.CGColor
        
        beiZhuXinXiTV.editable = false
        xiangXiDiZhiTV.editable = false
    }
   
    @IBAction func quXiaoBT(sender: AnyObject) {
        print("取消订单")
        fenLei.quXiaoDingDan(orderId) { (data) -> () in
            
//            self.productTableView.reloadData()
            if data as! String == "1"{
                self.navigationController?.popViewControllerAnimated(true)
            }
            
        }

    }
    
    
    @IBAction func xiuGaiBT(sender: AnyObject) {
        print("修改地址")
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
        let rpvc:FixAddressViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("FixAddressViewController") as! FixAddressViewController
        rpvc.addrId = addrId
        rpvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(rpvc, animated: true)
    }
    @IBAction func shangChuanBT(sender: AnyObject) {
        print("上传打款凭证")
        self.navigationController!.navigationBarHidden = true
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
        let rpvc:ShangChuanDaKuanViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ShangChuanDaKuanViewController") as! ShangChuanDaKuanViewController
        rpvc.orderId = orderId
        rpvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(rpvc, animated: true)
        
    }
    
    @IBAction func zhuangTai(sender: AnyObject) {
    //////////print("订单详情")
        if self.yuYueLB.text == "预约成功"{
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
        let rpvc:ImageViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ImageViewController") as! ImageViewController
        rpvc.myInt = 1
        rpvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(rpvc, animated: true)
        }else if self.yuYueLB.text == "重新上传打款凭证"{
            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
            let rpvc:ImageViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ImageViewController") as! ImageViewController
            rpvc.myInt = 2
            rpvc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(rpvc, animated: true)
        }else if self.yuYueLB.text == "打款凭证审核"{
            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
            let rpvc:ImageViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ImageViewController") as! ImageViewController
            rpvc.myInt = 3
            rpvc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(rpvc, animated: true)
        }else if self.yuYueLB.text == "客户完成交易"{
            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
            let rpvc:ImageViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ImageViewController") as! ImageViewController
            rpvc.myInt = 4
            rpvc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(rpvc, animated: true)
        }else if self.yuYueLB.text == "重新上传合同"{
            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
            let rpvc:ImageViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ImageViewController") as! ImageViewController
            rpvc.myInt = 5
            rpvc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(rpvc, animated: true)
        }else if self.yuYueLB.text == "合同签署页审核"{
            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
            let rpvc:ImageViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ImageViewController") as! ImageViewController
            rpvc.myInt = 6
            rpvc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(rpvc, animated: true)
        }else if self.yuYueLB.text == "首次返佣"{
            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
            let rpvc:ImageViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ImageViewController") as! ImageViewController
            rpvc.myInt = 7
            rpvc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(rpvc, animated: true)
        }else if self.yuYueLB.text == "回收合同"{
            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
            let rpvc:ImageViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ImageViewController") as! ImageViewController
            rpvc.myInt = 8
            rpvc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(rpvc, animated: true)
        }else if self.yuYueLB.text == "订单关闭"{
            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
            let rpvc:ImageViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ImageViewController") as! ImageViewController
            rpvc.myInt = 9
            rpvc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(rpvc, animated: true)
        }

    }
    @IBAction func chongXinYuYue(sender: AnyObject) {
        print("重新预约")
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let rpvc:ImmediatelyViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ImmediatelyViewController") as! ImmediatelyViewController
        rpvc.str = proId
        rpvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(rpvc, animated: true)

    }
    
    @IBAction func shangChuanQianShu(sender: AnyObject) {
        print("上传签署页面")
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
        let rpvc:ShangChuanQianShuViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ShangChuanQianShuViewController") as! ShangChuanQianShuViewController
        rpvc.orderId = orderId
        rpvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(rpvc, animated: true)
    }
    
    @IBAction func xiuGaiHeTong(sender: AnyObject) {
        print("修改合同")
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
        let rpvc:FixAddressViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("FixAddressViewController") as! FixAddressViewController
        rpvc.addrId = addrId
        rpvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(rpvc, animated: true)
    }
    
    @IBAction func quXiao2(sender: AnyObject) {
        print("取消预约")
        fenLei.quXiaoDingDan(orderId) { (data) -> () in
            
            //            self.productTableView.reloadData()
            if data as! String == "1"{
                self.navigationController?.popViewControllerAnimated(true)
            }
            
        }

    }
        
    
    
    
    
}