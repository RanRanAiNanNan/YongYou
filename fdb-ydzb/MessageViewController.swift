//
//  MessageViewController.swift
//  fdb-ydzb
//
//  Created by 123 on 16/4/22.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation
class MessageViewController:BaseViewController {
    
    @IBOutlet weak var segment: UISegmentedControl!
    var myView : UIView?
    
    var gongGao : GongGaoViewController!
    var xiaoXi : XiaoXiViewController!
    
    var currentVC : UIViewController?
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initView()
        let lab = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        lab.text = "站内信"
        lab.textColor = UIColor.blackColor()
        self.navigationItem.titleView = lab

        
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.backItem?.title = ""
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 240/255, green: 244/255, blue: 249/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.translucent = false
                //设置标题颜色
        _ = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        //self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as [NSObject : AnyObject]
        //self.view.backgroundColor = B.VIEW_BG
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black

        

    }
    func initView(){
        
        
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: "segmentDidchange:",
            forControlEvents: UIControlEvents.ValueChanged)
  
        myView = UIView(frame: CGRectMake(0 ,40, B.SCREEN_WIDTH , B.SCREEN_HEIGHT - 40))
        self.view.addSubview(myView!)

      
        gongGao = GongGaoViewController()
        self.addChildViewController(gongGao!)
        self.currentVC = gongGao
        
        xiaoXi = XiaoXiViewController()
        self.addChildViewController(xiaoXi!)

        self.fitFrameForChildViewController(gongGao!)
        myView?.addSubview((gongGao?.view)!)

    }
    func fitFrameForChildViewController(chileViewController : UIViewController){
        var frame :CGRect = (self.myView?.frame)!
        frame.origin.y = 0
        chileViewController.view.frame = frame
        
    }
    func segmentDidchange(sender: AnyObject?){
        let segment:UISegmentedControl = sender as! UISegmentedControl
               switch segment.selectedSegmentIndex {
           
                case 0 :
                    print("公告")
//                    myView?.addSubview((gongGao?.view)
//                    myView?.addSubview(gongGao.view)
                    self.fitFrameForChildViewController(gongGao!)
                    self.transitionFromOldViewController(self.currentVC!, newViewController: gongGao!)
                

                default:
                    print("消息")
                    if !userDefaultsUtil.isLoggedIn(){
                        let twoStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                        let twoController:LoginViewController = twoStoryBoard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                        twoController.hidesBottomBarWhenPushed = true
                        self.presentViewController(twoController, animated: true, completion: nil)
                        segment.selectedSegmentIndex = 0
 
                    }else{
                        self.fitFrameForChildViewController(xiaoXi!)
                        self.transitionFromOldViewController(self.gongGao!, newViewController: xiaoXi!)

//                    myView?.addSubview(xiaoXi.view)
                }
                
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

    
    
}
