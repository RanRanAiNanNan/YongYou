//
//  ChanPinGongGaoViewController.swift
//  fdb-ydzb
//
//  Created by 123 on 16/4/13.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation
class ChanPinGongGaoViewController:BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let geRenService = GeRenService.getInstance()
    var Arr = NSArray?()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initView()
        
        
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.navigationBarHidden = true
        super.viewWillAppear(animated)
        self.loadingShow()
        geRenService.chanPinGongGao1 { (data) -> () in
           self.loadingHidden()
            self.Arr = data as? NSArray
            self.tableView.reloadData()
            if (data as! NSArray).count == 0{
                self.tableView.hidden = true
                self.view.backgroundColor = UIColor.whiteColor()
                var imageView = UIImageView()
                imageView = UIImageView(frame: CGRectMake(B.SCREEN_WIDTH / 2 - 50 , B.SCREEN_HEIGHT / 2 - 90, 100 , 120))
                imageView.image = UIImage(named:"no_item_notice")
                self.view.addSubview(imageView)
                
                let mobileLabel = UILabel(frame: CGRectMake(10 , B.SCREEN_HEIGHT / 2 + 60, B.SCREEN_WIDTH - 20, 30))
                mobileLabel.font = UIFont.systemFontOfSize(17)
                mobileLabel.text = "暂无公告信息"
                mobileLabel.textAlignment = NSTextAlignment.Center
                mobileLabel.textColor = UIColor(red: 172/255, green: 172/255, blue: 173/255, alpha: 1)
                self.view.addSubview(mobileLabel)


            }
        }
        
    }

    func initView(){
        
      initNav("产品公告")
        
    }
    @IBAction func leftBack(sender: AnyObject) {
         self.navigationController?.popViewControllerAnimated(true)
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }

     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.Arr == nil{
            return 0
        }else{
            return (self.Arr?.count)!
        }

    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell_My_Center_chanpin", forIndexPath: indexPath)
        if self.Arr != nil{
        let NameLable:UILabel = cell.viewWithTag(5001) as! UILabel!
            NameLable.text = self.Arr![indexPath.row]["pmTitle"] as? String
        let DateLable:UILabel = cell.viewWithTag(5003) as! UILabel!
            let str = (self.Arr![indexPath.row]["pmDate"] as! Int)
            let string = NSString(string: "\(str)")
            let timeSta:NSTimeInterval = string.doubleValue
            let dfmatter = NSDateFormatter()
            dfmatter.dateFormat="yyyy年MM月dd日"
            let date = NSDate(timeIntervalSince1970: timeSta)
             DateLable.text = dfmatter.stringFromDate(date)
            
            
            print(dfmatter.stringFromDate(date))
        let NeiLable:UILabel = cell.viewWithTag(5002) as! UILabel!
            NeiLable.text = self.Arr![indexPath.row]["pmContent"] as? String
        
        
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
//        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//        let rpvc:ChanPinWebViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ChanPinWebViewController") as! ChanPinWebViewController
//        
//        rpvc.passUrl = "\(self.Arr![indexPath.row]["id"])"
//        
//        rpvc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(rpvc, animated: true)
        
        
        
        
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let rpvc:ChanPinWebViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ChanPinWebViewController") as! ChanPinWebViewController
        rpvc.passUrl = self.Arr![indexPath.row]["id"] as? Int
        
        rpvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(rpvc, animated: true)
        
        
        
    }

    
    
    
    
    
    
    
    
    
    
    
    
}