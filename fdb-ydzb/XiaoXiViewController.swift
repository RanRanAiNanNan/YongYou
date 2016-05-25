//
//  XiaoXiViewController.swift
//  fdb-ydzb
//
//  Created by 123 on 16/4/22.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation
class XiaoXiViewController:BaseViewController ,UITableViewDataSource ,UITableViewDelegate{
    
    var xiaoXiTableView: UITableView!
    let geRenService = MessageService.getInstance()
    var arr : NSArray!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        self.loadingShow()
//        self.xiaoXiTableView.backgroundColor = UIColor.redColor()
        geRenService.xiaoXi({ (data) -> () in
                if (data as! NSArray).count == 0{
                self.xiaoXiTableView.hidden = true
                self.view.backgroundColor = UIColor.whiteColor()
                var imageView = UIImageView()
                imageView = UIImageView(frame: CGRectMake(B.SCREEN_WIDTH / 2 - 50 , B.SCREEN_HEIGHT / 2 - 200, 100 , 120))
                imageView.image = UIImage(named:"no_item_notice")
                self.view.addSubview(imageView)
                
                let mobileLabel = UILabel(frame: CGRectMake(10 , B.SCREEN_HEIGHT / 2 - 30, B.SCREEN_WIDTH - 20, 30))
                mobileLabel.font = UIFont.systemFontOfSize(17)
                mobileLabel.text = "暂无消息信息"
                mobileLabel.textAlignment = NSTextAlignment.Center
                mobileLabel.textColor = UIColor(red: 172/255, green: 172/255, blue: 173/255, alpha: 1)
                self.view.addSubview(mobileLabel)
                
                
            }else{
                self.arr = data as! NSArray
                self.xiaoXiTableView.reloadData()
            }


            })

    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        self.view.backgroundColor = UIColor.greenColor()
        xiaoXiTableView =  UITableView(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 40), style: UITableViewStyle.Plain)
        self.view.addSubview(xiaoXiTableView)
        xiaoXiTableView.delegate = self
        xiaoXiTableView.dataSource = self
        xiaoXiTableView.registerClass(XiaoXiCell.self, forCellReuseIdentifier: "XiaoXiViewController")

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arr == nil{
            return 0
        }else{
            return self.arr.count
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("XiaoXiViewController", forIndexPath: indexPath) as! XiaoXiCell
        if self.arr != nil{
        cell.biaoTi.text =  self.arr[indexPath.row]["title"] as? String //"和聚鼎宝君享证券投资基金"
        cell.neiRong.text = self.arr[indexPath.row]["content"] as? String
//        cell.dateLB.text = "2016-03-22"
//        cell.timeLB.text = "10:59:59"
//        cell.yuYueLB.text = "预约成功"
        let str = self.arr[indexPath.row]["created"] as! Int
            let string = NSString(string: "\(str)")
            let timeSta:NSTimeInterval = string.doubleValue
            let dfmatter = NSDateFormatter()
            dfmatter.dateFormat="yyyy年MM月dd日 HH:mm:ss"
            let date = NSDate(timeIntervalSince1970: timeSta)
            print(dfmatter.stringFromDate(date))
        cell.daKuanLB.text = dfmatter.stringFromDate(date)
//        cell.qianLB.text = "100万"
        }
        return cell
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let rpvc:XiaoXiWebViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("XiaoXiWebViewController") as! XiaoXiWebViewController
        
        rpvc.passUrl = self.arr[indexPath.row]["id"] as! Int
        
        rpvc.hidesBottomBarWhenPushed = true
        
        geRenService.duQu("\(rpvc.passUrl)") { (data) -> () in
            
            
        }
        
        
        self.navigationController?.pushViewController(rpvc, animated: true)
        
    }

    
}
