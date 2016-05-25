//
//  GongGaoViewController.swift
//  fdb-ydzb
//
//  Created by 123 on 16/4/22.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation
class GongGaoViewController:BaseViewController ,UITableViewDelegate , UITableViewDataSource{
    
    
    var gongGaoTableView: UITableView!
    let geRenService = MessageService.getInstance()
    var myArr : NSArray!
    override func viewDidLoad() {
        
        super.viewDidLoad()

        
//        self.view.backgroundColor = UIColor.redColor()
        
        gongGaoTableView =  UITableView(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 40), style: UITableViewStyle.Plain)
        self.view.addSubview(gongGaoTableView)
        gongGaoTableView.delegate = self
        gongGaoTableView.dataSource = self
        gongGaoTableView.registerClass(GongGaoCell.self, forCellReuseIdentifier: "GongGaoViewController")
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadingShow()
        geRenService.GongGao { (data) -> () in
            self.loadingHidden()
            if (data as! NSArray).count == 0{
                self.gongGaoTableView.hidden = true
                self.view.backgroundColor = UIColor.whiteColor()
                var imageView = UIImageView()
                imageView = UIImageView(frame: CGRectMake(B.SCREEN_WIDTH / 2 - 50 , B.SCREEN_HEIGHT / 2 - 200, 100 , 120))
                imageView.image = UIImage(named:"no_item_notice")
                self.view.addSubview(imageView)
                
                let mobileLabel = UILabel(frame: CGRectMake(10 , B.SCREEN_HEIGHT / 2 - 30, B.SCREEN_WIDTH - 20, 30))
                mobileLabel.font = UIFont.systemFontOfSize(17)
                mobileLabel.text = "暂无公告信息"
                mobileLabel.textAlignment = NSTextAlignment.Center
                mobileLabel.textColor = UIColor(red: 172/255, green: 172/255, blue: 173/255, alpha: 1)
                self.view.addSubview(mobileLabel)
 
            }else{
            self.myArr = data as! NSArray
            self.gongGaoTableView.reloadData()
            }
        }
        
    }

    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
//        return 1
//    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if myArr != nil{
            return myArr.count
        }else{
            return 0
        }
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("GongGaoViewController", forIndexPath: indexPath) as! GongGaoCell
        if myArr != nil{
        cell.biaoTi.text = myArr[indexPath.row]["title"] as? String //"深圳市盘古三号股权投资中心成立公告"
        cell.neiRong.text = myArr[indexPath.row]["content"] as? String //"什么什么什么什么投资中心（有限合作）成立公告"
        let str = myArr[indexPath.row]["created"] as! Int
            
//        str = numberFormatter.stringFromNumber(1460701172)!
//        var detaildate = NSDate(timeIntervalSince1970: str.doubleValue)
//        var dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
//        var currentDateStr = dateFormatter.stringFromDate(detaildate)
            
//          let str1 = "\(str)"
//          let detaildate = NSDate(timeIntervalSince1970: str1 as! Double)
//          let dateFormatter = NSDateFormatter()
//          dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
//          let currentDateStr = dateFormatter.stringFromDate(detaildate)
//            
//          print(currentDateStr)
            
            let string = NSString(string: "\(str)")
            
            let timeSta:NSTimeInterval = string.doubleValue
            let dfmatter = NSDateFormatter()
            dfmatter.dateFormat="yyyy年MM月dd日 HH:mm:ss"
            
            let date = NSDate(timeIntervalSince1970: timeSta)
            
            print(dfmatter.stringFromDate(date))
            
            
            
            
        cell.dateLB.text = dfmatter.stringFromDate(date) //"2016-03-22"
//        cell.timeLB.text = "10:59:59"
        }
        return cell
        
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let rpvc:GongGaoWebViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("GongGaoWebViewController") as! GongGaoWebViewController

        print(myArr[indexPath.row]["id"] as! Int)
        rpvc.passUrl = "\(myArr[indexPath.row]["id"] as! Int)"
  
        rpvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(rpvc, animated: true)
        
        
    }

    
    
}

