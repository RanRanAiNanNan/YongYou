//
//  MyRedPacketViewController.swift
//  ydzbapp-hybrid
//  我的红包
//  Created by qinxin on 15/9/3.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class MyRedPacketViewController: BaseViewController {
    
    @IBOutlet weak var unusedLineView: UIView!          //未使用
    @IBOutlet weak var usedLineView: UIView!            //已使用
    @IBOutlet weak var experiedLineView: UIView!        //已到期
    
    @IBOutlet weak var unusedButton: UIButton!          //未使用
    @IBOutlet weak var usedButton: UIButton!            //已使用
    @IBOutlet weak var experiedButton: UIButton!        //已到期
    
    var menuView: BTNavigationDropdownMenu!
    
    var params = [String:AnyObject]()
    var type: String = "99"                             //99全部、1现金、2加息券
    var status: String = "1"                            //1未使用、3已使用、4已过期
    var page: Int = 1                                   //页数
    
    var menu : REMenu?                                  //选项Menu
    var menuBtn: UIButton!                              //选项按钮
    
    var arrowImgView: UIImageView!                      //选项箭头
    
    
    //MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addHelpCenter("")
        //initView()
        initMenu()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
//        if menuView.isShown == true {
//            menuView.hideMenu(1)
//        }else{
//            menuView.hideMenu(0)
//        }
        if let menu = menu {
            if menu.isOpen {
                self.rotateArrow()
                menu.close()
                return
            }
        }
    }
    
    func initMenu(){
        let navView = UIView(frame: CGRectMake(0, 0, 90, 30))
        menuBtn = UIButton(frame: CGRectMake(0, 0, 80, 30))
        menuBtn.setTitle("我的红包", forState: UIControlState.Normal)
        menuBtn.setTitleColor(B.NAV_TITLE_CORLOR, forState: UIControlState.Normal)
        menuBtn.backgroundColor = UIColor.clearColor()
        menuBtn.addTapAction("menuclick", target: self)
        arrowImgView = UIImageView(frame: CGRectMake(82, 13, 8, 5))
        arrowImgView.image = UIImage(named: "polygon-1")
        navView.addSubview(menuBtn)
        navView.addSubview(arrowImgView)
        self.navigationItem.titleView = navView
    }
    
    func menuclick(){
        self.rotateArrow()
        //菜单开关
        if let menu = menu {
            if menu.isOpen {
                menu.close()
                return
            }
        }
        //菜单项
        var items : [REMenuItem] = []
        //菜单项加载
        for filterItem in MenuEnumerations.allValues {
            let item = REMenuItem(title: filterItem.getDescription(), image: nil, highlightedImage: nil) { (item) -> Void in
                //菜单项点击事件
                self.menuBtn.setTitle(filterItem.getDescription(), forState: UIControlState.Normal)
                self.type = filterItem.getType()
                self.rotateArrow()
                self.loadData()
            }
            items.append(item)
        }
        
        self.menu = REMenu(items: items)
        
        self.menu!.liveBlur = true
        self.menu!.liveBlurBackgroundStyle = .Light
        self.menu!.separatorColor = UIColor(red: 190/255, green: 158/255, blue: 118/255, alpha: 1)
        self.menu!.imageAlignment = .Right
        
        self.menu!.showFromNavigationController(self.navigationController)
    }
    
    func rotateArrow() {
        UIView.animateWithDuration(0.3, animations: {[weak self] () -> () in
            if let selfie = self {
                selfie.arrowImgView.transform = CGAffineTransformRotate(selfie.arrowImgView.transform, 180 * CGFloat(M_PI/180))
            }
        })
    }
    
    
    //MARK: - Private methods
    
    private func initView() {
        let items = ["我的红包","加息券","现金红包"]
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: B.NAV_TITLE_CORLOR]
        menuView = BTNavigationDropdownMenu(title: items.first!, items: items)
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = UIColor.whiteColor()
        menuView.cellSelectionColor = UIColor.whiteColor()
        menuView.cellTextLabelColor = B.NAV_TITLE_CORLOR
        menuView.cellTextLabelFont = UIFont.systemFontOfSize(17.0)
        menuView.arrowPadding = 15
        menuView.animationDuration = 0.5
        menuView.maskBackgroundColor = UIColor.blackColor()
        menuView.maskBackgroundOpacity = 0.3
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
        switch indexPath {
            case 0 :
                self.type = "99"
            case 1:
                self.type = "2"
            case 2:
                self.type = "1"
            default:
                break
            }
            self.loadData()
        }
        self.navigationItem.titleView = menuView
    }
    
    private func loadData() {
        params["mm"] = userDefaultsUtil.getMobile()!
        params["type"] = type
        params["status"] = status
        params["page"] = page
        let center = NSNotificationCenter.defaultCenter()
        let notification = NSNotification(name: RED_LIST.Notification, object: nil, userInfo: [RED_LIST.Params:params])
        center.postNotification(notification)
    }
    
    
    //MARK: - Action
    
    @IBAction func unuseAction(sender: UIButton) {
        unusedButton.selected = true
        usedButton.selected = false
        experiedButton.selected = false
        
        unusedLineView.hidden = false
        usedLineView.hidden = true
        experiedLineView.hidden = true
        
        status = "1"
        loadData()
    }
    
    @IBAction func usedAction(sender: UIButton) {
        unusedButton.selected = false
        usedButton.selected = true
        experiedButton.selected = false
        
        unusedLineView.hidden = true
        usedLineView.hidden = false
        experiedLineView.hidden = true
        
        status = "3"
        loadData()
    }
    
    @IBAction func experiedDateAction(sender: UIButton) {
        unusedButton.selected = false
        usedButton.selected = false
        experiedButton.selected = true
        
        unusedLineView.hidden = true
        usedLineView.hidden = true
        experiedLineView.hidden = false
        
        status = "4"
        loadData()
    }
    
}
