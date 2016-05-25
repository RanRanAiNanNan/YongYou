//
//  ImageTableViewController.swift
//  ydzbapp-hybrid
//
//  Created by qinxin on 15/5/14.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit
import Alamofire

class ActivityTableViewController: BaseTableViewController, UIWebViewDelegate {
    
    var activityArray = [ActivityModel]()           //用来装载service返回数组
    
    var scrollDeireciton: Bool = true               //下拉图片显示动画，上拉图片不显示动画
    var lastOffset = CGPoint()                      //记录当前滚动的offset
    
    var headerView: UIView!                         //table view header
    var activityButton: UIButton!                   //活动按钮
    var informationButton: UIButton!                //资讯按钮
    var lineView: UIView!                           //下横线
    var webView = UIWebView()                       //资讯webview
    
    let homeService = HomeService.getInstance()
    
    
    //MARK: - View Life methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        let discoverTabBarItem = tabBarController?.tabBar.items![2]
        discoverTabBarItem?.image = UIImage(named: "main_tabbar_discover")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
    }
    
    
    //MARK: - Private methods
    
    private func initView() {
        initNav("发现")
        loadingShow()
        
        self.tableView.backgroundColor = B.ACTIVITY_CELL_BG
        
        headerView = UIView(frame: CGRectMake(0, 0, B.SCREEN_WIDTH, 55))
        headerView.backgroundColor = B.TABLEVIEW_BG
        
        activityButton = UIButton(frame: CGRectMake(0, 0, headerView.width / 2, 55))
        activityButton.backgroundColor = UIColor.whiteColor()
        activityButton.setTitle("活动", forState: .Normal)
        activityButton.setTitleColor(B.LIST_GRAY_TEXT_COLOR, forState: .Normal)
        activityButton.setTitleColor(B.LIST_YELLOW_TEXT_COLOR, forState: .Selected)
        activityButton.addTarget(self, action: "activityAction", forControlEvents: .TouchUpInside)
        activityButton.selected = true
        headerView.addSubview(activityButton)
        
        informationButton = UIButton(frame: CGRectMake(activityButton.right + 1, 0, headerView.width / 2, 55))
        informationButton.backgroundColor = UIColor.whiteColor()
        informationButton.setTitle("资讯", forState: .Normal)
        informationButton.setTitleColor(B.LIST_GRAY_TEXT_COLOR, forState: .Normal)
        informationButton.setTitleColor(B.LIST_YELLOW_TEXT_COLOR, forState: .Selected)
        informationButton.addTarget(self, action: "informationAction", forControlEvents: .TouchUpInside)
        headerView.addSubview(informationButton)
        
        lineView = UIView(frame: CGRectMake(0, 53, headerView.width / 2, 2))
        lineView.backgroundColor = B.LIST_YELLOW_TEXT_COLOR
        headerView.addSubview(lineView)
    }
    
    private func loadData(){
        homeService.loadActivityData({
            (data) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let array = data as? Array<ActivityModel>{
                    self.activityArray = array
                    self.tableView.reloadData()
                    self.loadingHidden()
                }
            })
        })
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityArray.count
    }
    
    private struct Storyboard {
        static let CellReusableIdentifier = "ActivityTableViewCell"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReusableIdentifier, forIndexPath: indexPath) as! ActivityTableViewCell
        cell.backgroundColor = B.ACTIVITY_CELL_BG
        
        // Configure the cell...
        var activity: ActivityModel = ActivityModel()
        activity = self.activityArray[indexPath.row]
        cell.activityLabel.text = activity.activityName
        cell.activityImageView?.sd_setImageWithURL(NSURL(string: activity.activityThumb))
        
        return cell
    }
    
    
    // MARK: - Table view delegate
    
    private struct TransForm3DAnimate {
        static let SX: CGFloat = 0.3
        static let SY: CGFloat = 0.3
        static let SZ: CGFloat = 1.0
        
        static let Duration:        NSTimeInterval = 0.8
        static let Delay:           NSTimeInterval = 0.0
        static let SpringDamping:   CGFloat = 1.0
        static let SpringVelocity:  CGFloat = 0.0
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if scrollDeireciton {
            let transform : CATransform3D = CATransform3DMakeScale(TransForm3DAnimate.SX, TransForm3DAnimate.SY, TransForm3DAnimate.SZ)
            cell.layer.transform = transform
            [UIView .animateWithDuration(TransForm3DAnimate.Duration, delay: TransForm3DAnimate.Delay, usingSpringWithDamping: TransForm3DAnimate.SpringDamping, initialSpringVelocity: TransForm3DAnimate.SpringVelocity, options: UIViewAnimationOptions.CurveEaseInOut, animations: {cell.layer.transform = CATransform3DIdentity}, completion: nil)]
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let activityVC = storyboard!.instantiateViewControllerWithIdentifier("imageintoweb") as! ActivityIntoWebViewController
        let activity = self.activityArray[indexPath.row]
        activityVC.passUrl = activity.activityUrl
        activityVC.name = activity.activityName
        self.navigationController?.pushViewController(activityVC, animated: true)
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    
    //MARK: - Scrollview delegate
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset
        if currentOffset.y > self.lastOffset.y {
            self.scrollDeireciton = true
        }else{
            self.scrollDeireciton = false
        }
        self.lastOffset = currentOffset
    }
    
    
    //MARK: - Action
    
    func activityAction() {
        webView.removeFromSuperview()
        activityButton.selected = true
        activityButton.userInteractionEnabled = false
        informationButton.selected = false
        informationButton.userInteractionEnabled = true
        
        lineView.frame = CGRectMake(0, 53, headerView.width / 2, 2)
        
        loadData()
    }
    
    func informationAction() {
        activityButton.selected = false
        activityButton.userInteractionEnabled = true
        informationButton.selected = true
        informationButton.userInteractionEnabled = false
        
        lineView.frame = CGRectMake(headerView.width / 2, 53, headerView.width / 2, 2)
        
        activityArray = []
        tableView.reloadData()
        
        loadWebView()
    }
    
    func loadWebView() {
        webView = UIWebView(frame: CGRectMake(0, 54, tableView.width, tableView.height - 49))
        webView.loadRequest(NSURLRequest(URL: NSURL(string: B.ACTIVITY_INFORMATION)!))
        webView.delegate = self
        tableView.addSubview(webView)
    }
    
    
    //MARK: - UIWebViewDelegate
    
    func webViewDidStartLoad(webView: UIWebView) {
        loadingShow()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        loadingHidden()
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "WebKitCacheModelPreferenceKey")
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "WebKitOfflineWebApplicationCacheEnabled")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        loadingHidden()
    }
}
