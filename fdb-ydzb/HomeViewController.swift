//
//  HomeViewController.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/5/12.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import ImagePlayerView

struct FinanceKeyRadio {
    static let Notification = "FinanceKey Radio Station"
    static let Key = "Finance Key"
}

struct DiscoverKeyRadio {
    static let Notification = "DiscoverKey Radio Station"
    static let Key = "Discover Key"
}

class HomeViewController: BaseViewController, UIScrollViewDelegate, UINavigationControllerDelegate, UIWebViewDelegate, ImagePlayerViewDelegate ,  UIImagePickerControllerDelegate , UIActionSheetDelegate, UIAlertViewDelegate, UITableViewDataSource , UITableViewDelegate{
    
    @IBOutlet weak var imagePlayerView: ImagePlayerView!
    
    @IBOutlet weak var noticeView: SXMarquee!
    @IBOutlet weak var newsView: UIView!        //消息view
//    @IBOutlet weak var bannerScrollView: UIScrollView!
    @IBOutlet weak var bannerPageControl: UIPageControl!
    
    var tableView : UITableView!
    var bannerTimer:NSTimer!
    var banners:[BannerModel]!      //banner数组
    var hot:JSON!//热门推荐
    var lieBiao:[LieBiaoModel]!     //列表数组
    var buttonArr:NSArray!   //按钮数组
    //股票型
    var stockBT: UIButton!
    //债券型
    var debentureBT: UIButton!
    //量化型
    var quantificationBT: UIButton!
    //多策略
    var strategyBT: UIButton!
    //线
    var xianView : UIImageView!
    
    var messageBtn: UIBarButtonItem!
    
    let homeService = HomeService.getInstance()
    
    var imageURLs = [String]()
    let userCenterService = UserCenterService.getInstance()
    var picker:UIImagePickerController!
    var avatarImg: UIImageView!          //头像
    let touXiang = HomeService.getInstance()
    /** 新闻滚动 **/
    var gun = UIScrollView()
    var w = CGFloat()
    var h = CGFloat()
    var totalPeople1Lab = UILabel()             //银多累计交易人数1
    var totalDealLab = UILabel()                //银多累计交易额
    var totalRevenueLab = UILabel()             //银多累计收益额
    var totalPeople2Lab = UILabel()             //银多累计交易人数2*循环滚动时使用
    
    var avatarBtn = UIButton()
    
    @IBOutlet weak var hotWebView: UIWebView!
    
    
    override func viewDidLoad() {
//        notificationCenter()
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.lieBiao = [LieBiaoModel]!()
        super.viewDidLoad()
        initView()
        loadUrl()
        addMsg()
        showAvatar()
        self.view.backgroundColor = UIColor.whiteColor()
        
    }
    //客服推送过来的
//    func notificationCenter(){
//        if userDefaultsUtil.getMessage() == "message"{
//            let chat = MQChatViewManager()
//            userDefaultsUtil.setNotificationMessageKey("")
//            chat.pushMQChatViewControllerInViewController(self)
//        }
//    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: ""), forBarMetrics: UIBarMetrics.Default)
        loadUrl()
        if userDefaultsUtil.getTiaoZhuan()! == "订单"{
            userDefaultsUtil.setTiaoZhuan("")
           self.tabBarController?.selectedIndex = 1
        }else if userDefaultsUtil.getTiaoZhuan()! == "财富"{
            userDefaultsUtil.setTiaoZhuan("")
           self.tabBarController?.selectedIndex = 2
        }
//        self.tabBarController?.selectedIndex = 3
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController!.navigationBarHidden = false
//        stockBT.setTitleColor(B.NAV_TITLE_CORLOR,forState: .Normal)
//        debentureBT.setTitleColor(B.MENU_NORMAL_FONT_COLOR,forState: .Normal)
//        quantificationBT.setTitleColor(B.MENU_NORMAL_FONT_COLOR,forState: .Normal)
//        strategyBT.setTitleColor(B.MENU_NORMAL_FONT_COLOR,forState: .Normal)
//        //xianView.frame = CGRectMake(0, 45 + 170, self.view.bounds.size.width / 4, 1)
//        self.stockBT.addSubview(self.xianView)
        
        self.loadingShow()
        homeService.main(userDefaultsUtil.getUid()!, type: "1") {
            (data) -> () in
           
            if let hm = data as? HomeModel {
                 self.loadingHidden()
                self.buttonArr = hm.productType
                self.banners = hm.homeBanners
                self.lieBiao = hm.homeProductInfos
                self.loadBanner(hm.homeBanners)
//                self.stockBT.setTitle(self.buttonArr.objectAtIndex(0) as? String, forState: UIControlState.Normal)
//                self.debentureBT.setTitle(self.buttonArr.objectAtIndex(1) as? String, forState: UIControlState.Normal)
//                self.quantificationBT.setTitle(self.buttonArr.objectAtIndex(2) as? String, forState: UIControlState.Normal)
//                self.strategyBT.setTitle(self.buttonArr.objectAtIndex(3) as? String, forState: UIControlState.Normal)
                if hm.messageStatus == "1"{
                    self.setMessageImg("icon－meixin")
                }else{
                    self.setMessageImg("envelope")
                }
//                self.tableView.reloadData()
            }
            if userDefaultsUtil.isLoggedIn(){
            self.homeService.my {
                (data) -> () in
                
                if let hm = data as? MyModel {
                    self.loadingHidden()
                    if hm.photoUrl == ""{
                        self.avatarBtn.setImage(UIImage(named: "Avatar@2x(1)"), forState: UIControlState.Normal)
                    }else{
                        userDefaultsUtil.setAvatarLink(hm.photoUrl)
                        self.avatarBtn.setImageWithURL(NSURL(string: hm.photoUrl), forState: UIControlState.Normal)
                      }
                   }
                }
            }else{
                self.avatarBtn.setImage(UIImage(named: "Avatar@2x(1)"), forState: UIControlState.Normal)
            }
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.pushNav()
//        userCenterService.loadDataGet({
//            (data) -> () in
//            self.loadingHidden()
//            if let ucm = data as? UserCenterModel {
//                //显示消息
//                switch Int(ucm.msg)! {
//                case 0:
//                    self.setMessageImg("icon－meixin")
//                default:
//                    self.setMessageImg("envelope")
//                    
//                }
////                //帐号异常提醒
////                if ucm.remind == "1" {
////                    self.remindSwitch.on = true
////                }else{
////                    self.remindSwitch.on = false
////                }
//            }
//        })

    }
    func setMessageImg(name:String){
        (self.navigationItem.rightBarButtonItem!.customView as! UIButton).setImage(UIImage(named: name), forState: UIControlState.Normal)
    }
    
    func addMsg(){
        let msgBtn = UIButton()
        let backImage = UIImage(named: "icon－meixin")
        msgBtn.frame = CGRectMake(0, 0, backImage!.size.width, backImage!.size.height)
        msgBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        msgBtn.setImage(backImage, forState: UIControlState.Normal)
        msgBtn.addTarget(self, action: "messageClick", forControlEvents: UIControlEvents.TouchUpInside)
        //var backBtnItem = UIBarButtonItem(customView: backBtn)
        messageBtn = UIBarButtonItem(customView: msgBtn)
        self.navigationItem.rightBarButtonItem = messageBtn
    }
    //跳转信息页面
    func messageClick(){
//        gotoPage("UserCenter", pageName: "MessageRecordTVC")
//        homeService.zhanNeiXin { (data) -> () in
//            
//        }
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "UserCenter", bundle: NSBundle.mainBundle())
        let rpvc:MessageViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("MessageViewController") as! MessageViewController
        rpvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(rpvc, animated: true)
 
  
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        let center = NSNotificationCenter.defaultCenter()
        center.removeObserver(self)
//        stockBT.setTitleColor(B.NAV_TITLE_CORLOR,forState: .Normal)
//        debentureBT.setTitleColor(B.MENU_NORMAL_FONT_COLOR,forState: .Normal)
//        quantificationBT.setTitleColor(B.MENU_NORMAL_FONT_COLOR,forState: .Normal)
//        strategyBT.setTitleColor(B.MENU_NORMAL_FONT_COLOR,forState: .Normal)
        //            xianView.frame = CGRectMake(0, 45 + 170, self.view.bounds.size.width / 4, 1)
//        stockBT.addSubview(xianView)

    }
    
    
    //MARK: - Private Methods
    
    //Tab bar 通过状态改写图标
//    private func checkTabbar(hm: HomeModel) {
    
//        let financeTabBarItem = tabBarController?.tabBar.items![1]
//        let discoverTabBarItem = tabBarController?.tabBar.items![2]
    
//        if (userDefaultsUtil.getFinnaceKey() as NSString).doubleValue < (hm.financeKey as NSString).doubleValue {
//            financeTabBarItem?.image = UIImage(named: "finance_point")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
//        }
//        
//        if (userDefaultsUtil.getDiscoverKey() as NSString).doubleValue < (hm.discoverKey as NSString).doubleValue {
//            discoverTabBarItem?.image = UIImage(named: "discover_point")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
//        }
        
//        addFinanceRation(hm)
//        addDiscoverRation(hm)
//        
//    }
    
//    private func addFinanceRation(hm: HomeModel) {
//        let center = NSNotificationCenter.defaultCenter()
//        let queue = NSOperationQueue.mainQueue()
//        center.addObserverForName(FinanceKeyRadio.Notification, object: nil, queue: queue) { notification -> Void in
//            self.saveFinanceKeyToUserDefalt(hm)
//        }
//    }
//    
//    private func addDiscoverRation(hm: HomeModel) {
//        let center = NSNotificationCenter.defaultCenter()
//        let queue = NSOperationQueue.mainQueue()
//        center.addObserverForName(DiscoverKeyRadio.Notification, object: nil, queue: queue) { notification -> Void in
//            self.saveDiscoverKeyToUserDefalt(hm)
//        }
//    }
    
//    private func saveFinanceKeyToUserDefalt(hm: HomeModel) {
//        if (userDefaultsUtil.getFinnaceKey() as NSString).doubleValue < (hm.financeKey as NSString).doubleValue {
//            userDefaultsUtil.setFinnaceIconkey(hm.financeKey)
//        }
//    }
//    
//    private func saveDiscoverKeyToUserDefalt(hm: HomeModel) {
//        if (userDefaultsUtil.getDiscoverKey() as NSString).doubleValue < (hm.discoverKey as NSString).doubleValue {
//            userDefaultsUtil.setDiscoverIconKey(hm.discoverKey)
//        }
//    }
    
    //加载热门webView
    func loadUrl(){
//        let path = NSBundle.mainBundle().pathForResource("121.43.118.86:10220/Home/Product/stock", ofType: "html")
        let url = NSURL(string: "http://121.43.118.86:10220/Home/Product/stock")
//        let url = NSURL.fileURLWithPath(path!)
        let request = NSURLRequest(URL: url!)
        hotWebView.delegate = self
        hotWebView.scalesPageToFit = true
        hotWebView.loadRequest(request)
        hotWebView.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        hotWebView.scrollView.scrollEnabled = false
    }
    
    //加载banner
    func loadBanner(banners:[BannerModel]){
        print(banners)
        self.imagePlayerView.layer.shadowColor = UIColor.blackColor().CGColor
        self.imagePlayerView.layer.shadowOpacity = 5
        self.imagePlayerView.layer.cornerRadius = 10
        self.imagePlayerView.layer.masksToBounds = false
        self.banners = banners
        self.imagePlayerView.imagePlayerViewDelegate = self
        self.imagePlayerView.scrollInterval = 5
        self.imagePlayerView.pageControlPosition = ICPageControlPosition.BottomRight
        self.imagePlayerView.hidePageControl = false
        imagePlayerView.reloadData()
    }
    
    
//    banner点击跳转
    func jump2WebView(sender: UITapGestureRecognizer) {
        let activityVC = storyboard!.instantiateViewControllerWithIdentifier("imageintoweb") as! ActivityIntoWebViewController
        if let tag = sender.view?.tag {
            if !self.banners[tag].actUrl.isEmpty {
                activityVC.passUrl = self.banners[tag].actUrl.stringByAppendingString("/mm/")
                activityVC.name = ""
                self.navigationController?.pushViewController(activityVC, animated: true)
            }
            
        }
    }
    
    
    
    @IBAction func gotoUserCenter(sender: AnyObject) {
        swipe()
    }
    
    
    //新头像下载
    func checkAvatar(link:String) {
        
        if !link.isEmpty {
            //判断本地是否有头像地址或者与远程头像地址不一致
            if  userDefaultsUtil.getAvatarLink() != link {
                //设置新头像地址
                userDefaultsUtil.setAvatarLink(link)
                //下载头像
                homeService.downloadAvatar(link, calback: {
                    img in
                    if let mm = img as? UIImage {
                        (self.navigationItem.leftBarButtonItem?.customView as! UIButton).setImage(mm, forState: UIControlState.Normal)
                    }
                })
            }
        }
    }
    
    func initView(){
        loadingShow()
        initNav("佣有")
//        initTableView()
        //右滑动设置
//        let swipe = UISwipeGestureRecognizer(target: self, action: Selector("swipe"))
//        swipe.direction = UISwipeGestureRecognizerDirection.Right
//        self.view.addGestureRecognizer(swipe)
//        noticeView.initWithSb(SXMarqueeSpeedLevel.MediumFast, msg: "提供了颜色微调方案，可以让一个已知颜色的rgb的某值上升或下降若干，可用于不管背景是什么色，边框都比背景深20。 也可以将认可颜色的详细值打印出来。", bgColor: UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1), txtColor: UIColor(red: 142/255, green: 42/255, blue: 24/255, alpha: 1))
//        noticeView.start()
        
        NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: "autoChange", userInfo: nil, repeats: true)
        
        //user default: finance key && discover key
        if userDefaultsUtil.getFinnaceKey() == "" {
            userDefaultsUtil.setFinnaceIconkey("0")
        }
        
        if userDefaultsUtil.getDiscoverKey() == "" {
            userDefaultsUtil.setDiscoverIconKey("0")
        }
        
        //
        let homeTabBarItem = tabBarController?.tabBar.items![0]
        let financeTabBarItem = tabBarController?.tabBar.items![1]
        let discoverTabBarItem = tabBarController?.tabBar.items![2]
        let assetTabBarItem = tabBarController?.tabBar.items![3]
        
        homeTabBarItem?.image = UIImage(named: "64-icon-yongyou")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        financeTabBarItem?.image = UIImage(named: "64-icon-yongyou2")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        discoverTabBarItem?.image = UIImage(named: "64-icon-yongyou3")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        assetTabBarItem?.image = UIImage(named: "64-icon-yongyou4")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
    }
    //nav头像设置
    func showAvatar(){
        
        avatarBtn = UIButton(frame: CGRectMake(0, 0, 30, 30))
        avatarBtn.setImage(UIImage(named: "Avatar@2x(1)"), forState: UIControlState.Normal)
        avatarBtn.layer.cornerRadius = 15
        avatarBtn.layer.borderColor = B.BTN_GOLDEN_COLOR.CGColor
        avatarBtn.layer.borderWidth = 2
        avatarBtn.layer.masksToBounds = true
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: avatarBtn)
        
        avatarBtn.addTarget(self, action: Selector("swipe"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    //右滑动进入用户中心
    func swipe(){
        print("点击头像  点击头像")
        if !userDefaultsUtil.isLoggedIn(){
            
            let twoStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let twoController:LoginViewController = twoStoryBoard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            twoController.hidesBottomBarWhenPushed = true
            self.presentViewController(twoController, animated: true, completion: nil)

//            
//            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
//            let rpvc:DingDanXiangQingNewViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("DingDanXiangQingNewViewController") as! DingDanXiangQingNewViewController
////            rpvc.passUrl = self.banners[index].actUrl
//            
//            rpvc.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(rpvc, animated: true)

            
            
                     
//            self.tabBarController?.selectedIndex = 3
            
        }else{
//            let actionSheet:UIActionSheet = UIActionSheet()
//            actionSheet.addButtonWithTitle("取消")
//            actionSheet.addButtonWithTitle("拍照")
//            actionSheet.addButtonWithTitle("从手机相册中选取")
//            actionSheet.cancelButtonIndex = 0
//            actionSheet.delegate = self
//            actionSheet.showInView(self.view)
            
        }
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
//        print("info 0^^^^\(info)")
        let dic = info as NSDictionary
        //编辑过后的图片
        let editedImage = dic.objectForKey("UIImagePickerControllerEditedImage") as! UIImage
        avatarBtn.setImage(editedImage, forState: UIControlState.Normal)
        PhotoUtils.saveImage(editedImage)
        uploadAvatar()
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        
        
        
        
        
    }
    
    func uploadAvatar(){
        userCenterService.uploadAvatar()
    }

    //滚动新闻
    func addStatistics(totalPeople:String, totalDeal:String, totalRevenue:String){
        w = newsView.frame.width
        h = newsView.frame.height
        
        gun.frame = CGRectMake(0, 0, w, h)
        gun.backgroundColor = UIColor.clearColor()       //gun的背景颜色
        gun.contentSize = CGSize(width: w, height: h * 4)
        gun.pagingEnabled = true
        gun.showsVerticalScrollIndicator = false
        gun.bounces = false
        gun.scrollEnabled = false
        
        
        totalPeople1Lab.frame = CGRectMake(0, 0, w, h)
        totalPeople1Lab.text = "累计交易人数:" + totalPeople + "人"
        totalPeople1Lab.textColor = B.NAV_BG
        totalPeople1Lab.textAlignment = NSTextAlignment.Center
        //zi1.textAlignment = NSTextAlignment.Center
        gun.addSubview(totalPeople1Lab)
        
        
        totalDealLab.frame = CGRectMake(0, h, w, h)
        totalDealLab.text = "累计交易额:" + totalDeal + "元"
        totalDealLab.textColor = B.NAV_BG
        totalDealLab.textAlignment = NSTextAlignment.Center
        gun.addSubview(totalDealLab)
        
        totalRevenueLab.frame = CGRectMake(0, h * 2, w, h)
        totalRevenueLab.text = "累计收益额:" + totalRevenue + "元"
        totalRevenueLab.textColor = B.NAV_BG
        totalRevenueLab.textAlignment = NSTextAlignment.Center
        gun.addSubview(totalRevenueLab)
        
        totalPeople2Lab.frame = CGRectMake(0, h * 3, w, h)
        totalPeople2Lab.textAlignment = NSTextAlignment.Center
        totalPeople2Lab.textColor = B.NAV_BG
        totalPeople2Lab.text = "累计交易人数:" + totalPeople + "人"
        gun.addSubview(totalPeople2Lab)
        
        gun.delegate = self
        
        
        newsView.addSubview(gun)
    }
    
    func timing() {
        gun.scrollRectToVisible(CGRectMake(0, 0, w, h), animated: false)
    }
    
    //滚动新闻改变
    func autoChange(){
        switch gun.contentOffset.y {
        case 0:
            gun.scrollRectToVisible(CGRectMake(0, h, w, h), animated: true)
        case 40:
            gun.scrollRectToVisible(CGRectMake(0, h * 2, w, h), animated: true)
        default :
            gun.scrollRectToVisible(CGRectMake(0, h * 3, w, h), animated: true)
            NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: "timing", userInfo: nil, repeats: false)
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        //防止webview内存泄露
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "WebKitCacheModelPreferenceKey")
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "WebKitOfflineWebApplicationCacheEnabled")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
//
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let url = request.URL
//        print(url)
        if url?.scheme == "link" {
            //截取ID
//            hotWebView.stringByEvaluatingJavaScriptFromString("createData(\(self.hot))")
//            print(url)
//            print(url!.absoluteString)
            let ss = url!.absoluteString.componentsSeparatedByString("id=").last
            let time = ss!.componentsSeparatedByString("time=").last
            let aa = ss!.componentsSeparatedByString("&").first
            print(time)
            print(aa)
            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let rpvc:ProductDetailsViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("productDetails") as! ProductDetailsViewController
            rpvc.str = aa
            rpvc.date1 = time
            
            rpvc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(rpvc, animated: true)

//            print(hotWebView.stringByEvaluatingJavaScriptFromString("id"))
        }else if url?.scheme == "divLink" {
            self.gotoLink(url!.absoluteString)
        }
        
        return true
    }
    
    func gotoLink(parms:String){
        let parm = splitParameter(parms)
        if parm.0 == "1" {
            switch parm.1 {
            case "dayloan":
                gotoPage("Finance", pageName: "dayloanMainCtrl")
            case "deposit":
                gotoPage("Finance", pageName: "depositMainCtrl")
            case "jumu":
                gotoPage("HighFinance", pageName: "jumuCtrl")
            case "transfer":
                gotoPage("HighFinance", pageName: "transferCtrl")
            default:
                break
            }
        }else{
            let oneStoryBoard:UIStoryboard = UIStoryboard(name: "HighFinance", bundle: NSBundle.mainBundle())
            let rpvc:RemoteProductViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("remoteProductCtrl") as! RemoteProductViewController
            rpvc.url = parm.1 + userDefaultsUtil.getMobile()!               //外页url地址
            rpvc.productName = (parm.2).stringByRemovingPercentEncoding!    //nav标题
            self.navigationController?.pushViewController(rpvc, animated: true)
        }
    }
    
    /*
    *拆分参数数据，上传购买数据
    *返回(类型，外网地址，产品名称)
    */
    func splitParameter(params:String) -> (String,String,String){
        var parm = (cate:"", addr:"", name:"")
        _ = (params as NSString).rangeOfString("?")
        let result = params.componentsSeparatedByString("?").last
        let arr = result!.componentsSeparatedByString("&")
        for str in arr {
            let ss = str.componentsSeparatedByString("=")
            if ss.first! == "cate" {
                parm.cate = ss.last!
            }else if ss.first! == "addr" {
                parm.addr = ss.last!
            }else if ss.first! == "name" {
                parm.name = ss.last!
            }
        }
        return parm
    }
    //banner数量
    func numberOfItems() -> Int {
//        print(self.banners.count)
        return self.banners.count
    }
    
    //banner图片显示
    func imagePlayerView(imagePlayerView: ImagePlayerView!, loadImageForImageView imageView: UIImageView!, index: Int) {
        //imageView.sd_setImageWithURL(NSURL(string: self.banners[index].thumb), placeholderImage: UIImage(named: "default-banner"))
        imageView.sd_setImageWithURL(NSURL(string: self.banners[index].photoUrl), placeholderImage: UIImage(named: "default-banner"))
    }
    //banner图片点击
    func imagePlayerView(imagePlayerView: ImagePlayerView!, didTapAtIndex index: Int) {
        
        if self.banners[index].actUrl != ""{
        
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let rpvc:BannerWebViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("BannerWebViewController") as! BannerWebViewController
         rpvc.passUrl = self.banners[index].actUrl

        rpvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(rpvc, animated: true)

        }
//        let activityVC = storyboard!.instantiateViewControllerWithIdentifier("BannerWebViewController") as! BannerWebViewController
//        if !self.banners[index].actUrl.isEmpty {
////            print("title:\(self.banners[index].actUrl)")
//            activityVC.passUrl = self.banners[index].actUrl
////            activityVC.name = self.banners[index].title
//            self.navigationController?.pushViewController(activityVC, animated: true)
//        }
        
    }
    
    func initTableView(){
        
        stockBT = UIButton(type: .System)
        stockBT.frame = CGRectMake(0, 150, self.view.bounds.size.width / 4, 37)
        stockBT.titleLabel?.font = UIFont.systemFontOfSize(13)
        
        stockBT.setTitleColor(B.NAV_TITLE_CORLOR,forState: .Normal)
        stockBT.addTarget(self,action:Selector("productMainBT:"),forControlEvents:.TouchUpInside)
        stockBT.tag = 10001
        self.view.addSubview(stockBT)
        
        debentureBT = UIButton(type: .System)
        debentureBT.frame = CGRectMake(self.view.bounds.size.width / 4, 150, self.view.bounds.size.width / 4, 37)
        debentureBT.titleLabel?.font = UIFont.systemFontOfSize(13)
        
        debentureBT.setTitleColor(B.MENU_NORMAL_FONT_COLOR,forState: .Normal)
        debentureBT.addTarget(self,action:Selector("productMainBT:"),forControlEvents:.TouchUpInside)
        debentureBT.tag = 10002
        self.view.addSubview(debentureBT)
        
        quantificationBT = UIButton(type: .System)
        quantificationBT.frame = CGRectMake(self.view.bounds.size.width / 2, 150, self.view.bounds.size.width / 4, 37)
        quantificationBT.titleLabel?.font = UIFont.systemFontOfSize(13)
        
        quantificationBT.setTitleColor(B.MENU_NORMAL_FONT_COLOR,forState: .Normal)
        quantificationBT.addTarget(self,action:Selector("productMainBT:"),forControlEvents:.TouchUpInside)
        quantificationBT.tag = 10003
        self.view.addSubview(quantificationBT)
        
        strategyBT = UIButton(type: .System)
        strategyBT.frame = CGRectMake(self.view.bounds.size.width / 4*3, 150, self.view.bounds.size.width / 4, 36)
        strategyBT.titleLabel?.font = UIFont.systemFontOfSize(13)
        
        strategyBT.setTitleColor(B.MENU_NORMAL_FONT_COLOR,forState: .Normal)
        strategyBT.addTarget(self,action:Selector("productMainBT:"),forControlEvents:.TouchUpInside)
        strategyBT.tag = 10004
        self.view.addSubview(strategyBT)

        xianView = UIImageView()
        xianView.frame = CGRectMake(B.SCREEN_WIDTH / 4 / 2 - 20 , 20, 40, 35)
        xianView.image = UIImage(named: "icon－sanjiao")
        stockBT.addSubview(xianView)

        
        
        
        
        tableView =  UITableView(frame: CGRectMake(0, 135 + 37 + 15, self.view.bounds.size.width, self.view.bounds.size.height - 200 + 13 - 49 - 65), style: UITableViewStyle.Plain)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(ProductCell.self, forCellReuseIdentifier: "tableViewcell")
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 110
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        if self.lieBiao != nil {
        return self.lieBiao.count
        }
        return 0
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 10
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tableViewcell", forIndexPath: indexPath) as! ProductCell
        if self.lieBiao != nil{

            cell.titleLabel.text = self.lieBiao[indexPath.section].name
            cell.yuqiLabel.text = "预期收益"
            cell.yuqishuLabel.text = "\(self.lieBiao[indexPath.section].interestRate)%"
            cell.shouyiLabel.text = self.lieBiao[indexPath.section].backInterest
            cell.baifen.text = "%"
            cell.fanyongLabel.text = "返佣"
            cell.chanpinLabel.text = "产品形式"
            cell.chanLabel.text = self.lieBiao[indexPath.section].productClas
            cell.qixianLabel.text = "期限\(self.lieBiao[indexPath.section].cylcles)天"
            //        cell.yueLabel.text = "12个月"
            cell.qigouLabel.text = "起购金额\(self.lieBiao[indexPath.section].startupMoney)元"
            //        cell.qianLabel.text = "200万"

        }
        return cell;
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
//        if !userDefaultsUtil.isLoggedIn(){
//            let twoStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//            let twoController:LoginViewController = twoStoryBoard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
//            twoController.hidesBottomBarWhenPushed = true
//            self.presentViewController(twoController, animated: true, completion: nil)
//        }else{
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let rpvc:ProductDetailsViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("productDetails") as! ProductDetailsViewController
        rpvc.str = self.lieBiao[indexPath.section].id
        rpvc.date1 = self.lieBiao[indexPath.section].openDate
        print(rpvc.str)
        rpvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(rpvc, animated: true)
        
//        }
        
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let myView = UIView()
        myView.backgroundColor = UIColor(red: 238.0/255, green: 241.0/255, blue: 242.0/255, alpha: 1)
        
        return myView
    }
    
    
    
    
    func productMainBT(button : UIButton){
        if button.tag == 10001{
            stockBT.setTitleColor(B.NAV_TITLE_CORLOR,forState: .Normal)
            debentureBT.setTitleColor(B.MENU_NORMAL_FONT_COLOR,forState: .Normal)
            quantificationBT.setTitleColor(B.MENU_NORMAL_FONT_COLOR,forState: .Normal)
            strategyBT.setTitleColor(B.MENU_NORMAL_FONT_COLOR,forState: .Normal)
//            xianView.frame = CGRectMake(0, 45 + 170, self.view.bounds.size.width / 4, 1)
            stockBT.addSubview(xianView)
            self.loadingShow()
            homeService.main(userDefaultsUtil.getUid()!, type: "1") {
                (data) -> () in
                self.loadingHidden()
                if let hm = data as? HomeModel {
//                    self.banners = hm.homeBanners
                    self.lieBiao = hm.homeProductInfos
//                    self.loadBanner(hm.homeBanners)
                    self.tableView.reloadData()
                }
                
            }

        }else if button.tag == 10002{
            stockBT.setTitleColor(B.MENU_NORMAL_FONT_COLOR,forState: .Normal)
            debentureBT.setTitleColor(B.NAV_TITLE_CORLOR,forState: .Normal)
            quantificationBT.setTitleColor(B.MENU_NORMAL_FONT_COLOR,forState: .Normal)
            strategyBT.setTitleColor(B.MENU_NORMAL_FONT_COLOR,forState: .Normal)
            debentureBT.addSubview(xianView)
            self.loadingShow()
            homeService.main(userDefaultsUtil.getUid()!, type: "2") {
                (data) -> () in
                self.loadingHidden()
                if let hm = data as? HomeModel {
//                    self.banners = hm.homeBanners
                    self.lieBiao = hm.homeProductInfos
//                    self.loadBanner(hm.homeBanners)
                    self.tableView.reloadData()
                }
                
            }

        }else if button.tag == 10003{
            stockBT.setTitleColor(B.MENU_NORMAL_FONT_COLOR,forState: .Normal)
            debentureBT.setTitleColor(B.MENU_NORMAL_FONT_COLOR,forState: .Normal)
            quantificationBT.setTitleColor(B.NAV_TITLE_CORLOR,forState: .Normal)
            strategyBT.setTitleColor(B.MENU_NORMAL_FONT_COLOR,forState: .Normal)
            self.loadingShow()
            homeService.main(userDefaultsUtil.getUid()!, type: "3") {
                (data) -> () in
                self.loadingHidden()
                if let hm = data as? HomeModel {
//                    self.banners = hm.homeBanners
                    self.lieBiao = hm.homeProductInfos
//                    self.loadBanner(hm.homeBanners)
                    self.tableView.reloadData()
                }
                
            }

            quantificationBT.addSubview(xianView)
        }else{
            stockBT.setTitleColor(B.MENU_NORMAL_FONT_COLOR,forState: .Normal)
            debentureBT.setTitleColor(B.MENU_NORMAL_FONT_COLOR,forState: .Normal)
            quantificationBT.setTitleColor(B.MENU_NORMAL_FONT_COLOR,forState: .Normal)
            strategyBT.setTitleColor(B.NAV_TITLE_CORLOR,forState: .Normal)
            self.loadingShow()
            homeService.main(userDefaultsUtil.getUid()!, type: "4") {
                (data) -> () in
                self.loadingHidden()
                if let hm = data as? HomeModel {
//                    self.banners = hm.homeBanners
                    self.lieBiao = hm.homeProductInfos
//                    self.loadBanner(hm.homeBanners)
                    self.tableView.reloadData()
                }
                
            }
            strategyBT.addSubview(xianView)
        }
        
    }

}