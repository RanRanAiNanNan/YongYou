//
//  IndentViewController.swift
//  fdb-ydzb
//
//  Created by 123 on 16/3/30.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation


class IndentViewController: BaseViewController , UITableViewDataSource , UITableViewDelegate{
    
    //传参数
    var shuzi : Int?
    
    //选项View
    var myView : UIView?
    
    var myTableView : UITableView?
    
    var all : IndentAllViewController?
    var order : IndentOrderViewController?
    var remit : IndentRemitViewController?
    var fanyong : IndentFanYongViewController?
    var finsh : IndentFinshViewController?
    
    var scroller : UIView?
    
    var currentVC : UIViewController?
    
    var seleButton: UIButton?
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initView()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.navigationBarHidden = false
    }
    func initView(){
        initNav("我的订单")
       
        myView = UIView(frame: CGRectMake(0 ,0, B.SCREEN_WIDTH, 60))
        myView!.backgroundColor = B.NAV_BG
        self.view.addSubview(myView!)
        initButton()
        
       
        scroller = UIView(frame: CGRectMake(0 ,60, B.SCREEN_WIDTH , B.SCREEN_HEIGHT - 60))
//        scroller!.contentSize = CGSizeMake(B.SCREEN_WIDTH * 5, B.SCREEN_HEIGHT - 60)
//        scroller!.pagingEnabled = true
        self.view.addSubview(scroller!)
        //[_mainScroll addSubview:category.collectionView];
//        _mainScroll.delegate = self;

        all = IndentAllViewController()
        self.addChildViewController(all!)

        
        order = IndentOrderViewController()
        self.addChildViewController(order!)
        
        remit = IndentRemitViewController()
        self.addChildViewController(remit!)
        
        fanyong = IndentFanYongViewController()
        self.addChildViewController(fanyong!)
        
        finsh = IndentFinshViewController()
        self.addChildViewController(finsh!)

        
        
        if shuzi == 0{
            self.fitFrameForChildViewController(all!)
            scroller?.addSubview((all?.view)!)
            self.currentVC = all
        }else if shuzi == 1{
            
            self.fitFrameForChildViewController(order!)
            scroller?.addSubview((order?.view)!)
            self.currentVC = order
        }else if shuzi == 2{
            
            self.fitFrameForChildViewController(remit!)
            scroller?.addSubview((remit?.view)!)
            self.currentVC = remit
        }else if shuzi == 3{
            
            self.fitFrameForChildViewController(fanyong!)
            scroller?.addSubview((fanyong?.view)!)
            self.currentVC = fanyong
        }else{
            self.fitFrameForChildViewController(finsh!)
            scroller?.addSubview((finsh?.view)!)
            self.currentVC = finsh

        }


        
        


 
        
        
    }
    func initButton(){
        var button = UIButton()
        var arr = ["全部","预约","汇款","返佣","完成"]
        for var i = 0 ; i < 5 ; i++ {
            if i == shuzi {
                button = UIButton(frame: CGRectMake(B.SCREEN_WIDTH  / 5 * CGFloat(Float(i)) + 20 ,10 , 40,40 ))
                button.titleLabel?.font = UIFont.systemFontOfSize(16)
                button.setTitle(arr[i] , forState: UIControlState.Normal)
                button.tag = 30000 + i
                button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                button.backgroundColor = UIColor(red: 247.0/255, green: 99.0/255, blue: 118.0/255, alpha: 1)
                button.layer.masksToBounds = true
//                button.layer.borderWidth = 1
                button.layer.cornerRadius = 20
//                button.layer.shadowOpacity = 5
                button.layer.shadowColor = UIColor.redColor().CGColor
//                button.layer.shadowOffset = CGSize(width: 5, height: 5)
                button.addTarget(self,action:Selector("myButton:"),forControlEvents:.TouchUpInside)
                self.myView!.addSubview(button)
 
            }else{
            button = UIButton(frame: CGRectMake(B.SCREEN_WIDTH  / 5 * CGFloat(Float(i)) + 20 ,10 , 40,40 ))
            button.titleLabel?.font = UIFont.systemFontOfSize(16)
            button.setTitle(arr[i] , forState: UIControlState.Normal)
            button.tag = 30000 + i
            button.setTitleColor(B.NAV_TITLE_CORLOR, forState: UIControlState.Normal)
            button.backgroundColor = B.NAV_BG
            button.layer.masksToBounds = true
//            button.layer.borderWidth = 1
            button.layer.cornerRadius = 20
//            button.layer.shadowOpacity = 5
            button.layer.shadowColor = UIColor.redColor().CGColor
//            button.layer.shadowOffset = CGSize(width: 5, height: 5)
            button.addTarget(self,action:Selector("myButton:"),forControlEvents:.TouchUpInside)
            self.myView!.addSubview(button)
            }
        }
    }
    
    
    
    func initTableView(){
        
        myTableView =  UITableView(frame: CGRectMake(0,110, B.SCREEN_WIDTH , B.SCREEN_HEIGHT - 110 - 69), style: UITableViewStyle.Plain)
        self.view.addSubview(myTableView!)
        myTableView!.delegate = self
        myTableView!.dataSource = self
        myTableView!.registerClass(RichesCell.self, forCellReuseIdentifier: "myTableView")
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (B.SCREEN_HEIGHT - 49 - 88) / 4
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 10
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("myTableView", forIndexPath: indexPath) as! RichesCell
        
        //名称
        cell.nameLabel?.text = "和聚鼎宝君享证券投资基金"
        //日期
        cell.dateLabel?.text = "2016-03-03"
        //审核
        cell.auditorLabel?.text = "预约待审核"
        //钱
        cell.moneyLabel?.text = "100万"
        
        
        
        cell.cancelButton!.setTitle("取消预约", forState: UIControlState.Normal)
        cell.cancelButton!.setTitleColor(B.MENU_NORMAL_FONT_COLOR,forState: .Normal)
        cell.cancelButton!.layer.masksToBounds = true
        cell.cancelButton!.layer.borderWidth = 1

        
        
        
        
        
        return cell;
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
                let oneStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let rpvc:ParticularsViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ParticularsViewController") as! ParticularsViewController
                //        rpvc.str = "aaa"
                rpvc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(rpvc, animated: true)
        
        
    }
//订单按钮
    func myButton(button : UIButton){
//        let iii = button.tag
        for var i = 30000 ; i < 30005 ; i++ {
            if i  == button.tag  {
                
               
                button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                button.backgroundColor = UIColor(red: 247.0/255, green: 99.0/255, blue: 118.0/255, alpha: 1)
                button.layer.masksToBounds = true
//                button.layer.borderWidth = 1
                button.layer.cornerRadius = 20
//                button.layer.shadowOpacity = 0.8
//                button.layer.shadowColor = UIColor.redColor().CGColor
//                button.layer.shadowOffset = CGSize(width: 1, height: 1)
                
            }else{
                let button = self.view.viewWithTag(i) as! UIButton
                button.setTitleColor(B.NAV_TITLE_CORLOR, forState: UIControlState.Normal)
                button.backgroundColor = B.NAV_BG
                button.layer.masksToBounds = true
//                button.layer.borderWidth = 1
                button.layer.cornerRadius = 20
//                button.layer.shadowOpacity = 0.8
//                button.layer.shadowColor = UIColor.redColor().CGColor
//                button.layer.shadowOffset = CGSize(width: 1, height: 1)
              
            }
        
        
        }
        
        if (button.tag == 30000 && self.currentVC == all) || (button.tag == 30001 && self.currentVC == order) || (button.tag == 30002 && self.currentVC == remit) || (button.tag == 30003 && self.currentVC == fanyong) || (button.tag == 30004 && self.currentVC == finsh){
            
            
            return
        }
        switch button.tag {
        case 30000 :
            self.fitFrameForChildViewController(all!)
           self.transitionFromOldViewController(self.currentVC!, newViewController: all!)
            print("1")
             break
        case 30001:
            self.fitFrameForChildViewController(order!)
            self.transitionFromOldViewController(self.currentVC!, newViewController: order!)
            print("2")
            break
        case 30002:
            self.fitFrameForChildViewController(remit!)
            self.transitionFromOldViewController(self.currentVC!, newViewController: remit!)
            print("3")
            break
        case 30003:
            self.fitFrameForChildViewController(fanyong!)
             self.transitionFromOldViewController(self.currentVC!, newViewController: fanyong!)
            print("4")
            break
        case 30004:
            self.fitFrameForChildViewController(finsh!)
            self.transitionFromOldViewController(self.currentVC!, newViewController: finsh!)
            print("5")
            break
        default:
            break
        }
        
        
        
    }
    
    
    
    func transitionFromOldViewController(oldViewController : UIViewController ,newViewController : UIViewController ) {
        
     self.transitionFromViewController(oldViewController, toViewController: newViewController, duration: 0.3, options: UIViewAnimationOptions.TransitionNone, animations: nil) { (finish) -> Void in
        if finish  {
            newViewController.didMoveToParentViewController(self)
            self.currentVC = newViewController
        }else{
            self.currentVC = oldViewController
        }
  
      }
        
    }
        
    func fitFrameForChildViewController(chileViewController : UIViewController){
        var frame :CGRect = (self.scroller?.frame)!
        frame.origin.y = 0
        chileViewController.view.frame = frame
        
    }

  
    
    func feiLeiButton(button : UIButton){
        
        print("分类按钮")
        
        
    }

    
}