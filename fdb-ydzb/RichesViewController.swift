//
//  RichesViewController.swift
//  fdb-ydzb
//
//  Created by 123 on 16/3/29.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation

class RichesViewController: BaseViewController {
    //预约
//    var orderButton : UIButton?
//    //佣金
//    var commissionLabel : UILabel?
//    //现金
//    var moneyLabel : UILabel?
//    //下拉小条按钮
//    var littleButton : UIButton?
//    //更多  小三角
//    var littleImage : UIImageView?
//    //下拉小条
//    var selectView : UIView?
//    //合同
//    var contractTableView : UITableView!
    let touXiang = HomeService.getInstance()
    @IBOutlet weak var myWebView: UIWebView!
    var str : String!
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
       
        
    }
    
    override func viewWillAppear(animated: Bool) {
       self.navigationController!.navigationBarHidden = false
        
       touXiang.caiFu { (data) -> () in
        print(data as! String)
        self.str = data as! String
        userDefaultsUtil.setMobile(data as! String)
        self.initView()
        }
        
        
        
    }
    func initView(){
        initNav("成就")
        let lab = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        lab.text = "成就"
        lab.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = lab
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 42/255, green: 43/255, blue: 49/255, alpha: 1)

       print(userDefaultsUtil.getMobile()!)
      
        let ss = userDefaultsUtil.getMobile()!.base64Encoded()
        print(ss)
  
        let str = "username=" + ss + "&" + "key=" + "3e9bb86c6980c3b79e5b936ce10b9b96"
        let hash = str.sha256()

        myWebView.loadRequest(NSURLRequest(URL:NSURL(string:"http://121.43.118.86:10220/index.php/home/Index/achievement?username=\(ss)&key=\(hash)")!))
        print("http://121.43.118.86:10220/index.php/home/Index/achievement?username=\(ss)&key=\(hash)")
        
        
    }
//    func initButton(){
//        
//        let myView1 = UIView(frame: CGRectMake(0, 0, B.SCREEN_WIDTH, (B.SCREEN_HEIGHT - 49) / 3))
//        myView1.backgroundColor = UIColor(red: 90/255, green: 94/255, blue: 109/255, alpha: 1)
//        self.view.addSubview(myView1)
//        
//        let nameLabel = UILabel(frame: CGRectMake(0, 40, B.SCREEN_WIDTH, 40))
//        nameLabel.font = UIFont.systemFontOfSize(25)
//        nameLabel.textAlignment=NSTextAlignment.Center
//        nameLabel.text = "1000000.000000￥"
//        nameLabel.textColor = B.NAV_TITLE_CORLOR
//        myView1.addSubview(nameLabel)
//
//        let nameLabel1 = UILabel(frame: CGRectMake(0, 100, B.SCREEN_WIDTH, 40))
//        nameLabel1.font = UIFont.systemFontOfSize(25)
//        nameLabel1.textAlignment=NSTextAlignment.Center
//        nameLabel1.text = "累计赚取佣金"
//        nameLabel1.textColor = B.NAV_TITLE_CORLOR
//        myView1.addSubview(nameLabel1)
//
//        
//        
//        
//
//        let myView2 = UIView(frame: CGRectMake(0, (B.SCREEN_HEIGHT - 49) / 3, B.SCREEN_WIDTH, (B.SCREEN_HEIGHT - 49) / 3 * 2 / 4))
//        myView2.backgroundColor = UIColor(red: 101/255, green: 104/255, blue: 120/255, alpha: 1)
//        let myView2Label = UILabel(frame: CGRectMake(B.SCREEN_WIDTH - 100 , 0 ,50 ,(B.SCREEN_HEIGHT - 49) / 3 * 2 / 4 ))
//
//        myView2Label.font = UIFont.systemFontOfSize(16)
//        myView2Label.textAlignment=NSTextAlignment.Left
//        myView2Label.text = "预约"
//        myView2Label.textColor = B.NAV_TITLE_CORLOR
//        myView2.addSubview(myView2Label)
//
//        
//        let button1 : UIButton = UIButton(frame: CGRectMake(B.SCREEN_WIDTH - 50 , 0 ,50 ,(B.SCREEN_HEIGHT - 49) / 3 * 2 / 4 ))
//        button1.titleLabel?.font = UIFont.systemFontOfSize(16)
//        button1.setTitleColor(B.NAV_TITLE_CORLOR, forState: UIControlState.Normal)
//        button1.addTarget(self,action:Selector("yuyueButton:"),forControlEvents:.TouchUpInside)
//        button1.setImage(UIImage(named: "home_cell_rightArrow_icon"), forState: UIControlState.Normal)
//        myView2.addSubview(button1)
//        self.view.addSubview(myView2)
//        
//        
//        
//        
//        let myView3 = UIView(frame: CGRectMake(0, (B.SCREEN_HEIGHT - 49) / 3 + (B.SCREEN_HEIGHT - 49) / 3 * 2 / 4, B.SCREEN_WIDTH, (B.SCREEN_HEIGHT - 49) / 3 * 2 / 4))
//        myView3.backgroundColor = UIColor(red: 185/255, green: 195/255, blue: 199/255, alpha: 1)
//        let myView3Label = UILabel(frame: CGRectMake(B.SCREEN_WIDTH - 100 , 0 ,50 ,(B.SCREEN_HEIGHT - 49) / 3 * 2 / 4 ))
//        myView3Label.font = UIFont.systemFontOfSize(16)
//        myView3Label.textAlignment=NSTextAlignment.Left
//        myView3Label.text = "汇款"
//        myView3Label.textColor = B.NAV_TITLE_CORLOR
//        myView3.addSubview(myView3Label)
//        
//        
//        let button2 : UIButton = UIButton(frame: CGRectMake(B.SCREEN_WIDTH - 50 , 0 ,50 ,(B.SCREEN_HEIGHT - 49) / 3 * 2 / 4 ))
//        button2.titleLabel?.font = UIFont.systemFontOfSize(16)
//        button2.setTitleColor(B.NAV_TITLE_CORLOR, forState: UIControlState.Normal)
//        button2.addTarget(self,action:Selector("huikuanButton:"),forControlEvents:.TouchUpInside)
//        button2.setImage(UIImage(named: "home_cell_rightArrow_icon"), forState: UIControlState.Normal)
//        myView3.addSubview(button2)
//
//        self.view.addSubview(myView3)
//        
//        
//        
//        
//        
//        
//        let myView4 = UIView(frame: CGRectMake(0, (B.SCREEN_HEIGHT - 49) / 3 + (B.SCREEN_HEIGHT - 49) / 3 * 2 / 4 * 2, B.SCREEN_WIDTH, (B.SCREEN_HEIGHT - 49) / 3 * 2 / 4))
//        myView4.backgroundColor = UIColor(red: 229/255, green: 230/255, blue: 229/255, alpha: 1)
//        let myView4Label = UILabel(frame: CGRectMake(B.SCREEN_WIDTH - 100 , 0 ,50 ,(B.SCREEN_HEIGHT - 49) / 3 * 2 / 4 ))
//        myView4Label.font = UIFont.systemFontOfSize(16)
//        myView4Label.textAlignment=NSTextAlignment.Left
//        myView4Label.text = "返佣"
//        myView4Label.textColor = B.NAV_TITLE_CORLOR
//        myView4.addSubview(myView4Label)
//        
//        
//        let button3 : UIButton = UIButton(frame: CGRectMake(B.SCREEN_WIDTH - 50 , 0 ,50 ,(B.SCREEN_HEIGHT - 49) / 3 * 2 / 4 ))
//        button3.titleLabel?.font = UIFont.systemFontOfSize(16)
//        button3.setTitleColor(B.NAV_TITLE_CORLOR, forState: UIControlState.Normal)
//        button3.addTarget(self,action:Selector("fanyongButton:"),forControlEvents:.TouchUpInside)
//        button3.setImage(UIImage(named: "home_cell_rightArrow_icon"), forState: UIControlState.Normal)
//        myView4.addSubview(button3)
//
//        self.view.addSubview(myView4)
//        
//        let myView5 = UIView(frame: CGRectMake(0, (B.SCREEN_HEIGHT - 49) / 3 + (B.SCREEN_HEIGHT - 49) / 3 * 2 / 4 * 3, B.SCREEN_WIDTH, (B.SCREEN_HEIGHT - 49) / 3 * 2 / 4))
//        myView5.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
//        let myView5Label = UILabel(frame: CGRectMake(B.SCREEN_WIDTH - 100 , 0 ,50 ,(B.SCREEN_HEIGHT - 49) / 3 * 2 / 4 ))
//        myView5Label.font = UIFont.systemFontOfSize(16)
//        myView5Label.textAlignment=NSTextAlignment.Left
//        myView5Label.text = "完成"
//        myView5Label.textColor = B.NAV_TITLE_CORLOR
//        myView5.addSubview(myView5Label)
//        
//        
//        let button4 : UIButton = UIButton(frame: CGRectMake(B.SCREEN_WIDTH - 50 , 0 ,50 ,(B.SCREEN_HEIGHT - 49) / 3 * 2 / 4 ))
//        button4.titleLabel?.font = UIFont.systemFontOfSize(16)
//        button4.setTitleColor(B.NAV_TITLE_CORLOR, forState: UIControlState.Normal)
//        button4.addTarget(self,action:Selector("wanchengButton:"),forControlEvents:.TouchUpInside)
//        button4.setImage(UIImage(named: "home_cell_rightArrow_icon"), forState: UIControlState.Normal)
//        myView5.addSubview(button4)
//
//        self.view.addSubview(myView5)
//        
//        
//        let myImage1 = UIImageView(frame: CGRectMake(10, 0, 30, (B.SCREEN_HEIGHT - 49) / 3 * 2 / 4))
//        myImage1.image =  UIImage(named: "recharge_selectCard_icon")
//        myView2.addSubview(myImage1)
//        
//        let myImage2 = UIImageView(frame: CGRectMake(10, 0, 30, (B.SCREEN_HEIGHT - 49) / 3 * 2 / 4))
//        myImage2.image =  UIImage(named: "recharge_selectCard_icon")
//        myView3.addSubview(myImage2)
//        
//        let myImage3 = UIImageView(frame: CGRectMake(10, 0, 30, (B.SCREEN_HEIGHT - 49) / 3 * 2 / 4))
//        myImage3.image =  UIImage(named: "recharge_selectCard_icon")
//        myView4.addSubview(myImage3)
//        
//        let myImage4 = UIImageView(frame: CGRectMake(10, 0, 30, (B.SCREEN_HEIGHT - 49) / 3 * 2 / 4))
//        myImage4.image =  UIImage(named: "recharge_selectCard_icon")
//        myView5.addSubview(myImage4)
//        
//    
//        
//        
//    }
//
//    func yuyueButton(sender: AnyObject) {
//        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//        let rpvc:IndentViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("IndentViewController") as! IndentViewController
//            rpvc.shuzi = 1
//        rpvc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(rpvc, animated: true)
//
//    }
//    
//    func huikuanButton(sender: AnyObject) {
//        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//        let rpvc:IndentViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("IndentViewController") as! IndentViewController
//        rpvc.shuzi = 2
//        rpvc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(rpvc, animated: true)
//
//    }
//    
//    func fanyongButton(sender: AnyObject) {
//        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//        let rpvc:IndentViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("IndentViewController") as! IndentViewController
//        rpvc.shuzi = 3
//        rpvc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(rpvc, animated: true)
//
//    }
//    
//    func wanchengButton(sender: AnyObject) {
//        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//        let rpvc:IndentViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("IndentViewController") as! IndentViewController
//        rpvc.shuzi = 4
//        rpvc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(rpvc, animated: true)
//
//    }
    
    
    
    
    
    
    
    
    
    
}